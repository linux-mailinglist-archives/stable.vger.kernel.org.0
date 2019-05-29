Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF182E411
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 20:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfE2SIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 14:08:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43930 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727017AbfE2SIv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 14:08:51 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D8F1D75739;
        Wed, 29 May 2019 18:08:45 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 428621017E30;
        Wed, 29 May 2019 18:08:44 +0000 (UTC)
Message-ID: <3de33a50f281689e116577c07be5f736c4351d19.camel@redhat.com>
Subject: Re: [PATCH] block: Fix read-only block device setting after
 revalidate
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org
Cc:     stable@vger.kernel.org, Jeremy Cline <jeremy@jcline.org>,
        Oleksii Kurochko <olkuroch@cisco.com>
Date:   Wed, 29 May 2019 14:08:43 -0400
In-Reply-To: <20190529173512.9587-1-martin.petersen@oracle.com>
References: <20190529173512.9587-1-martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 29 May 2019 18:08:50 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2019-05-29 at 13:35 -0400, Martin K. Petersen wrote:
> Commit 20bd1d026aac ("scsi: sd: Keep disk read-only when re-reading
> partition") addressed a long-standing problem with user read-only
> policy being overridden as a result of a device-initiated revalidate.
> The commit has since been reverted due to a regression that left some
> USB devices read-only indefinitely.
> 
> To fix the underlying problems with revalidate we need to keep track
> of hardware state and user policy separately. Every time the state is
> changed, either via a hardware event or the BLKROSET ioctl, the
> per-partition read-only state is updated based on the combination of
> device state and policy. The resulting active state is stored in a
> separate hd_struct flag to avoid introducing additional lookups in the
> I/O hot path.
> 
> The gendisk has been updated to reflect the current hardware state set
> by the device driver. This is done to allow returning the device to
> the hardware state once the user clears the BLKROSET flag.
> 
> For partitions, the existing hd_struct 'policy' flag is split into
> two:
> 
>  - 'read_only' indicates the currently active read-only state of a
>    whole disk device or partition.
> 
>  - 'ro_policy' indicates the whether the user has administratively set
>    the whole disk or partition read-only via the BLKROSET ioctl.
> 
> The resulting semantics are as follows:
> 
>  - If BLKROSET is used to set a whole-disk device read-only, any
>    partitions will end up in a read-only state until the user
>    explicitly clears the flag.
> 
>  - If BLKROSET sets a given partition read-only, that partition will
>    remain read-only even if the underlying storage stack initiates a
>    revalidate. However, the BLKRRPART ioctl will cause the partition
>    table to be dropped and any user policy on partitions will be lost.
> 
>  - If BLKROSET has not been set, both the whole disk device and any
>    partitions will reflect the current write-protect state of the
>    underlying device.
> 
> Cc: <stable@vger.kernel.org>
> Cc: Jeremy Cline <jeremy@jcline.org>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Reported-by: Oleksii Kurochko <olkuroch@cisco.com>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201221
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  block/blk-core.c          |  2 +-
>  block/genhd.c             | 69 +++++++++++++++++++++++++++++----------
>  block/partition-generic.c |  4 +--
>  include/linux/genhd.h     | 10 +++---
>  4 files changed, 61 insertions(+), 24 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 4673ebe42255..932f179a9095 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -792,7 +792,7 @@ static inline bool bio_check_ro(struct bio *bio, struct hd_struct *part)
>  {
>  	const int op = bio_op(bio);
>  
> -	if (part->policy && op_is_write(op)) {
> +	if (part->read_only && op_is_write(op)) {
>  		char b[BDEVNAME_SIZE];
>  
>  		if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
> diff --git a/block/genhd.c b/block/genhd.c
> index 703267865f14..75138cf5540d 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1539,38 +1539,73 @@ static void set_disk_ro_uevent(struct gendisk *gd, int ro)
>  	kobject_uevent_env(&disk_to_dev(gd)->kobj, KOBJ_CHANGE, envp);
>  }
>  
> -void set_device_ro(struct block_device *bdev, int flag)
> -{
> -	bdev->bd_part->policy = flag;
> -}
> -
> -EXPORT_SYMBOL(set_device_ro);
> -
> -void set_disk_ro(struct gendisk *disk, int flag)
> +/**
> + * update_part_ro_state - iterate over partitions to update read-only state
> + * @disk:	The disk device
> + *
> + * This function updates the read-only state for all partitions on a
> + * given disk device. This is required every time a hardware event
> + * signals that the device write-protect state has changed. It is also
> + * necessary when the user sets or clears the read-only flag on the
> + * whole-disk device.
> + */
> +static void update_part_ro_state(struct gendisk *disk)
>  {
>  	struct disk_part_iter piter;
>  	struct hd_struct *part;
>  
> -	if (disk->part0.policy != flag) {
> -		set_disk_ro_uevent(disk, flag);
> -		disk->part0.policy = flag;
> -	}
> -
> -	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
> +	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY_PART0);
>  	while ((part = disk_part_iter_next(&piter)))
> -		part->policy = flag;
> +		if (disk->read_only || disk->part0.ro_policy || part->ro_policy)
> +			part->read_only = true;
> +		else
> +			part->read_only = false;
>  	disk_part_iter_exit(&piter);
>  }
>  
> +/**
> + * set_device_ro - set a block device read-only
> + * @bdev:	The block device (whole disk or partition)
> + * @state:	true or false
> + *
> + * This function is used to specify the read-only policy for a
> + * block_device (whole disk or partition). set_device_ro() is called
> + * by the BLKROSET ioctl.
> + */
> +void set_device_ro(struct block_device *bdev, bool state)
> +{
> +	bdev->bd_part->read_only = bdev->bd_part->ro_policy = state;
> +	if (bdev->bd_part->partno == 0)
> +		update_part_ro_state(bdev->bd_disk);
> +}
> +EXPORT_SYMBOL(set_device_ro);
> +
> +/**
> + * set_disk_ro - set a gendisk read-only
> + * @disk:	The disk device
> + * @state:	true or false
> + *
> + * This function is used to indicate whether a given disk device
> + * should have its read-only flag set. set_disk_ro() is typically used
> + * by device drivers to indicate whether the underlying physical
> + * device is write-protected.
> + */
> +void set_disk_ro(struct gendisk *disk, bool state)
> +{
> +	if (disk->read_only == state)
> +		return;
> +	set_disk_ro_uevent(disk, state);
> +	disk->read_only = state;
> +	update_part_ro_state(disk);
> +}
>  EXPORT_SYMBOL(set_disk_ro);
>  
>  int bdev_read_only(struct block_device *bdev)
>  {
>  	if (!bdev)
>  		return 0;
> -	return bdev->bd_part->policy;
> +	return bdev->bd_part->read_only;
>  }
> -
>  EXPORT_SYMBOL(bdev_read_only);
>  
>  int invalidate_partition(struct gendisk *disk, int partno)
> diff --git a/block/partition-generic.c b/block/partition-generic.c
> index 8e596a8dff32..8c55b90c918d 100644
> --- a/block/partition-generic.c
> +++ b/block/partition-generic.c
> @@ -98,7 +98,7 @@ static ssize_t part_ro_show(struct device *dev,
>  			    struct device_attribute *attr, char *buf)
>  {
>  	struct hd_struct *p = dev_to_part(dev);
> -	return sprintf(buf, "%d\n", p->policy ? 1 : 0);
> +	return sprintf(buf, "%u\n", p->read_only ? 1 : 0);
>  }
>  
>  static ssize_t part_alignment_offset_show(struct device *dev,
> @@ -338,7 +338,7 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
>  		queue_limit_discard_alignment(&disk->queue->limits, start);
>  	p->nr_sects = len;
>  	p->partno = partno;
> -	p->policy = get_disk_ro(disk);
> +	p->read_only = get_disk_ro(disk);
>  
>  	if (info) {
>  		struct partition_meta_info *pinfo = alloc_part_info(disk);
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index 06c0fd594097..3ebd94f520cc 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -118,7 +118,8 @@ struct hd_struct {
>  	unsigned int discard_alignment;
>  	struct device __dev;
>  	struct kobject *holder_dir;
> -	int policy, partno;
> +	bool read_only, ro_policy;
> +	int partno;
>  	struct partition_meta_info *info;
>  #ifdef CONFIG_FAIL_MAKE_REQUEST
>  	int make_it_fail;
> @@ -183,6 +184,7 @@ struct gendisk {
>  
>  	char disk_name[DISK_NAME_LEN];	/* name of major driver */
>  	char *(*devnode)(struct gendisk *gd, umode_t *mode);
> +	bool read_only;			/* device read-only state */
>  
>  	unsigned int events;		/* supported events */
>  	unsigned int async_events;	/* async events, subset of all */
> @@ -431,12 +433,12 @@ extern void del_gendisk(struct gendisk *gp);
>  extern struct gendisk *get_gendisk(dev_t dev, int *partno);
>  extern struct block_device *bdget_disk(struct gendisk *disk, int partno);
>  
> -extern void set_device_ro(struct block_device *bdev, int flag);
> -extern void set_disk_ro(struct gendisk *disk, int flag);
> +extern void set_device_ro(struct block_device *bdev, bool state);
> +extern void set_disk_ro(struct gendisk *disk, bool state);
>  
>  static inline int get_disk_ro(struct gendisk *disk)
>  {
> -	return disk->part0.policy;
> +	return disk->part0.read_only;
>  }
>  
>  extern void disk_block_events(struct gendisk *disk);

Looks good.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


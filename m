Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6458F16450
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 15:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfEGNL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 09:11:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60474 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbfEGNL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 09:11:27 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6DB473084034;
        Tue,  7 May 2019 13:11:26 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CAC371A4D9;
        Tue,  7 May 2019 13:11:25 +0000 (UTC)
Message-ID: <ad48a69bb946c5d244755ddbd1af8111c1f90770.camel@redhat.com>
Subject: Re: [REPOST, PATCH] scsi: sd: block: Fix regressions in read-only
 block device handling
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Jeremy Cline <jeremy@jcline.org>,
        Oleksii Kurochko <olkuroch@cisco.com>, stable@vger.kernel.org
Date:   Tue, 07 May 2019 09:11:25 -0400
In-Reply-To: <20190327162141.23882-1-martin.petersen@oracle.com>
References: <20190327162141.23882-1-martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 07 May 2019 13:11:26 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2019-03-27 at 12:21 -0400, Martin K. Petersen wrote:
> Some devices come online in write protected state and switch to
> read-write once they are ready to process I/O requests. These devices
> broke with commit 20bd1d026aac ("scsi: sd: Keep disk read-only when
> re-reading partition") because we had no way to distinguish between a
> user decision to set a block_device read-only and the actual hardware
> device being write-protected.
> 
> Because partitions are dropped and recreated on revalidate we are
> unable to persist any user-provided policy in hd_struct. Introduce a
> bitmap in struct gendisk to track the user configuration. This bitmap
> is updated when BLKROSET is called on a given disk or partition.
> 
> A helper function, get_user_ro(), is provided to determine whether the
> ioctl has forced read-only state for a given block device. This helper
> is used by set_disk_ro() and add_partition() to ensure that both
> existing and newly created partitions will get the correct state.
> 
>  - If BLKROSET sets a whole disk device read-only, all partitions will
>    now end up in a read-only state.
> 
>  - If BLKROSET sets a given partition read-only, that partition will
>    remain read-only post revalidate.
> 
>  - Otherwise both the whole disk device and any partitions will
>    reflect the write protect state of the underlying device.
> 
> Since nobody knows what "policy" means, rename the field to
> "read_only" for clarity.
> 
> Cc: Jeremy Cline <jeremy@jcline.org>
> Cc: Oleksii Kurochko <olkuroch@cisco.com>
> Cc: stable@vger.kernel.org # v4.16+
> Reported-by: Oleksii Kurochko <olkuroch@cisco.com>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201221
> Fixes: 20bd1d026aac ("scsi: sd: Keep disk read-only when re-reading partition")
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> ---
> 
> v3:
> 	- Drop ?: since gcc complains about mixing int and bool (zeroday)
> 	- Drop EXPORT_SYMBOL (hch)
> 	- s/policy/read_only/ and make it a boolean
> 
> v2:
> 	- Track user read-only state in a bitmap
> 
> 	- Work around the regression that caused us to drop user
> 	  preferences on revalidate
> ---
>  block/blk-core.c          |  2 +-
>  block/genhd.c             | 34 ++++++++++++++++++++++++----------
>  block/ioctl.c             |  4 ++++
>  block/partition-generic.c |  7 +++++--
>  drivers/scsi/sd.c         |  4 +---
>  include/linux/genhd.h     | 11 +++++++----
>  6 files changed, 42 insertions(+), 20 deletions(-)
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
> index 703267865f14..9f3a93ca1851 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1539,26 +1539,40 @@ static void set_disk_ro_uevent(struct gendisk *gd, int ro)
>  	kobject_uevent_env(&disk_to_dev(gd)->kobj, KOBJ_CHANGE, envp);
>  }
>  
> -void set_device_ro(struct block_device *bdev, int flag)
> +void set_device_ro(struct block_device *bdev, bool state)
>  {
> -	bdev->bd_part->policy = flag;
> +	bdev->bd_part->read_only = state;
>  }
>  
>  EXPORT_SYMBOL(set_device_ro);
>  
> -void set_disk_ro(struct gendisk *disk, int flag)
> +bool get_user_ro(struct gendisk *disk, unsigned int partno)
> +{
> +	/* Is the user read-only bit set for the whole disk device? */
> +	if (test_bit(0, disk->user_ro_bitmap))
> +		return true;
> +
> +	/* Is the user read-only bit set for this particular partition? */
> +	if (test_bit(partno, disk->user_ro_bitmap))
> +		return true;
> +
> +	return false;
> +}
> +
> +void set_disk_ro(struct gendisk *disk, bool state)
>  {
>  	struct disk_part_iter piter;
>  	struct hd_struct *part;
>  
> -	if (disk->part0.policy != flag) {
> -		set_disk_ro_uevent(disk, flag);
> -		disk->part0.policy = flag;
> -	}
> +	if (disk->part0.read_only != state)
> +		set_disk_ro_uevent(disk, state);
>  
> -	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
> +	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY_PART0);
>  	while ((part = disk_part_iter_next(&piter)))
> -		part->policy = flag;
> +		if (get_user_ro(disk, part->partno))
> +			part->read_only = true;
> +		else
> +			part->read_only = state;
>  	disk_part_iter_exit(&piter);
>  }
>  
> @@ -1568,7 +1582,7 @@ int bdev_read_only(struct block_device *bdev)
>  {
>  	if (!bdev)
>  		return 0;
> -	return bdev->bd_part->policy;
> +	return bdev->bd_part->read_only;
>  }
>  
>  EXPORT_SYMBOL(bdev_read_only);
> diff --git a/block/ioctl.c b/block/ioctl.c
> index 4825c78a6baa..41206df89485 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -451,6 +451,10 @@ static int blkdev_roset(struct block_device *bdev, fmode_t mode,
>  		return ret;
>  	if (get_user(n, (int __user *)arg))
>  		return -EFAULT;
> +	if (n)
> +		set_bit(bdev->bd_partno, bdev->bd_disk->user_ro_bitmap);
> +	else
> +		clear_bit(bdev->bd_partno, bdev->bd_disk->user_ro_bitmap);
>  	set_device_ro(bdev, n);
>  	return 0;
>  }
> diff --git a/block/partition-generic.c b/block/partition-generic.c
> index 8e596a8dff32..2bade849cc5c 100644
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
> @@ -338,7 +338,10 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
>  		queue_limit_discard_alignment(&disk->queue->limits, start);
>  	p->nr_sects = len;
>  	p->partno = partno;
> -	p->policy = get_disk_ro(disk);
> +	if (get_user_ro(disk, partno))
> +		p->read_only = true;
> +	else
> +		p->read_only = get_disk_ro(disk);
>  
>  	if (info) {
>  		struct partition_meta_info *pinfo = alloc_part_info(disk);
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 251db30d0882..9d8e15d03d2b 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2608,10 +2608,8 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
>  	int res;
>  	struct scsi_device *sdp = sdkp->device;
>  	struct scsi_mode_data data;
> -	int disk_ro = get_disk_ro(sdkp->disk);
>  	int old_wp = sdkp->write_prot;
>  
> -	set_disk_ro(sdkp->disk, 0);
>  	if (sdp->skip_ms_page_3f) {
>  		sd_first_printk(KERN_NOTICE, sdkp, "Assuming Write Enabled\n");
>  		return;
> @@ -2649,7 +2647,7 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
>  			  "Test WP failed, assume Write Enabled\n");
>  	} else {
>  		sdkp->write_prot = ((data.device_specific & 0x80) != 0);
> -		set_disk_ro(sdkp->disk, sdkp->write_prot || disk_ro);
> +		set_disk_ro(sdkp->disk, sdkp->write_prot);
>  		if (sdkp->first_scan || old_wp != sdkp->write_prot) {
>  			sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
>  				  sdkp->write_prot ? "on" : "off");
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index 06c0fd594097..1abde0e88ccb 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -118,7 +118,8 @@ struct hd_struct {
>  	unsigned int discard_alignment;
>  	struct device __dev;
>  	struct kobject *holder_dir;
> -	int policy, partno;
> +	bool read_only;
> +	int partno;
>  	struct partition_meta_info *info;
>  #ifdef CONFIG_FAIL_MAKE_REQUEST
>  	int make_it_fail;
> @@ -194,6 +195,7 @@ struct gendisk {
>  	 */
>  	struct disk_part_tbl __rcu *part_tbl;
>  	struct hd_struct part0;
> +	DECLARE_BITMAP(user_ro_bitmap, DISK_MAX_PARTS);
>  
>  	const struct block_device_operations *fops;
>  	struct request_queue *queue;
> @@ -431,12 +433,13 @@ extern void del_gendisk(struct gendisk *gp);
>  extern struct gendisk *get_gendisk(dev_t dev, int *partno);
>  extern struct block_device *bdget_disk(struct gendisk *disk, int partno);
>  
> -extern void set_device_ro(struct block_device *bdev, int flag);
> -extern void set_disk_ro(struct gendisk *disk, int flag);
> +extern void set_device_ro(struct block_device *bdev, bool state);
> +extern void set_disk_ro(struct gendisk *disk, bool state);
> +extern bool get_user_ro(struct gendisk *disk, unsigned int partno);
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


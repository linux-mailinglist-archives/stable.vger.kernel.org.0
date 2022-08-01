Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C23F5586BC3
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 15:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiHANSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 09:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbiHANRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 09:17:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E26F2CC8B;
        Mon,  1 Aug 2022 06:17:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 366E0B810A2;
        Mon,  1 Aug 2022 13:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BAEC433C1;
        Mon,  1 Aug 2022 13:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659359864;
        bh=zH3Ehn/hIVUzMnTuGSwQkNzgUb3aYG3WZTwUWiuSkHc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iIkI4k/7mSmDzMpQaqoYn819arD0ForNseYCl22jiJ4j0fkhH2M8TM+8IVcZ1PvD7
         A6E6+wsMO4aU9pxhWpJoqQo/BOnskx7BARIso/I9PdDrXLnTMWqWWHm4m9rYbgxtYG
         B7nJPdrrF/0YxcwFu++/aBsFR4yllp3v38tC27qY=
Date:   Mon, 1 Aug 2022 15:17:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     stable@vger.kernel.org, hch@lst.de, axboe@kernel.dk,
        snitzer@redhat.com, dm-devel@redhat.com,
        linux-block@vger.kernel.org, yi.zhang@huawei.com,
        "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH stable 5.10 1/3] block: look up holders by bdev
Message-ID: <YufSdhzXq/Fmozdw@kroah.com>
References: <20220729062356.1663513-1-yukuai1@huaweicloud.com>
 <20220729062356.1663513-2-yukuai1@huaweicloud.com>
 <Yue2rU2Y+xzvGU6x@kroah.com>
 <93acbb5c-5dae-cdf1-5ed2-2c7f5fba6dc7@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <93acbb5c-5dae-cdf1-5ed2-2c7f5fba6dc7@huaweicloud.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 01, 2022 at 08:25:27PM +0800, Yu Kuai wrote:
> Hi, Greg
> 
> 在 2022/08/01 19:19, Greg KH 写道:
> > On Fri, Jul 29, 2022 at 02:23:54PM +0800, Yu Kuai wrote:
> > > From: Christoph Hellwig <hch@lst.de>
> > > 
> > > commit 0dbcfe247f22a6d73302dfa691c48b3c14d31c4c upstream.
> > > 
> > > Invert they way the holder relations are tracked.  This very
> > > slightly reduces the memory overhead for partitioned devices.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> > > ---
> > >   block/genhd.c             |  3 +++
> > >   fs/block_dev.c            | 31 +++++++++++++++++++------------
> > >   include/linux/blk_types.h |  3 ---
> > >   include/linux/genhd.h     |  4 +++-
> > >   4 files changed, 25 insertions(+), 16 deletions(-)
> > > 
> > > diff --git a/block/genhd.c b/block/genhd.c
> > > index 796baf761202..2b11a2735285 100644
> > > --- a/block/genhd.c
> > > +++ b/block/genhd.c
> > > @@ -1760,6 +1760,9 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
> > >   	disk_to_dev(disk)->class = &block_class;
> > >   	disk_to_dev(disk)->type = &disk_type;
> > >   	device_initialize(disk_to_dev(disk));
> > > +#ifdef CONFIG_SYSFS
> > > +	INIT_LIST_HEAD(&disk->slave_bdevs);
> > > +#endif
> > >   	return disk;
> > >   out_free_part0:
> > > diff --git a/fs/block_dev.c b/fs/block_dev.c
> > > index 29f020c4b2d0..a202c76fcf7f 100644
> > > --- a/fs/block_dev.c
> > > +++ b/fs/block_dev.c
> > > @@ -823,9 +823,6 @@ static void init_once(void *foo)
> > >   	memset(bdev, 0, sizeof(*bdev));
> > >   	mutex_init(&bdev->bd_mutex);
> > > -#ifdef CONFIG_SYSFS
> > > -	INIT_LIST_HEAD(&bdev->bd_holder_disks);
> > > -#endif
> > >   	bdev->bd_bdi = &noop_backing_dev_info;
> > >   	inode_init_once(&ei->vfs_inode);
> > >   	/* Initialize mutex for freeze. */
> > > @@ -1188,7 +1185,7 @@ EXPORT_SYMBOL(bd_abort_claiming);
> > >   #ifdef CONFIG_SYSFS
> > >   struct bd_holder_disk {
> > >   	struct list_head	list;
> > > -	struct gendisk		*disk;
> > > +	struct block_device	*bdev;
> > >   	int			refcnt;
> > >   };
> > > @@ -1197,8 +1194,8 @@ static struct bd_holder_disk *bd_find_holder_disk(struct block_device *bdev,
> > >   {
> > >   	struct bd_holder_disk *holder;
> > > -	list_for_each_entry(holder, &bdev->bd_holder_disks, list)
> > > -		if (holder->disk == disk)
> > > +	list_for_each_entry(holder, &disk->slave_bdevs, list)
> > > +		if (holder->bdev == bdev)
> > >   			return holder;
> > >   	return NULL;
> > >   }
> > > @@ -1244,9 +1241,13 @@ static void del_symlink(struct kobject *from, struct kobject *to)
> > >   int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
> > >   {
> > >   	struct bd_holder_disk *holder;
> > > +	struct block_device *bdev_holder = bdget_disk(disk, 0);
> > >   	int ret = 0;
> > > -	mutex_lock(&bdev->bd_mutex);
> > > +	if (WARN_ON_ONCE(!bdev_holder))
> > > +		return -ENOENT;
> > > +
> > > +	mutex_lock(&bdev_holder->bd_mutex);
> > >   	WARN_ON_ONCE(!bdev->bd_holder);
> > > @@ -1267,7 +1268,7 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
> > >   	}
> > >   	INIT_LIST_HEAD(&holder->list);
> > > -	holder->disk = disk;
> > > +	holder->bdev = bdev;
> > >   	holder->refcnt = 1;
> > >   	ret = add_symlink(disk->slave_dir, &part_to_dev(bdev->bd_part)->kobj);
> > > @@ -1283,7 +1284,7 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
> > >   	 */
> > >   	kobject_get(bdev->bd_part->holder_dir);
> > > -	list_add(&holder->list, &bdev->bd_holder_disks);
> > > +	list_add(&holder->list, &disk->slave_bdevs);
> > >   	goto out_unlock;
> > >   out_del:
> > > @@ -1291,7 +1292,8 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
> > >   out_free:
> > >   	kfree(holder);
> > >   out_unlock:
> > > -	mutex_unlock(&bdev->bd_mutex);
> > > +	mutex_unlock(&bdev_holder->bd_mutex);
> > > +	bdput(bdev_holder);
> > >   	return ret;
> > >   }
> > >   EXPORT_SYMBOL_GPL(bd_link_disk_holder);
> > > @@ -1309,8 +1311,12 @@ EXPORT_SYMBOL_GPL(bd_link_disk_holder);
> > >   void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
> > >   {
> > >   	struct bd_holder_disk *holder;
> > > +	struct block_device *bdev_holder = bdget_disk(disk, 0);
> > > -	mutex_lock(&bdev->bd_mutex);
> > > +	if (WARN_ON_ONCE(!bdev_holder))
> > > +		return;
> > > +
> > > +	mutex_lock(&bdev_holder->bd_mutex);
> > >   	holder = bd_find_holder_disk(bdev, disk);
> > > @@ -1323,7 +1329,8 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
> > >   		kfree(holder);
> > >   	}
> > > -	mutex_unlock(&bdev->bd_mutex);
> > > +	mutex_unlock(&bdev_holder->bd_mutex);
> > > +	bdput(bdev_holder);
> > >   }
> > >   EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
> > >   #endif
> > > diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> > > index d9b69bbde5cc..1b84ecb34c18 100644
> > > --- a/include/linux/blk_types.h
> > > +++ b/include/linux/blk_types.h
> > > @@ -29,9 +29,6 @@ struct block_device {
> > >   	void *			bd_holder;
> > >   	int			bd_holders;
> > >   	bool			bd_write_holder;
> > > -#ifdef CONFIG_SYSFS
> > > -	struct list_head	bd_holder_disks;
> > > -#endif
> > >   	struct block_device *	bd_contains;
> > >   	u8			bd_partno;
> > >   	struct hd_struct *	bd_part;
> > > diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> > > index 03da3f603d30..3e5049a527e6 100644
> > > --- a/include/linux/genhd.h
> > > +++ b/include/linux/genhd.h
> > > @@ -195,7 +195,9 @@ struct gendisk {
> > >   #define GD_NEED_PART_SCAN		0
> > >   	struct rw_semaphore lookup_sem;
> > >   	struct kobject *slave_dir;
> > > -
> > > +#ifdef CONFIG_SYSFS
> > > +	struct list_head	slave_bdevs;
> > > +#endif
> > 
> > This is very different from the upstream version, and forces the change
> > onto everyone, not just those who had CONFIG_BLOCK_HOLDER_DEPRECATED
> > enabled like was done in the main kernel tree.
> > 
> > Why force this on all and not just use the same option?
> > 
> > I would need a strong ACK from the original developers and maintainers
> > of these subsystems before being able to take these into the 5.10 tree.
> 
> Yes, I agree that Christoph must take a look first.
> > 
> > What prevents you from just using 5.15 for those systems that run into
> > these issues?
> 
> The null pointer problem is reported by our product(related to dm-
> mpath), and they had been using 5.10 for a long time. And switching
> kernel for commercial will require lots of work, it's not an option
> for now.

It should be the same validation and verification and testing path for
5.15.y as for an intrusive kernel change as this one, right?  What makes
it any different to prevent 5.15 from being used?

thanks,

greg k-h

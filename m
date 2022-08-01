Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09380586B09
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbiHAMnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234871AbiHAMnG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:43:06 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082B3D10C;
        Mon,  1 Aug 2022 05:25:30 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4LxHNs35LpzKFJG;
        Mon,  1 Aug 2022 20:24:13 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP3 (Coremail) with SMTP id _Ch0CgD3djA3xudiJIdKAA--.40632S3;
        Mon, 01 Aug 2022 20:25:28 +0800 (CST)
Subject: Re: [PATCH stable 5.10 1/3] block: look up holders by bdev
To:     Greg KH <gregkh@linuxfoundation.org>,
        Yu Kuai <yukuai1@huaweicloud.com>
Cc:     stable@vger.kernel.org, hch@lst.de, axboe@kernel.dk,
        snitzer@redhat.com, dm-devel@redhat.com,
        linux-block@vger.kernel.org, yi.zhang@huawei.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20220729062356.1663513-1-yukuai1@huaweicloud.com>
 <20220729062356.1663513-2-yukuai1@huaweicloud.com>
 <Yue2rU2Y+xzvGU6x@kroah.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <93acbb5c-5dae-cdf1-5ed2-2c7f5fba6dc7@huaweicloud.com>
Date:   Mon, 1 Aug 2022 20:25:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <Yue2rU2Y+xzvGU6x@kroah.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _Ch0CgD3djA3xudiJIdKAA--.40632S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Xw15Gw45uFWDCr4fKryrtFb_yoWxJFW5pF
        98JFZ5GFW8JrW7Wr4Iqa13ZFZIqw48K3WxGFyakF1fKrZrtrs2vF1Utr1UuF92krZ7Kr42
        qF17WFZIkF1093DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
        0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
        kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
        67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
        CI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E
        3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
        sGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Greg

ÔÚ 2022/08/01 19:19, Greg KH Ð´µÀ:
> On Fri, Jul 29, 2022 at 02:23:54PM +0800, Yu Kuai wrote:
>> From: Christoph Hellwig <hch@lst.de>
>>
>> commit 0dbcfe247f22a6d73302dfa691c48b3c14d31c4c upstream.
>>
>> Invert they way the holder relations are tracked.  This very
>> slightly reduces the memory overhead for partitioned devices.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   block/genhd.c             |  3 +++
>>   fs/block_dev.c            | 31 +++++++++++++++++++------------
>>   include/linux/blk_types.h |  3 ---
>>   include/linux/genhd.h     |  4 +++-
>>   4 files changed, 25 insertions(+), 16 deletions(-)
>>
>> diff --git a/block/genhd.c b/block/genhd.c
>> index 796baf761202..2b11a2735285 100644
>> --- a/block/genhd.c
>> +++ b/block/genhd.c
>> @@ -1760,6 +1760,9 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
>>   	disk_to_dev(disk)->class = &block_class;
>>   	disk_to_dev(disk)->type = &disk_type;
>>   	device_initialize(disk_to_dev(disk));
>> +#ifdef CONFIG_SYSFS
>> +	INIT_LIST_HEAD(&disk->slave_bdevs);
>> +#endif
>>   	return disk;
>>   
>>   out_free_part0:
>> diff --git a/fs/block_dev.c b/fs/block_dev.c
>> index 29f020c4b2d0..a202c76fcf7f 100644
>> --- a/fs/block_dev.c
>> +++ b/fs/block_dev.c
>> @@ -823,9 +823,6 @@ static void init_once(void *foo)
>>   
>>   	memset(bdev, 0, sizeof(*bdev));
>>   	mutex_init(&bdev->bd_mutex);
>> -#ifdef CONFIG_SYSFS
>> -	INIT_LIST_HEAD(&bdev->bd_holder_disks);
>> -#endif
>>   	bdev->bd_bdi = &noop_backing_dev_info;
>>   	inode_init_once(&ei->vfs_inode);
>>   	/* Initialize mutex for freeze. */
>> @@ -1188,7 +1185,7 @@ EXPORT_SYMBOL(bd_abort_claiming);
>>   #ifdef CONFIG_SYSFS
>>   struct bd_holder_disk {
>>   	struct list_head	list;
>> -	struct gendisk		*disk;
>> +	struct block_device	*bdev;
>>   	int			refcnt;
>>   };
>>   
>> @@ -1197,8 +1194,8 @@ static struct bd_holder_disk *bd_find_holder_disk(struct block_device *bdev,
>>   {
>>   	struct bd_holder_disk *holder;
>>   
>> -	list_for_each_entry(holder, &bdev->bd_holder_disks, list)
>> -		if (holder->disk == disk)
>> +	list_for_each_entry(holder, &disk->slave_bdevs, list)
>> +		if (holder->bdev == bdev)
>>   			return holder;
>>   	return NULL;
>>   }
>> @@ -1244,9 +1241,13 @@ static void del_symlink(struct kobject *from, struct kobject *to)
>>   int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
>>   {
>>   	struct bd_holder_disk *holder;
>> +	struct block_device *bdev_holder = bdget_disk(disk, 0);
>>   	int ret = 0;
>>   
>> -	mutex_lock(&bdev->bd_mutex);
>> +	if (WARN_ON_ONCE(!bdev_holder))
>> +		return -ENOENT;
>> +
>> +	mutex_lock(&bdev_holder->bd_mutex);
>>   
>>   	WARN_ON_ONCE(!bdev->bd_holder);
>>   
>> @@ -1267,7 +1268,7 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
>>   	}
>>   
>>   	INIT_LIST_HEAD(&holder->list);
>> -	holder->disk = disk;
>> +	holder->bdev = bdev;
>>   	holder->refcnt = 1;
>>   
>>   	ret = add_symlink(disk->slave_dir, &part_to_dev(bdev->bd_part)->kobj);
>> @@ -1283,7 +1284,7 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
>>   	 */
>>   	kobject_get(bdev->bd_part->holder_dir);
>>   
>> -	list_add(&holder->list, &bdev->bd_holder_disks);
>> +	list_add(&holder->list, &disk->slave_bdevs);
>>   	goto out_unlock;
>>   
>>   out_del:
>> @@ -1291,7 +1292,8 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
>>   out_free:
>>   	kfree(holder);
>>   out_unlock:
>> -	mutex_unlock(&bdev->bd_mutex);
>> +	mutex_unlock(&bdev_holder->bd_mutex);
>> +	bdput(bdev_holder);
>>   	return ret;
>>   }
>>   EXPORT_SYMBOL_GPL(bd_link_disk_holder);
>> @@ -1309,8 +1311,12 @@ EXPORT_SYMBOL_GPL(bd_link_disk_holder);
>>   void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
>>   {
>>   	struct bd_holder_disk *holder;
>> +	struct block_device *bdev_holder = bdget_disk(disk, 0);
>>   
>> -	mutex_lock(&bdev->bd_mutex);
>> +	if (WARN_ON_ONCE(!bdev_holder))
>> +		return;
>> +
>> +	mutex_lock(&bdev_holder->bd_mutex);
>>   
>>   	holder = bd_find_holder_disk(bdev, disk);
>>   
>> @@ -1323,7 +1329,8 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
>>   		kfree(holder);
>>   	}
>>   
>> -	mutex_unlock(&bdev->bd_mutex);
>> +	mutex_unlock(&bdev_holder->bd_mutex);
>> +	bdput(bdev_holder);
>>   }
>>   EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
>>   #endif
>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>> index d9b69bbde5cc..1b84ecb34c18 100644
>> --- a/include/linux/blk_types.h
>> +++ b/include/linux/blk_types.h
>> @@ -29,9 +29,6 @@ struct block_device {
>>   	void *			bd_holder;
>>   	int			bd_holders;
>>   	bool			bd_write_holder;
>> -#ifdef CONFIG_SYSFS
>> -	struct list_head	bd_holder_disks;
>> -#endif
>>   	struct block_device *	bd_contains;
>>   	u8			bd_partno;
>>   	struct hd_struct *	bd_part;
>> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
>> index 03da3f603d30..3e5049a527e6 100644
>> --- a/include/linux/genhd.h
>> +++ b/include/linux/genhd.h
>> @@ -195,7 +195,9 @@ struct gendisk {
>>   #define GD_NEED_PART_SCAN		0
>>   	struct rw_semaphore lookup_sem;
>>   	struct kobject *slave_dir;
>> -
>> +#ifdef CONFIG_SYSFS
>> +	struct list_head	slave_bdevs;
>> +#endif
> 
> This is very different from the upstream version, and forces the change
> onto everyone, not just those who had CONFIG_BLOCK_HOLDER_DEPRECATED
> enabled like was done in the main kernel tree.
> 
> Why force this on all and not just use the same option?
> 
> I would need a strong ACK from the original developers and maintainers
> of these subsystems before being able to take these into the 5.10 tree.

Yes, I agree that Christoph must take a look first.
> 
> What prevents you from just using 5.15 for those systems that run into
> these issues?

The null pointer problem is reported by our product(related to dm-
mpath), and they had been using 5.10 for a long time. And switching
kernel for commercial will require lots of work, it's not an option
for now.

Thanks,
Kuai


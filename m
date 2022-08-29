Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639C75A4115
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 04:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiH2Cci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Aug 2022 22:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiH2Cch (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Aug 2022 22:32:37 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22AA730F6D;
        Sun, 28 Aug 2022 19:32:36 -0700 (PDT)
Subject: Re: [PATCH 5.10 055/545] md-raid: destroy the bitmap after destroying
 the thread
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661740353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G/zxIS5zqaRaC4QjSt04plEeX/jYzUPGlco6IhkDxxU=;
        b=nXgL8HZ753Aa/GKO3AawO73ga8XZ14VyFMatENgrm915otxB09Lm+dYUTlGeqqI3O0p+g+
        EucyJuqQhQrBc9JRrM4NscyBrhgxg3ij1IrNZlVEEAA9CUnT7nx64cgy/7zzFb2nRsvtv5
        yr06VfQnELreWu46qsTtfAwpl5zKJcI=
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <20220819153829.135562864@linuxfoundation.org>
 <20220819153831.691474713@linuxfoundation.org>
 <0075cc2c-c48d-c7b7-5f08-f1c4322ef2bc@linux.dev> <YwMhmoVlq9Dc8uAk@kroah.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <d841adb6-c9b0-372c-2145-1bca29a013ac@linux.dev>
Date:   Mon, 29 Aug 2022 10:32:30 +0800
MIME-Version: 1.0
In-Reply-To: <YwMhmoVlq9Dc8uAk@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/22/22 2:26 PM, Greg Kroah-Hartman wrote:
> On Mon, Aug 22, 2022 at 01:33:47PM +0800, Guoqing Jiang wrote:
>>
>> On 8/19/22 11:37 PM, Greg Kroah-Hartman wrote:
>>> From: Mikulas Patocka <mpatocka@redhat.com>
>>>
>>> commit e151db8ecfb019b7da31d076130a794574c89f6f upstream.
>>>
>>> When we ran the lvm test "shell/integrity-blocksize-3.sh" on a kernel with
>>> kasan, we got failure in write_page.
>>>
>>> The reason for the failure is that md_bitmap_destroy is called before
>>> destroying the thread and the thread may be waiting in the function
>>> write_page for the bio to complete. When the thread finishes waiting, it
>>> executes "if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))", which
>>> triggers the kasan warning.
>>>
>>> Note that the commit 48df498daf62 that caused this bug claims that it is
>>> neede for md-cluster, you should check md-cluster and possibly find
>>> another bugfix for it.
>>>
>>> BUG: KASAN: use-after-free in write_page+0x18d/0x680 [md_mod]
>>> Read of size 8 at addr ffff889162030c78 by task mdX_raid1/5539
>>>
>>> CPU: 10 PID: 5539 Comm: mdX_raid1 Not tainted 5.19.0-rc2 #1
>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
>>> Call Trace:
>>>    <TASK>
>>>    dump_stack_lvl+0x34/0x44
>>>    print_report.cold+0x45/0x57a
>>>    ? __lock_text_start+0x18/0x18
>>>    ? write_page+0x18d/0x680 [md_mod]
>>>    kasan_report+0xa8/0xe0
>>>    ? write_page+0x18d/0x680 [md_mod]
>>>    kasan_check_range+0x13f/0x180
>>>    write_page+0x18d/0x680 [md_mod]
>>>    ? super_sync+0x4d5/0x560 [dm_raid]
>>>    ? md_bitmap_file_kick+0xa0/0xa0 [md_mod]
>>>    ? rs_set_dev_and_array_sectors+0x2e0/0x2e0 [dm_raid]
>>>    ? mutex_trylock+0x120/0x120
>>>    ? preempt_count_add+0x6b/0xc0
>>>    ? preempt_count_sub+0xf/0xc0
>>>    md_update_sb+0x707/0xe40 [md_mod]
>>>    md_reap_sync_thread+0x1b2/0x4a0 [md_mod]
>>>    md_check_recovery+0x533/0x960 [md_mod]
>>>    raid1d+0xc8/0x2a20 [raid1]
>>>    ? var_wake_function+0xe0/0xe0
>>>    ? psi_group_change+0x411/0x500
>>>    ? preempt_count_sub+0xf/0xc0
>>>    ? _raw_spin_lock_irqsave+0x78/0xc0
>>>    ? __lock_text_start+0x18/0x18
>>>    ? raid1_end_read_request+0x2a0/0x2a0 [raid1]
>>>    ? preempt_count_sub+0xf/0xc0
>>>    ? _raw_spin_unlock_irqrestore+0x19/0x40
>>>    ? del_timer_sync+0xa9/0x100
>>>    ? try_to_del_timer_sync+0xc0/0xc0
>>>    ? _raw_spin_lock_irqsave+0x78/0xc0
>>>    ? __lock_text_start+0x18/0x18
>>>    ? __list_del_entry_valid+0x68/0xa0
>>>    ? finish_wait+0xa3/0x100
>>>    md_thread+0x161/0x260 [md_mod]
>>>    ? unregister_md_personality+0xa0/0xa0 [md_mod]
>>>    ? _raw_spin_lock_irqsave+0x78/0xc0
>>>    ? prepare_to_wait_event+0x2c0/0x2c0
>>>    ? unregister_md_personality+0xa0/0xa0 [md_mod]
>>>    kthread+0x148/0x180
>>>    ? kthread_complete_and_exit+0x20/0x20
>>>    ret_from_fork+0x1f/0x30
>>>    </TASK>
>>>
>>> Allocated by task 5522:
>>>    kasan_save_stack+0x1e/0x40
>>>    __kasan_kmalloc+0x80/0xa0
>>>    md_bitmap_create+0xa8/0xe80 [md_mod]
>>>    md_run+0x777/0x1300 [md_mod]
>>>    raid_ctr+0x249c/0x4a30 [dm_raid]
>>>    dm_table_add_target+0x2b0/0x620 [dm_mod]
>>>    table_load+0x1c8/0x400 [dm_mod]
>>>    ctl_ioctl+0x29e/0x560 [dm_mod]
>>>    dm_compat_ctl_ioctl+0x7/0x20 [dm_mod]
>>>    __do_compat_sys_ioctl+0xfa/0x160
>>>    do_syscall_64+0x90/0xc0
>>>    entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>>
>>> Freed by task 5680:
>>>    kasan_save_stack+0x1e/0x40
>>>    kasan_set_track+0x21/0x40
>>>    kasan_set_free_info+0x20/0x40
>>>    __kasan_slab_free+0xf7/0x140
>>>    kfree+0x80/0x240
>>>    md_bitmap_free+0x1c3/0x280 [md_mod]
>>>    __md_stop+0x21/0x120 [md_mod]
>>>    md_stop+0x9/0x40 [md_mod]
>>>    raid_dtr+0x1b/0x40 [dm_raid]
>>>    dm_table_destroy+0x98/0x1e0 [dm_mod]
>>>    __dm_destroy+0x199/0x360 [dm_mod]
>>>    dev_remove+0x10c/0x160 [dm_mod]
>>>    ctl_ioctl+0x29e/0x560 [dm_mod]
>>>    dm_compat_ctl_ioctl+0x7/0x20 [dm_mod]
>>>    __do_compat_sys_ioctl+0xfa/0x160
>>>    do_syscall_64+0x90/0xc0
>>>    entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>>
>>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>> Cc: stable@vger.kernel.org
>>> Fixes: 48df498daf62 ("md: move bitmap_destroy to the beginning of __md_stop")
>>> Signed-off-by: Song Liu <song@kernel.org>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>>>    drivers/md/md.c |    2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -6278,11 +6278,11 @@ static void mddev_detach(struct mddev *m
>>>    static void __md_stop(struct mddev *mddev)
>>>    {
>>>    	struct md_personality *pers = mddev->pers;
>>> -	md_bitmap_destroy(mddev);
>>>    	mddev_detach(mddev);
>>>    	/* Ensure ->event_work is done */
>>>    	if (mddev->event_work.func)
>>>    		flush_workqueue(md_misc_wq);
>>> +	md_bitmap_destroy(mddev);
>>>    	spin_lock(&mddev->lock);
>>>    	mddev->pers = NULL;
>>>    	spin_unlock(&mddev->lock);
>> Pls consider drop this one from stable per the link given it cause issue for
>> md-cluster.
>>
>> https://lore.kernel.org/linux-raid/a6657e08-b6a7-358b-2d2a-0ac37d49d23a@linux.dev/T/#m95ac225cab7409f66c295772483d091084a6d470
> I will just take the fixup patch when it hits Linus's tree as this
> commit is already in the following releases:
> 	5.10.137 5.15.61 5.18.18 5.19.2

It is reverted by the commit.

1d258758cf06 Revert "md-raid: destroy the bitmap after destroying the 
thread"

And the original problem should be fixed with this one.

0dd84b319352 md: call __md_stop_writes in md_stop

Please consider take the two patches, I assume they can be applied 
directly, otherwise I will send them later.

Thanks,
Guoqing

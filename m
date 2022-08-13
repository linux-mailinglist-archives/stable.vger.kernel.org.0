Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3C6591AF6
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 16:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239547AbiHMO2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 10:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239419AbiHMO2y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 10:28:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1443327B2D
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 07:28:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2C6260DED
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 14:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DF5C433D6;
        Sat, 13 Aug 2022 14:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660400932;
        bh=tOal3ZBf2c9F/4EVimhXb5i4D/vhj4pdgJe+ISSeZXo=;
        h=Subject:To:Cc:From:Date:From;
        b=UpDtPcTVqtvYRRbfisb6RQ6g9ycq4jfrMDZzg5rBpFuYJz1+fvp4+zmIUeKcS8gN5
         bBG+s1J3nCu5AVxUHXuoXeLuqRYI4StV94b0MWTdpWnjOr46HbncQqBkyc6cQ/nTFG
         AHKhT0Ykbrk8o0iATCBQpn17/G+lWlJoFaOa9cVA=
Subject: FAILED: patch "[PATCH] md-raid: destroy the bitmap after destroying the thread" failed to apply to 5.4-stable tree
To:     mpatocka@redhat.com, axboe@kernel.dk, song@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 16:28:49 +0200
Message-ID: <166040092923374@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e151db8ecfb019b7da31d076130a794574c89f6f Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Sun, 24 Jul 2022 14:26:12 -0400
Subject: [PATCH] md-raid: destroy the bitmap after destroying the thread

When we ran the lvm test "shell/integrity-blocksize-3.sh" on a kernel with
kasan, we got failure in write_page.

The reason for the failure is that md_bitmap_destroy is called before
destroying the thread and the thread may be waiting in the function
write_page for the bio to complete. When the thread finishes waiting, it
executes "if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))", which
triggers the kasan warning.

Note that the commit 48df498daf62 that caused this bug claims that it is
neede for md-cluster, you should check md-cluster and possibly find
another bugfix for it.

BUG: KASAN: use-after-free in write_page+0x18d/0x680 [md_mod]
Read of size 8 at addr ffff889162030c78 by task mdX_raid1/5539

CPU: 10 PID: 5539 Comm: mdX_raid1 Not tainted 5.19.0-rc2 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x34/0x44
 print_report.cold+0x45/0x57a
 ? __lock_text_start+0x18/0x18
 ? write_page+0x18d/0x680 [md_mod]
 kasan_report+0xa8/0xe0
 ? write_page+0x18d/0x680 [md_mod]
 kasan_check_range+0x13f/0x180
 write_page+0x18d/0x680 [md_mod]
 ? super_sync+0x4d5/0x560 [dm_raid]
 ? md_bitmap_file_kick+0xa0/0xa0 [md_mod]
 ? rs_set_dev_and_array_sectors+0x2e0/0x2e0 [dm_raid]
 ? mutex_trylock+0x120/0x120
 ? preempt_count_add+0x6b/0xc0
 ? preempt_count_sub+0xf/0xc0
 md_update_sb+0x707/0xe40 [md_mod]
 md_reap_sync_thread+0x1b2/0x4a0 [md_mod]
 md_check_recovery+0x533/0x960 [md_mod]
 raid1d+0xc8/0x2a20 [raid1]
 ? var_wake_function+0xe0/0xe0
 ? psi_group_change+0x411/0x500
 ? preempt_count_sub+0xf/0xc0
 ? _raw_spin_lock_irqsave+0x78/0xc0
 ? __lock_text_start+0x18/0x18
 ? raid1_end_read_request+0x2a0/0x2a0 [raid1]
 ? preempt_count_sub+0xf/0xc0
 ? _raw_spin_unlock_irqrestore+0x19/0x40
 ? del_timer_sync+0xa9/0x100
 ? try_to_del_timer_sync+0xc0/0xc0
 ? _raw_spin_lock_irqsave+0x78/0xc0
 ? __lock_text_start+0x18/0x18
 ? __list_del_entry_valid+0x68/0xa0
 ? finish_wait+0xa3/0x100
 md_thread+0x161/0x260 [md_mod]
 ? unregister_md_personality+0xa0/0xa0 [md_mod]
 ? _raw_spin_lock_irqsave+0x78/0xc0
 ? prepare_to_wait_event+0x2c0/0x2c0
 ? unregister_md_personality+0xa0/0xa0 [md_mod]
 kthread+0x148/0x180
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x1f/0x30
 </TASK>

Allocated by task 5522:
 kasan_save_stack+0x1e/0x40
 __kasan_kmalloc+0x80/0xa0
 md_bitmap_create+0xa8/0xe80 [md_mod]
 md_run+0x777/0x1300 [md_mod]
 raid_ctr+0x249c/0x4a30 [dm_raid]
 dm_table_add_target+0x2b0/0x620 [dm_mod]
 table_load+0x1c8/0x400 [dm_mod]
 ctl_ioctl+0x29e/0x560 [dm_mod]
 dm_compat_ctl_ioctl+0x7/0x20 [dm_mod]
 __do_compat_sys_ioctl+0xfa/0x160
 do_syscall_64+0x90/0xc0
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Freed by task 5680:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x40
 kasan_set_free_info+0x20/0x40
 __kasan_slab_free+0xf7/0x140
 kfree+0x80/0x240
 md_bitmap_free+0x1c3/0x280 [md_mod]
 __md_stop+0x21/0x120 [md_mod]
 md_stop+0x9/0x40 [md_mod]
 raid_dtr+0x1b/0x40 [dm_raid]
 dm_table_destroy+0x98/0x1e0 [dm_mod]
 __dm_destroy+0x199/0x360 [dm_mod]
 dev_remove+0x10c/0x160 [dm_mod]
 ctl_ioctl+0x29e/0x560 [dm_mod]
 dm_compat_ctl_ioctl+0x7/0x20 [dm_mod]
 __do_compat_sys_ioctl+0xfa/0x160
 do_syscall_64+0x90/0xc0
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 48df498daf62 ("md: move bitmap_destroy to the beginning of __md_stop")
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6e82df21623d..35b895813c88 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6238,11 +6238,11 @@ static void mddev_detach(struct mddev *mddev)
 static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
-	md_bitmap_destroy(mddev);
 	mddev_detach(mddev);
 	/* Ensure ->event_work is done */
 	if (mddev->event_work.func)
 		flush_workqueue(md_misc_wq);
+	md_bitmap_destroy(mddev);
 	spin_lock(&mddev->lock);
 	mddev->pers = NULL;
 	spin_unlock(&mddev->lock);


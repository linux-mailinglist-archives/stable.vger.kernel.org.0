Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD4C59A0CE
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350068AbiHSP43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350164AbiHSPyx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:54:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C362710447E;
        Fri, 19 Aug 2022 08:49:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCF706170A;
        Fri, 19 Aug 2022 15:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13BFC433D6;
        Fri, 19 Aug 2022 15:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924187;
        bh=uITWwWiqVVhqD+peB1FLjnS3NZwX0gDhHuogkAoyk78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WCXD8q1nFZfkWy6BVcJDOwAmOA0OWOV8UpcBOURNvbUc4+iLq7LnxOS0FcCxCdz3/
         1AfwJ4FbQMbW1pGGmDSg+cROcpkKom9y8z55ECgCEWgLOW+p2vdiQicCAjBXgvLoLj
         ZIV71vsmXt2FHytSKlWmBdEnvF7s8Q/Tv+807Je0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 056/545] md-raid10: fix KASAN warning
Date:   Fri, 19 Aug 2022 17:37:06 +0200
Message-Id: <20220819153831.740288820@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit d17f744e883b2f8d13cca252d71cfe8ace346f7d upstream.

There's a KASAN warning in raid10_remove_disk when running the lvm
test lvconvert-raid-reshape.sh. We fix this warning by verifying that the
value "number" is valid.

BUG: KASAN: slab-out-of-bounds in raid10_remove_disk+0x61/0x2a0 [raid10]
Read of size 8 at addr ffff889108f3d300 by task mdX_raid10/124682

CPU: 3 PID: 124682 Comm: mdX_raid10 Not tainted 5.19.0-rc6 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x34/0x44
 print_report.cold+0x45/0x57a
 ? __lock_text_start+0x18/0x18
 ? raid10_remove_disk+0x61/0x2a0 [raid10]
 kasan_report+0xa8/0xe0
 ? raid10_remove_disk+0x61/0x2a0 [raid10]
 raid10_remove_disk+0x61/0x2a0 [raid10]
Buffer I/O error on dev dm-76, logical block 15344, async page read
 ? __mutex_unlock_slowpath.constprop.0+0x1e0/0x1e0
 remove_and_add_spares+0x367/0x8a0 [md_mod]
 ? super_written+0x1c0/0x1c0 [md_mod]
 ? mutex_trylock+0xac/0x120
 ? _raw_spin_lock+0x72/0xc0
 ? _raw_spin_lock_bh+0xc0/0xc0
 md_check_recovery+0x848/0x960 [md_mod]
 raid10d+0xcf/0x3360 [raid10]
 ? sched_clock_cpu+0x185/0x1a0
 ? rb_erase+0x4d4/0x620
 ? var_wake_function+0xe0/0xe0
 ? psi_group_change+0x411/0x500
 ? preempt_count_sub+0xf/0xc0
 ? _raw_spin_lock_irqsave+0x78/0xc0
 ? __lock_text_start+0x18/0x18
 ? raid10_sync_request+0x36c0/0x36c0 [raid10]
 ? preempt_count_sub+0xf/0xc0
 ? _raw_spin_unlock_irqrestore+0x19/0x40
 ? del_timer_sync+0xa9/0x100
 ? try_to_del_timer_sync+0xc0/0xc0
 ? _raw_spin_lock_irqsave+0x78/0xc0
 ? __lock_text_start+0x18/0x18
 ? _raw_spin_unlock_irq+0x11/0x24
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

Allocated by task 124495:
 kasan_save_stack+0x1e/0x40
 __kasan_kmalloc+0x80/0xa0
 setup_conf+0x140/0x5c0 [raid10]
 raid10_run+0x4cd/0x740 [raid10]
 md_run+0x6f9/0x1300 [md_mod]
 raid_ctr+0x2531/0x4ac0 [dm_raid]
 dm_table_add_target+0x2b0/0x620 [dm_mod]
 table_load+0x1c8/0x400 [dm_mod]
 ctl_ioctl+0x29e/0x560 [dm_mod]
 dm_compat_ctl_ioctl+0x7/0x20 [dm_mod]
 __do_compat_sys_ioctl+0xfa/0x160
 do_syscall_64+0x90/0xc0
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Last potentially related work creation:
 kasan_save_stack+0x1e/0x40
 __kasan_record_aux_stack+0x9e/0xc0
 kvfree_call_rcu+0x84/0x480
 timerfd_release+0x82/0x140
L __fput+0xfa/0x400
 task_work_run+0x80/0xc0
 exit_to_user_mode_prepare+0x155/0x160
 syscall_exit_to_user_mode+0x12/0x40
 do_syscall_64+0x42/0xc0
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Second to last potentially related work creation:
 kasan_save_stack+0x1e/0x40
 __kasan_record_aux_stack+0x9e/0xc0
 kvfree_call_rcu+0x84/0x480
 timerfd_release+0x82/0x140
 __fput+0xfa/0x400
 task_work_run+0x80/0xc0
 exit_to_user_mode_prepare+0x155/0x160
 syscall_exit_to_user_mode+0x12/0x40
 do_syscall_64+0x42/0xc0
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

The buggy address belongs to the object at ffff889108f3d200
 which belongs to the cache kmalloc-256 of size 256
The buggy address is located 0 bytes to the right of
 256-byte region [ffff889108f3d200, ffff889108f3d300)

The buggy address belongs to the physical page:
page:000000007ef2a34c refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1108f3c
head:000000007ef2a34c order:2 compound_mapcount:0 compound_pincount:0
flags: 0x4000000000010200(slab|head|zone=2)
raw: 4000000000010200 0000000000000000 dead000000000001 ffff889100042b40
raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff889108f3d200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff889108f3d280: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff889108f3d300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                   ^
 ffff889108f3d380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff889108f3d400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid10.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1809,9 +1809,12 @@ static int raid10_remove_disk(struct mdd
 	int err = 0;
 	int number = rdev->raid_disk;
 	struct md_rdev **rdevp;
-	struct raid10_info *p = conf->mirrors + number;
+	struct raid10_info *p;
 
 	print_conf(conf);
+	if (unlikely(number >= mddev->raid_disks))
+		return 0;
+	p = conf->mirrors + number;
 	if (rdev == p->rdev)
 		rdevp = &p->rdev;
 	else if (rdev == p->replacement)



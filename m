Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BB8676E5C
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjAVPJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbjAVPJo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:09:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A209C1F5C4
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:09:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9668160C61
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7554C4339B;
        Sun, 22 Jan 2023 15:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400181;
        bh=NUdP9PTMsA/Vaj0UhvJsNljCS5B81Vi8XZZYCso9a8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hj3CDYCwkPeCUMEp1fDBBc3lKg02AANvS2LjmoZ+5HGDpErsnkNgAw7lCkmeYJir9
         ZVpxTZ7FhfAkhDKQzgTJrflg0t0agBzws5CdIUU6lAn3JrTGxOCoDWF38MHCQL/5xJ
         Qt7h8kCzmKqjtkiflOFTDwOZumFBr/+Q1L7R53OI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+96977faa68092ad382c4@syzkaller.appspotmail.com,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 32/55] btrfs: fix race between quota rescan and disable leading to NULL pointer deref
Date:   Sun, 22 Jan 2023 16:04:19 +0100
Message-Id: <20230122150223.546678122@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150222.210885219@linuxfoundation.org>
References: <20230122150222.210885219@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit b7adbf9ada3513d2092362c8eac5cddc5b651f5c upstream.

If we have one task trying to start the quota rescan worker while another
one is trying to disable quotas, we can end up hitting a race that results
in the quota rescan worker doing a NULL pointer dereference. The steps for
this are the following:

1) Quotas are enabled;

2) Task A calls the quota rescan ioctl and enters btrfs_qgroup_rescan().
   It calls qgroup_rescan_init() which returns 0 (success) and then joins a
   transaction and commits it;

3) Task B calls the quota disable ioctl and enters btrfs_quota_disable().
   It clears the bit BTRFS_FS_QUOTA_ENABLED from fs_info->flags and calls
   btrfs_qgroup_wait_for_completion(), which returns immediately since the
   rescan worker is not yet running.
   Then it starts a transaction and locks fs_info->qgroup_ioctl_lock;

4) Task A queues the rescan worker, by calling btrfs_queue_work();

5) The rescan worker starts, and calls rescan_should_stop() at the start
   of its while loop, which results in 0 iterations of the loop, since
   the flag BTRFS_FS_QUOTA_ENABLED was cleared from fs_info->flags by
   task B at step 3);

6) Task B sets fs_info->quota_root to NULL;

7) The rescan worker tries to start a transaction and uses
   fs_info->quota_root as the root argument for btrfs_start_transaction().
   This results in a NULL pointer dereference down the call chain of
   btrfs_start_transaction(). The stack trace is something like the one
   reported in Link tag below:

   general protection fault, probably for non-canonical address 0xdffffc0000000041: 0000 [#1] PREEMPT SMP KASAN
   KASAN: null-ptr-deref in range [0x0000000000000208-0x000000000000020f]
   CPU: 1 PID: 34 Comm: kworker/u4:2 Not tainted 6.1.0-syzkaller-13872-gb6bb9676f216 #0
   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
   Workqueue: btrfs-qgroup-rescan btrfs_work_helper
   RIP: 0010:start_transaction+0x48/0x10f0 fs/btrfs/transaction.c:564
   Code: 48 89 fb 48 (...)
   RSP: 0018:ffffc90000ab7ab0 EFLAGS: 00010206
   RAX: 0000000000000041 RBX: 0000000000000208 RCX: ffff88801779ba80
   RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
   RBP: dffffc0000000000 R08: 0000000000000001 R09: fffff52000156f5d
   R10: fffff52000156f5d R11: 1ffff92000156f5c R12: 0000000000000000
   R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000003
   FS:  0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   CR2: 00007f2bea75b718 CR3: 000000001d0cc000 CR4: 00000000003506e0
   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
   Call Trace:
    <TASK>
    btrfs_qgroup_rescan_worker+0x3bb/0x6a0 fs/btrfs/qgroup.c:3402
    btrfs_work_helper+0x312/0x850 fs/btrfs/async-thread.c:280
    process_one_work+0x877/0xdb0 kernel/workqueue.c:2289
    worker_thread+0xb14/0x1330 kernel/workqueue.c:2436
    kthread+0x266/0x300 kernel/kthread.c:376
    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
    </TASK>
   Modules linked in:

So fix this by having the rescan worker function not attempt to start a
transaction if it didn't do any rescan work.

Reported-by: syzbot+96977faa68092ad382c4@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/000000000000e5454b05f065a803@google.com/
Fixes: e804861bd4e6 ("btrfs: fix deadlock between quota disable and qgroup rescan worker")
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3209,6 +3209,7 @@ static void btrfs_qgroup_rescan_worker(s
 	int err = -ENOMEM;
 	int ret = 0;
 	bool stopped = false;
+	bool did_leaf_rescans = false;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -3229,6 +3230,7 @@ static void btrfs_qgroup_rescan_worker(s
 		}
 
 		err = qgroup_rescan_leaf(trans, path);
+		did_leaf_rescans = true;
 
 		if (err > 0)
 			btrfs_commit_transaction(trans);
@@ -3249,16 +3251,23 @@ out:
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
 	/*
-	 * only update status, since the previous part has already updated the
-	 * qgroup info.
+	 * Only update status, since the previous part has already updated the
+	 * qgroup info, and only if we did any actual work. This also prevents
+	 * race with a concurrent quota disable, which has already set
+	 * fs_info->quota_root to NULL and cleared BTRFS_FS_QUOTA_ENABLED at
+	 * btrfs_quota_disable().
 	 */
-	trans = btrfs_start_transaction(fs_info->quota_root, 1);
-	if (IS_ERR(trans)) {
-		err = PTR_ERR(trans);
+	if (did_leaf_rescans) {
+		trans = btrfs_start_transaction(fs_info->quota_root, 1);
+		if (IS_ERR(trans)) {
+			err = PTR_ERR(trans);
+			trans = NULL;
+			btrfs_err(fs_info,
+				  "fail to start transaction for status update: %d",
+				  err);
+		}
+	} else {
 		trans = NULL;
-		btrfs_err(fs_info,
-			  "fail to start transaction for status update: %d",
-			  err);
 	}
 
 	mutex_lock(&fs_info->qgroup_rescan_lock);



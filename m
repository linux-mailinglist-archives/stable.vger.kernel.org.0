Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0EA23906E
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731529AbfFGPt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:49:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731220AbfFGPt7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:49:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC22320840;
        Fri,  7 Jun 2019 15:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922598;
        bh=GIa95EDxLb662cgHg9eL5EOoarCgrVnezrgsG4zgPxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUgPyLXsksvo1ZwzNU4sPcXXU/310gh6x8dEctCHpxBviaPPSt01K45rPeOCUbyLf
         oAPJr5T1vvwBwQB/3xDvVyeOgA9XCfoFp89gIOJ+OYglVn0bN6zt7HLzoYrY4zi8Vt
         YkKoL4/rC6WFLqJTp2m1Nj9gnfyjJ8sNr5wfOou8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dennis Zhou <dennis@kernel.org>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.1 24/85] btrfs: correct zstd workspace manager lock to use spin_lock_bh()
Date:   Fri,  7 Jun 2019 17:39:09 +0200
Message-Id: <20190607153852.232873626@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dennis Zhou <dennis@kernel.org>

commit fee13fe96529523a709d1fff487f14a5e0d56d34 upstream.

The btrfs zstd workspace manager uses a background timer to reclaim not
recently used workspaces. I used spin_lock() from this context which
should have been caught with lockdep, but was not. This deadlock was
reported in bugzilla. The fix is to switch the zstd wsm lock to use
spin_lock_bh() from the softirq context.

This happened quite relibably on ppc64, unlike on other architectures.

  [  313.402874] ================================
  [  313.402875] WARNING: inconsistent lock state
  [  313.402879] 5.1.0-rc7 #1 Not tainted
  [  313.402880] --------------------------------
  [  313.402882] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
  [  313.402885] swapper/5/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
  [  313.402888] 0000000080d1120c (&(&wsm.lock)->rlock){+.?.}, at: .zstd_reclaim_timer_fn+0x40/0x230
  [  313.402895] {SOFTIRQ-ON-W} state was registered at:
  [  313.402899]   .lock_acquire+0xd0/0x240
  [  313.402903]   ._raw_spin_lock+0x34/0x60
  [  313.402906]   .zstd_get_workspace+0xd0/0x360
  [  313.402908]   .end_compressed_bio_read+0x3b8/0x540
  [  313.402911]   .bio_endio+0x174/0x2c0
  [  313.402914]   .end_workqueue_fn+0x4c/0x70
  [  313.402917]   .normal_work_helper+0x138/0x7e0
  [  313.402920]   .process_one_work+0x324/0x790
  [  313.402922]   .worker_thread+0x68/0x570
  [  313.402925]   .kthread+0x19c/0x1b0
  [  313.402928]   .ret_from_kernel_thread+0x58/0x78
  [  313.402930] irq event stamp: 2629216
  [  313.402933] hardirqs last  enabled at (2629216): [<c0000000009da738>] ._raw_spin_unlock_irq+0x38/0x60
  [  313.402936] hardirqs last disabled at (2629215): [<c0000000009da4c4>] ._raw_spin_lock_irq+0x24/0x70
  [  313.402939] softirqs last  enabled at (2629212): [<c0000000000af9fc>] .irq_enter+0x8c/0xd0
  [  313.402942] softirqs last disabled at (2629213): [<c0000000000afb58>] .irq_exit+0x118/0x170
  [  313.402944]
		 other info that might help us debug this:
  [  313.402945]  Possible unsafe locking scenario:

  [  313.402947]        CPU0
  [  313.402948]        ----
  [  313.402949]   lock(&(&wsm.lock)->rlock);
  [  313.402951]   <Interrupt>
  [  313.402952]     lock(&(&wsm.lock)->rlock);
  [  313.402954]
		  *** DEADLOCK ***

  [  313.402957] 1 lock held by swapper/5/0:
  [  313.402958]  #0: 000000004b612042 ((&wsm.timer)){+.-.}, at: .call_timer_fn+0x0/0x3c0
  [  313.402963]
		 stack backtrace:
  [  313.402967] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 5.1.0-rc7 #1
  [  313.402968] Call Trace:
  [  313.402972] [c0000007fa262e70] [c0000000009b3294] .dump_stack+0xe0/0x15c (unreliable)
  [  313.402975] [c0000007fa262f10] [c000000000125548] .print_usage_bug+0x348/0x390
  [  313.402978] [c0000007fa262fd0] [c000000000125cb4] .mark_lock+0x724/0x930
  [  313.402981] [c0000007fa263080] [c000000000126c20] .__lock_acquire+0xc90/0x16a0
  [  313.402984] [c0000007fa2631b0] [c000000000128040] .lock_acquire+0xd0/0x240
  [  313.402987] [c0000007fa263280] [c0000000009da2b4] ._raw_spin_lock+0x34/0x60
  [  313.402990] [c0000007fa263300] [c00000000054b0b0] .zstd_reclaim_timer_fn+0x40/0x230
  [  313.402993] [c0000007fa2633d0] [c000000000158b38] .call_timer_fn+0xc8/0x3c0
  [  313.402996] [c0000007fa2634a0] [c000000000158f74] .expire_timers+0x144/0x260
  [  313.402999] [c0000007fa263550] [c000000000159178] .run_timer_softirq+0xe8/0x230
  [  313.403002] [c0000007fa263680] [c0000000009db288] .__do_softirq+0x188/0x5d4
  [  313.403004] [c0000007fa263790] [c0000000000afb58] .irq_exit+0x118/0x170
  [  313.403008] [c0000007fa263800] [c000000000028d88] .timer_interrupt+0x158/0x430
  [  313.403012] [c0000007fa2638b0] [c0000000000091d4] decrementer_common+0x134/0x140
  [  313.403017] --- interrupt: 901 at replay_interrupt_return+0x0/0x4
		     LR = .arch_local_irq_restore.part.0+0x68/0x80
  [  313.403020] [c0000007fa263bb0] [c00000000001a3ac] .arch_local_irq_restore.part.0+0x2c/0x80 (unreliable)
  [  313.403024] [c0000007fa263c30] [c0000000007bbbcc] .cpuidle_enter_state+0xec/0x670
  [  313.403027] [c0000007fa263d00] [c0000000000f5130] .call_cpuidle+0x40/0x90
  [  313.403031] [c0000007fa263d70] [c0000000000f554c] .do_idle+0x2dc/0x3a0
  [  313.403034] [c0000007fa263e30] [c0000000000f59ac] .cpu_startup_entry+0x2c/0x30
  [  313.403037] [c0000007fa263ea0] [c000000000045674] .start_secondary+0x644/0x650
  [  313.403041] [c0000007fa263f90] [c00000000000ad5c] start_secondary_prolog+0x10/0x14

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203517
Fixes: 3f93aef535c8 ("btrfs: add zstd compression level support")
CC: stable@vger.kernel.org # 5.1+
Signed-off-by: Dennis Zhou <dennis@kernel.org>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/zstd.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -102,10 +102,10 @@ static void zstd_reclaim_timer_fn(struct
 	unsigned long reclaim_threshold = jiffies - ZSTD_BTRFS_RECLAIM_JIFFIES;
 	struct list_head *pos, *next;
 
-	spin_lock(&wsm.lock);
+	spin_lock_bh(&wsm.lock);
 
 	if (list_empty(&wsm.lru_list)) {
-		spin_unlock(&wsm.lock);
+		spin_unlock_bh(&wsm.lock);
 		return;
 	}
 
@@ -134,7 +134,7 @@ static void zstd_reclaim_timer_fn(struct
 	if (!list_empty(&wsm.lru_list))
 		mod_timer(&wsm.timer, jiffies + ZSTD_BTRFS_RECLAIM_JIFFIES);
 
-	spin_unlock(&wsm.lock);
+	spin_unlock_bh(&wsm.lock);
 }
 
 /*
@@ -195,7 +195,7 @@ static void zstd_cleanup_workspace_manag
 	struct workspace *workspace;
 	int i;
 
-	spin_lock(&wsm.lock);
+	spin_lock_bh(&wsm.lock);
 	for (i = 0; i < ZSTD_BTRFS_MAX_LEVEL; i++) {
 		while (!list_empty(&wsm.idle_ws[i])) {
 			workspace = container_of(wsm.idle_ws[i].next,
@@ -205,7 +205,7 @@ static void zstd_cleanup_workspace_manag
 			wsm.ops->free_workspace(&workspace->list);
 		}
 	}
-	spin_unlock(&wsm.lock);
+	spin_unlock_bh(&wsm.lock);
 
 	del_timer_sync(&wsm.timer);
 }
@@ -227,7 +227,7 @@ static struct list_head *zstd_find_works
 	struct workspace *workspace;
 	int i = level - 1;
 
-	spin_lock(&wsm.lock);
+	spin_lock_bh(&wsm.lock);
 	for_each_set_bit_from(i, &wsm.active_map, ZSTD_BTRFS_MAX_LEVEL) {
 		if (!list_empty(&wsm.idle_ws[i])) {
 			ws = wsm.idle_ws[i].next;
@@ -239,11 +239,11 @@ static struct list_head *zstd_find_works
 				list_del(&workspace->lru_list);
 			if (list_empty(&wsm.idle_ws[i]))
 				clear_bit(i, &wsm.active_map);
-			spin_unlock(&wsm.lock);
+			spin_unlock_bh(&wsm.lock);
 			return ws;
 		}
 	}
-	spin_unlock(&wsm.lock);
+	spin_unlock_bh(&wsm.lock);
 
 	return NULL;
 }
@@ -302,7 +302,7 @@ static void zstd_put_workspace(struct li
 {
 	struct workspace *workspace = list_to_workspace(ws);
 
-	spin_lock(&wsm.lock);
+	spin_lock_bh(&wsm.lock);
 
 	/* A node is only taken off the lru if we are the corresponding level */
 	if (workspace->req_level == workspace->level) {
@@ -322,7 +322,7 @@ static void zstd_put_workspace(struct li
 	list_add(&workspace->list, &wsm.idle_ws[workspace->level - 1]);
 	workspace->req_level = 0;
 
-	spin_unlock(&wsm.lock);
+	spin_unlock_bh(&wsm.lock);
 
 	if (workspace->level == ZSTD_BTRFS_MAX_LEVEL)
 		cond_wake_up(&wsm.wait);



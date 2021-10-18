Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62904431EC9
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbhJROFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:05:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234734AbhJRODO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:03:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0632461A78;
        Mon, 18 Oct 2021 13:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564608;
        bh=ohU2CGRvScP7Ozf5160ORUkY9bQvyGfN4Y71Rdzls+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzjSMBuH8EgliSo8MY8DlSSha78JdUujE6icJAxdsrQIEQdmUvrry0rBMtDrUmvhe
         M0voJHjHMeYM3t5fQ8qBGqsJfpbEsxnXVZT5B86+BXYvfXaiCA20z8kZjJ3pRhzJPy
         edDAktLz1reaVhraGN6hMve6SAAbL9T5F4fxuVJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 142/151] ice: fix locking for Tx timestamp tracking flush
Date:   Mon, 18 Oct 2021 15:25:21 +0200
Message-Id: <20211018132345.279322865@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

commit 4d4a223a86afe658cd878800f09458e8bb54415d upstream.

Commit 4dd0d5c33c3e ("ice: add lock around Tx timestamp tracker flush")
added a lock around the Tx timestamp tracker flow which is used to
cleanup any left over SKBs and prepare for device removal.

This lock is problematic because it is being held around a call to
ice_clear_phy_tstamp. The clear function takes a mutex to send a PHY
write command to firmware. This could lead to a deadlock if the mutex
actually sleeps, and causes the following warning on a kernel with
preemption debugging enabled:

[  715.419426] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:573
[  715.427900] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 3100, name: rmmod
[  715.435652] INFO: lockdep is turned off.
[  715.439591] Preemption disabled at:
[  715.439594] [<0000000000000000>] 0x0
[  715.446678] CPU: 52 PID: 3100 Comm: rmmod Tainted: G        W  OE     5.15.0-rc4+ #42 bdd7ec3018e725f159ca0d372ce8c2c0e784891c
[  715.458058] Hardware name: Intel Corporation S2600STQ/S2600STQ, BIOS SE5C620.86B.02.01.0010.010620200716 01/06/2020
[  715.468483] Call Trace:
[  715.470940]  dump_stack_lvl+0x6a/0x9a
[  715.474613]  ___might_sleep.cold+0x224/0x26a
[  715.478895]  __mutex_lock+0xb3/0x1440
[  715.482569]  ? stack_depot_save+0x378/0x500
[  715.486763]  ? ice_sq_send_cmd+0x78/0x14c0 [ice 9a7e1ec00971c89ecd3fe0d4dc7da2b3786a421d]
[  715.494979]  ? kfree+0xc1/0x520
[  715.498128]  ? mutex_lock_io_nested+0x12a0/0x12a0
[  715.502837]  ? kasan_set_free_info+0x20/0x30
[  715.507110]  ? __kasan_slab_free+0x10b/0x140
[  715.511385]  ? slab_free_freelist_hook+0xc7/0x220
[  715.516092]  ? kfree+0xc1/0x520
[  715.519235]  ? ice_deinit_lag+0x16c/0x220 [ice 9a7e1ec00971c89ecd3fe0d4dc7da2b3786a421d]
[  715.527359]  ? ice_remove+0x1cf/0x6a0 [ice 9a7e1ec00971c89ecd3fe0d4dc7da2b3786a421d]
[  715.535133]  ? pci_device_remove+0xab/0x1d0
[  715.539318]  ? __device_release_driver+0x35b/0x690
[  715.544110]  ? driver_detach+0x214/0x2f0
[  715.548035]  ? bus_remove_driver+0x11d/0x2f0
[  715.552309]  ? pci_unregister_driver+0x26/0x250
[  715.556840]  ? ice_module_exit+0xc/0x2f [ice 9a7e1ec00971c89ecd3fe0d4dc7da2b3786a421d]
[  715.564799]  ? __do_sys_delete_module.constprop.0+0x2d8/0x4e0
[  715.570554]  ? do_syscall_64+0x3b/0x90
[  715.574303]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
[  715.579529]  ? start_flush_work+0x542/0x8f0
[  715.583719]  ? ice_sq_send_cmd+0x78/0x14c0 [ice 9a7e1ec00971c89ecd3fe0d4dc7da2b3786a421d]
[  715.591923]  ice_sq_send_cmd+0x78/0x14c0 [ice 9a7e1ec00971c89ecd3fe0d4dc7da2b3786a421d]
[  715.599960]  ? wait_for_completion_io+0x250/0x250
[  715.604662]  ? lock_acquire+0x196/0x200
[  715.608504]  ? do_raw_spin_trylock+0xa5/0x160
[  715.612864]  ice_sbq_rw_reg+0x1e6/0x2f0 [ice 9a7e1ec00971c89ecd3fe0d4dc7da2b3786a421d]
[  715.620813]  ? ice_reset+0x130/0x130 [ice 9a7e1ec00971c89ecd3fe0d4dc7da2b3786a421d]
[  715.628497]  ? __debug_check_no_obj_freed+0x1e8/0x3c0
[  715.633550]  ? trace_hardirqs_on+0x1c/0x130
[  715.637748]  ice_write_phy_reg_e810+0x70/0xf0 [ice 9a7e1ec00971c89ecd3fe0d4dc7da2b3786a421d]
[  715.646220]  ? do_raw_spin_trylock+0xa5/0x160
[  715.650581]  ? ice_ptp_release+0x910/0x910 [ice 9a7e1ec00971c89ecd3fe0d4dc7da2b3786a421d]
[  715.658797]  ? ice_ptp_release+0x255/0x910 [ice 9a7e1ec00971c89ecd3fe0d4dc7da2b3786a421d]
[  715.667013]  ice_clear_phy_tstamp+0x2c/0x110 [ice 9a7e1ec00971c89ecd3fe0d4dc7da2b3786a421d]
[  715.675403]  ice_ptp_release+0x408/0x910 [ice 9a7e1ec00971c89ecd3fe0d4dc7da2b3786a421d]
[  715.683440]  ice_remove+0x560/0x6a0 [ice 9a7e1ec00971c89ecd3fe0d4dc7da2b3786a421d]
[  715.691037]  ? _raw_spin_unlock_irqrestore+0x46/0x73
[  715.696005]  pci_device_remove+0xab/0x1d0
[  715.700018]  __device_release_driver+0x35b/0x690
[  715.704637]  driver_detach+0x214/0x2f0
[  715.708389]  bus_remove_driver+0x11d/0x2f0
[  715.712489]  pci_unregister_driver+0x26/0x250
[  715.716857]  ice_module_exit+0xc/0x2f [ice 9a7e1ec00971c89ecd3fe0d4dc7da2b3786a421d]
[  715.724637]  __do_sys_delete_module.constprop.0+0x2d8/0x4e0
[  715.730210]  ? free_module+0x6d0/0x6d0
[  715.733963]  ? task_work_run+0xe1/0x170
[  715.737803]  ? exit_to_user_mode_loop+0x17f/0x1d0
[  715.742509]  ? rcu_read_lock_sched_held+0x12/0x80
[  715.747215]  ? trace_hardirqs_on+0x1c/0x130
[  715.751401]  do_syscall_64+0x3b/0x90
[  715.754981]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  715.760033] RIP: 0033:0x7f4dfe59000b
[  715.763612] Code: 73 01 c3 48 8b 0d 6d 1e 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 3d 1e 0c 00 f7 d8 64 89 01 48
[  715.782357] RSP: 002b:00007ffe8c891708 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
[  715.789923] RAX: ffffffffffffffda RBX: 00005558a20468b0 RCX: 00007f4dfe59000b
[  715.797054] RDX: 000000000000000a RSI: 0000000000000800 RDI: 00005558a2046918
[  715.804189] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[  715.811319] R10: 00007f4dfe603ac0 R11: 0000000000000206 R12: 00007ffe8c891940
[  715.818455] R13: 00007ffe8c8920a3 R14: 00005558a20462a0 R15: 00005558a20468b0

Notice that this is the only case where we use the lock in this way. In
the cleanup kthread and work kthread the lock is only taken around the
bit accesses. This was done intentionally to avoid this kind of issue.
The way the lock is used, we only protect ordering of bit sets vs bit
clears. The Tx writers in the hot path don't need to be protected
against the entire kthread loop. The Tx queues threads only need to
ensure that they do not re-use an index that is currently in use. The
cleanup loop does not need to block all new set bits, since it will
re-queue itself if new timestamps are present.

Fix the tracker flow so that it uses the same flow as the standard
cleanup thread. In addition, ensure the in_use bitmap actually gets
cleared properly.

This fixes the warning and also avoids the potential deadlock that might
have occurred otherwise.

Fixes: 4dd0d5c33c3e ("ice: add lock around Tx timestamp tracker flush")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1324,22 +1324,21 @@ ice_ptp_flush_tx_tracker(struct ice_pf *
 {
 	u8 idx;
 
-	spin_lock(&tx->lock);
-
 	for (idx = 0; idx < tx->len; idx++) {
 		u8 phy_idx = idx + tx->quad_offset;
 
-		/* Clear any potential residual timestamp in the PHY block */
-		if (!pf->hw.reset_ongoing)
-			ice_clear_phy_tstamp(&pf->hw, tx->quad, phy_idx);
-
+		spin_lock(&tx->lock);
 		if (tx->tstamps[idx].skb) {
 			dev_kfree_skb_any(tx->tstamps[idx].skb);
 			tx->tstamps[idx].skb = NULL;
 		}
-	}
+		clear_bit(idx, tx->in_use);
+		spin_unlock(&tx->lock);
 
-	spin_unlock(&tx->lock);
+		/* Clear any potential residual timestamp in the PHY block */
+		if (!pf->hw.reset_ongoing)
+			ice_clear_phy_tstamp(&pf->hw, tx->quad, phy_idx);
+	}
 }
 
 /**



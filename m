Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97878328C08
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235894AbhCASn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:43:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:49688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240493AbhCASjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:39:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC13D64FBF;
        Mon,  1 Mar 2021 17:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620249;
        bh=nxb7H9kc46wHw88pBK02xc8xUguiYxOFbqNehu6OHrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/6PlnX89b7bRBSruWtGLA5Ut/Y7/TmD9LfhgUgNDfEZXrZbs38HZYXkKEs+mdny1
         Rjnl57lienHcEHFp18Br7sFflTu7YG0H0PJJQ4dClXOVYmlgrQSTgRUorDOmQAKWcz
         gd+wvlwANdY//z2e6nVbvSnFKAKibuuGnZU2kOVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand K Mistry <amistry@google.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 085/775] ath10k: Fix suspicious RCU usage warning in ath10k_wmi_tlv_parse_peer_stats_info()
Date:   Mon,  1 Mar 2021 17:04:13 +0100
Message-Id: <20210301161205.881826781@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand K Mistry <amistry@google.com>

[ Upstream commit 2615e3cdbd9c0e864f5906279c952a309871d225 ]

The ieee80211_find_sta_by_ifaddr call in
ath10k_wmi_tlv_parse_peer_stats_info must be called while holding the
RCU read lock. Otherwise, the following warning will be seen when RCU
usage checking is enabled:

=============================
WARNING: suspicious RCU usage
5.10.3 #8 Tainted: G        W
-----------------------------
include/linux/rhashtable.h:594 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
no locks held by ksoftirqd/1/16.

stack backtrace:
CPU: 1 PID: 16 Comm: ksoftirqd/1 Tainted: G        W         5.10.3 #8
Hardware name: HP Grunt/Grunt, BIOS Google_Grunt.11031.104.0 09/05/2019
Call Trace:
 dump_stack+0xab/0x115
 sta_info_hash_lookup+0x71/0x1e9 [mac80211]
 ? lock_is_held_type+0xe6/0x12f
 ? __kasan_kmalloc+0xfb/0x112
 ieee80211_find_sta_by_ifaddr+0x12/0x61 [mac80211]
 ath10k_wmi_tlv_parse_peer_stats_info+0xbd/0x10b [ath10k_core]
 ath10k_wmi_tlv_iter+0x8b/0x1a1 [ath10k_core]
 ? ath10k_wmi_tlv_iter+0x1a1/0x1a1 [ath10k_core]
 ath10k_wmi_tlv_event_peer_stats_info+0x103/0x13b [ath10k_core]
 ath10k_wmi_tlv_op_rx+0x722/0x80d [ath10k_core]
 ath10k_htc_rx_completion_handler+0x16e/0x1d7 [ath10k_core]
 ath10k_pci_process_rx_cb+0x116/0x22c [ath10k_pci]
 ? ath10k_htc_process_trailer+0x332/0x332 [ath10k_core]
 ? _raw_spin_unlock_irqrestore+0x34/0x61
 ? lockdep_hardirqs_on+0x8e/0x12e
 ath10k_ce_per_engine_service+0x55/0x74 [ath10k_core]
 ath10k_ce_per_engine_service_any+0x76/0x84 [ath10k_core]
 ath10k_pci_napi_poll+0x49/0x141 [ath10k_pci]
 net_rx_action+0x11a/0x347
 __do_softirq+0x2d3/0x539
 run_ksoftirqd+0x4b/0x86
 smpboot_thread_fn+0x1d0/0x2ab
 ? cpu_report_death+0x7f/0x7f
 kthread+0x189/0x191
 ? cpu_report_death+0x7f/0x7f
 ? kthread_blkcg+0x31/0x31
 ret_from_fork+0x22/0x30

Fixes: 0f7cb26830a6e ("ath10k: add rx bitrate report for SDIO")
Signed-off-by: Anand K Mistry <amistry@google.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210202134451.1.I0d2e83c42755671b7143504b62787fd06cd914ed@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 7b5834157fe51..e6135795719a1 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -240,8 +240,10 @@ static int ath10k_wmi_tlv_parse_peer_stats_info(struct ath10k *ar, u16 tag, u16
 		   __le32_to_cpu(stat->last_tx_rate_code),
 		   __le32_to_cpu(stat->last_tx_bitrate_kbps));
 
+	rcu_read_lock();
 	sta = ieee80211_find_sta_by_ifaddr(ar->hw, stat->peer_macaddr.addr, NULL);
 	if (!sta) {
+		rcu_read_unlock();
 		ath10k_warn(ar, "not found station for peer stats\n");
 		return -EINVAL;
 	}
@@ -251,6 +253,7 @@ static int ath10k_wmi_tlv_parse_peer_stats_info(struct ath10k *ar, u16 tag, u16
 	arsta->rx_bitrate_kbps = __le32_to_cpu(stat->last_rx_bitrate_kbps);
 	arsta->tx_rate_code = __le32_to_cpu(stat->last_tx_rate_code);
 	arsta->tx_bitrate_kbps = __le32_to_cpu(stat->last_tx_bitrate_kbps);
+	rcu_read_unlock();
 
 	return 0;
 }
-- 
2.27.0




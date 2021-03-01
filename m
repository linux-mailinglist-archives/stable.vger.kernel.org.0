Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C236328DA9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235737AbhCATPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:15:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241006AbhCATKz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:10:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87CBB6516B;
        Mon,  1 Mar 2021 17:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618431;
        bh=XeifrDpmBk94vKodWEVz14LQs53vvphqmP3+K1N241U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nwIv/tB0/fMfaL9601dJZf/LsfZNTxMTS41KJ8q/btymOrZL+UjkI3sjKszZk5CHC
         qolNoCkuzvnsEKR+rMLXRtFtCEPFB2dynMRqiLL64U2Ue6Dq0bFU6xF9pdCh+sEfRo
         FWRxtKDjYgxq5aNLh378Oq2fblNmTyDLLDIhcDP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand K Mistry <amistry@google.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/663] ath10k: Fix lockdep assertion warning in ath10k_sta_statistics
Date:   Mon,  1 Mar 2021 17:05:32 +0100
Message-Id: <20210301161145.888080242@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand K Mistry <amistry@google.com>

[ Upstream commit 7df28718928d08034b36168200d67b558ce36f3d ]

ath10k_debug_fw_stats_request just be called with conf_mutex held,
otherwise the following warning is seen when lock debugging is enabled:

WARNING: CPU: 0 PID: 793 at drivers/net/wireless/ath/ath10k/debug.c:357 ath10k_debug_fw_stats_request+0x12c/0x133 [ath10k_core]
Modules linked in: snd_hda_codec_hdmi designware_i2s snd_hda_intel snd_intel_dspcfg snd_hda_codec i2c_piix4 snd_hwdep snd_hda_core acpi_als kfifo_buf industrialio snd_soc_max98357a snd_soc_adau7002 snd_soc_acp_da7219mx98357_mach snd_soc_da7219 acp_audio_dma ccm xt_MASQUERADE fuse ath10k_pci ath10k_core lzo_rle ath lzo_compress mac80211 zram cfg80211 r8152 mii joydev
CPU: 0 PID: 793 Comm: wpa_supplicant Tainted: G        W         5.10.9 #5
Hardware name: HP Grunt/Grunt, BIOS Google_Grunt.11031.104.0 09/05/2019
RIP: 0010:ath10k_debug_fw_stats_request+0x12c/0x133 [ath10k_core]
Code: 1e bb a1 ff ff ff 4c 89 ef 48 c7 c6 d3 31 2e c0 89 da 31 c0 e8 bd f8 ff ff 89 d8 eb 02 31 c0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 <0f> 0b e9 04 ff ff ff 0f 1f 44 00 00 55 48 89 e5 41 56 53 48 89 fb
RSP: 0018:ffffb2478099f7d0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff9e432700cce0 RCX: 11c85cfd6b8e3b00
RDX: ffff9e432700cce0 RSI: ffff9e43127c5668 RDI: ffff9e4318deddf0
RBP: ffffb2478099f7f8 R08: 0000000000000002 R09: 00000003fd7068cc
R10: ffffffffc01b2749 R11: ffffffffc029efaf R12: ffff9e432700c000
R13: ffff9e43127c33e0 R14: ffffb2478099f918 R15: ffff9e43127c33e0
FS:  00007f7ea48e2740(0000) GS:ffff9e432aa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000059aa799ddf38 CR3: 0000000118de2000 CR4: 00000000001506f0
Call Trace:
 ath10k_sta_statistics+0x4d/0x270 [ath10k_core]
 sta_set_sinfo+0x1be/0xaec [mac80211]
 ieee80211_get_station+0x58/0x76 [mac80211]
 rdev_get_station+0xf1/0x11e [cfg80211]
 nl80211_get_station+0x7f/0x146 [cfg80211]
 genl_rcv_msg+0x32e/0x35e
 ? nl80211_stop_ap+0x19/0x19 [cfg80211]
 ? nl80211_get_station+0x146/0x146 [cfg80211]
 ? genl_rcv+0x19/0x36
 ? genl_rcv+0x36/0x36
 netlink_rcv_skb+0x89/0xfb
 genl_rcv+0x28/0x36
 netlink_unicast+0x169/0x23b
 netlink_sendmsg+0x38a/0x402
 sock_sendmsg+0x72/0x76
 ____sys_sendmsg+0x153/0x1cc
 ? copy_msghdr_from_user+0x5d/0x85
 ___sys_sendmsg+0x7c/0xb5
 ? lock_acquire+0x181/0x23d
 ? syscall_trace_enter+0x15e/0x160
 ? find_held_lock+0x3d/0xb2
 ? syscall_trace_enter+0x15e/0x160
 ? sched_clock_cpu+0x15/0xc6
 __sys_sendmsg+0x62/0x9a
 do_syscall_64+0x43/0x55
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 4913e675630e ("ath10k: enable rx duration report default for wmi tlv")
Signed-off-by: Anand K Mistry <amistry@google.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210202144033.1.I9e556f9fb1110d58c31d04a8a1293995fb8bb678@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 2e3eb5bbe49c8..4bc84cc5e824b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -9116,7 +9116,9 @@ static void ath10k_sta_statistics(struct ieee80211_hw *hw,
 	if (!ath10k_peer_stats_enabled(ar))
 		return;
 
+	mutex_lock(&ar->conf_mutex);
 	ath10k_debug_fw_stats_request(ar);
+	mutex_unlock(&ar->conf_mutex);
 
 	sinfo->rx_duration = arsta->rx_duration;
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_DURATION);
-- 
2.27.0




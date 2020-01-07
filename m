Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9C741331AE
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbgAGVC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:02:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:43522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728834AbgAGVCz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:02:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDCD02087F;
        Tue,  7 Jan 2020 21:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430974;
        bh=3duC+50xosOhh86u4la+Fe/usjRSVW+ZS0O7szyOrg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qwQlSKiXZDRFbYpTVD3sVh0FOb8idPlK8bYNSQxncys9DemkWspZjnBvnnxT9iE13
         RosNARUMtX2Zfqoeyi/QsDWMKx+jNpBl7mKWzn5W+t/LYxmtzeB5aYvn0o4h2x29q0
         SmPMoQPa2KKJhiYS0u1GcQVYc7wZRxf0mqURMis8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masashi Honma <masashi.honma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 174/191] ath9k_htc: Discard undersized packets
Date:   Tue,  7 Jan 2020 21:54:54 +0100
Message-Id: <20200107205342.310574861@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masashi Honma <masashi.honma@gmail.com>

[ Upstream commit cd486e627e67ee9ab66914d36d3127ef057cc010 ]

Sometimes the hardware will push small packets that trigger a WARN_ON
in mac80211. Discard them early to avoid this issue.

This patch ports 2 patches from ath9k to ath9k_htc.
commit 3c0efb745a172bfe96459e20cbd37b0c945d5f8d "ath9k: discard
undersized packets".
commit df5c4150501ee7e86383be88f6490d970adcf157 "ath9k: correctly
handle short radar pulses".

[  112.835889] ------------[ cut here ]------------
[  112.835971] WARNING: CPU: 5 PID: 0 at net/mac80211/rx.c:804 ieee80211_rx_napi+0xaac/0xb40 [mac80211]
[  112.835973] Modules linked in: ath9k_htc ath9k_common ath9k_hw ath mac80211 cfg80211 libarc4 nouveau snd_hda_codec_hdmi intel_rapl_msr intel_rapl_common x86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio snd_hda_intel snd_hda_codec video snd_hda_core ttm snd_hwdep drm_kms_helper snd_pcm crct10dif_pclmul snd_seq_midi drm snd_seq_midi_event crc32_pclmul snd_rawmidi ghash_clmulni_intel snd_seq aesni_intel aes_x86_64 crypto_simd cryptd snd_seq_device glue_helper snd_timer sch_fq_codel i2c_algo_bit fb_sys_fops snd input_leds syscopyarea sysfillrect sysimgblt intel_cstate mei_me intel_rapl_perf soundcore mxm_wmi lpc_ich mei kvm_intel kvm mac_hid irqbypass parport_pc ppdev lp parport ip_tables x_tables autofs4 hid_generic usbhid hid raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear e1000e ahci libahci wmi
[  112.836022] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 5.3.0-wt #1
[  112.836023] Hardware name: MouseComputer Co.,Ltd. X99-S01/X99-S01, BIOS 1.0C-W7 04/01/2015
[  112.836056] RIP: 0010:ieee80211_rx_napi+0xaac/0xb40 [mac80211]
[  112.836059] Code: 00 00 66 41 89 86 b0 00 00 00 e9 c8 fa ff ff 4c 89 b5 40 ff ff ff 49 89 c6 e9 c9 fa ff ff 48 c7 c7 e0 a2 a5 c0 e8 47 41 b0 e9 <0f> 0b 48 89 df e8 5a 94 2d ea e9 02 f9 ff ff 41 39 c1 44 89 85 60
[  112.836060] RSP: 0018:ffffaa6180220da8 EFLAGS: 00010286
[  112.836062] RAX: 0000000000000024 RBX: ffff909a20eeda00 RCX: 0000000000000000
[  112.836064] RDX: 0000000000000000 RSI: ffff909a2f957448 RDI: ffff909a2f957448
[  112.836065] RBP: ffffaa6180220e78 R08: 00000000000006e9 R09: 0000000000000004
[  112.836066] R10: 000000000000000a R11: 0000000000000001 R12: 0000000000000000
[  112.836068] R13: ffff909a261a47a0 R14: 0000000000000000 R15: 0000000000000004
[  112.836070] FS:  0000000000000000(0000) GS:ffff909a2f940000(0000) knlGS:0000000000000000
[  112.836071] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  112.836073] CR2: 00007f4e3ffffa08 CR3: 00000001afc0a006 CR4: 00000000001606e0
[  112.836074] Call Trace:
[  112.836076]  <IRQ>
[  112.836083]  ? finish_td+0xb3/0xf0
[  112.836092]  ? ath9k_rx_prepare.isra.11+0x22f/0x2a0 [ath9k_htc]
[  112.836099]  ath9k_rx_tasklet+0x10b/0x1d0 [ath9k_htc]
[  112.836105]  tasklet_action_common.isra.22+0x63/0x110
[  112.836108]  tasklet_action+0x22/0x30
[  112.836115]  __do_softirq+0xe4/0x2da
[  112.836118]  irq_exit+0xae/0xb0
[  112.836121]  do_IRQ+0x86/0xe0
[  112.836125]  common_interrupt+0xf/0xf
[  112.836126]  </IRQ>
[  112.836130] RIP: 0010:cpuidle_enter_state+0xa9/0x440
[  112.836133] Code: 3d bc 20 38 55 e8 f7 1d 84 ff 49 89 c7 0f 1f 44 00 00 31 ff e8 28 29 84 ff 80 7d d3 00 0f 85 e6 01 00 00 fb 66 0f 1f 44 00 00 <45> 85 ed 0f 89 ff 01 00 00 41 c7 44 24 10 00 00 00 00 48 83 c4 18
[  112.836134] RSP: 0018:ffffaa61800e3e48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffde
[  112.836136] RAX: ffff909a2f96b340 RBX: ffffffffabb58200 RCX: 000000000000001f
[  112.836137] RDX: 0000001a458adc5d RSI: 0000000026c9b581 RDI: 0000000000000000
[  112.836139] RBP: ffffaa61800e3e88 R08: 0000000000000002 R09: 000000000002abc0
[  112.836140] R10: ffffaa61800e3e18 R11: 000000000000002d R12: ffffca617fb40b00
[  112.836141] R13: 0000000000000002 R14: ffffffffabb582d8 R15: 0000001a458adc5d
[  112.836145]  ? cpuidle_enter_state+0x98/0x440
[  112.836149]  ? menu_select+0x370/0x600
[  112.836151]  cpuidle_enter+0x2e/0x40
[  112.836154]  call_cpuidle+0x23/0x40
[  112.836156]  do_idle+0x204/0x280
[  112.836159]  cpu_startup_entry+0x1d/0x20
[  112.836164]  start_secondary+0x167/0x1c0
[  112.836169]  secondary_startup_64+0xa4/0xb0
[  112.836173] ---[ end trace 9f4cd18479cc5ae5 ]---

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 23 +++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index aba0d454c381..9cec5c216e1f 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -973,6 +973,8 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	struct ath_htc_rx_status *rxstatus;
 	struct ath_rx_status rx_stats;
 	bool decrypt_error = false;
+	__be16 rs_datalen;
+	bool is_phyerr;
 
 	if (skb->len < HTC_RX_FRAME_HEADER_SIZE) {
 		ath_err(common, "Corrupted RX frame, dropping (len: %d)\n",
@@ -982,11 +984,24 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 
 	rxstatus = (struct ath_htc_rx_status *)skb->data;
 
-	if (be16_to_cpu(rxstatus->rs_datalen) -
-	    (skb->len - HTC_RX_FRAME_HEADER_SIZE) != 0) {
+	rs_datalen = be16_to_cpu(rxstatus->rs_datalen);
+	if (unlikely(rs_datalen -
+	    (skb->len - HTC_RX_FRAME_HEADER_SIZE) != 0)) {
 		ath_err(common,
 			"Corrupted RX data len, dropping (dlen: %d, skblen: %d)\n",
-			be16_to_cpu(rxstatus->rs_datalen), skb->len);
+			rs_datalen, skb->len);
+		goto rx_next;
+	}
+
+	is_phyerr = rxstatus->rs_status & ATH9K_RXERR_PHY;
+	/*
+	 * Discard zero-length packets and packets smaller than an ACK
+	 * which are not PHY_ERROR (short radar pulses have a length of 3)
+	 */
+	if (unlikely(!rs_datalen || (rs_datalen < 10 && !is_phyerr))) {
+		ath_warn(common,
+			 "Short RX data len, dropping (dlen: %d)\n",
+			 rs_datalen);
 		goto rx_next;
 	}
 
@@ -1011,7 +1026,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	 * Process PHY errors and return so that the packet
 	 * can be dropped.
 	 */
-	if (rx_stats.rs_status & ATH9K_RXERR_PHY) {
+	if (unlikely(is_phyerr)) {
 		/* TODO: Not using DFS processing now. */
 		if (ath_cmn_process_fft(&priv->spec_priv, hdr,
 				    &rx_stats, rx_status->mactime)) {
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0188D450E09
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240521AbhKOSKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:10:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:46096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239844AbhKOSEy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:04:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81D106324A;
        Mon, 15 Nov 2021 17:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997967;
        bh=YoMJBw+pwqJ7nyxDP2Zq3HG+bM29ivKvUDy+ZzE5B+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OowWssgQNUEp4gGRKNSfYsUFNTYuzKvdxd5iabNgmQKroDOzxsXkeAVmQzkvLm7sV
         Gta++MVSL4FoWlqMcTdrq475A7yt8i+3ZEpg/agpkD5NlW2itfIpcJBcgE8iJ1Hhkm
         +LxaW9EMkD7dNWvNcmZA5I4ZRiW5UTuhUUdDMtiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <seckelmann@datto.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 322/575] ath10k: fix max antenna gain unit
Date:   Mon, 15 Nov 2021 18:00:47 +0100
Message-Id: <20211115165354.939303517@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <seckelmann@datto.com>

[ Upstream commit 0a491167fe0cf9f26062462de2a8688b96125d48 ]

Most of the txpower for the ath10k firmware is stored as twicepower (0.5 dB
steps). This isn't the case for max_antenna_gain - which is still expected
by the firmware as dB.

The firmware is converting it from dB to the internal (twicepower)
representation when it calculates the limits of a channel. This can be seen
in tpc_stats when configuring "12" as max_antenna_gain. Instead of the
expected 12 (6 dB), the tpc_stats shows 24 (12 dB).

Tested on QCA9888 and IPQ4019 with firmware 10.4-3.5.3-00057.

Fixes: 02256930d9b8 ("ath10k: use proper tx power unit")
Signed-off-by: Sven Eckelmann <seckelmann@datto.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20190611172131.6064-1-sven@narfation.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 6 +++---
 drivers/net/wireless/ath/ath10k/wmi.h | 3 +++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 90dc48f66fbfe..c42977918e049 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1041,7 +1041,7 @@ static int ath10k_monitor_vdev_start(struct ath10k *ar, int vdev_id)
 	arg.channel.min_power = 0;
 	arg.channel.max_power = channel->max_power * 2;
 	arg.channel.max_reg_power = channel->max_reg_power * 2;
-	arg.channel.max_antenna_gain = channel->max_antenna_gain * 2;
+	arg.channel.max_antenna_gain = channel->max_antenna_gain;
 
 	reinit_completion(&ar->vdev_setup_done);
 	reinit_completion(&ar->vdev_delete_done);
@@ -1487,7 +1487,7 @@ static int ath10k_vdev_start_restart(struct ath10k_vif *arvif,
 	arg.channel.min_power = 0;
 	arg.channel.max_power = chandef->chan->max_power * 2;
 	arg.channel.max_reg_power = chandef->chan->max_reg_power * 2;
-	arg.channel.max_antenna_gain = chandef->chan->max_antenna_gain * 2;
+	arg.channel.max_antenna_gain = chandef->chan->max_antenna_gain;
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
 		arg.ssid = arvif->u.ap.ssid;
@@ -3258,7 +3258,7 @@ static int ath10k_update_channel_list(struct ath10k *ar)
 			ch->min_power = 0;
 			ch->max_power = channel->max_power * 2;
 			ch->max_reg_power = channel->max_reg_power * 2;
-			ch->max_antenna_gain = channel->max_antenna_gain * 2;
+			ch->max_antenna_gain = channel->max_antenna_gain;
 			ch->reg_class_id = 0; /* FIXME */
 
 			/* FIXME: why use only legacy modes, why not any
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 66ecf09068c19..e244b7038e606 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2066,7 +2066,9 @@ struct wmi_channel {
 	union {
 		__le32 reginfo1;
 		struct {
+			/* note: power unit is 1 dBm */
 			u8 antenna_max;
+			/* note: power unit is 0.5 dBm */
 			u8 max_tx_power;
 		} __packed;
 	} __packed;
@@ -2086,6 +2088,7 @@ struct wmi_channel_arg {
 	u32 min_power;
 	u32 max_power;
 	u32 max_reg_power;
+	/* note: power unit is 1 dBm */
 	u32 max_antenna_gain;
 	u32 reg_class_id;
 	enum wmi_phy_mode mode;
-- 
2.33.0




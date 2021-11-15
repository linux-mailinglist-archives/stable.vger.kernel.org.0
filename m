Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37A345270F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238930AbhKPCPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:15:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:35656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238554AbhKORsj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:48:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1C4F63320;
        Mon, 15 Nov 2021 17:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997414;
        bh=r0LGiRnDZpsEmQpGpk932AmsmzSV1AM7R+XdtkUqyU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x3wpGmBhomrUaeIdfMZvfl5GVie66nIFQ8SSOFqCn7OMMKil0Gp2Z4hUcoG8jw5Tq
         tA/hk1FnrQ+bVp/Pc6qy5LCva1PE+k+N8fVreWXBuxjlapeX9dgkyYYTupM8rdqvwT
         YwxgwpSUwEKNSzEhuCkm+HWkRYhuUQqsmhQN/uUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.10 112/575] rsi: fix key enabled check causing unwanted encryption for vap_id > 0
Date:   Mon, 15 Nov 2021 17:57:17 +0100
Message-Id: <20211115165347.539653063@linuxfoundation.org>
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

From: Martin Fuzzey <martin.fuzzey@flowbird.group>

commit 99ac6018821253ec67f466086afb63fc18ea48e2 upstream.

My previous patch checked if encryption should be enabled by directly
checking info->control.hw_key (like the downstream driver).
However that missed that the control and driver_info members of
struct ieee80211_tx_info are union fields.

Due to this when rsi_core_xmit() updates fields in "tx_params"
(driver_info) it can overwrite the control.hw_key, causing the result
of the later test to be incorrect.

With the current structure layout the first byte of control.hw_key is
overlayed with the vap_id so, since we only test if control.hw_key is
NULL / non NULL, a non zero vap_id will incorrectly enable encryption.

In basic STA and AP modes the vap_id is always zero so it works but in
P2P client mode a second VIF is created causing vap_id to be non zero
and hence encryption to be enabled before keys have been set.

Fix this by extracting the key presence flag to a new field in the driver
private tx_params structure and populating it first.

Fixes: 314538041b56 ("rsi: fix AP mode with WPA failure due to encrypted EAPOL")
Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
CC: stable@vger.kernel.org
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1630337206-12410-3-git-send-email-martin.fuzzey@flowbird.group
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/rsi/rsi_91x_core.c |    2 ++
 drivers/net/wireless/rsi/rsi_91x_hal.c  |    2 +-
 drivers/net/wireless/rsi/rsi_main.h     |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -400,6 +400,8 @@ void rsi_core_xmit(struct rsi_common *co
 
 	info = IEEE80211_SKB_CB(skb);
 	tx_params = (struct skb_info *)info->driver_data;
+	/* info->driver_data and info->control part of union so make copy */
+	tx_params->have_key = !!info->control.hw_key;
 	wh = (struct ieee80211_hdr *)&skb->data[0];
 	tx_params->sta_id = 0;
 
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -203,7 +203,7 @@ int rsi_prepare_data_desc(struct rsi_com
 		wh->frame_control |= cpu_to_le16(RSI_SET_PS_ENABLE);
 
 	if ((!(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) &&
-	    info->control.hw_key) {
+	    tx_params->have_key) {
 		if (rsi_is_cipher_wep(common))
 			ieee80211_size += 4;
 		else
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -139,6 +139,7 @@ struct skb_info {
 	u8 internal_hdr_size;
 	struct ieee80211_vif *vif;
 	u8 vap_id;
+	bool have_key;
 };
 
 enum edca_queue {



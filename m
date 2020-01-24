Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83C991480A8
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389593AbgAXLNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:13:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:49582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389575AbgAXLNQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:13:16 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CE312075D;
        Fri, 24 Jan 2020 11:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864396;
        bh=fR8gmILwklJ0B5AsOs/paTIsTkLdDPRN3rqApDv41+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lhaiplsT+pxbJ7hbBI4KyeQZfkyFugfHzoji+XJUeDQXL/SnGRAW/L1eE/pS5WR8B
         MzmmsPMzR+F4o8DzqOHPiuA5qY4Ij1jfLTlG3e5g5iyJWhsh+eyYjMHnHV59SqBeea
         mAiTgWgGfQhkUBmLPo6oei1wUgJiWRZlJj/Mi5Uo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Surabhi Vishnoi <svishnoi@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 240/639] ath10k: Fix length of wmi tlv command for protected mgmt frames
Date:   Fri, 24 Jan 2020 10:26:50 +0100
Message-Id: <20200124093116.884954590@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Surabhi Vishnoi <svishnoi@codeaurora.org>

[ Upstream commit 761156ff573d1002983416e4fd1fe8d3489c4bd8 ]

The length of wmi tlv command for management tx send is calculated
incorrectly in case of protected management frames as there is addition
of IEEE80211_CCMP_MIC_LEN twice. This leads to improper behaviour of
firmware as the wmi tlv mgmt tx send command for protected mgmt frames
is formed wrongly.

Fix the length calculation of wmi tlv command for mgmt tx send in case
of protected management frames by adding the IEEE80211_CCMP_MIC_LEN only
once.

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1

Fixes: 1807da49733e "ath10k: wmi: add management tx by reference support over wmi"
Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index cdc1e64d52ad5..a90990b8008de 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2692,10 +2692,8 @@ ath10k_wmi_tlv_op_gen_mgmt_tx_send(struct ath10k *ar, struct sk_buff *msdu,
 	if ((ieee80211_is_action(hdr->frame_control) ||
 	     ieee80211_is_deauth(hdr->frame_control) ||
 	     ieee80211_is_disassoc(hdr->frame_control)) &&
-	     ieee80211_has_protected(hdr->frame_control)) {
-		len += IEEE80211_CCMP_MIC_LEN;
+	     ieee80211_has_protected(hdr->frame_control))
 		buf_len += IEEE80211_CCMP_MIC_LEN;
-	}
 
 	buf_len = min_t(u32, buf_len, WMI_TLV_MGMT_TX_FRAME_MAX_LEN);
 	buf_len = round_up(buf_len, 4);
-- 
2.20.1




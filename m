Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7392333B61B
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhCON5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231130AbhCON4m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:56:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65F0864EF8;
        Mon, 15 Mar 2021 13:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816600;
        bh=YgK7z5OuoTYfHFxczuQxZsrqwMpzCQi6HapODk0JIQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wNOUiRgU7KyzGBS3TtWwV9VeHenGLyD5E6LruP8/4GygUzOSSUV20I57u+VIEc3Vn
         g7O/ZquAV6bXgQqA48htqhxikF5Lq2vErF+RGANgv5NOWVA87cYF0e8UeuwwakxW+E
         S/Lzpi1z68v8NxuDk/aYvy1LTAEQjDYqoUXOriiw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Kennedy <hurricos@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.10 006/290] ath9k: fix transmitting to stations in dynamic SMPS mode
Date:   Mon, 15 Mar 2021 14:51:39 +0100
Message-Id: <20210315135542.156631808@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Felix Fietkau <nbd@nbd.name>

commit 3b9ea7206d7e1fdd7419cbd10badd3b2c80d04b4 upstream.

When transmitting to a receiver in dynamic SMPS mode, all transmissions that
use multiple spatial streams need to be sent using CTS-to-self or RTS/CTS to
give the receiver's extra chains some time to wake up.
This fixes the tx rate getting stuck at <= MCS7 for some clients, especially
Intel ones, which make aggressive use of SMPS.

Cc: stable@vger.kernel.org
Reported-by: Martin Kennedy <hurricos@gmail.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210214184911.96702-1-nbd@nbd.name
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    3 ++-
 drivers/net/wireless/ath/ath9k/xmit.c  |    6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -177,7 +177,8 @@ struct ath_frame_info {
 	s8 txq;
 	u8 keyix;
 	u8 rtscts_rate;
-	u8 retries : 7;
+	u8 retries : 6;
+	u8 dyn_smps : 1;
 	u8 baw_tracked : 1;
 	u8 tx_power;
 	enum ath9k_key_type keytype:2;
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1271,6 +1271,11 @@ static void ath_buf_set_rate(struct ath_
 				 is_40, is_sgi, is_sp);
 			if (rix < 8 && (tx_info->flags & IEEE80211_TX_CTL_STBC))
 				info->rates[i].RateFlags |= ATH9K_RATESERIES_STBC;
+			if (rix >= 8 && fi->dyn_smps) {
+				info->rates[i].RateFlags |=
+					ATH9K_RATESERIES_RTS_CTS;
+				info->flags |= ATH9K_TXDESC_CTSENA;
+			}
 
 			info->txpower[i] = ath_get_rate_txpower(sc, bf, rix,
 								is_40, false);
@@ -2114,6 +2119,7 @@ static void setup_frame_info(struct ieee
 		fi->keyix = an->ps_key;
 	else
 		fi->keyix = ATH9K_TXKEYIX_INVALID;
+	fi->dyn_smps = sta && sta->smps_mode == IEEE80211_SMPS_DYNAMIC;
 	fi->keytype = keytype;
 	fi->framelen = framelen;
 	fi->tx_power = txpower;



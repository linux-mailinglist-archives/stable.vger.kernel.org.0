Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657EE33B6C2
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhCON6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229815AbhCON6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1DCC64F04;
        Mon, 15 Mar 2021 13:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816681;
        bh=nswGCUt+fiFwb6WHGUpuDzc9XaU0BOqhlvsOixL2YLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8vLS6SU4mP88kgFfmKPMFEkUwhmUOhGeiL4OVida2ZmSpM9y7Sch6xuz13SpKS8N
         ohBDfG5rznsWMoZB6hbS0MfgZKKNzXb1FSugUjbNPz781bFK3yz8FBBcmgcRiZgXQo
         mCa3o9r9CJXxIY3lz4L6zP8XFF5S2PN8MSDY5kVI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Kennedy <hurricos@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.19 003/120] ath9k: fix transmitting to stations in dynamic SMPS mode
Date:   Mon, 15 Mar 2021 14:55:54 +0100
Message-Id: <20210315135720.115158642@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
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
@@ -179,7 +179,8 @@ struct ath_frame_info {
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
@@ -1324,6 +1324,11 @@ static void ath_buf_set_rate(struct ath_
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
@@ -2206,6 +2211,7 @@ static void setup_frame_info(struct ieee
 		fi->keyix = an->ps_key;
 	else
 		fi->keyix = ATH9K_TXKEYIX_INVALID;
+	fi->dyn_smps = sta && sta->smps_mode == IEEE80211_SMPS_DYNAMIC;
 	fi->keytype = keytype;
 	fi->framelen = framelen;
 	fi->tx_power = txpower;



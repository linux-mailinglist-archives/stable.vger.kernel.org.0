Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5B8A73FF4
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387923AbfGXTYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:24:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387916AbfGXTYL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:24:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAB4622387;
        Wed, 24 Jul 2019 19:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996250;
        bh=z2tDvDZ1wSCfjB31V79vAvatC0HzUue8IWw2Z5RYXzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FOUfXS60WsPhZmEg2VEZE/n6Hh+6xP77yQbIC+sa2ggDTX732RwqvdpbecQY7Q2wu
         ink5jqgrE1dLg4M5NAZkzeUZ+V46RTG2Du6SVPoun/9JyHKiFbajkSVo3Oo0Cg9MSq
         l0X4/OBbuhotvYmEcl6gbabsCq6WFppOXAxeUITA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Miguel Catalan Cid <miguel.catalan@i2cat.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 004/413] ath9k: Dont trust TX status TID number when reporting airtime
Date:   Wed, 24 Jul 2019 21:14:55 +0200
Message-Id: <20190724191735.486183261@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 389b72e58259336c2d56d58b660b79cf4b9e0dcb ]

As already noted a comment in ath_tx_complete_aggr(), the hardware will
occasionally send a TX status with the wrong tid number. If we trust the
value, airtime usage will be reported to the wrong AC, which can cause the
deficit on that AC to become very low, blocking subsequent attempts to
transmit.

To fix this, account airtime usage to the TID number from the original skb,
instead of the one in the hardware TX status report.

Reported-by: Miguel Catalan Cid <miguel.catalan@i2cat.net>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index b17e1ca40995..3be0aeedb9b5 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -668,7 +668,8 @@ static bool bf_is_ampdu_not_probing(struct ath_buf *bf)
 static void ath_tx_count_airtime(struct ath_softc *sc,
 				 struct ieee80211_sta *sta,
 				 struct ath_buf *bf,
-				 struct ath_tx_status *ts)
+				 struct ath_tx_status *ts,
+				 u8 tid)
 {
 	u32 airtime = 0;
 	int i;
@@ -679,7 +680,7 @@ static void ath_tx_count_airtime(struct ath_softc *sc,
 		airtime += rate_dur * bf->rates[i].count;
 	}
 
-	ieee80211_sta_register_airtime(sta, ts->tid, airtime, 0);
+	ieee80211_sta_register_airtime(sta, tid, airtime, 0);
 }
 
 static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
@@ -709,7 +710,7 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 	if (sta) {
 		struct ath_node *an = (struct ath_node *)sta->drv_priv;
 		tid = ath_get_skb_tid(sc, an, bf->bf_mpdu);
-		ath_tx_count_airtime(sc, sta, bf, ts);
+		ath_tx_count_airtime(sc, sta, bf, ts, tid->tidno);
 		if (ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY))
 			tid->clear_ps_filter = true;
 	}
-- 
2.20.1




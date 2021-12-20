Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCECE47AD3E
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236711AbhLTOvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236709AbhLTOsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:48:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6571C0617A1;
        Mon, 20 Dec 2021 06:44:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3E09B80EDF;
        Mon, 20 Dec 2021 14:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB818C36AE7;
        Mon, 20 Dec 2021 14:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011476;
        bh=GUVxUKqGsmPmlMVDzYN75ySpwgaTHiahYc/G0qshb20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Er3MBsX0/d3ZBGZ7/ZU72YPwUsGKYr3NsLdTBeSd3d5rl8NzqQ0LoaKV3tHABB8xy
         Sqt2gNbWSxuyHlPeG74npyh1OtWA3TejS+E3ookqlFuEB4K7/SUqzlNMHGOtcHhOLC
         VfqOeqV2+wAR5tcHzB99memkc9zCcAfk1hl9mf2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 27/71] mac80211: agg-tx: refactor sending addba
Date:   Mon, 20 Dec 2021 15:34:16 +0100
Message-Id: <20211220143026.597565088@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit 31d8bb4e07f80935ee9bf599a9d99de7ca90fc5a ]

We move the actual arming the timer and sending ADDBA to a function
for the use in different places calling the same logic.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20200326150855.58a337eb90a1.I75934e6464535fbf43969acc796bc886291e79a5@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/agg-tx.c | 67 +++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 28 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 3d2af1851bdf9..1a5768ae5f515 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -9,7 +9,7 @@
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2007-2010, Intel Corporation
  * Copyright(c) 2015-2017 Intel Deutschland GmbH
- * Copyright (C) 2018 - 2019 Intel Corporation
+ * Copyright (C) 2018 - 2020 Intel Corporation
  */
 
 #include <linux/ieee80211.h>
@@ -448,6 +448,43 @@ static void sta_addba_resp_timer_expired(struct timer_list *t)
 	ieee80211_stop_tx_ba_session(&sta->sta, tid);
 }
 
+static void ieee80211_send_addba_with_timeout(struct sta_info *sta,
+					      struct tid_ampdu_tx *tid_tx)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sta->local;
+	u8 tid = tid_tx->tid;
+	u16 buf_size;
+
+	/* activate the timer for the recipient's addBA response */
+	mod_timer(&tid_tx->addba_resp_timer, jiffies + ADDBA_RESP_INTERVAL);
+	ht_dbg(sdata, "activated addBA response timer on %pM tid %d\n",
+	       sta->sta.addr, tid);
+
+	spin_lock_bh(&sta->lock);
+	sta->ampdu_mlme.last_addba_req_time[tid] = jiffies;
+	sta->ampdu_mlme.addba_req_num[tid]++;
+	spin_unlock_bh(&sta->lock);
+
+	if (sta->sta.he_cap.has_he) {
+		buf_size = local->hw.max_tx_aggregation_subframes;
+	} else {
+		/*
+		 * We really should use what the driver told us it will
+		 * transmit as the maximum, but certain APs (e.g. the
+		 * LinkSys WRT120N with FW v1.0.07 build 002 Jun 18 2012)
+		 * will crash when we use a lower number.
+		 */
+		buf_size = IEEE80211_MAX_AMPDU_BUF_HT;
+	}
+
+	/* send AddBA request */
+	ieee80211_send_addba_request(sdata, sta->sta.addr, tid,
+				     tid_tx->dialog_token,
+				     sta->tid_seq[tid] >> 4,
+				     buf_size, tid_tx->timeout);
+}
+
 void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 {
 	struct tid_ampdu_tx *tid_tx;
@@ -462,7 +499,6 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 		.timeout = 0,
 	};
 	int ret;
-	u16 buf_size;
 
 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
 
@@ -501,32 +537,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 		return;
 	}
 
-	/* activate the timer for the recipient's addBA response */
-	mod_timer(&tid_tx->addba_resp_timer, jiffies + ADDBA_RESP_INTERVAL);
-	ht_dbg(sdata, "activated addBA response timer on %pM tid %d\n",
-	       sta->sta.addr, tid);
-
-	spin_lock_bh(&sta->lock);
-	sta->ampdu_mlme.last_addba_req_time[tid] = jiffies;
-	sta->ampdu_mlme.addba_req_num[tid]++;
-	spin_unlock_bh(&sta->lock);
-
-	if (sta->sta.he_cap.has_he) {
-		buf_size = local->hw.max_tx_aggregation_subframes;
-	} else {
-		/*
-		 * We really should use what the driver told us it will
-		 * transmit as the maximum, but certain APs (e.g. the
-		 * LinkSys WRT120N with FW v1.0.07 build 002 Jun 18 2012)
-		 * will crash when we use a lower number.
-		 */
-		buf_size = IEEE80211_MAX_AMPDU_BUF_HT;
-	}
-
-	/* send AddBA request */
-	ieee80211_send_addba_request(sdata, sta->sta.addr, tid,
-				     tid_tx->dialog_token, params.ssn,
-				     buf_size, tid_tx->timeout);
+	ieee80211_send_addba_with_timeout(sta, tid_tx);
 }
 
 /*
-- 
2.33.0




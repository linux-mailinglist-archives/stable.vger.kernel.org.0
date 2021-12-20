Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE61047AE70
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbhLTPBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:01:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237723AbhLTO4Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:56:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF32C08E9BA;
        Mon, 20 Dec 2021 06:48:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8DABB80EE6;
        Mon, 20 Dec 2021 14:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2097BC36AE7;
        Mon, 20 Dec 2021 14:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011705;
        bh=I5nIKZUEaoFN89WdUGnhbpGBLjClkSRiyS+TA8ifW8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D9YjxznjzkQds4ndkA3wPQ3UnUO9lroVK3ZxrHk16FimLxL2RcfQdzJEivBTconwn
         lMjYpNEBPdyov7VvkS/2odQSxJkeJ2SHZRQCkUoh/5KH8znJ0sByztwIJdXnHbK4Fc
         W86SW4SLlJ0payNhh5WPq5c+EY9oTWDmFIf1e4bo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Murphy <lists@colorremedies.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 43/99] mac80211: agg-tx: dont schedule_and_wake_txq() under sta->lock
Date:   Mon, 20 Dec 2021 15:34:16 +0100
Message-Id: <20211220143030.832652389@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 06c41bda0ea14aa7fba932a9613c4ee239682cf0 ]

When we call ieee80211_agg_start_txq(), that will in turn call
schedule_and_wake_txq(). Called from ieee80211_stop_tx_ba_cb()
this is done under sta->lock, which leads to certain circular
lock dependencies, as reported by Chris Murphy:
https://lore.kernel.org/r/CAJCQCtSXJ5qA4bqSPY=oLRMbv-irihVvP7A2uGutEbXQVkoNaw@mail.gmail.com

In general, ieee80211_agg_start_txq() is usually not called
with sta->lock held, only in this one place. But it's always
called with sta->ampdu_mlme.mtx held, and that's therefore
clearly sufficient.

Change ieee80211_stop_tx_ba_cb() to also call it without the
sta->lock held, by factoring it out of ieee80211_remove_tid_tx()
(which is only called in this one place).

This breaks the locking chain and makes it less likely that
we'll have similar locking chain problems in the future.

Fixes: ba8c3d6f16a1 ("mac80211: add an intermediate software queue implementation")
Reported-by: Chris Murphy <lists@colorremedies.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211202152554.f519884c8784.I555fef8e67d93fff3d9a304886c4a9f8b322e591@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/agg-tx.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 407765ad9cc92..190f300d8923c 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -9,7 +9,7 @@
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2007-2010, Intel Corporation
  * Copyright(c) 2015-2017 Intel Deutschland GmbH
- * Copyright (C) 2018 - 2020 Intel Corporation
+ * Copyright (C) 2018 - 2021 Intel Corporation
  */
 
 #include <linux/ieee80211.h>
@@ -213,6 +213,8 @@ ieee80211_agg_start_txq(struct sta_info *sta, int tid, bool enable)
 	struct ieee80211_txq *txq = sta->sta.txq[tid];
 	struct txq_info *txqi;
 
+	lockdep_assert_held(&sta->ampdu_mlme.mtx);
+
 	if (!txq)
 		return;
 
@@ -290,7 +292,6 @@ static void ieee80211_remove_tid_tx(struct sta_info *sta, int tid)
 	ieee80211_assign_tid_tx(sta, tid, NULL);
 
 	ieee80211_agg_splice_finish(sta->sdata, tid);
-	ieee80211_agg_start_txq(sta, tid, false);
 
 	kfree_rcu(tid_tx, rcu_head);
 }
@@ -889,6 +890,7 @@ void ieee80211_stop_tx_ba_cb(struct sta_info *sta, int tid,
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	bool send_delba = false;
+	bool start_txq = false;
 
 	ht_dbg(sdata, "Stopping Tx BA session for %pM tid %d\n",
 	       sta->sta.addr, tid);
@@ -906,10 +908,14 @@ void ieee80211_stop_tx_ba_cb(struct sta_info *sta, int tid,
 		send_delba = true;
 
 	ieee80211_remove_tid_tx(sta, tid);
+	start_txq = true;
 
  unlock_sta:
 	spin_unlock_bh(&sta->lock);
 
+	if (start_txq)
+		ieee80211_agg_start_txq(sta, tid, false);
+
 	if (send_delba)
 		ieee80211_send_delba(sdata, sta->sta.addr, tid,
 			WLAN_BACK_INITIATOR, WLAN_REASON_QSTA_NOT_USE);
-- 
2.33.0




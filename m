Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7296CC372
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbjC1Ox4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbjC1Oxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:53:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29D7DBCB
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:53:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E697617F1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9180AC433EF;
        Tue, 28 Mar 2023 14:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015232;
        bh=PV+tvnKdvEhsHAe82HDs99P5304QtIouqIXnmnVL7U0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0SUllZsQvjORS6nnLPstKD6yCmfASQtw2n/UmtqnbB2TM/cxW1HXAIKMvw+UL37Z7
         1Gw9QZvoFZSwHcWwYBxdXYQKCGqo6x25xSllf8F6Pk2InxRcgbjZiu4HZPRLkqhqBf
         4luoq5qoi0rsil0PGjhm25ZZ25XPLfK9obmmnM6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thomas Mann <rauchwolke@gmx.net>,
        Alexander Wetzel <alexander@wetzel-home.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.2 215/240] wifi: mac80211: Serialize ieee80211_handle_wake_tx_queue()
Date:   Tue, 28 Mar 2023 16:42:58 +0200
Message-Id: <20230328142628.651705812@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Wetzel <alexander@wetzel-home.de>

commit 007ae9b268ba7553e479608cf9735d3c4672a2ab upstream.

ieee80211_handle_wake_tx_queue must not run concurrent multiple times.
It calls ieee80211_txq_schedule_start() and the drivers migrated to iTXQ
do not expect overlapping drv_tx() calls.

This fixes 'c850e31f79f0 ("wifi: mac80211: add internal handler for
wake_tx_queue")', which introduced ieee80211_handle_wake_tx_queue.
Drivers started to use it with 'a790cc3a4fad ("wifi: mac80211: add
wake_tx_queue callback to drivers")'.
But only after fixing an independent bug with
'4444bc2116ae ("wifi: mac80211: Proper mark iTXQs for resumption")'
problematic concurrent calls really happened and exposed the initial
issue.

Fixes: c850e31f79f0 ("wifi: mac80211: add internal handler for wake_tx_queue")
Reported-by: Thomas Mann <rauchwolke@gmx.net>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217119
Link: https://lore.kernel.org/r/b8efebc6-4399-d0b8-b2a0-66843314616b@leemhuis.info/
Link: https://lore.kernel.org/r/b7445607128a6b9ed7c17fcdcf3679bfaf4aaea.camel@sipsolutions.net>
CC: <stable@vger.kernel.org>
Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
Link: https://lore.kernel.org/r/20230314211122.111688-1-alexander@wetzel-home.de
[add missing spin_lock_init() noticed by Felix]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/main.c        |    2 ++
 net/mac80211/util.c        |    3 +++
 3 files changed, 8 insertions(+)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1285,6 +1285,9 @@ struct ieee80211_local {
 	struct list_head active_txqs[IEEE80211_NUM_ACS];
 	u16 schedule_round[IEEE80211_NUM_ACS];
 
+	/* serializes ieee80211_handle_wake_tx_queue */
+	spinlock_t handle_wake_tx_queue_lock;
+
 	u16 airtime_flags;
 	u32 aql_txq_limit_low[IEEE80211_NUM_ACS];
 	u32 aql_txq_limit_high[IEEE80211_NUM_ACS];
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -802,6 +802,8 @@ struct ieee80211_hw *ieee80211_alloc_hw_
 	local->aql_threshold = IEEE80211_AQL_THRESHOLD;
 	atomic_set(&local->aql_total_pending_airtime, 0);
 
+	spin_lock_init(&local->handle_wake_tx_queue_lock);
+
 	INIT_LIST_HEAD(&local->chanctx_list);
 	mutex_init(&local->chanctx_mtx);
 
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -314,6 +314,8 @@ void ieee80211_handle_wake_tx_queue(stru
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(txq->vif);
 	struct ieee80211_txq *queue;
 
+	spin_lock(&local->handle_wake_tx_queue_lock);
+
 	/* Use ieee80211_next_txq() for airtime fairness accounting */
 	ieee80211_txq_schedule_start(hw, txq->ac);
 	while ((queue = ieee80211_next_txq(hw, txq->ac))) {
@@ -321,6 +323,7 @@ void ieee80211_handle_wake_tx_queue(stru
 		ieee80211_return_txq(hw, queue, false);
 	}
 	ieee80211_txq_schedule_end(hw, txq->ac);
+	spin_unlock(&local->handle_wake_tx_queue_lock);
 }
 EXPORT_SYMBOL(ieee80211_handle_wake_tx_queue);
 



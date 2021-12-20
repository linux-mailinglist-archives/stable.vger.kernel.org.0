Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D3A47AD47
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbhLTOvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237506AbhLTOse (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:48:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32786C06139B;
        Mon, 20 Dec 2021 06:45:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6D65611AD;
        Mon, 20 Dec 2021 14:45:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB073C36AE8;
        Mon, 20 Dec 2021 14:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011538;
        bh=ZfsMhTn92iQfyB0EKCMyU0/pcBKHs5OG/oYoSZpvtDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BD7LPUhiaSzZYAujBQgSCcbQYKqFOCXmiZRmdhvcTV4Z81SBcX712xC1VxbMUsS8Z
         cSIjPsGpdLpk+nlX3C+kugxUfw8UEtj8lhNMSbkJvcNwnX4s6VRJk5QLyjS3GZhBj1
         HEcYLOHfl2EMwPKbcS1Tk6kBrJvetNVRpdTU7ECc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 29/71] mac80211: accept aggregation sessions on 6 GHz
Date:   Mon, 20 Dec 2021 15:34:18 +0100
Message-Id: <20211220143026.672016478@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 93382a0d119b3ab95e3ebca51ea15aa87187b493 ]

On 6 GHz, stations don't have ht_supported set, but they can
still do aggregation since they must have HE, allow that.

Link: https://lore.kernel.org/r/20200528213443.776d3c891b64.Ifa099d450617b50c691832b3c4aa08959fab520a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/agg-rx.c | 5 +++--
 net/mac80211/agg-tx.c | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 4d1c335e06e57..7f245e9f114c2 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -9,7 +9,7 @@
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2007-2010, Intel Corporation
  * Copyright(c) 2015-2017 Intel Deutschland GmbH
- * Copyright (C) 2018        Intel Corporation
+ * Copyright (C) 2018-2020 Intel Corporation
  */
 
 /**
@@ -292,7 +292,8 @@ void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
 		goto end;
 	}
 
-	if (!sta->sta.ht_cap.ht_supported) {
+	if (!sta->sta.ht_cap.ht_supported &&
+	    sta->sdata->vif.bss_conf.chandef.chan->band != NL80211_BAND_6GHZ) {
 		ht_dbg(sta->sdata,
 		       "STA %pM erroneously requests BA session on tid %d w/o QoS\n",
 		       sta->sta.addr, tid);
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index d801ceb2ed7fa..8d3b905e551a3 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -583,7 +583,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 		 "Requested to start BA session on reserved tid=%d", tid))
 		return -EINVAL;
 
-	if (!pubsta->ht_cap.ht_supported)
+	if (!pubsta->ht_cap.ht_supported &&
+	    sta->sdata->vif.bss_conf.chandef.chan->band != NL80211_BAND_6GHZ)
 		return -EINVAL;
 
 	if (WARN_ON_ONCE(!local->ops->ampdu_action))
-- 
2.33.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC1D3AB183
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 12:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhFQKlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 06:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhFQKlH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 06:41:07 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190C4C061574;
        Thu, 17 Jun 2021 03:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=88P+mVU+T6x1CWy71RbTkXq1aoDnrH6RLWxo83LbSLY=; b=mahF303DjtNkHL9cY4B+Hvj3CM
        EBXccR0lItf6Oo0oxTltJH3T+Hp0uQZMcHKAMzbOtWH88wbUE3PstMxV/Pwozxvo5nQm5CbBV/RHE
        gQAm8AwBBBp8df4KQFlJzKbRR+3F4Vbmnn+4et8+GtklRn3vZ+OJ8h6eXDbqXR0+CuIQ=;
Received: from p54ae9ff2.dip0.t-ipconnect.de ([84.174.159.242] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1ltpQG-0000UO-Rh; Thu, 17 Jun 2021 12:38:57 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, stable@vger.kernel.org
Subject: [PATCH 5.13] mac80211: minstrel_ht: fix sample time check
Date:   Thu, 17 Jun 2021 12:38:54 +0200
Message-Id: <20210617103854.61875-1-nbd@nbd.name>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We need to skip sampling if the next sample time is after jiffies, not before.
This patch fixes an issue where in some cases only very little sampling (or none
at all) is performed, leading to really bad data rates

Fixes: 80d55154b2f8 ("mac80211: minstrel_ht: significantly redesign the rate probing strategy")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rc80211_minstrel_ht.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 6487b05da6fa..a6f3fb4a9197 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1514,7 +1514,7 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	    (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO))
 		return;
 
-	if (time_is_before_jiffies(mi->sample_time))
+	if (time_is_after_jiffies(mi->sample_time))
 		return;
 
 	mi->sample_time = jiffies + MINSTREL_SAMPLE_INTERVAL;
-- 
2.30.1


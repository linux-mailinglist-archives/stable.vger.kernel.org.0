Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6536CA8FA3
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389166AbfIDSE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:04:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389143AbfIDSEz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:04:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE7FB206B8;
        Wed,  4 Sep 2019 18:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620294;
        bh=/c0E3IhlUuK29sMKO5Ld2wcLO2NHBouIlgrO37+mFDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nklbeQGzP9xjR1u0cmIkFl4PFyGC/IQC8kEzl3us5hu9gt7rLf0CyfsptJCa8/EOn
         o6cTnqZBxAbiCRDFrr06uzBB/YY+zzQ4fos8fMhf1kK7K5qAwJOXaF9Dws/GxdAx4B
         kN9ngAav3qF2B/CftxvwpFiHHceFI+cYWN0XhoJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.14 48/57] mac80211: fix possible sta leak
Date:   Wed,  4 Sep 2019 19:54:16 +0200
Message-Id: <20190904175306.641592543@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
References: <20190904175301.777414715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 5fd2f91ad483baffdbe798f8a08f1b41442d1e24 upstream.

If TDLS station addition is rejected, the sta memory is leaked.
Avoid this by moving the check before the allocation.

Cc: stable@vger.kernel.org
Fixes: 7ed5285396c2 ("mac80211: don't initiate TDLS connection if station is not associated to AP")
Link: https://lore.kernel.org/r/20190801073033.7892-1-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/cfg.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1459,6 +1459,11 @@ static int ieee80211_add_station(struct
 	if (is_multicast_ether_addr(mac))
 		return -EINVAL;
 
+	if (params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER) &&
+	    sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    !sdata->u.mgd.associated)
+		return -EINVAL;
+
 	sta = sta_info_alloc(sdata, mac, GFP_KERNEL);
 	if (!sta)
 		return -ENOMEM;
@@ -1466,10 +1471,6 @@ static int ieee80211_add_station(struct
 	if (params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER))
 		sta->sta.tdls = true;
 
-	if (sta->sta.tdls && sdata->vif.type == NL80211_IFTYPE_STATION &&
-	    !sdata->u.mgd.associated)
-		return -EINVAL;
-
 	err = sta_apply_parameters(local, sta, params);
 	if (err) {
 		sta_info_free(local, sta);



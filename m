Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52A34A8E7D
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387991AbfIDR6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:58:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388023AbfIDR6S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:58:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A9FE21883;
        Wed,  4 Sep 2019 17:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619897;
        bh=VvHYiusNWtxqIFbpFY8rvWugSCdZoy++9ObtJ4TOP6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBG3pFThHC/PSY6p5Q+pjV3+5jLqrTHT1iE31Ref9ApiKJ90e48+cSAGxzZvEudp2
         UcEAL3QMyLCREUsL3EgnP6iyHXAfpgu+Ya3ShLIKr/OkwAEPQlI6lk/SwyJ0CkXzez
         lLvJEJgeTrqM5dQYlkIBduAK1J+ZVjg8hwjditBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.4 76/77] mac80211: fix possible sta leak
Date:   Wed,  4 Sep 2019 19:54:03 +0200
Message-Id: <20190904175310.427013886@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
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
@@ -1211,6 +1211,11 @@ static int ieee80211_add_station(struct
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
@@ -1228,10 +1233,6 @@ static int ieee80211_add_station(struct
 	if (params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER))
 		sta->sta.tdls = true;
 
-	if (sta->sta.tdls && sdata->vif.type == NL80211_IFTYPE_STATION &&
-	    !sdata->u.mgd.associated)
-		return -EINVAL;
-
 	err = sta_apply_parameters(local, sta, params);
 	if (err) {
 		sta_info_free(local, sta);



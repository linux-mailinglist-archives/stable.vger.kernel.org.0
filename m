Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E95313722
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbhBHPUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:20:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:55766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231452AbhBHPNa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:13:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8D6664EFF;
        Mon,  8 Feb 2021 15:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797027;
        bh=Vw21LDfqvR1vAbR9fbUI1B2If3KKTuMXwiCW1ovarE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXszzOgjo3OgFuXDLWtcVG5rRk/vTk6JECVLYim9ImU9KLuAU3VVDGQhRhMX+rVLG
         1YJl+FYlNxn7oEUpI5DCpMuZSj40VKybbuKNTuoiopTcBzNjKdAX4xtfaYOOAeRDGH
         mhIYZMgKaifTG2AkBiff3RFgKWoL+p3FwHmn3qXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 33/65] mac80211: fix station rate table updates on assoc
Date:   Mon,  8 Feb 2021 16:01:05 +0100
Message-Id: <20210208145811.507439369@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

commit 18fe0fae61252b5ae6e26553e2676b5fac555951 upstream.

If the driver uses .sta_add, station entries are only uploaded after the sta
is in assoc state. Fix early station rate table updates by deferring them
until the sta has been uploaded.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20210201083324.3134-1-nbd@nbd.name
[use rcu_access_pointer() instead since we won't dereference here]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/driver-ops.c |    5 ++++-
 net/mac80211/rate.c       |    3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -125,8 +125,11 @@ int drv_sta_state(struct ieee80211_local
 	} else if (old_state == IEEE80211_STA_AUTH &&
 		   new_state == IEEE80211_STA_ASSOC) {
 		ret = drv_sta_add(local, sdata, &sta->sta);
-		if (ret == 0)
+		if (ret == 0) {
 			sta->uploaded = true;
+			if (rcu_access_pointer(sta->sta.rates))
+				drv_sta_rate_tbl_update(local, sdata, &sta->sta);
+		}
 	} else if (old_state == IEEE80211_STA_ASSOC &&
 		   new_state == IEEE80211_STA_AUTH) {
 		drv_sta_remove(local, sdata, &sta->sta);
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -934,7 +934,8 @@ int rate_control_set_rates(struct ieee80
 	if (old)
 		kfree_rcu(old, rcu_head);
 
-	drv_sta_rate_tbl_update(hw_to_local(hw), sta->sdata, pubsta);
+	if (sta->uploaded)
+		drv_sta_rate_tbl_update(hw_to_local(hw), sta->sdata, pubsta);
 
 	ieee80211_sta_set_expected_throughput(pubsta, sta_get_expected_throughput(sta));
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780D73136B6
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbhBHPOJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:14:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:55254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233236AbhBHPKz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:10:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B66D64EC4;
        Mon,  8 Feb 2021 15:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796865;
        bh=zu04za1olHJW9o9M8NvbZ6Jb6iTbCFvbqw7IS6YMdJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PpWx1gmOwdm75oiaDCKS5Gm3cZItZcX5nk+l4A9Hf1wBRnhwBNUjdqj+vdShH3sqa
         Um68YDVGWAzfqhdavL6z9AG99uip3isoZn4uFIvOewX3eZiOW4a2eYo/s8SrAUCPFu
         mzBzU7dY8kPJkUVNRBFrrT0lw4Dnm+4lYgUmWOn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 17/38] mac80211: fix station rate table updates on assoc
Date:   Mon,  8 Feb 2021 16:01:04 +0100
Message-Id: <20210208145806.817420784@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.141056364@linuxfoundation.org>
References: <20210208145806.141056364@linuxfoundation.org>
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
@@ -128,8 +128,11 @@ int drv_sta_state(struct ieee80211_local
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
@@ -941,7 +941,8 @@ int rate_control_set_rates(struct ieee80
 	if (old)
 		kfree_rcu(old, rcu_head);
 
-	drv_sta_rate_tbl_update(hw_to_local(hw), sta->sdata, pubsta);
+	if (sta->uploaded)
+		drv_sta_rate_tbl_update(hw_to_local(hw), sta->sdata, pubsta);
 
 	ieee80211_sta_set_expected_throughput(pubsta, sta_get_expected_throughput(sta));
 



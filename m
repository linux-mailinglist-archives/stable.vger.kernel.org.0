Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA892B1E93
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388914AbfIMNL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388955AbfIMNL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:11:27 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 813C6208C2;
        Fri, 13 Sep 2019 13:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380286;
        bh=t2tjSDO5vxOy3giNKDDJxJA/uKkPLx8LF1myWbw+N+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szYJrN8mWpqgbFl7A8IyxCvL78l3smgchDIDUo/Sl26W3ETz5PEaPuut6NvdG8zZr
         055Mzz+pMIxQCcZ5nl2RaWvw06r6Jis+HidRcVT54bMKHJ2klZrp+1nd0PMOSm7cTL
         BgZo9i5ayj/KkumAstJ2IbM/ubnzFEYPiCbXaQww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 016/190] {nl,mac}80211: fix interface combinations on crypto controlled devices
Date:   Fri, 13 Sep 2019 14:04:31 +0100
Message-Id: <20190913130600.869646954@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e6f4051123fd33901e9655a675b22aefcdc5d277 ]

Commit 33d915d9e8ce ("{nl,mac}80211: allow 4addr AP operation on
crypto controlled devices") has introduced a change which allows
4addr operation on crypto controlled devices (ex: ath10k). This
change has inadvertently impacted the interface combinations logic
on such devices.

General rule is that software interfaces like AP/VLAN should not be
listed under supported interface combinations and should not be
considered during validation of these combinations; because of the
aforementioned change, AP/VLAN interfaces(if present) will be checked
against interfaces supported by the device and blocks valid interface
combinations.

Consider a case where an AP and AP/VLAN are up and running; when a
second AP device is brought up on the same physical device, this AP
will be checked against the AP/VLAN interface (which will not be
part of supported interface combinations of the device) and blocks
second AP to come up.

Add a new API cfg80211_iftype_allowed() to fix the problem, this
API works for all devices with/without SW crypto control.

Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Fixes: 33d915d9e8ce ("{nl,mac}80211: allow 4addr AP operation on crypto controlled devices")
Link: https://lore.kernel.org/r/1563779690-9716-1-git-send-email-mpubbise@codeaurora.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h | 15 +++++++++++++++
 net/mac80211/util.c    |  7 +++----
 net/wireless/core.c    |  6 ++----
 net/wireless/nl80211.c |  4 +---
 net/wireless/util.c    | 27 +++++++++++++++++++++++++--
 5 files changed, 46 insertions(+), 13 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 67e0a990144a6..468deae5d603e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -6562,6 +6562,21 @@ int cfg80211_external_auth_request(struct net_device *netdev,
 				   struct cfg80211_external_auth_params *params,
 				   gfp_t gfp);
 
+/**
+ * cfg80211_iftype_allowed - check whether the interface can be allowed
+ * @wiphy: the wiphy
+ * @iftype: interface type
+ * @is_4addr: use_4addr flag, must be '0' when check_swif is '1'
+ * @check_swif: check iftype against software interfaces
+ *
+ * Check whether the interface is allowed to operate; additionally, this API
+ * can be used to check iftype against the software interfaces when
+ * check_swif is '1'.
+ */
+bool cfg80211_iftype_allowed(struct wiphy *wiphy, enum nl80211_iftype iftype,
+			     bool is_4addr, u8 check_swif);
+
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index c59638574cf8b..f101a6460b44b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3527,9 +3527,7 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* Always allow software iftypes */
-	if (local->hw.wiphy->software_iftypes & BIT(iftype) ||
-	    (iftype == NL80211_IFTYPE_AP_VLAN &&
-	     local->hw.wiphy->flags & WIPHY_FLAG_4ADDR_AP)) {
+	if (cfg80211_iftype_allowed(local->hw.wiphy, iftype, 0, 1)) {
 		if (radar_detect)
 			return -EINVAL;
 		return 0;
@@ -3564,7 +3562,8 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 
 		if (sdata_iter == sdata ||
 		    !ieee80211_sdata_running(sdata_iter) ||
-		    local->hw.wiphy->software_iftypes & BIT(wdev_iter->iftype))
+		    cfg80211_iftype_allowed(local->hw.wiphy,
+					    wdev_iter->iftype, 0, 1))
 			continue;
 
 		params.iftype_num[wdev_iter->iftype]++;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 2a46ec3cb72c1..68660781aa51f 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1335,10 +1335,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		}
 		break;
 	case NETDEV_PRE_UP:
-		if (!(wdev->wiphy->interface_modes & BIT(wdev->iftype)) &&
-		    !(wdev->iftype == NL80211_IFTYPE_AP_VLAN &&
-		      rdev->wiphy.flags & WIPHY_FLAG_4ADDR_AP &&
-		      wdev->use_4addr))
+		if (!cfg80211_iftype_allowed(wdev->wiphy, wdev->iftype,
+					     wdev->use_4addr, 0))
 			return notifier_from_errno(-EOPNOTSUPP);
 
 		if (rfkill_blocked(rdev->rfkill))
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8e2f03ab4cc9f..2a85bff6a8f35 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3210,9 +3210,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 			return err;
 	}
 
-	if (!(rdev->wiphy.interface_modes & (1 << type)) &&
-	    !(type == NL80211_IFTYPE_AP_VLAN && params.use_4addr &&
-	      rdev->wiphy.flags & WIPHY_FLAG_4ADDR_AP))
+	if (!cfg80211_iftype_allowed(&rdev->wiphy, type, params.use_4addr, 0))
 		return -EOPNOTSUPP;
 
 	err = nl80211_parse_mon_options(rdev, type, info, &params);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index d57e2f679a3e4..c14e8f6e5e198 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1670,7 +1670,7 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 	for (iftype = 0; iftype < NUM_NL80211_IFTYPES; iftype++) {
 		num_interfaces += params->iftype_num[iftype];
 		if (params->iftype_num[iftype] > 0 &&
-		    !(wiphy->software_iftypes & BIT(iftype)))
+		    !cfg80211_iftype_allowed(wiphy, iftype, 0, 1))
 			used_iftypes |= BIT(iftype);
 	}
 
@@ -1692,7 +1692,7 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 			return -ENOMEM;
 
 		for (iftype = 0; iftype < NUM_NL80211_IFTYPES; iftype++) {
-			if (wiphy->software_iftypes & BIT(iftype))
+			if (cfg80211_iftype_allowed(wiphy, iftype, 0, 1))
 				continue;
 			for (j = 0; j < c->n_limits; j++) {
 				all_iftypes |= limits[j].types;
@@ -1895,3 +1895,26 @@ EXPORT_SYMBOL(rfc1042_header);
 const unsigned char bridge_tunnel_header[] __aligned(2) =
 	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8 };
 EXPORT_SYMBOL(bridge_tunnel_header);
+
+bool cfg80211_iftype_allowed(struct wiphy *wiphy, enum nl80211_iftype iftype,
+			     bool is_4addr, u8 check_swif)
+
+{
+	bool is_vlan = iftype == NL80211_IFTYPE_AP_VLAN;
+
+	switch (check_swif) {
+	case 0:
+		if (is_vlan && is_4addr)
+			return wiphy->flags & WIPHY_FLAG_4ADDR_AP;
+		return wiphy->interface_modes & BIT(iftype);
+	case 1:
+		if (!(wiphy->software_iftypes & BIT(iftype)) && is_vlan)
+			return wiphy->flags & WIPHY_FLAG_4ADDR_AP;
+		return wiphy->software_iftypes & BIT(iftype);
+	default:
+		break;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL(cfg80211_iftype_allowed);
-- 
2.20.1




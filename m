Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6B0508CB
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730769AbfFXKVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730740AbfFXKVs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:21:48 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0455A21670;
        Mon, 24 Jun 2019 10:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371707;
        bh=666xdgK++dn6u7OHiH29ChQci0NLFFTAOmdXCAi80cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KhvgcwopC8Cnhjnq6kUe5I+Po8vk4w0g67vgLNK/l6Mq9zaYumW4lhc/YTa5LwWsw
         jxksEToYWzp86jx82QXyGoK3IbYg42wuzw0h2P60/sperdQxYu6kIpfkv5aBgUpN+B
         3SIPD8ISyefAZJQeigG4oha5NaDGNRLmE6vxeZS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.1 117/121] {nl,mac}80211: allow 4addr AP operation on crypto controlled devices
Date:   Mon, 24 Jun 2019 17:57:29 +0800
Message-Id: <20190624092326.611959095@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manikanta Pubbisetty <mpubbise@codeaurora.org>

commit 33d915d9e8ce811d8958915ccd18d71a66c7c495 upstream.

As per the current design, in the case of sw crypto controlled devices,
it is the device which advertises the support for AP/VLAN iftype based
on it's ability to tranmsit packets encrypted in software
(In VLAN functionality, group traffic generated for a specific
VLAN group is always encrypted in software). Commit db3bdcb9c3ff
("mac80211: allow AP_VLAN operation on crypto controlled devices")
has introduced this change.

Since 4addr AP operation also uses AP/VLAN iftype, this conditional
way of advertising AP/VLAN support has broken 4addr AP mode operation on
crypto controlled devices which do not support VLAN functionality.

In the case of ath10k driver, not all firmwares have support for VLAN
functionality but all can support 4addr AP operation. Because AP/VLAN
support is not advertised for these devices, 4addr AP operations are
also blocked.

Fix this by allowing 4addr operation on devices which do not support
AP/VLAN iftype but can support 4addr AP operation (decision is based on
the wiphy flag WIPHY_FLAG_4ADDR_AP).

Cc: stable@vger.kernel.org
Fixes: db3bdcb9c3ff ("mac80211: allow AP_VLAN operation on crypto controlled devices")
Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/cfg80211.h |    3 ++-
 net/mac80211/util.c    |    4 +++-
 net/wireless/core.c    |    6 +++++-
 net/wireless/nl80211.c |    8 ++++++--
 4 files changed, 16 insertions(+), 5 deletions(-)

--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3767,7 +3767,8 @@ struct cfg80211_ops {
  *	on wiphy_new(), but can be changed by the driver if it has a good
  *	reason to override the default
  * @WIPHY_FLAG_4ADDR_AP: supports 4addr mode even on AP (with a single station
- *	on a VLAN interface)
+ *	on a VLAN interface). This flag also serves an extra purpose of
+ *	supporting 4ADDR AP mode on devices which do not support AP/VLAN iftype.
  * @WIPHY_FLAG_4ADDR_STATION: supports 4addr mode even as a station
  * @WIPHY_FLAG_CONTROL_PORT_PROTOCOL: This device supports setting the
  *	control port protocol ethertype. The device also honours the
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3757,7 +3757,9 @@ int ieee80211_check_combinations(struct
 	}
 
 	/* Always allow software iftypes */
-	if (local->hw.wiphy->software_iftypes & BIT(iftype)) {
+	if (local->hw.wiphy->software_iftypes & BIT(iftype) ||
+	    (iftype == NL80211_IFTYPE_AP_VLAN &&
+	     local->hw.wiphy->flags & WIPHY_FLAG_4ADDR_AP)) {
 		if (radar_detect)
 			return -EINVAL;
 		return 0;
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1396,8 +1396,12 @@ static int cfg80211_netdev_notifier_call
 		}
 		break;
 	case NETDEV_PRE_UP:
-		if (!(wdev->wiphy->interface_modes & BIT(wdev->iftype)))
+		if (!(wdev->wiphy->interface_modes & BIT(wdev->iftype)) &&
+		    !(wdev->iftype == NL80211_IFTYPE_AP_VLAN &&
+		      rdev->wiphy.flags & WIPHY_FLAG_4ADDR_AP &&
+		      wdev->use_4addr))
 			return notifier_from_errno(-EOPNOTSUPP);
+
 		if (rfkill_blocked(rdev->rfkill))
 			return notifier_from_errno(-ERFKILL);
 		break;
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3385,8 +3385,7 @@ static int nl80211_new_interface(struct
 	if (info->attrs[NL80211_ATTR_IFTYPE])
 		type = nla_get_u32(info->attrs[NL80211_ATTR_IFTYPE]);
 
-	if (!rdev->ops->add_virtual_intf ||
-	    !(rdev->wiphy.interface_modes & (1 << type)))
+	if (!rdev->ops->add_virtual_intf)
 		return -EOPNOTSUPP;
 
 	if ((type == NL80211_IFTYPE_P2P_DEVICE || type == NL80211_IFTYPE_NAN ||
@@ -3405,6 +3404,11 @@ static int nl80211_new_interface(struct
 			return err;
 	}
 
+	if (!(rdev->wiphy.interface_modes & (1 << type)) &&
+	    !(type == NL80211_IFTYPE_AP_VLAN && params.use_4addr &&
+	      rdev->wiphy.flags & WIPHY_FLAG_4ADDR_AP))
+		return -EOPNOTSUPP;
+
 	err = nl80211_parse_mon_options(rdev, type, info, &params);
 	if (err < 0)
 		return err;



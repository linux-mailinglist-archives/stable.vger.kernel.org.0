Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67A4441716
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbhKAJc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:32:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232952AbhKAJa2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:30:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3EFD61179;
        Mon,  1 Nov 2021 09:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758644;
        bh=J6Ul1GG2oFWylQa5cKyso2gWWBiwTYvIvAB8/b66bRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uUxU9dyF2KblsiPJAZiB828SWKamlfQUv9/53kqHs3w6z9ZeCYkAtsLrB8lQqub3V
         zKXvf9xjNyRTjskhS3o61FHQ8xPdR7+qyDPufbjgADBku4x2JiFbEu1wyrVdVe0L1K
         pBTYqkKcgoYRZ8SGpSB7JVG5TYy0p5CJSbv7ovu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Janusz Dziedzic <janusz.dziedzic@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 48/51] cfg80211: correct bridge/4addr mode check
Date:   Mon,  1 Nov 2021 10:17:52 +0100
Message-Id: <20211101082511.714058673@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082500.203657870@linuxfoundation.org>
References: <20211101082500.203657870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janusz Dziedzic <janusz.dziedzic@gmail.com>

[ Upstream commit 689a0a9f505f7bffdefe6f17fddb41c8ab6344f6 ]

Without the patch we fail:

$ sudo brctl addbr br0
$ sudo brctl addif br0 wlp1s0
$ sudo iw wlp1s0 set 4addr on
command failed: Device or resource busy (-16)

Last command failed but iface was already in 4addr mode.

Fixes: ad4bb6f8883a ("cfg80211: disallow bridging managed/adhoc interfaces")
Signed-off-by: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Link: https://lore.kernel.org/r/20211024201546.614379-1-janusz.dziedzic@gmail.com
[add fixes tag, fix indentation, edit commit log]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 82b3baed2c7d..aaefaf3422a1 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -975,14 +975,14 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 	    !(rdev->wiphy.interface_modes & (1 << ntype)))
 		return -EOPNOTSUPP;
 
-	/* if it's part of a bridge, reject changing type to station/ibss */
-	if (netif_is_bridge_port(dev) &&
-	    (ntype == NL80211_IFTYPE_ADHOC ||
-	     ntype == NL80211_IFTYPE_STATION ||
-	     ntype == NL80211_IFTYPE_P2P_CLIENT))
-		return -EBUSY;
-
 	if (ntype != otype) {
+		/* if it's part of a bridge, reject changing type to station/ibss */
+		if (netif_is_bridge_port(dev) &&
+		    (ntype == NL80211_IFTYPE_ADHOC ||
+		     ntype == NL80211_IFTYPE_STATION ||
+		     ntype == NL80211_IFTYPE_P2P_CLIENT))
+			return -EBUSY;
+
 		dev->ieee80211_ptr->use_4addr = false;
 		dev->ieee80211_ptr->mesh_id_up_len = 0;
 		wdev_lock(dev->ieee80211_ptr);
-- 
2.33.0




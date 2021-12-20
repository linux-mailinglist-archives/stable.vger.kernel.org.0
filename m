Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD22B47AF3A
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239774AbhLTPKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239653AbhLTPJZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:09:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225C1C061748;
        Mon, 20 Dec 2021 06:55:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF70CB80EDA;
        Mon, 20 Dec 2021 14:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B944C36AE8;
        Mon, 20 Dec 2021 14:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012100;
        bh=VsQSCW+ae1gJl901lq84cY5dYQysOf4QCLxosYfImTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NM8pFzyduFjiEKBrtvC/K4SwLDuTKI/h+XSrP4u2lltuIH9QyUJl0SF8UqbQwgqsx
         gUhHxxtja3vSIx4iS6g46gKHqoc/dSTDCZvKslmbmZZ1xOgKK0qq5tmQ0EXE5rLU4u
         9MmMy2G8BByxAsC638PS35HdMi8GO6s8nL1y9uB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/177] cfg80211: Acquire wiphy mutex on regulatory work
Date:   Mon, 20 Dec 2021 15:33:51 +0100
Message-Id: <20211220143042.828981980@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit e08ebd6d7b90ae81f21425ca39136f5b2272580f ]

The function cfg80211_reg_can_beacon_relax() expects wiphy
mutex to be held when it is being called. However, when
reg_leave_invalid_chans() is called the mutex is not held.
Fix it by acquiring the lock before calling the function.

Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211202152831.527686cda037.I40ad9372a47cbad53b4aae7b5a6ccc0dc3fddf8b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index df87c7f3a0492..795e86b371bba 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2338,6 +2338,7 @@ static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
 	struct cfg80211_chan_def chandef = {};
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	enum nl80211_iftype iftype;
+	bool ret;
 
 	wdev_lock(wdev);
 	iftype = wdev->iftype;
@@ -2387,7 +2388,11 @@ static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_ADHOC:
-		return cfg80211_reg_can_beacon_relax(wiphy, &chandef, iftype);
+		wiphy_lock(wiphy);
+		ret = cfg80211_reg_can_beacon_relax(wiphy, &chandef, iftype);
+		wiphy_unlock(wiphy);
+
+		return ret;
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
 		return cfg80211_chandef_usable(wiphy, &chandef,
-- 
2.33.0




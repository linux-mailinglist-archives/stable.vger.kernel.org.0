Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C99E2EDF9
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730621AbfE3DnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:43:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:32896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732431AbfE3DVE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:21:04 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04C0F2498A;
        Thu, 30 May 2019 03:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186464;
        bh=w1LT5UR517Rs7CnOJOe8ZIHRcIeX0It/g1UAjUzlAEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W8LMLaryPs4xpesTKkOehH9gLQfJG7Jati0JUhWqchY8+Nxb14/EHnbyzxYpaLbPI
         G2/ZHMZc1PSNxgtVX0R1lHddJQNAffGXN9wqljAwiL7f2Ox64sdKdok6Fcc+QJMXk2
         dGtU9OhymoO/lvNG2fAfWAXBeVWC2ykezvxZzcLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 041/128] mac80211/cfg80211: update bss channel on channel switch
Date:   Wed, 29 May 2019 20:06:13 -0700
Message-Id: <20190530030441.620213016@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5dc8cdce1d722c733f8c7af14c5fb595cfedbfa8 ]

FullMAC STAs have no way to update bss channel after CSA channel switch
completion. As a result, user-space tools may provide inconsistent
channel info. For instance, consider the following two commands:
$ sudo iw dev wlan0 link
$ sudo iw dev wlan0 info
The latter command gets channel info from the hardware, so most probably
its output will be correct. However the former command gets channel info
from scan cache, so its output will contain outdated channel info.
In fact, current bss channel info will not be updated until the
next [re-]connect.

Note that mac80211 STAs have a workaround for this, but it requires
access to internal cfg80211 data, see ieee80211_chswitch_work:

	/* XXX: shouldn't really modify cfg80211-owned data! */
	ifmgd->associated->channel = sdata->csa_chandef.chan;

This patch suggests to convert mac80211 workaround into cfg80211 behavior
and to update current bss channel in cfg80211_ch_switch_notify.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c    | 3 ---
 net/wireless/nl80211.c | 5 +++++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6e0aa296f1346..d787717140e54 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1072,9 +1072,6 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 		goto out;
 	}
 
-	/* XXX: shouldn't really modify cfg80211-owned data! */
-	ifmgd->associated->channel = sdata->csa_chandef.chan;
-
 	ifmgd->csa_waiting_bcn = true;
 
 	ieee80211_sta_reset_beacon_monitor(sdata);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 09a353c6373a8..d6e6293157717 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14014,6 +14014,11 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 
 	wdev->chandef = *chandef;
 	wdev->preset_chandef = *chandef;
+
+	if (wdev->iftype == NL80211_IFTYPE_STATION &&
+	    !WARN_ON(!wdev->current_bss))
+		wdev->current_bss->pub.channel = chandef->chan;
+
 	nl80211_ch_switch_notify(rdev, dev, chandef, GFP_KERNEL,
 				 NL80211_CMD_CH_SWITCH_NOTIFY, 0);
 }
-- 
2.20.1




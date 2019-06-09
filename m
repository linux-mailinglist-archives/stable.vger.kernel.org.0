Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEAD3A866
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387810AbfFIRAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:00:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387800AbfFIRAL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:00:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5E5E206DF;
        Sun,  9 Jun 2019 17:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099611;
        bh=nrluRFfQlDoWn/PKM1DEjQNwKaGZNGPzpG2hx5AfHS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iq0GNAAumbucaNOW0Ey5IpRVoecPSvRSAgHj7x1LcTWJkjQ7Eo3qM91EOPJAGiqo4
         qB8OPMLbNKWn4FAiMXc9/jbQZyXdgTWVZRncuVxn+XmMh1c/CzUevTbKCJjswQXQEo
         EsLwhQw6VoSt0DypSqDz0c7oyjzy64clZ3pLiiKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 103/241] mac80211/cfg80211: update bss channel on channel switch
Date:   Sun,  9 Jun 2019 18:40:45 +0200
Message-Id: <20190609164150.766783285@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
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
index ed4fef32b394f..08384dbf426c8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1104,9 +1104,6 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 		goto out;
 	}
 
-	/* XXX: shouldn't really modify cfg80211-owned data! */
-	ifmgd->associated->channel = sdata->csa_chandef.chan;
-
 	ifmgd->csa_waiting_bcn = true;
 
 	ieee80211_sta_reset_beacon_monitor(sdata);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 81013490a99f4..1968998e6c6c2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12788,6 +12788,11 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 
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




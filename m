Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51777D9DBC
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 23:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436826AbfJPVwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:52:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729703AbfJPVwv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:52:51 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C46B320872;
        Wed, 16 Oct 2019 21:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262770;
        bh=b9tJJIYUCqo6di2o1/Abyy0VUXK9ssE4EWroc7sMp/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/nQTMEUrzzSgpfKF9U84z4Ayi9cZzby4BU7koQR7jN4iF5sCQJctkym6h3IqdDxz
         J5YxSc3u1gAkr+JhZa3zHuw5aMhCIv29kU9OxeLJ5viTlgQ1JGjjpzloUxd6/QsfS8
         T2j3IoZVLOhkDkptRCugaMF6cX4n+gWL5QucXgLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.4 11/79] cfg80211: initialize on-stack chandefs
Date:   Wed, 16 Oct 2019 14:49:46 -0700
Message-Id: <20191016214740.295829525@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit f43e5210c739fe76a4b0ed851559d6902f20ceb1 upstream.

In a few places we don't properly initialize on-stack chandefs,
resulting in EDMG data to be non-zero, which broke things.

Additionally, in a few places we rely on the driver to init the
data completely, but perhaps we shouldn't as non-EDMG drivers
may not initialize the EDMG data, also initialize it there.

Cc: stable@vger.kernel.org
Fixes: 2a38075cd0be ("nl80211: Add support for EDMG channels")
Reported-by: Dmitry Osipenko <digetx@gmail.com>
Tested-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/1569239475-I2dcce394ecf873376c386a78f31c2ec8b538fa25@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/nl80211.c     |    4 +++-
 net/wireless/reg.c         |    2 +-
 net/wireless/wext-compat.c |    2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1934,6 +1934,8 @@ static int nl80211_parse_chandef(struct
 
 	control_freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
 
+	memset(chandef, 0, sizeof(*chandef));
+
 	chandef->chan = ieee80211_get_channel(&rdev->wiphy, control_freq);
 	chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
 	chandef->center_freq1 = control_freq;
@@ -2402,7 +2404,7 @@ static int nl80211_send_iface(struct sk_
 
 	if (rdev->ops->get_channel) {
 		int ret;
-		struct cfg80211_chan_def chandef;
+		struct cfg80211_chan_def chandef = {};
 
 		ret = rdev_get_channel(rdev, wdev, &chandef);
 		if (ret == 0) {
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1604,7 +1604,7 @@ static void reg_call_notifier(struct wip
 
 static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
 {
-	struct cfg80211_chan_def chandef;
+	struct cfg80211_chan_def chandef = {};
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	enum nl80211_iftype iftype;
 
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -821,7 +821,7 @@ static int cfg80211_wext_giwfreq(struct
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
-	struct cfg80211_chan_def chandef;
+	struct cfg80211_chan_def chandef = {};
 	int ret;
 
 	switch (wdev->iftype) {



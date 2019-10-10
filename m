Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0C9D2486
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389269AbfJJIqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:46:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388607AbfJJIqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:46:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FD0D208C3;
        Thu, 10 Oct 2019 08:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697176;
        bh=RTIc11CGm9X/mV7zFMEL6/hA6HxPC2WTf9CV8RTmhds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D4g9rTklqZbpE1n3Gf88sbUmb7upwqghYM7vQwmHmieoIG0FFTr9hETvTJO65YzoV
         VJr049sIBpRoNoDSWTb+9JyKuVn/SEBkztinkkin9Hbm1YVaQfYMAJSPufeo2UAN2f
         P/QeJrg+WOoPhFnN8JnXWllc21YhsTVy+6x8d6R0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 047/114] cfg80211: initialize on-stack chandefs
Date:   Thu, 10 Oct 2019 10:35:54 +0200
Message-Id: <20191010083607.849752336@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
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
@@ -2299,6 +2299,8 @@ static int nl80211_parse_chandef(struct
 
 	control_freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
 
+	memset(chandef, 0, sizeof(*chandef));
+
 	chandef->chan = ieee80211_get_channel(&rdev->wiphy, control_freq);
 	chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
 	chandef->center_freq1 = control_freq;
@@ -2819,7 +2821,7 @@ static int nl80211_send_iface(struct sk_
 
 	if (rdev->ops->get_channel) {
 		int ret;
-		struct cfg80211_chan_def chandef;
+		struct cfg80211_chan_def chandef = {};
 
 		ret = rdev_get_channel(rdev, wdev, &chandef);
 		if (ret == 0) {
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2095,7 +2095,7 @@ static void reg_call_notifier(struct wip
 
 static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
 {
-	struct cfg80211_chan_def chandef;
+	struct cfg80211_chan_def chandef = {};
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	enum nl80211_iftype iftype;
 
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -800,7 +800,7 @@ static int cfg80211_wext_giwfreq(struct
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
-	struct cfg80211_chan_def chandef;
+	struct cfg80211_chan_def chandef = {};
 	int ret;
 
 	switch (wdev->iftype) {



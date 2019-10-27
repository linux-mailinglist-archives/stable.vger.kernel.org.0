Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C322E684F
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732199AbfJ0VWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:22:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732193AbfJ0VWi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:22:38 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DCDE205C9;
        Sun, 27 Oct 2019 21:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211357;
        bh=G8fdBiczYjP1dj+XAo4W0fgeejN6M3is5d/XqM9NW8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CeHKb/OsBAzZwnGM8B9m2eYMcMVVSlxlkPJ7PJhfntqiAPjwv7ag65XlvNmC0oxCW
         A7knKxx+GRFFarPIQzmjkuwXDnsKcvcc93W3M8VlNK+mHhuIifZQNpSjZuCl2QM0yC
         Itt9SRnxMGmAmEsNF4Q95BTAgx8BscnnMSNFiatA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Nicolas Waisman <nico@semmle.com>,
        Will Deacon <will@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.3 122/197] cfg80211: wext: avoid copying malformed SSIDs
Date:   Sun, 27 Oct 2019 22:00:40 +0100
Message-Id: <20191027203358.324038638@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit 4ac2813cc867ae563a1ba5a9414bfb554e5796fa upstream.

Ensure the SSID element is bounds-checked prior to invoking memcpy()
with its length field, when copying to userspace.

Cc: <stable@vger.kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Reported-by: Nicolas Waisman <nico@semmle.com>
Signed-off-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20191004095132.15777-2-will@kernel.org
[adjust commit log a bit]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/wext-sme.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -202,6 +202,7 @@ int cfg80211_mgd_wext_giwessid(struct ne
 			       struct iw_point *data, char *ssid)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int ret = 0;
 
 	/* call only for station! */
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
@@ -219,7 +220,10 @@ int cfg80211_mgd_wext_giwessid(struct ne
 		if (ie) {
 			data->flags = 1;
 			data->length = ie[1];
-			memcpy(ssid, ie + 2, data->length);
+			if (data->length > IW_ESSID_MAX_SIZE)
+				ret = -EINVAL;
+			else
+				memcpy(ssid, ie + 2, data->length);
 		}
 		rcu_read_unlock();
 	} else if (wdev->wext.connect.ssid && wdev->wext.connect.ssid_len) {
@@ -229,7 +233,7 @@ int cfg80211_mgd_wext_giwessid(struct ne
 	}
 	wdev_unlock(wdev);
 
-	return 0;
+	return ret;
 }
 
 int cfg80211_mgd_wext_siwap(struct net_device *dev,



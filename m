Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B61BCB7A8
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 11:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387908AbfJDJvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 05:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387827AbfJDJvr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 05:51:47 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FE1521D81;
        Fri,  4 Oct 2019 09:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570182706;
        bh=vE/jWS60KzqcNNmlodqOlV9AdeCoY1+tE4ZQVtKNzf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yp1IkKEedfiRjZZ63iNqBeC6Z87eN81/lCy5T3vvESbPi7xVobOhKbjycm6ERQxz0
         QUYsnIU7brsaSZlEjRkmUA6TYnSEA7r1AsbFBC66inUqcCJ4n+AmrNttuCWxciClE8
         l5gNqRGxEmMXt/EUqpQ+8yexFhLQfOC0Km9FJg8I=
From:   Will Deacon <will@kernel.org>
To:     linux-wireless@vger.kernel.org
Cc:     nico@semmle.com, Will Deacon <will@kernel.org>,
        stable@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 2/2] cfg80211: wext: Reject malformed SSID elements
Date:   Fri,  4 Oct 2019 10:51:32 +0100
Message-Id: <20191004095132.15777-2-will@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191004095132.15777-1-will@kernel.org>
References: <20191004095132.15777-1-will@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ensure the SSID element is bounds-checked prior to invoking memcpy()
with its length field.

Cc: <stable@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Kees Cook <keescook@chromium.org>
Reported-by: Nicolas Waisman <nico@semmle.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 net/wireless/wext-sme.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index c67d7a82ab13..3fd2cc7fc36a 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -201,6 +201,7 @@ int cfg80211_mgd_wext_giwessid(struct net_device *dev,
 			       struct iw_request_info *info,
 			       struct iw_point *data, char *ssid)
 {
+	int ret = 0;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
 	/* call only for station! */
@@ -219,7 +220,10 @@ int cfg80211_mgd_wext_giwessid(struct net_device *dev,
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
@@ -229,7 +233,7 @@ int cfg80211_mgd_wext_giwessid(struct net_device *dev,
 	}
 	wdev_unlock(wdev);
 
-	return 0;
+	return ret;
 }
 
 int cfg80211_mgd_wext_siwap(struct net_device *dev,
-- 
2.23.0.581.g78d2f28ef7-goog


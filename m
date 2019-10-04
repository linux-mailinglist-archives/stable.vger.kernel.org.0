Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C69C3CB7A5
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 11:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730414AbfJDJvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 05:51:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729926AbfJDJvn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 05:51:43 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0A87215EA;
        Fri,  4 Oct 2019 09:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570182703;
        bh=0re6AKO8Nc8k5tIwNz8ZINJVebWLGCavvr4ONGuuIfc=;
        h=From:To:Cc:Subject:Date:From;
        b=PdUjTgqUCvXjD0PFis/MkQQktVOfmvwYd40fMFznU9disYGV/2RZARSTCycgRQbRH
         6FNEeHqL0YDQQzd7YNNIWp+n3HG+wwqrulqTttlFFCNh3+W3bhqsD5vl98LB3O7LvH
         uJr5Oyj+g1KIScKopjyCTJVWnpGxYsQqq7xhTw7w=
From:   Will Deacon <will@kernel.org>
To:     linux-wireless@vger.kernel.org
Cc:     nico@semmle.com, Will Deacon <will@kernel.org>,
        stable@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 1/2] mac80211: Reject malformed SSID elements
Date:   Fri,  4 Oct 2019 10:51:31 +0100
Message-Id: <20191004095132.15777-1-will@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Although this shouldn't occur in practice, it's a good idea to bounds
check the length field of the SSID element prior to using it for things
like allocations or memcpy operations.

Cc: <stable@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Kees Cook <keescook@chromium.org>
Reported-by: Nicolas Waisman <nico@semmle.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 net/mac80211/mlme.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 26a2f49208b6..54dd8849d1cc 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2633,7 +2633,8 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
 
 	rcu_read_lock();
 	ssid = ieee80211_bss_get_ie(cbss, WLAN_EID_SSID);
-	if (WARN_ON_ONCE(ssid == NULL))
+	if (WARN_ONCE(!ssid || ssid[1] > IEEE80211_MAX_SSID_LEN,
+		      "invalid SSID element (len=%d)", ssid ? ssid[1] : -1))
 		ssid_len = 0;
 	else
 		ssid_len = ssid[1];
@@ -5233,7 +5234,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 	rcu_read_lock();
 	ssidie = ieee80211_bss_get_ie(req->bss, WLAN_EID_SSID);
-	if (!ssidie) {
+	if (!ssidie || ssidie[1] > sizeof(assoc_data->ssid)) {
 		rcu_read_unlock();
 		kfree(assoc_data);
 		return -EINVAL;
-- 
2.23.0.581.g78d2f28ef7-goog


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B013FE6975
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbfJ0VGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:06:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727702AbfJ0VGj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:06:39 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E1042064A;
        Sun, 27 Oct 2019 21:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210398;
        bh=uw4FsbykKvY5mRQRdXpS59+P12ELhRHDs100pawlrWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nmsddOP73VcrHXoc6fCyzitqY25qczk0kODTP7XGTAvWCSN6OrtQLMGsxKDgZcbeU
         bRev7u0V8l0WPPGD9nJUU9ZAZ2Xktv5ZTjTV7xPtjzThhpGRIc/1kXoq8rKD8wYwz7
         Aew2S0H4Rgdv6Qq3jjaWjaaH8u4FhakEfnWwRxBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Nicolas Waisman <nico@semmle.com>,
        Will Deacon <will@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.9 36/49] mac80211: Reject malformed SSID elements
Date:   Sun, 27 Oct 2019 22:01:14 +0100
Message-Id: <20191027203152.366352267@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203119.468466356@linuxfoundation.org>
References: <20191027203119.468466356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit 4152561f5da3fca92af7179dd538ea89e248f9d0 upstream.

Although this shouldn't occur in practice, it's a good idea to bounds
check the length field of the SSID element prior to using it for things
like allocations or memcpy operations.

Cc: <stable@vger.kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Reported-by: Nicolas Waisman <nico@semmle.com>
Signed-off-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20191004095132.15777-1-will@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mlme.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2434,7 +2434,8 @@ struct sk_buff *ieee80211_ap_probereq_ge
 
 	rcu_read_lock();
 	ssid = ieee80211_bss_get_ie(cbss, WLAN_EID_SSID);
-	if (WARN_ON_ONCE(ssid == NULL))
+	if (WARN_ONCE(!ssid || ssid[1] > IEEE80211_MAX_SSID_LEN,
+		      "invalid SSID element (len=%d)", ssid ? ssid[1] : -1))
 		ssid_len = 0;
 	else
 		ssid_len = ssid[1];
@@ -4691,7 +4692,7 @@ int ieee80211_mgd_assoc(struct ieee80211
 
 	rcu_read_lock();
 	ssidie = ieee80211_bss_get_ie(req->bss, WLAN_EID_SSID);
-	if (!ssidie) {
+	if (!ssidie || ssidie[1] > sizeof(assoc_data->ssid)) {
 		rcu_read_unlock();
 		kfree(assoc_data);
 		return -EINVAL;



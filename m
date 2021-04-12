Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E5635BE37
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238855AbhDLI5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238989AbhDLIzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66B5C61278;
        Mon, 12 Apr 2021 08:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217665;
        bh=3AtG43HBjMs1mKGoAp3wayoP5T7WKn3GKllqvHnRJ5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ttmVFsWZ+8xQP73DxFqxR+Ucrhipq7mrqr3SJ3HVGsFzE9qbgM0bQHm7qTobE8nms
         +TWUQGPsb9mwATqOyR+y+XPTMOE6E1WFWkmPMMWcSgnGuxP+ySvwFMsW26/XvVYGoM
         soXiEP301wfXrA5eIYFgkb1Y44hQ/mKKu6/OTVQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 065/188] cfg80211: check S1G beacon compat element length
Date:   Mon, 12 Apr 2021 10:39:39 +0200
Message-Id: <20210412084015.817030388@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit b5ac0146492fc5c199de767e492be8a66471011a upstream.

We need to check the length of this element so that we don't
access data beyond its end. Fix that.

Fixes: 9eaffe5078ca ("cfg80211: convert S1G beacon to scan results")
Link: https://lore.kernel.org/r/20210408142826.f6f4525012de.I9fdeff0afdc683a6024e5ea49d2daa3cd2459d11@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/scan.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2351,14 +2351,16 @@ cfg80211_inform_single_bss_frame_data(st
 		return NULL;
 
 	if (ext) {
-		struct ieee80211_s1g_bcn_compat_ie *compat;
-		u8 *ie;
+		const struct ieee80211_s1g_bcn_compat_ie *compat;
+		const struct element *elem;
 
-		ie = (void *)cfg80211_find_ie(WLAN_EID_S1G_BCN_COMPAT,
-					      variable, ielen);
-		if (!ie)
+		elem = cfg80211_find_elem(WLAN_EID_S1G_BCN_COMPAT,
+					  variable, ielen);
+		if (!elem)
 			return NULL;
-		compat = (void *)(ie + 2);
+		if (elem->datalen < sizeof(*compat))
+			return NULL;
+		compat = (void *)elem->data;
 		bssid = ext->u.s1g_beacon.sa;
 		capability = le16_to_cpu(compat->compat_info);
 		beacon_int = le16_to_cpu(compat->beacon_int);



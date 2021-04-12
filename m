Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052EC35BFC3
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237762AbhDLJGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239382AbhDLJEH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:04:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6643461278;
        Mon, 12 Apr 2021 09:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218104;
        bh=9337pXTxxT7HOHBP5XBF6YzugR9v8TYQ46gxMeF+1mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m+N0knj1kaCPzg8kgMlDJ0MSmt2RW2ghmwrfCVIeDlDLeeqw9tF0fXeTp8ePCOB/s
         ZFfaCSvNJI2fPBuhNg7FkmRICM0jAAgsaG0n/x9vQTEMFGj5HuUPd3nyp3hqaHTEEL
         kn/5nr31ybDRmeiX2ia9QGhlEo+26KQL18Rtt/L0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.11 072/210] cfg80211: check S1G beacon compat element length
Date:   Mon, 12 Apr 2021 10:39:37 +0200
Message-Id: <20210412084018.418807636@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
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
@@ -2352,14 +2352,16 @@ cfg80211_inform_single_bss_frame_data(st
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



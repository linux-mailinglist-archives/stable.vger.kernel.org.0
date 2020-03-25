Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0106F19221B
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 09:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgCYIFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 04:05:42 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:41418 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgCYIFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 04:05:42 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jH12i-007dwW-GT; Wed, 25 Mar 2020 09:05:40 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org
Subject: [PATCH] nl80211: fix NL80211_ATTR_CHANNEL_WIDTH attribute type
Date:   Wed, 25 Mar 2020 09:05:32 +0100
Message-Id: <20200325090531.be124f0a11c7.Iedbf4e197a85471ebd729b186d5365c0343bf7a8@changeid>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

The new opmode notification used this attribute with a u8, when
it's documented as a u32 and indeed used in userspace as such,
it just happens to work on little-endian systems since userspace
isn't doing any strict size validation, and the u8 goes into the
lower byte. Fix this.

Cc: stable@vger.kernel.org
Fixes: 466b9936bf93 ("cfg80211: Add support to notify station's opmode change to userspace")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ec5d67794aab..f0af23c1634a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -16416,7 +16416,7 @@ void cfg80211_sta_opmode_change_notify(struct net_device *dev, const u8 *mac,
 		goto nla_put_failure;
 
 	if ((sta_opmode->changed & STA_OPMODE_MAX_BW_CHANGED) &&
-	    nla_put_u8(msg, NL80211_ATTR_CHANNEL_WIDTH, sta_opmode->bw))
+	    nla_put_u32(msg, NL80211_ATTR_CHANNEL_WIDTH, sta_opmode->bw))
 		goto nla_put_failure;
 
 	if ((sta_opmode->changed & STA_OPMODE_N_SS_CHANGED) &&
-- 
2.25.1


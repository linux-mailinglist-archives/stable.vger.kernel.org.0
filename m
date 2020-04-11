Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33B9C1A53F3
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 00:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgDKWki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 18:40:38 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:42994 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgDKWki (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Apr 2020 18:40:38 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jNOnk-00AVVu-Jx; Sun, 12 Apr 2020 00:40:36 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org
Subject: [PATCH] nl80211: fix NL80211_ATTR_FTM_RESPONDER policy
Date:   Sun, 12 Apr 2020 00:40:30 +0200
Message-Id: <20200412004029.9d0722bb56c8.Ie690bfcc4a1a61ff8d8ca7e475d59fcaa52fb2da@changeid>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

The nested policy here should be established using the
NLA_POLICY_NESTED() macro so the length is properly
filled in.

Cc: stable@vger.kernel.org
Fixes: 81e54d08d9d8 ("cfg80211: support FTM responder configuration/statistics")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5fa402144cda..692bcd35f809 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -644,10 +644,8 @@ const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_HE_CAPABILITY] = { .type = NLA_BINARY,
 					 .len = NL80211_HE_MAX_CAPABILITY_LEN },
 
-	[NL80211_ATTR_FTM_RESPONDER] = {
-		.type = NLA_NESTED,
-		.validation_data = nl80211_ftm_responder_policy,
-	},
+	[NL80211_ATTR_FTM_RESPONDER] =
+		NLA_POLICY_NESTED(nl80211_ftm_responder_policy),
 	[NL80211_ATTR_TIMEOUT] = NLA_POLICY_MIN(NLA_U32, 1),
 	[NL80211_ATTR_PEER_MEASUREMENTS] =
 		NLA_POLICY_NESTED(nl80211_pmsr_attr_policy),
-- 
2.25.1


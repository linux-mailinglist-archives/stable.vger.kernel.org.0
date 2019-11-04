Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39E8FEDB37
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 10:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfKDJFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 04:05:47 -0500
Received: from smail.rz.tu-ilmenau.de ([141.24.186.67]:34304 "EHLO
        smail.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbfKDJFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 04:05:47 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Nov 2019 04:05:46 EST
Received: from thunderstorm.prakinf.tu-ilmenau.de (thunderstorm.prakinf.tu-ilmenau.de [141.24.212.108])
        by smail.rz.tu-ilmenau.de (Postfix) with ESMTPA id 78C61580063;
        Mon,  4 Nov 2019 10:00:43 +0100 (CET)
From:   Markus Theil <markus.theil@tu-ilmenau.de>
To:     stable@vger.kernel.org
Cc:     johannes.berg@intel.com, Markus Theil <markus.theil@tu-ilmenau.de>
Subject: [PATCH] nl80211: fix validation of mesh path nexthop
Date:   Mon,  4 Nov 2019 10:00:16 +0100
Message-Id: <20191104090016.12723-1-markus.theil@tu-ilmenau.de>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 1fab1b89e2e8f01204a9c05a39fd0b6411a48593 upstream.

Mesh path nexthop should be a ethernet address, but current validation
checks against 4 byte integers.

Cc: stable@vger.kernel.org
Fixes: 2ec600d672e74 ("nl80211/cfg80211: support for mesh, sta dumping")
Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
---
 net/wireless/nl80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 105fdd8589d7..a9df1301436e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -259,7 +259,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_MNTR_FLAGS] = { /* NLA_NESTED can't be empty */ },
 	[NL80211_ATTR_MESH_ID] = { .type = NLA_BINARY,
 				   .len = IEEE80211_MAX_MESH_ID_LEN },
-	[NL80211_ATTR_MPATH_NEXT_HOP] = { .type = NLA_U32 },
+	[NL80211_ATTR_MPATH_NEXT_HOP] = { .type = NLA_BINARY,
+					  .len = ETH_ALEN },
 
 	[NL80211_ATTR_REG_ALPHA2] = { .type = NLA_STRING, .len = 2 },
 	[NL80211_ATTR_REG_RULES] = { .type = NLA_NESTED },
-- 
2.20.1


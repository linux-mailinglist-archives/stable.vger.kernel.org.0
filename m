Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF12E4FB7EB
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 11:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344650AbiDKJoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 05:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbiDKJoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 05:44:21 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F0C37A11;
        Mon, 11 Apr 2022 02:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=//CENzgbmsozcbwJyIoiHm22WQ8QVpiASXdzO6hbltU=; t=1649670128; x=1650879728; 
        b=H4fDPilRQCzW1wofc5LI7JSWDm7cerpDb2vAHVDr7rlgieN788w3ljTLVkSgMkxzFaAJXpcCO9B
        RfAmi1Oc70wzHY3ZmpHDrUSdkVFqozfqhMfuESeeMRBnsiaDRBKf17Rtsy/nx4Wm6k7u31usJS37O
        /wHPOdFNNsmHqT6TLrqnzovbQuAgPbYx/PugFfq69zOFMTREHgvwsZfmFZTBjqMzMeKmn3DI2BPyF
        GbqPM70AlPS5/QdzqVfhYy+tYnzobzt7npkfenBeqhcPqJS3K3uqmF2P68vMINVS1bt6w1Q8YSNC9
        iDnAvDm72fvgoiT12Ip9wxy3s2jUTtfTd6PA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ndqYf-008ED8-0g;
        Mon, 11 Apr 2022 11:42:05 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] nl80211: correctly check NL80211_ATTR_REG_ALPHA2 size
Date:   Mon, 11 Apr 2022 11:42:03 +0200
Message-Id: <20220411114201.fd4a31f06541.Ie7ff4be2cf348d8cc28ed0d626fc54becf7ea799@changeid>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

We need this to be at least two bytes, so we can access
alpha2[0] and alpha2[1]. It may be three in case some
userspace used NUL-termination since it was NLA_STRING
(and we also push it out with NUL-termination).

Cc: stable@vger.kernel.org
Reported-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ee1c2b6b6971..21e808fcb676 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -528,7 +528,8 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 				   .len = IEEE80211_MAX_MESH_ID_LEN },
 	[NL80211_ATTR_MPATH_NEXT_HOP] = NLA_POLICY_ETH_ADDR_COMPAT,
 
-	[NL80211_ATTR_REG_ALPHA2] = { .type = NLA_STRING, .len = 2 },
+	/* allow 3 for NUL-termination, we used to declare this NLA_STRING */
+	[NL80211_ATTR_REG_ALPHA2] = NLA_POLICY_RANGE(NLA_BINARY, 2, 3),
 	[NL80211_ATTR_REG_RULES] = { .type = NLA_NESTED },
 
 	[NL80211_ATTR_BSS_CTS_PROT] = { .type = NLA_U8 },
-- 
2.35.1


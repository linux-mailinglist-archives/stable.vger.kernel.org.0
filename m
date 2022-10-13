Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1485FE090
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbiJMSLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbiJMSLF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:11:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AF18F25F;
        Thu, 13 Oct 2022 11:08:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E5C76191F;
        Thu, 13 Oct 2022 17:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2B4C433C1;
        Thu, 13 Oct 2022 17:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683832;
        bh=DyhDNVe3IwYG+kcLRCqI3QWXxiGLavoZuoE/lOfGaeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ElG6bgkBq+N66JYrRsjw4n6SrIeJ3MZI0NT4SobUgBF2LGiPA2jquzLu7qQM2LK93
         15yznLCbE7aFgeq9aHEgqVHEdMSbLXtSCg54/8fEMBiTZuu30QkxsX+trOCbqrgrpX
         quM4cTjvsI92kM/9hkjBTvGpsFzBTs9m/NZ1mj5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?S=C3=B6nke=20Huster?= <shuster@seemoo.tu-darmstadt.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 50/54] wifi: cfg80211: update hidden BSSes to avoid WARN_ON
Date:   Thu, 13 Oct 2022 19:52:44 +0200
Message-Id: <20221013175148.544333834@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175147.337501757@linuxfoundation.org>
References: <20221013175147.337501757@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit c90b93b5b782891ebfda49d4e5da36632fefd5d1 upstream.

When updating beacon elements in a non-transmitted BSS,
also update the hidden sub-entries to the same beacon
elements, so that a future update through other paths
won't trigger a WARN_ON().

The warning is triggered because the beacon elements in
the hidden BSSes that are children of the BSS should
always be the same as in the parent.

Reported-by: Sönke Huster <shuster@seemoo.tu-darmstadt.de>
Tested-by: Sönke Huster <shuster@seemoo.tu-darmstadt.de>
Fixes: 0b8fb8235be8 ("cfg80211: Parsing of Multiple BSSID information in scanning")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/scan.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1602,6 +1602,23 @@ struct cfg80211_non_tx_bss {
 	u8 bssid_index;
 };
 
+static void cfg80211_update_hidden_bsses(struct cfg80211_internal_bss *known,
+					 const struct cfg80211_bss_ies *new_ies,
+					 const struct cfg80211_bss_ies *old_ies)
+{
+	struct cfg80211_internal_bss *bss;
+
+	/* Assign beacon IEs to all sub entries */
+	list_for_each_entry(bss, &known->hidden_list, hidden_list) {
+		const struct cfg80211_bss_ies *ies;
+
+		ies = rcu_access_pointer(bss->pub.beacon_ies);
+		WARN_ON(ies != old_ies);
+
+		rcu_assign_pointer(bss->pub.beacon_ies, new_ies);
+	}
+}
+
 static bool
 cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
 			  struct cfg80211_internal_bss *known,
@@ -1625,7 +1642,6 @@ cfg80211_update_known_bss(struct cfg8021
 			kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);
 	} else if (rcu_access_pointer(new->pub.beacon_ies)) {
 		const struct cfg80211_bss_ies *old;
-		struct cfg80211_internal_bss *bss;
 
 		if (known->pub.hidden_beacon_bss &&
 		    !list_empty(&known->hidden_list)) {
@@ -1653,16 +1669,7 @@ cfg80211_update_known_bss(struct cfg8021
 		if (old == rcu_access_pointer(known->pub.ies))
 			rcu_assign_pointer(known->pub.ies, new->pub.beacon_ies);
 
-		/* Assign beacon IEs to all sub entries */
-		list_for_each_entry(bss, &known->hidden_list, hidden_list) {
-			const struct cfg80211_bss_ies *ies;
-
-			ies = rcu_access_pointer(bss->pub.beacon_ies);
-			WARN_ON(ies != old);
-
-			rcu_assign_pointer(bss->pub.beacon_ies,
-					   new->pub.beacon_ies);
-		}
+		cfg80211_update_hidden_bsses(known, new->pub.beacon_ies, old);
 
 		if (old)
 			kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);
@@ -2309,6 +2316,8 @@ cfg80211_update_notlisted_nontrans(struc
 	} else {
 		old = rcu_access_pointer(nontrans_bss->beacon_ies);
 		rcu_assign_pointer(nontrans_bss->beacon_ies, new_ies);
+		cfg80211_update_hidden_bsses(bss_from_pub(nontrans_bss),
+					     new_ies, old);
 		rcu_assign_pointer(nontrans_bss->ies, new_ies);
 		if (old)
 			kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);



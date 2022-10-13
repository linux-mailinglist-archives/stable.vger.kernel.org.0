Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507405FE0BC
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiJMSPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232271AbiJMSOe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:14:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCBF170DF0;
        Thu, 13 Oct 2022 11:10:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5383EB820AD;
        Thu, 13 Oct 2022 18:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B547EC433D6;
        Thu, 13 Oct 2022 18:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665684113;
        bh=YcQbhCSPoD2UnDkliHAi/oE6U9WmvVTA8st+VYyO1o0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJh/MGzykUe+e46qb8pFPWngN3MsgCCNeynk0EX2OqNcKO23Tgu1p2CVFfPosG+h8
         DIYDyyGyab3Dv3EE5M9FlsIeRmOV7kU5r3DJgV4iWO3BiflVcKlbiBiMR47DNmLBh7
         x4VKOPEosJ742+eOzkpyjHgja38GrXpml6zmYRCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?S=C3=B6nke=20Huster?= <shuster@seemoo.tu-darmstadt.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.0 29/34] wifi: cfg80211: update hidden BSSes to avoid WARN_ON
Date:   Thu, 13 Oct 2022 19:53:07 +0200
Message-Id: <20221013175147.267608492@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
References: <20221013175146.507746257@linuxfoundation.org>
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
@@ -1607,6 +1607,23 @@ struct cfg80211_non_tx_bss {
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
@@ -1630,7 +1647,6 @@ cfg80211_update_known_bss(struct cfg8021
 			kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);
 	} else if (rcu_access_pointer(new->pub.beacon_ies)) {
 		const struct cfg80211_bss_ies *old;
-		struct cfg80211_internal_bss *bss;
 
 		if (known->pub.hidden_beacon_bss &&
 		    !list_empty(&known->hidden_list)) {
@@ -1658,16 +1674,7 @@ cfg80211_update_known_bss(struct cfg8021
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
@@ -2360,6 +2367,8 @@ cfg80211_update_notlisted_nontrans(struc
 	} else {
 		old = rcu_access_pointer(nontrans_bss->beacon_ies);
 		rcu_assign_pointer(nontrans_bss->beacon_ies, new_ies);
+		cfg80211_update_hidden_bsses(bss_from_pub(nontrans_bss),
+					     new_ies, old);
 		rcu_assign_pointer(nontrans_bss->ies, new_ies);
 		if (old)
 			kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);



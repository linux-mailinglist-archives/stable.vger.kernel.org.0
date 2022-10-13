Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF2E5FE02C
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbiJMSE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbiJMSEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:04:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AE0152C5F;
        Thu, 13 Oct 2022 11:04:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8604A61934;
        Thu, 13 Oct 2022 17:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADA4C4347C;
        Thu, 13 Oct 2022 17:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683817;
        bh=qCxuhtVhxTY8kPmJaS9od7H6ZZUGVyAUtY0+yTTrVYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+HCjjX81A0c6m/to48KwEgLdoBZyXooPCGFOtFtgCKloJlsn8d1xhusrUMmF14aQ
         z+C6zGbBHPej6/f7a/4MBCjIEYCpyDkR3S28NOdJGU1MI6ytKSCnFbPtwUkNLydE8Q
         zdumouUu+o/6aWg9pHhJUYJgdA5C4TninCpbqmuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?S=C3=B6nke=20Huster?= <shuster@seemoo.tu-darmstadt.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 46/54] wifi: cfg80211: fix BSS refcounting bugs
Date:   Thu, 13 Oct 2022 19:52:40 +0200
Message-Id: <20221013175148.454412010@linuxfoundation.org>
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

commit 0b7808818cb9df6680f98996b8e9a439fa7bcc2f upstream.

There are multiple refcounting bugs related to multi-BSSID:
 - In bss_ref_get(), if the BSS has a hidden_beacon_bss, then
   the bss pointer is overwritten before checking for the
   transmitted BSS, which is clearly wrong. Fix this by using
   the bss_from_pub() macro.

 - In cfg80211_bss_update() we copy the transmitted_bss pointer
   from tmp into new, but then if we release new, we'll unref
   it erroneously. We already set the pointer and ref it, but
   need to NULL it since it was copied from the tmp data.

 - In cfg80211_inform_single_bss_data(), if adding to the non-
   transmitted list fails, we unlink the BSS and yet still we
   return it, but this results in returning an entry without
   a reference. We shouldn't return it anyway if it was broken
   enough to not get added there.

This fixes CVE-2022-42720.

Reported-by: Sönke Huster <shuster@seemoo.tu-darmstadt.de>
Tested-by: Sönke Huster <shuster@seemoo.tu-darmstadt.de>
Fixes: a3584f56de1c ("cfg80211: Properly track transmitting and non-transmitting BSS")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/scan.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -143,18 +143,12 @@ static inline void bss_ref_get(struct cf
 	lockdep_assert_held(&rdev->bss_lock);
 
 	bss->refcount++;
-	if (bss->pub.hidden_beacon_bss) {
-		bss = container_of(bss->pub.hidden_beacon_bss,
-				   struct cfg80211_internal_bss,
-				   pub);
-		bss->refcount++;
-	}
-	if (bss->pub.transmitted_bss) {
-		bss = container_of(bss->pub.transmitted_bss,
-				   struct cfg80211_internal_bss,
-				   pub);
-		bss->refcount++;
-	}
+
+	if (bss->pub.hidden_beacon_bss)
+		bss_from_pub(bss->pub.hidden_beacon_bss)->refcount++;
+
+	if (bss->pub.transmitted_bss)
+		bss_from_pub(bss->pub.transmitted_bss)->refcount++;
 }
 
 static inline void bss_ref_put(struct cfg80211_registered_device *rdev,
@@ -1736,6 +1730,8 @@ cfg80211_bss_update(struct cfg80211_regi
 		new->refcount = 1;
 		INIT_LIST_HEAD(&new->hidden_list);
 		INIT_LIST_HEAD(&new->pub.nontrans_list);
+		/* we'll set this later if it was non-NULL */
+		new->pub.transmitted_bss = NULL;
 
 		if (rcu_access_pointer(tmp->pub.proberesp_ies)) {
 			hidden = rb_find_bss(rdev, tmp, BSS_CMP_HIDE_ZLEN);
@@ -1973,10 +1969,15 @@ cfg80211_inform_single_bss_data(struct w
 		spin_lock_bh(&rdev->bss_lock);
 		if (cfg80211_add_nontrans_list(non_tx_data->tx_bss,
 					       &res->pub)) {
-			if (__cfg80211_unlink_bss(rdev, res))
+			if (__cfg80211_unlink_bss(rdev, res)) {
 				rdev->bss_generation++;
+				res = NULL;
+			}
 		}
 		spin_unlock_bh(&rdev->bss_lock);
+
+		if (!res)
+			return NULL;
 	}
 
 	trace_cfg80211_return_bss(&res->pub);



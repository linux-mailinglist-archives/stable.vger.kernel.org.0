Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05BD53CF0F
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345401AbiFCRw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345680AbiFCRuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:50:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349CA580FF;
        Fri,  3 Jun 2022 10:46:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6805AB82419;
        Fri,  3 Jun 2022 17:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E0DC385A9;
        Fri,  3 Jun 2022 17:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278371;
        bh=6Ppkon/hC2eAj/T1dzUhBA7Eve7f37CkXZaPIG8Z9Sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ppz38QBJVFyVu4Wy/z/+k8prCoKerIqCiUJ9alXQVYNAEOLWl3mIq23kEAIEuW7PY
         N2d0gYBI+PNkG7EQLz43im5OzQfrnOA/2Gwh59RxcH18TAJRbFTXB9xSLYKzdIvdoD
         PjYM1qPU8mu4FB7tzerQYSnSmmKExA2WWMmjR1BA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 11/53] cfg80211: set custom regdomain after wiphy registration
Date:   Fri,  3 Jun 2022 19:42:56 +0200
Message-Id: <20220603173819.050098450@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173818.716010877@linuxfoundation.org>
References: <20220603173818.716010877@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

commit 1b7b3ac8ff3317cdcf07a1c413de9bdb68019c2b upstream.

We used to set regulatory info before the registration of
the device and then the regulatory info didn't get set, because
the device isn't registered so there isn't a device to set the
regulatory info for. So set the regulatory info after the device
registration.
Call reg_process_self_managed_hints() once again after the device
registration because it does nothing before it.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210618133832.c96eadcffe80.I86799c2c866b5610b4cf91115c21d8ceb525c5aa@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/core.c |    8 ++++----
 net/wireless/reg.c  |    1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -5,7 +5,7 @@
  * Copyright 2006-2010		Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright 2015-2017	Intel Deutschland GmbH
- * Copyright (C) 2018-2020 Intel Corporation
+ * Copyright (C) 2018-2021 Intel Corporation
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -918,9 +918,6 @@ int wiphy_register(struct wiphy *wiphy)
 		return res;
 	}
 
-	/* set up regulatory info */
-	wiphy_regulatory_register(wiphy);
-
 	list_add_rcu(&rdev->list, &cfg80211_rdev_list);
 	cfg80211_rdev_list_generation++;
 
@@ -931,6 +928,9 @@ int wiphy_register(struct wiphy *wiphy)
 	cfg80211_debugfs_rdev_add(rdev);
 	nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
 
+	/* set up regulatory info */
+	wiphy_regulatory_register(wiphy);
+
 	if (wiphy->regulatory_flags & REGULATORY_CUSTOM_REG) {
 		struct regulatory_request request;
 
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -4001,6 +4001,7 @@ void wiphy_regulatory_register(struct wi
 
 	wiphy_update_regulatory(wiphy, lr->initiator);
 	wiphy_all_share_dfs_chan_state(wiphy);
+	reg_process_self_managed_hints();
 }
 
 void wiphy_regulatory_deregister(struct wiphy *wiphy)



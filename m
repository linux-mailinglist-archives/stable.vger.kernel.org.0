Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337BB5365D7
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 18:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344731AbiE0QSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 12:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243257AbiE0QSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 12:18:33 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB4D8FD58
        for <stable@vger.kernel.org>; Fri, 27 May 2022 09:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=RY2sEtFu3ppxXoV9b8MCWjPocsvy846F55eTP5nID1Y=; t=1653668312; x=1654877912; 
        b=eoZ9FEbT63KW6Xv7JZZ92uyPDaKYOaPXXJX63X/hzgY+kEvo2MViOCi6FIcrVNKbR3jZFcbAkOm
        lLH/bePT28GCOaQnAxcAQ0HZsRWvEot4dM3Wd60CIRohk27uAQmEHinPr4JgsY+/iNFyap6qfHcPX
        ysMIyNQVYU+WXPAAMoGYTpopnzRd/UTKF4YPCv9cniC5V8IiKQ6AdfZNQHt6Y97QjoI9nCe0eWAUi
        f6B/pJOFuA6fdQ6L16rglS1yWHaRWpv8N/qOJqHpUR3DGoi/A40DkAuuj39e1Pnyqq5RAiSfLczdF
        13dDajWoTNoo5YE35y/uhALDVzSKYrCqoFgg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nucfV-0066Mn-IM;
        Fri, 27 May 2022 18:18:29 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     stable@vger.kernel.org
Cc:     Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 5.4] cfg80211: set custom regdomain after wiphy registration
Date:   Fri, 27 May 2022 18:18:26 +0200
Message-Id: <20220527161826.712499-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.36.1
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
---
 net/wireless/core.c | 8 ++++----
 net/wireless/reg.c  | 1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5d151e8f8932..f7228afd81eb 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -5,7 +5,7 @@
  * Copyright 2006-2010		Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright 2015-2017	Intel Deutschland GmbH
- * Copyright (C) 2018-2019 Intel Corporation
+ * Copyright (C) 2018-2021 Intel Corporation
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -891,9 +891,6 @@ int wiphy_register(struct wiphy *wiphy)
 		return res;
 	}
 
-	/* set up regulatory info */
-	wiphy_regulatory_register(wiphy);
-
 	list_add_rcu(&rdev->list, &cfg80211_rdev_list);
 	cfg80211_rdev_list_generation++;
 
@@ -904,6 +901,9 @@ int wiphy_register(struct wiphy *wiphy)
 	cfg80211_debugfs_rdev_add(rdev);
 	nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
 
+	/* set up regulatory info */
+	wiphy_regulatory_register(wiphy);
+
 	if (wiphy->regulatory_flags & REGULATORY_CUSTOM_REG) {
 		struct regulatory_request request;
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 0f3b57a73670..74caece77963 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3790,6 +3790,7 @@ void wiphy_regulatory_register(struct wiphy *wiphy)
 
 	wiphy_update_regulatory(wiphy, lr->initiator);
 	wiphy_all_share_dfs_chan_state(wiphy);
+	reg_process_self_managed_hints();
 }
 
 void wiphy_regulatory_deregister(struct wiphy *wiphy)
-- 
2.36.1


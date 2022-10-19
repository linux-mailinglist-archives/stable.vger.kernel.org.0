Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A68603D1B
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbiJSI5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbiJSI4j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:56:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF1A175A2;
        Wed, 19 Oct 2022 01:52:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0730D617D4;
        Wed, 19 Oct 2022 08:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C30FC433D6;
        Wed, 19 Oct 2022 08:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169344;
        bh=CDZp1MYri+orB59jg/D8jxZWD0sMczQ9N3voVKdnd0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pwCHRqCqLLKX9lumbpz42T63VWdx7ULwU1xp0HNjhAXZ49lozdhktu9Sascii5Id7
         lF36GbWebhYwxs2jqCFGfdLWTe2M5ZrYlcW6QqtTyWjcMW2jI4Noc4OboFfrbQTF5v
         yqGs+YXSGT0+l7H/WHkM36tOoo/tDsvREwSWBWac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 242/862] wifi: mac80211_hwsim: fix link change handling
Date:   Wed, 19 Oct 2022 10:25:29 +0200
Message-Id: <20221019083300.705612740@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 65f7052b6c38f767d95ebfa4ae4b389b6da6a421 ]

The code for determining which links to update in wmediumd
or virtio was wrong, fix it to remove the deflink only if
there were no old links, and also add the deflink if there
are no other new links.

Fixes: c204d9df0202 ("wifi: mac80211_hwsim: handle links for wmediumd/virtio")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ee34814bd12b..a074552bcec3 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2995,10 +2995,15 @@ static int mac80211_hwsim_change_vif_links(struct ieee80211_hw *hw,
 					   u16 old_links, u16 new_links,
 					   struct ieee80211_bss_conf *old[IEEE80211_MLD_MAX_NUM_LINKS])
 {
-	unsigned long rem = old_links & ~new_links ?: BIT(0);
+	unsigned long rem = old_links & ~new_links;
 	unsigned long add = new_links & ~old_links;
 	int i;
 
+	if (!old_links)
+		rem |= BIT(0);
+	if (!new_links)
+		add |= BIT(0);
+
 	for_each_set_bit(i, &rem, IEEE80211_MLD_MAX_NUM_LINKS)
 		mac80211_hwsim_config_mac_nl(hw, old[i]->addr, false);
 
-- 
2.35.1




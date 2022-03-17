Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15F44DC642
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbiCQMuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233973AbiCQMuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:50:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2661F378A;
        Thu, 17 Mar 2022 05:48:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67EF1B81EA0;
        Thu, 17 Mar 2022 12:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23DBC340E9;
        Thu, 17 Mar 2022 12:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521302;
        bh=tnE90IB6LR3XgPsa47TXjDRPFMPyJOgNoQJRfk99q+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H6getQpsmSg5TjfsnugcwSSyfy+kxfOGeZ532uz7SYe4RBhYxhzAuuZIRO3fHhCyZ
         IeSJh+j4R8VKn8ZC907RKbmRm3qjb+LuOjpLGpqOv4/Py15dz86Wl7XFb3VuvNyiAA
         zObZ3bkJECyFX5TW4AYg3OLEeFXES8aKdYM3ehiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 37/43] iwlwifi: dont advertise TWT support
Date:   Thu, 17 Mar 2022 13:45:48 +0100
Message-Id: <20220317124528.699827415@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317124527.672236844@linuxfoundation.org>
References: <20220317124527.672236844@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Golan Ben Ami <golan.ben.ami@intel.com>

[ Upstream commit 1db5fcbba2631277b78d7f8aff99c9607d29f6d8 ]

Some APs misbehave when TWT is used and cause our firmware to crash.
We don't know a reasonable way to detect and work around this problem
in the FW yet.  To prevent these crashes, disable TWT in the driver by
stopping to advertise TWT support.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215523
Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
[reworded the commit message]
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/20220301072926.153969-1-luca@coelho.fi
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 3 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 022f2faccab4..4a433e34ee7a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -519,8 +519,7 @@ static struct ieee80211_sband_iftype_data iwl_he_capa[] = {
 			.has_he = true,
 			.he_cap_elem = {
 				.mac_cap_info[0] =
-					IEEE80211_HE_MAC_CAP0_HTC_HE |
-					IEEE80211_HE_MAC_CAP0_TWT_REQ,
+					IEEE80211_HE_MAC_CAP0_HTC_HE,
 				.mac_cap_info[1] =
 					IEEE80211_HE_MAC_CAP1_TF_MAC_PAD_DUR_16US |
 					IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_8,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 29ad7804d77a..3c523774ef0e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -343,7 +343,6 @@ const static u8 he_if_types_ext_capa_sta[] = {
 	 [0] = WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING,
 	 [2] = WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT,
 	 [7] = WLAN_EXT_CAPA8_OPMODE_NOTIF,
-	 [9] = WLAN_EXT_CAPA10_TWT_REQUESTER_SUPPORT,
 };
 
 const static struct wiphy_iftype_ext_capab he_iftypes_ext_capa[] = {
-- 
2.34.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8892C657BA4
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbiL1PXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233689AbiL1PXx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:23:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE2E12747
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:23:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 345886155C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE11C433F1;
        Wed, 28 Dec 2022 15:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241031;
        bh=gthM6um44mZb5EFyVhOGTV2i6JfL/mbGdjXhQvjqsw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSeFwiCel82zBqbjB+0cYdAzh+7JEtB0Z7M7vIDqIEW+KSizdkmnDd27tyFATkiJ6
         A2DImOGydVPbvhM2KWvyQ+PtIJHH70YQzOLJY5tu4QY80I8DT4WrpXIEG1U7YRSIxY
         vUvD+bmjp6C/dPezH9Ol3U2w8li2TzHWDSqRvjDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0197/1146] wifi: mac80211: check link ID in auth/assoc continuation
Date:   Wed, 28 Dec 2022 15:28:56 +0100
Message-Id: <20221228144335.497080119@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit 85176a3fcd9748558cff72d4cdff5465b8732282 ]

Ensure that the link ID matches in auth/assoc continuation,
otherwise we need to reset all the data.

Fixes: 81151ce462e5 ("wifi: mac80211: support MLO authentication/association with one link")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h | 1 +
 net/mac80211/mlme.c        | 7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a842f2e1c230..de7b8a4d4bbb 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -390,6 +390,7 @@ struct ieee80211_mgd_auth_data {
 	bool done, waiting;
 	bool peer_confirmed;
 	bool timeout_started;
+	int link_id;
 
 	u8 ap_addr[ETH_ALEN] __aligned(2);
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1fff44ddda8a..0125b3e6175b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6644,6 +6644,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	       req->ap_mld_addr ?: req->bss->bssid,
 	       ETH_ALEN);
 	auth_data->bss = req->bss;
+	auth_data->link_id = req->link_id;
 
 	if (req->auth_data_len >= 4) {
 		if (req->auth_type == NL80211_AUTHTYPE_SAE) {
@@ -6662,7 +6663,8 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	 * removal and re-addition of the STA entry in
 	 * ieee80211_prep_connection().
 	 */
-	cont_auth = ifmgd->auth_data && req->bss == ifmgd->auth_data->bss;
+	cont_auth = ifmgd->auth_data && req->bss == ifmgd->auth_data->bss &&
+		    ifmgd->auth_data->link_id == req->link_id;
 
 	if (req->ie && req->ie_len) {
 		memcpy(&auth_data->data[auth_data->data_len],
@@ -6986,7 +6988,8 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 		/* keep sta info, bssid if matching */
 		match = ether_addr_equal(ifmgd->auth_data->ap_addr,
-					 assoc_data->ap_addr);
+					 assoc_data->ap_addr) &&
+			ifmgd->auth_data->link_id == req->link_id;
 		ieee80211_destroy_auth_data(sdata, match);
 	}
 
-- 
2.35.1




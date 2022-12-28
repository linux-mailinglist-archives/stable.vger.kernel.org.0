Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F65E657B72
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbiL1PWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233621AbiL1PWI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:22:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE6D14011
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:21:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56075B8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95EAC433F0;
        Wed, 28 Dec 2022 15:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240898;
        bh=cYR+rggBgN0oq+5BjbIsTLxj1sZVNyGAmi+2zaO9R0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jobR/6g9ODI5uwto6dDHECfDljMspoGL8GXqFLaAwxjI8AZcv1A1DeAoT/ok0EeYU
         mcj1Fm8a8n3E9fbg5cJSrjHx32Mqov6FUHrK0IFlEAK+XKCyweuO8FfqrqQEExWqSU
         l7RHyus3Yf+T+k2PsCrrPK+ZRanB0p38pRTI7F0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0189/1073] wifi: mac80211: mlme: fix null-ptr deref on failed assoc
Date:   Wed, 28 Dec 2022 15:29:37 +0100
Message-Id: <20221228144333.144403443@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 78a6a43aaf87180ec7425a2a90468e1b4d09a1ec ]

If association to an AP without a link 0 fails, then we crash in
tracing because it assumes that either ap_mld_addr or link 0 BSS
is valid, since we clear sdata->vif.valid_links and then don't
add the ap_mld_addr to the struct.

Since we clear also sdata->vif.cfg.ap_addr, keep a local copy of
it and assign it earlier, before clearing valid_links, to fix
this.

Fixes: 81151ce462e5 ("wifi: mac80211: support MLO authentication/association with one link")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 654414caeb71..a21571eb02ec 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4955,6 +4955,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_rx_assoc_resp resp = {
 		.uapsd_queues = -1,
 	};
+	u8 ap_mld_addr[ETH_ALEN] __aligned(2);
 	unsigned int link_id;
 
 	sdata_assert_lock(sdata);
@@ -5119,6 +5120,11 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 				resp.uapsd_queues |= ieee80211_ac_to_qos_mask[ac];
 	}
 
+	if (sdata->vif.valid_links) {
+		ether_addr_copy(ap_mld_addr, sdata->vif.cfg.ap_addr);
+		resp.ap_mld_addr = ap_mld_addr;
+	}
+
 	ieee80211_destroy_assoc_data(sdata,
 				     status_code == WLAN_STATUS_SUCCESS ?
 					ASSOC_SUCCESS :
@@ -5128,8 +5134,6 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	resp.len = len;
 	resp.req_ies = ifmgd->assoc_req_ies;
 	resp.req_ies_len = ifmgd->assoc_req_ies_len;
-	if (sdata->vif.valid_links)
-		resp.ap_mld_addr = sdata->vif.cfg.ap_addr;
 	cfg80211_rx_assoc_resp(sdata->dev, &resp);
 notify_driver:
 	drv_mgd_complete_tx(sdata->local, sdata, &info);
-- 
2.35.1




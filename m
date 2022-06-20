Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6DBD551A55
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243484AbiFTNBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243488AbiFTNAS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817B81CFFC;
        Mon, 20 Jun 2022 05:57:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49641614EE;
        Mon, 20 Jun 2022 12:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D36C3411B;
        Mon, 20 Jun 2022 12:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729823;
        bh=DwDIzfNA74efO02ffba1vutT/7QIvyWeKb/pLH4Ju+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kW1VY3CU8BKaBvpk+68KloExB40FiRlnirhQGqkyuhBbLYJpYKx92nNcBulS8IVNJ
         C6BgzZr6GI4fWq7U1ZF0pE/p9TkjcmhQUqAgswlTFOniOn8f9sBb59Vwayzem/THNN
         VgHs/r2QoHfuBft5ryyxihsCnTIkhNHryRfm2Yts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Roman Storozhenko <roman.storozhenko@intel.com>,
        Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.18 077/141] ice: Sync VLAN filtering features for DVM
Date:   Mon, 20 Jun 2022 14:50:15 +0200
Message-Id: <20220620124731.813634220@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
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

From: Roman Storozhenko <roman.storozhenko@intel.com>

[ Upstream commit 9542ef4fba8c73e176b8aa18a8adf04aecb889e5 ]

VLAN filtering features, that is C-Tag and S-Tag, in DVM mode must be
both enabled or disabled.
In case of turning off/on only one of the features, another feature must
be turned off/on automatically with issuing an appropriate message to
the kernel log.

Fixes: 1babaf77f49d ("ice: Advertise 802.1ad VLAN filtering and offloads for PF netdev")
Signed-off-by: Roman Storozhenko <roman.storozhenko@intel.com>
Co-developed-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 49 ++++++++++++++---------
 1 file changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 963a5f40e071..d069b19f9bf7 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5746,25 +5746,38 @@ static netdev_features_t
 ice_fix_features(struct net_device *netdev, netdev_features_t features)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
-	netdev_features_t supported_vlan_filtering;
-	netdev_features_t requested_vlan_filtering;
-	struct ice_vsi *vsi = np->vsi;
-
-	requested_vlan_filtering = features & NETIF_VLAN_FILTERING_FEATURES;
-
-	/* make sure supported_vlan_filtering works for both SVM and DVM */
-	supported_vlan_filtering = NETIF_F_HW_VLAN_CTAG_FILTER;
-	if (ice_is_dvm_ena(&vsi->back->hw))
-		supported_vlan_filtering |= NETIF_F_HW_VLAN_STAG_FILTER;
-
-	if (requested_vlan_filtering &&
-	    requested_vlan_filtering != supported_vlan_filtering) {
-		if (requested_vlan_filtering & NETIF_F_HW_VLAN_CTAG_FILTER) {
-			netdev_warn(netdev, "cannot support requested VLAN filtering settings, enabling all supported VLAN filtering settings\n");
-			features |= supported_vlan_filtering;
+	netdev_features_t req_vlan_fltr, cur_vlan_fltr;
+	bool cur_ctag, cur_stag, req_ctag, req_stag;
+
+	cur_vlan_fltr = netdev->features & NETIF_VLAN_FILTERING_FEATURES;
+	cur_ctag = cur_vlan_fltr & NETIF_F_HW_VLAN_CTAG_FILTER;
+	cur_stag = cur_vlan_fltr & NETIF_F_HW_VLAN_STAG_FILTER;
+
+	req_vlan_fltr = features & NETIF_VLAN_FILTERING_FEATURES;
+	req_ctag = req_vlan_fltr & NETIF_F_HW_VLAN_CTAG_FILTER;
+	req_stag = req_vlan_fltr & NETIF_F_HW_VLAN_STAG_FILTER;
+
+	if (req_vlan_fltr != cur_vlan_fltr) {
+		if (ice_is_dvm_ena(&np->vsi->back->hw)) {
+			if (req_ctag && req_stag) {
+				features |= NETIF_VLAN_FILTERING_FEATURES;
+			} else if (!req_ctag && !req_stag) {
+				features &= ~NETIF_VLAN_FILTERING_FEATURES;
+			} else if ((!cur_ctag && req_ctag && !cur_stag) ||
+				   (!cur_stag && req_stag && !cur_ctag)) {
+				features |= NETIF_VLAN_FILTERING_FEATURES;
+				netdev_warn(netdev,  "802.1Q and 802.1ad VLAN filtering must be either both on or both off. VLAN filtering has been enabled for both types.\n");
+			} else if ((cur_ctag && !req_ctag && cur_stag) ||
+				   (cur_stag && !req_stag && cur_ctag)) {
+				features &= ~NETIF_VLAN_FILTERING_FEATURES;
+				netdev_warn(netdev,  "802.1Q and 802.1ad VLAN filtering must be either both on or both off. VLAN filtering has been disabled for both types.\n");
+			}
 		} else {
-			netdev_warn(netdev, "cannot support requested VLAN filtering settings, clearing all supported VLAN filtering settings\n");
-			features &= ~supported_vlan_filtering;
+			if (req_vlan_fltr & NETIF_F_HW_VLAN_STAG_FILTER)
+				netdev_warn(netdev, "cannot support requested 802.1ad filtering setting in SVM mode\n");
+
+			if (req_vlan_fltr & NETIF_F_HW_VLAN_CTAG_FILTER)
+				features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 		}
 	}
 
-- 
2.35.1




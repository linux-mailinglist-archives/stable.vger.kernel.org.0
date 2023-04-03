Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE95A6D4868
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbjDCO2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233363AbjDCO2Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:28:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F56A59D2
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:28:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE49161DBF
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29B9C433EF;
        Mon,  3 Apr 2023 14:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532102;
        bh=z8bIqu+tjn/drb5jNXVqkU7gfS8hovNTfUF4ll+5mIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/aYYGl2eipNt+yuTt9mxsblBd9Ym5raHoJZ/nLxu04ymTYKEjx7RyMknf6V3jKWy
         gfxXvXk22vMPNLPCS32Lb1xr7y/EMp4HwawoiRhyFOK6zMdgO/TIGpOrKsYy2nTLr/
         ybFML1gfZByRHfquyVdt4DczcC879KWGvFrbLm0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tianhao Zhao <tizhao@redhat.com>,
        Jonathan Cooper <jonathan.s.cooper@amd.com>,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 128/173] sfc: ef10: dont overwrite offload features at NIC reset
Date:   Mon,  3 Apr 2023 16:09:03 +0200
Message-Id: <20230403140418.591640030@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Íñigo Huguet <ihuguet@redhat.com>

[ Upstream commit ca4a80e4bb7e87daf33b27d2ab9e4f5311018a89 ]

At NIC reset, some offload features related to encapsulated traffic
might have changed (this mainly happens if the firmware-variant is
changed with the sfboot userspace tool). Because of this, features are
checked and set again at reset time.

However, this was not done right, and some features were improperly
overwritten at NIC reset:
- Tunneled IPv6 segmentation was always disabled
- Features disabled with ethtool were reenabled
- Features that becomes unsupported after the reset were not disabled

Also, checking if the device supports IPV6_CSUM to enable TSO6 is no
longer necessary because all currently supported devices support it.
Additionally, move the assignment of some other features to the
EF10_OFFLOAD_FEATURES macro, like it is done in ef100, leaving the
selection of features in efx_pci_probe_post_io a bit cleaner.

Fixes: ffffd2454a7a ("sfc: correctly advertise tunneled IPv6 segmentation")
Fixes: 24b2c3751aa3 ("sfc: advertise encapsulated offloads on EF10")
Reported-by: Tianhao Zhao <tizhao@redhat.com>
Suggested-by: Jonathan Cooper <jonathan.s.cooper@amd.com>
Tested-by: Jonathan Cooper <jonathan.s.cooper@amd.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
Link: https://lore.kernel.org/r/20230323083417.7345-1-ihuguet@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef10.c | 38 ++++++++++++++++++++++-----------
 drivers/net/ethernet/sfc/efx.c  | 17 ++++++---------
 2 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index eb1be73020822..32654fe1f8b59 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1304,7 +1304,8 @@ static void efx_ef10_fini_nic(struct efx_nic *efx)
 static int efx_ef10_init_nic(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-	netdev_features_t hw_enc_features = 0;
+	struct net_device *net_dev = efx->net_dev;
+	netdev_features_t tun_feats, tso_feats;
 	int rc;
 
 	if (nic_data->must_check_datapath_caps) {
@@ -1349,20 +1350,30 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 		nic_data->must_restore_piobufs = false;
 	}
 
-	/* add encapsulated checksum offload features */
+	/* encap features might change during reset if fw variant changed */
 	if (efx_has_cap(efx, VXLAN_NVGRE) && !efx_ef10_is_vf(efx))
-		hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-	/* add encapsulated TSO features */
-	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
-		netdev_features_t encap_tso_features;
+		net_dev->hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	else
+		net_dev->hw_enc_features &= ~(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
 
-		encap_tso_features = NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
-			NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_GRE_CSUM;
+	tun_feats = NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
+		    NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_GRE_CSUM;
+	tso_feats = NETIF_F_TSO | NETIF_F_TSO6;
 
-		hw_enc_features |= encap_tso_features | NETIF_F_TSO;
-		efx->net_dev->features |= encap_tso_features;
+	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
+		/* If this is first nic_init, or if it is a reset and a new fw
+		 * variant has added new features, enable them by default.
+		 * If the features are not new, maintain their current value.
+		 */
+		if (!(net_dev->hw_features & tun_feats))
+			net_dev->features |= tun_feats;
+		net_dev->hw_enc_features |= tun_feats | tso_feats;
+		net_dev->hw_features |= tun_feats;
+	} else {
+		net_dev->hw_enc_features &= ~(tun_feats | tso_feats);
+		net_dev->hw_features &= ~tun_feats;
+		net_dev->features &= ~tun_feats;
 	}
-	efx->net_dev->hw_enc_features = hw_enc_features;
 
 	/* don't fail init if RSS setup doesn't work */
 	rc = efx->type->rx_push_rss_config(efx, false,
@@ -3977,7 +3988,10 @@ static unsigned int ef10_check_caps(const struct efx_nic *efx,
 	 NETIF_F_HW_VLAN_CTAG_FILTER |	\
 	 NETIF_F_IPV6_CSUM |		\
 	 NETIF_F_RXHASH |		\
-	 NETIF_F_NTUPLE)
+	 NETIF_F_NTUPLE |		\
+	 NETIF_F_SG |			\
+	 NETIF_F_RXCSUM |		\
+	 NETIF_F_RXALL)
 
 const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.is_vf = true,
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 29c8d2c990044..c069659c9e2d0 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1045,21 +1045,18 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	}
 
 	/* Determine netdevice features */
-	net_dev->features |= (efx->type->offload_features | NETIF_F_SG |
-			      NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_RXALL);
-	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM)) {
-		net_dev->features |= NETIF_F_TSO6;
-		if (efx_has_cap(efx, TX_TSO_V2_ENCAP))
-			net_dev->hw_enc_features |= NETIF_F_TSO6;
-	}
-	/* Check whether device supports TSO */
-	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
-		net_dev->features &= ~NETIF_F_ALL_TSO;
+	net_dev->features |= efx->type->offload_features;
+
+	/* Add TSO features */
+	if (efx->type->tso_versions && efx->type->tso_versions(efx))
+		net_dev->features |= NETIF_F_TSO | NETIF_F_TSO6;
+
 	/* Mask for features that also apply to VLAN devices */
 	net_dev->vlan_features |= (NETIF_F_HW_CSUM | NETIF_F_SG |
 				   NETIF_F_HIGHDMA | NETIF_F_ALL_TSO |
 				   NETIF_F_RXCSUM);
 
+	/* Determine user configurable features */
 	net_dev->hw_features |= net_dev->features & ~efx->fixed_features;
 
 	/* Disable receiving frames with bad FCS, by default. */
-- 
2.39.2




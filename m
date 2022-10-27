Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35FBF60FE7A
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236970AbiJ0RFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236973AbiJ0RFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:05:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D052194F90
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:05:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18EB7623F4
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0F6C433C1;
        Thu, 27 Oct 2022 17:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890335;
        bh=pjsqHNkxc+XpIY5aLdwPXzvovyYmE+H1U2IL2lx6eEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z5XU3HHP11l1Y254bZbI11GfCXzAqz5L68r5G04leqVXSfxM01PdH4seklq6uIDaE
         yyZTcyPuKZpgAOttBs92AWcAk6ldClOnYL6USQavY0J1dZg7J00pGp1c0eeTtboAGu
         5taY2U7yCM69cID7ID37UEzvOUk1idwT/V9yiwhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Jonathan Cooper <jonathan.s.cooper@amd.com>,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 32/79] sfc: Change VF mac via PF as first preference if available.
Date:   Thu, 27 Oct 2022 18:55:42 +0200
Message-Id: <20221027165055.471436950@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cooper <jonathan.s.cooper@amd.com>

[ Upstream commit a8aed7b35becfd21f22a77c7014029ea837b018f ]

Changing a VF's mac address through the VF (rather than via the PF)
fails with EPERM because the latter part of efx_ef10_set_mac_address
attempts to change the vport mac address list as the VF.
Even with this fixed it still fails with EBUSY because the vadaptor
is still assigned on the VF - the vadaptor reassignment must be within
a section where the VF has torn down its state.

A major reason this has broken is because we have two functions that
ostensibly do the same thing - have a PF and VF cooperate to change a
VF mac address. Rather than do this, if we are changing the mac of a VF
that has a link to the PF in the same VM then simply call
sriov_set_vf_mac instead, which is a proven working function that does
that.

If there is no PF available, or that fails non-fatally, then attempt to
change the VF's mac address as we would a PF, without updating the PF's
data.

Test case:
Create a VF:
  echo 1 > /sys/class/net/<if>/device/sriov_numvfs
Set the mac address of the VF directly:
  ip link set <vf> addr 00:11:22:33:44:55
Set the MAC address of the VF via the PF:
  ip link set <pf> vf 0 mac 00:11:22:33:44:66
Without this patch the last command will fail with ENOENT.

Signed-off-by: Jonathan Cooper <jonathan.s.cooper@amd.com>
Reported-by: Íñigo Huguet <ihuguet@redhat.com>
Fixes: 910c8789a777 ("set the MAC address using MC_CMD_VADAPTOR_SET_MAC")
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef10.c | 58 ++++++++++++++-------------------
 1 file changed, 24 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 5b7413305be6..eb1be7302082 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -3255,6 +3255,30 @@ static int efx_ef10_set_mac_address(struct efx_nic *efx)
 	bool was_enabled = efx->port_enabled;
 	int rc;
 
+#ifdef CONFIG_SFC_SRIOV
+	/* If this function is a VF and we have access to the parent PF,
+	 * then use the PF control path to attempt to change the VF MAC address.
+	 */
+	if (efx->pci_dev->is_virtfn && efx->pci_dev->physfn) {
+		struct efx_nic *efx_pf = pci_get_drvdata(efx->pci_dev->physfn);
+		struct efx_ef10_nic_data *nic_data = efx->nic_data;
+		u8 mac[ETH_ALEN];
+
+		/* net_dev->dev_addr can be zeroed by efx_net_stop in
+		 * efx_ef10_sriov_set_vf_mac, so pass in a copy.
+		 */
+		ether_addr_copy(mac, efx->net_dev->dev_addr);
+
+		rc = efx_ef10_sriov_set_vf_mac(efx_pf, nic_data->vf_index, mac);
+		if (!rc)
+			return 0;
+
+		netif_dbg(efx, drv, efx->net_dev,
+			  "Updating VF mac via PF failed (%d), setting directly\n",
+			  rc);
+	}
+#endif
+
 	efx_device_detach_sync(efx);
 	efx_net_stop(efx->net_dev);
 
@@ -3277,40 +3301,6 @@ static int efx_ef10_set_mac_address(struct efx_nic *efx)
 		efx_net_open(efx->net_dev);
 	efx_device_attach_if_not_resetting(efx);
 
-#ifdef CONFIG_SFC_SRIOV
-	if (efx->pci_dev->is_virtfn && efx->pci_dev->physfn) {
-		struct efx_ef10_nic_data *nic_data = efx->nic_data;
-		struct pci_dev *pci_dev_pf = efx->pci_dev->physfn;
-
-		if (rc == -EPERM) {
-			struct efx_nic *efx_pf;
-
-			/* Switch to PF and change MAC address on vport */
-			efx_pf = pci_get_drvdata(pci_dev_pf);
-
-			rc = efx_ef10_sriov_set_vf_mac(efx_pf,
-						       nic_data->vf_index,
-						       efx->net_dev->dev_addr);
-		} else if (!rc) {
-			struct efx_nic *efx_pf = pci_get_drvdata(pci_dev_pf);
-			struct efx_ef10_nic_data *nic_data = efx_pf->nic_data;
-			unsigned int i;
-
-			/* MAC address successfully changed by VF (with MAC
-			 * spoofing) so update the parent PF if possible.
-			 */
-			for (i = 0; i < efx_pf->vf_count; ++i) {
-				struct ef10_vf *vf = nic_data->vf + i;
-
-				if (vf->efx == efx) {
-					ether_addr_copy(vf->mac,
-							efx->net_dev->dev_addr);
-					return 0;
-				}
-			}
-		}
-	} else
-#endif
 	if (rc == -EPERM) {
 		netif_err(efx, drv, efx->net_dev,
 			  "Cannot change MAC address; use sfboot to enable"
-- 
2.35.1




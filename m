Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49BC3383094
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239407AbhEQO2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:28:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239111AbhEQO0r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:26:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8589561584;
        Mon, 17 May 2021 14:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260835;
        bh=xNbWiAZJ/0F0f5hRzan40mRN57nXhscGbdj2h0dyc8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0XSmnG38yy21myr2+op5bAC1Vv1B37TNcY/nDET91ivMBaXCOSOxdYf0xKrKG/AL/
         hRaWUw0mOBbtXmietU9WiCP1XKp0dvlDMQ7oldsO61XCkotHDH9p9LhG/gxK5gX6kL
         /45/wOKrmWYi1x8jB73S0BLR0xTEDtIussb9aOFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Imam Hassan Reza Biswas <imam.hassan.reza.biswas@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 246/363] i40e: Remove LLDP frame filters
Date:   Mon, 17 May 2021 16:01:52 +0200
Message-Id: <20210517140310.905329181@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

[ Upstream commit 8085a36db71f54d2592426eb76bdf71b82479140 ]

Remove filters from being setup in case of software DCB and allow the
LLDP frames to be properly transmitted to the wire.

It is not possible to transmit the LLDP frame out of the port, if they
are filtered by control VSI. This prohibits software LLDP agent
properly communicate its DCB capabilities to the neighbors.

Fixes: 4b208eaa8078 ("i40e: Add init and default config of software based DCB")
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Imam Hassan Reza Biswas <imam.hassan.reza.biswas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e.h        |  1 -
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  1 -
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 42 -------------------
 3 files changed, 44 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 15f93b355099..5069f690cf0b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -1142,7 +1142,6 @@ static inline bool i40e_is_sw_dcb(struct i40e_pf *pf)
 	return !!(pf->flags & I40E_FLAG_DISABLE_FW_LLDP);
 }
 
-void i40e_set_lldp_forwarding(struct i40e_pf *pf, bool enable);
 #ifdef CONFIG_I40E_DCB
 void i40e_dcbnl_flush_apps(struct i40e_pf *pf,
 			   struct i40e_dcbx_config *old_cfg,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index e8da7339137c..93dd58fda272 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -5288,7 +5288,6 @@ flags_complete:
 			i40e_aq_cfg_lldp_mib_change_event(&pf->hw, false, NULL);
 			i40e_aq_stop_lldp(&pf->hw, true, false, NULL);
 		} else {
-			i40e_set_lldp_forwarding(pf, false);
 			status = i40e_aq_start_lldp(&pf->hw, false, NULL);
 			if (status) {
 				adq_err = pf->hw.aq.asq_last_status;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 527023ee4c07..ac4b44fc19f1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -6878,40 +6878,6 @@ out:
 }
 #endif /* CONFIG_I40E_DCB */
 
-/**
- * i40e_set_lldp_forwarding - set forwarding of lldp frames
- * @pf: PF being configured
- * @enable: if forwarding to OS shall be enabled
- *
- * Toggle forwarding of lldp frames behavior,
- * When passing DCB control from firmware to software
- * lldp frames must be forwarded to the software based
- * lldp agent.
- */
-void i40e_set_lldp_forwarding(struct i40e_pf *pf, bool enable)
-{
-	if (pf->lan_vsi == I40E_NO_VSI)
-		return;
-
-	if (!pf->vsi[pf->lan_vsi])
-		return;
-
-	/* No need to check the outcome, commands may fail
-	 * if desired value is already set
-	 */
-	i40e_aq_add_rem_control_packet_filter(&pf->hw, NULL, ETH_P_LLDP,
-					      I40E_AQC_ADD_CONTROL_PACKET_FLAGS_TX |
-					      I40E_AQC_ADD_CONTROL_PACKET_FLAGS_IGNORE_MAC,
-					      pf->vsi[pf->lan_vsi]->seid, 0,
-					      enable, NULL, NULL);
-
-	i40e_aq_add_rem_control_packet_filter(&pf->hw, NULL, ETH_P_LLDP,
-					      I40E_AQC_ADD_CONTROL_PACKET_FLAGS_RX |
-					      I40E_AQC_ADD_CONTROL_PACKET_FLAGS_IGNORE_MAC,
-					      pf->vsi[pf->lan_vsi]->seid, 0,
-					      enable, NULL, NULL);
-}
-
 /**
  * i40e_print_link_message - print link up or down
  * @vsi: the VSI for which link needs a message
@@ -10735,10 +10701,6 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 	 */
 	i40e_add_filter_to_drop_tx_flow_control_frames(&pf->hw,
 						       pf->main_vsi_seid);
-#ifdef CONFIG_I40E_DCB
-	if (pf->flags & I40E_FLAG_DISABLE_FW_LLDP)
-		i40e_set_lldp_forwarding(pf, true);
-#endif /* CONFIG_I40E_DCB */
 
 	/* restart the VSIs that were rebuilt and running before the reset */
 	i40e_pf_unquiesce_all_vsi(pf);
@@ -15753,10 +15715,6 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	i40e_add_filter_to_drop_tx_flow_control_frames(&pf->hw,
 						       pf->main_vsi_seid);
-#ifdef CONFIG_I40E_DCB
-	if (pf->flags & I40E_FLAG_DISABLE_FW_LLDP)
-		i40e_set_lldp_forwarding(pf, true);
-#endif /* CONFIG_I40E_DCB */
 
 	if ((pf->hw.device_id == I40E_DEV_ID_10G_BASE_T) ||
 		(pf->hw.device_id == I40E_DEV_ID_10G_BASE_T4))
-- 
2.30.2




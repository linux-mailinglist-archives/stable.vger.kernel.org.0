Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7E535BE31
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238833AbhDLI5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238975AbhDLIzQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AFBB61383;
        Mon, 12 Apr 2021 08:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217650;
        bh=r7AtCXKx637h+0Wxe5+TouFviG32d9pd+T8vpDFlLMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=06ETx1gBKZdAXYSnWbJResY1HHsDGfvz5jSoaJ5utMoaiw4/xMloc3VgYNxEXTLKu
         eS2+SyNL2U2zlbSBO5a/ijh08UJE5lQj1DQhvzs0C37BGazH2rQfh83rwlw+gfymEI
         JPU9P0Nzzz8HENlGJqWFguYK0x4YnHDfx5igAe0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chinh T Cao <chinh.t.cao@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/188] ice: Recognize 860 as iSCSI port in CEE mode
Date:   Mon, 12 Apr 2021 10:40:07 +0200
Message-Id: <20210412084016.738342127@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chinh T Cao <chinh.t.cao@intel.com>

[ Upstream commit aeac8ce864d9c0836e12ed5b5cc80f62f3cccb7c ]

iSCSI can use both TCP ports 860 and 3260. However, in our current
implementation, the ice_aqc_opc_get_cee_dcb_cfg (0x0A07) AQ command
doesn't provide a way to communicate the protocol port number to the
AQ's caller. Thus, we assume that 3260 is the iSCSI port number at the
AQ's caller layer.

Rely on the dcbx-willing mode, desired QoS and remote QoS configuration to
determine which port number that iSCSI will use.

Fixes: 0ebd3ff13cca ("ice: Add code for DCB initialization part 2/4")
Signed-off-by: Chinh T Cao <chinh.t.cao@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_dcb.c  | 38 +++++++++++++++++------
 drivers/net/ethernet/intel/ice/ice_type.h |  1 +
 2 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index e42727941ef5..211ac6f907ad 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -738,22 +738,27 @@ ice_aq_get_cee_dcb_cfg(struct ice_hw *hw,
 /**
  * ice_cee_to_dcb_cfg
  * @cee_cfg: pointer to CEE configuration struct
- * @dcbcfg: DCB configuration struct
+ * @pi: port information structure
  *
  * Convert CEE configuration from firmware to DCB configuration
  */
 static void
 ice_cee_to_dcb_cfg(struct ice_aqc_get_cee_dcb_cfg_resp *cee_cfg,
-		   struct ice_dcbx_cfg *dcbcfg)
+		   struct ice_port_info *pi)
 {
 	u32 status, tlv_status = le32_to_cpu(cee_cfg->tlv_status);
 	u32 ice_aqc_cee_status_mask, ice_aqc_cee_status_shift;
+	u8 i, j, err, sync, oper, app_index, ice_app_sel_type;
 	u16 app_prio = le16_to_cpu(cee_cfg->oper_app_prio);
-	u8 i, err, sync, oper, app_index, ice_app_sel_type;
 	u16 ice_aqc_cee_app_mask, ice_aqc_cee_app_shift;
+	struct ice_dcbx_cfg *cmp_dcbcfg, *dcbcfg;
 	u16 ice_app_prot_id_type;
 
-	/* CEE PG data to ETS config */
+	dcbcfg = &pi->qos_cfg.local_dcbx_cfg;
+	dcbcfg->dcbx_mode = ICE_DCBX_MODE_CEE;
+	dcbcfg->tlv_status = tlv_status;
+
+	/* CEE PG data */
 	dcbcfg->etscfg.maxtcs = cee_cfg->oper_num_tc;
 
 	/* Note that the FW creates the oper_prio_tc nibbles reversed
@@ -780,10 +785,16 @@ ice_cee_to_dcb_cfg(struct ice_aqc_get_cee_dcb_cfg_resp *cee_cfg,
 		}
 	}
 
-	/* CEE PFC data to ETS config */
+	/* CEE PFC data */
 	dcbcfg->pfc.pfcena = cee_cfg->oper_pfc_en;
 	dcbcfg->pfc.pfccap = ICE_MAX_TRAFFIC_CLASS;
 
+	/* CEE APP TLV data */
+	if (dcbcfg->app_mode == ICE_DCBX_APPS_NON_WILLING)
+		cmp_dcbcfg = &pi->qos_cfg.desired_dcbx_cfg;
+	else
+		cmp_dcbcfg = &pi->qos_cfg.remote_dcbx_cfg;
+
 	app_index = 0;
 	for (i = 0; i < 3; i++) {
 		if (i == 0) {
@@ -802,6 +813,18 @@ ice_cee_to_dcb_cfg(struct ice_aqc_get_cee_dcb_cfg_resp *cee_cfg,
 			ice_aqc_cee_app_shift = ICE_AQC_CEE_APP_ISCSI_S;
 			ice_app_sel_type = ICE_APP_SEL_TCPIP;
 			ice_app_prot_id_type = ICE_APP_PROT_ID_ISCSI;
+
+			for (j = 0; j < cmp_dcbcfg->numapps; j++) {
+				u16 prot_id = cmp_dcbcfg->app[j].prot_id;
+				u8 sel = cmp_dcbcfg->app[j].selector;
+
+				if  (sel == ICE_APP_SEL_TCPIP &&
+				     (prot_id == ICE_APP_PROT_ID_ISCSI ||
+				      prot_id == ICE_APP_PROT_ID_ISCSI_860)) {
+					ice_app_prot_id_type = prot_id;
+					break;
+				}
+			}
 		} else {
 			/* FIP APP */
 			ice_aqc_cee_status_mask = ICE_AQC_CEE_FIP_STATUS_M;
@@ -892,11 +915,8 @@ enum ice_status ice_get_dcb_cfg(struct ice_port_info *pi)
 	ret = ice_aq_get_cee_dcb_cfg(pi->hw, &cee_cfg, NULL);
 	if (!ret) {
 		/* CEE mode */
-		dcbx_cfg = &pi->qos_cfg.local_dcbx_cfg;
-		dcbx_cfg->dcbx_mode = ICE_DCBX_MODE_CEE;
-		dcbx_cfg->tlv_status = le32_to_cpu(cee_cfg.tlv_status);
-		ice_cee_to_dcb_cfg(&cee_cfg, dcbx_cfg);
 		ret = ice_get_ieee_or_cee_dcb_cfg(pi, ICE_DCBX_MODE_CEE);
+		ice_cee_to_dcb_cfg(&cee_cfg, pi);
 	} else if (pi->hw->adminq.sq_last_status == ICE_AQ_RC_ENOENT) {
 		/* CEE mode not enabled try querying IEEE data */
 		dcbx_cfg = &pi->qos_cfg.local_dcbx_cfg;
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index c09c085f637a..1bed183d96a0 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -493,6 +493,7 @@ struct ice_dcb_app_priority_table {
 #define ICE_TLV_STATUS_ERR	0x4
 #define ICE_APP_PROT_ID_FCOE	0x8906
 #define ICE_APP_PROT_ID_ISCSI	0x0cbc
+#define ICE_APP_PROT_ID_ISCSI_860 0x035c
 #define ICE_APP_PROT_ID_FIP	0x8914
 #define ICE_APP_SEL_ETHTYPE	0x1
 #define ICE_APP_SEL_TCPIP	0x2
-- 
2.30.2




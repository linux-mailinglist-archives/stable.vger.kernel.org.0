Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D82505564
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242169AbiDRNN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242511AbiDRNJL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:09:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D09A35AB2;
        Mon, 18 Apr 2022 05:48:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16B816124A;
        Mon, 18 Apr 2022 12:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0053BC385A7;
        Mon, 18 Apr 2022 12:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286118;
        bh=xt/3ZgTb5M7UCbB0uEeBZlI135Cdciw7Ms4/z7SMJ/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pq8FDHVJFIGetdOgpRk3fRJ4WpuBA86V+QFFtHwmWIm/Y+ekUqEPuN2vNJgiV7XKS
         /9SWousDT+6+s0LEOhiZDNG1iCGRUE/V+fakBWDjiy+5ESWo4jp6w2R2qxycAvHwAZ
         V8NIESFODuvh9mwUO8ATZys8Pl9io9/CcqO7L9p4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Chopra <manishc@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 033/284] qed: validate and restrict untrusted VFs vlan promisc mode
Date:   Mon, 18 Apr 2022 14:10:14 +0200
Message-Id: <20220418121211.636992623@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
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

From: Manish Chopra <manishc@marvell.com>

commit cbcc44db2cf7b836896733acc0e5ea966136ed22 upstream.

Today when VFs are put in promiscuous mode, they can request PF
to configure device for them to receive all VLANs traffic regardless
of what vlan is configured by the PF (via ip link) and PF allows this
config request regardless of whether VF is trusted or not.

>From security POV, when VLAN is configured for VF through PF (via ip link),
honour such config requests from VF only when they are configured to be
trusted, otherwise restrict such VFs vlan promisc mode config.

Cc: stable@vger.kernel.org
Fixes: f990c82c385b ("qed*: Add support for ndo_set_vf_trust")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qed/qed_sriov.c |   28 ++++++++++++++++++++++++++--
 drivers/net/ethernet/qlogic/qed/qed_sriov.h |    1 +
 2 files changed, 27 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -2996,12 +2996,16 @@ static int qed_iov_pre_update_vport(stru
 	u8 mask = QED_ACCEPT_UCAST_UNMATCHED | QED_ACCEPT_MCAST_UNMATCHED;
 	struct qed_filter_accept_flags *flags = &params->accept_flags;
 	struct qed_public_vf_info *vf_info;
+	u16 tlv_mask;
+
+	tlv_mask = BIT(QED_IOV_VP_UPDATE_ACCEPT_PARAM) |
+		   BIT(QED_IOV_VP_UPDATE_ACCEPT_ANY_VLAN);
 
 	/* Untrusted VFs can't even be trusted to know that fact.
 	 * Simply indicate everything is configured fine, and trace
 	 * configuration 'behind their back'.
 	 */
-	if (!(*tlvs & BIT(QED_IOV_VP_UPDATE_ACCEPT_PARAM)))
+	if (!(*tlvs & tlv_mask))
 		return 0;
 
 	vf_info = qed_iov_get_public_vf_info(hwfn, vfid, true);
@@ -3018,6 +3022,13 @@ static int qed_iov_pre_update_vport(stru
 			flags->tx_accept_filter &= ~mask;
 	}
 
+	if (params->update_accept_any_vlan_flg) {
+		vf_info->accept_any_vlan = params->accept_any_vlan;
+
+		if (vf_info->forced_vlan && !vf_info->is_trusted_configured)
+			params->accept_any_vlan = false;
+	}
+
 	return 0;
 }
 
@@ -4920,6 +4931,12 @@ static void qed_iov_handle_trust_change(
 
 		params.update_ctl_frame_check = 1;
 		params.mac_chk_en = !vf_info->is_trusted_configured;
+		params.update_accept_any_vlan_flg = 0;
+
+		if (vf_info->accept_any_vlan && vf_info->forced_vlan) {
+			params.update_accept_any_vlan_flg = 1;
+			params.accept_any_vlan = vf_info->accept_any_vlan;
+		}
 
 		if (vf_info->rx_accept_mode & mask) {
 			flags->update_rx_mode_config = 1;
@@ -4935,13 +4952,20 @@ static void qed_iov_handle_trust_change(
 		if (!vf_info->is_trusted_configured) {
 			flags->rx_accept_filter &= ~mask;
 			flags->tx_accept_filter &= ~mask;
+			params.accept_any_vlan = false;
 		}
 
 		if (flags->update_rx_mode_config ||
 		    flags->update_tx_mode_config ||
-		    params.update_ctl_frame_check)
+		    params.update_ctl_frame_check ||
+		    params.update_accept_any_vlan_flg) {
+			DP_VERBOSE(hwfn, QED_MSG_IOV,
+				   "vport update config for %s VF[abs 0x%x rel 0x%x]\n",
+				   vf_info->is_trusted_configured ? "trusted" : "untrusted",
+				   vf->abs_vf_id, vf->relative_vf_id);
 			qed_sp_vport_update(hwfn, &params,
 					    QED_SPQ_MODE_EBLOCK, NULL);
+		}
 	}
 }
 
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.h
@@ -88,6 +88,7 @@ struct qed_public_vf_info {
 	bool is_trusted_request;
 	u8 rx_accept_mode;
 	u8 tx_accept_mode;
+	bool accept_any_vlan;
 };
 
 struct qed_iov_vf_init_params {



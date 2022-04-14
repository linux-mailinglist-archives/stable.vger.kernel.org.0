Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B56E500EB6
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243882AbiDNNUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243873AbiDNNTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:19:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541D591AD9;
        Thu, 14 Apr 2022 06:16:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02DFAB82981;
        Thu, 14 Apr 2022 13:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4A8C385A1;
        Thu, 14 Apr 2022 13:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942174;
        bh=xzu+s2ywCeLAoEzKldWQcGxNKVPhhlA9OwVIgCkHXGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iefce4ZKPVXN6XN9YaNcolNKOtDCkhSl8iVUfp5e/k3svAlGWdWp5Tr2CwDHM5CVE
         peyemcVQAh2ZimViSjeIhT7igs3Ddl5XZ9PDyk77OMf39IsH5Ko69DVRY4BMu7enEm
         bs+fRHTsibAwBPPRw7dToNDrXbdRZfaeCTJElPO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Chopra <manishc@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 041/338] qed: validate and restrict untrusted VFs vlan promisc mode
Date:   Thu, 14 Apr 2022 15:09:04 +0200
Message-Id: <20220414110840.065530217@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -3002,12 +3002,16 @@ static int qed_iov_pre_update_vport(stru
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
@@ -3024,6 +3028,13 @@ static int qed_iov_pre_update_vport(stru
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
 
@@ -5140,6 +5151,12 @@ static void qed_iov_handle_trust_change(
 
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
@@ -5155,13 +5172,20 @@ static void qed_iov_handle_trust_change(
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



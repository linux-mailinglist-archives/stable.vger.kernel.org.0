Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2625D1D0F30
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732677AbgEMJqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:46:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732674AbgEMJqi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:46:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A399B20769;
        Wed, 13 May 2020 09:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363196;
        bh=IgVQvdEEeWcSDbRTQR3027sp00BplDpovZc7JGFPOmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XE7U68CQ0pyXISeLD5phTbsQsNHL7Qxzxn4VuXk3KcKVZqgx8mJgZvMz4gcTfO4+s
         XZEvxLUpd2x92g30Lj/hQbQQwJ/nNi02EOaJpwduqC+rIcG7P1o8DVTtOqAGT94RfW
         MuPOteI/vWyJm3WJiszrVekb7FlTwC3yUx6WW8oE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 17/48] bnxt_en: Fix VF anti-spoof filter setup.
Date:   Wed, 13 May 2020 11:44:43 +0200
Message-Id: <20200513094355.480214815@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094351.100352960@linuxfoundation.org>
References: <20200513094351.100352960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit c71c4e49afe173823a2a85b0cabc9b3f1176ffa2 ]

Fix the logic that sets the enable/disable flag for the source MAC
filter according to firmware spec 1.7.1.

In the original firmware spec. before 1.7.1, the VF spoof check flags
were not latched after making the HWRM_FUNC_CFG call, so there was a
need to keep the func_flags so that subsequent calls would perserve
the VF spoof check setting.  A change was made in the 1.7.1 spec
so that the flags became latched.  So we now set or clear the anti-
spoof setting directly without retrieving the old settings in the
stored vf->func_flags which are no longer valid.  We also remove the
unneeded vf->func_flags.

Fixes: 8eb992e876a8 ("bnxt_en: Update firmware interface spec to 1.7.6.2.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h       |    1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c |    9 ++-------
 2 files changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -839,7 +839,6 @@ struct bnxt_vf_info {
 #define BNXT_VF_LINK_FORCED	0x4
 #define BNXT_VF_LINK_UP		0x8
 #define BNXT_VF_TRUST		0x10
-	u32	func_flags; /* func cfg flags */
 	u32	min_tx_rate;
 	u32	max_tx_rate;
 	void	*hwrm_cmd_req_addr;
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -99,11 +99,10 @@ int bnxt_set_vf_spoofchk(struct net_devi
 	if (old_setting == setting)
 		return 0;
 
-	func_flags = vf->func_flags;
 	if (setting)
-		func_flags |= FUNC_CFG_REQ_FLAGS_SRC_MAC_ADDR_CHECK_ENABLE;
+		func_flags = FUNC_CFG_REQ_FLAGS_SRC_MAC_ADDR_CHECK_ENABLE;
 	else
-		func_flags |= FUNC_CFG_REQ_FLAGS_SRC_MAC_ADDR_CHECK_DISABLE;
+		func_flags = FUNC_CFG_REQ_FLAGS_SRC_MAC_ADDR_CHECK_DISABLE;
 	/*TODO: if the driver supports VLAN filter on guest VLAN,
 	 * the spoof check should also include vlan anti-spoofing
 	 */
@@ -112,7 +111,6 @@ int bnxt_set_vf_spoofchk(struct net_devi
 	req.flags = cpu_to_le32(func_flags);
 	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
 	if (!rc) {
-		vf->func_flags = func_flags;
 		if (setting)
 			vf->flags |= BNXT_VF_SPOOFCHK;
 		else
@@ -197,7 +195,6 @@ int bnxt_set_vf_mac(struct net_device *d
 	memcpy(vf->mac_addr, mac, ETH_ALEN);
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_CFG, -1, -1);
 	req.fid = cpu_to_le16(vf->fw_fid);
-	req.flags = cpu_to_le32(vf->func_flags);
 	req.enables = cpu_to_le32(FUNC_CFG_REQ_ENABLES_DFLT_MAC_ADDR);
 	memcpy(req.dflt_mac_addr, mac, ETH_ALEN);
 	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
@@ -235,7 +232,6 @@ int bnxt_set_vf_vlan(struct net_device *
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_CFG, -1, -1);
 	req.fid = cpu_to_le16(vf->fw_fid);
-	req.flags = cpu_to_le32(vf->func_flags);
 	req.dflt_vlan = cpu_to_le16(vlan_tag);
 	req.enables = cpu_to_le32(FUNC_CFG_REQ_ENABLES_DFLT_VLAN);
 	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
@@ -274,7 +270,6 @@ int bnxt_set_vf_bw(struct net_device *de
 		return 0;
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_CFG, -1, -1);
 	req.fid = cpu_to_le16(vf->fw_fid);
-	req.flags = cpu_to_le32(vf->func_flags);
 	req.enables = cpu_to_le32(FUNC_CFG_REQ_ENABLES_MAX_BW);
 	req.max_bw = cpu_to_le32(max_tx_rate);
 	req.enables |= cpu_to_le32(FUNC_CFG_REQ_ENABLES_MIN_BW);



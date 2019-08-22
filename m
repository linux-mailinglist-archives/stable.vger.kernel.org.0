Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 593EF99C02
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389182AbfHVRaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404636AbfHVR0K (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:26:10 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6788D206DD;
        Thu, 22 Aug 2019 17:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494769;
        bh=N6lk2Dva1mbQmwlfVWErDLSrThh4/WYcDppJ9sWjLaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KO8+ogqp2Qwj32n7F8cVYj6uvubn/X6VraIrXoQg+LroPqYhCfp+ac/a31P4Z8te4
         XQ+OQwBGlK6Hdjc9sGVZOz6qrPLWZBhqPq7xM2PsrgrZisMsMcH3YFnord+2fO2b+1
         d3ZJYR/+RiO7Z5L5FZnRt9lZK1HQr7CroFSQw1Qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Chopra <manishc@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Shahed Shaikh <shshaikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 73/85] bnx2x: Fix VFs VLAN reconfiguration in reload.
Date:   Thu, 22 Aug 2019 10:19:46 -0700
Message-Id: <20190822171734.310138115@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>

[ Upstream commit 4a4d2d372fb9b9229327e2ed01d5d9572eddf4de ]

Commit 04f05230c5c13 ("bnx2x: Remove configured vlans as
part of unload sequence."), introduced a regression in driver
that as a part of VF's reload flow, VLANs created on the VF
doesn't get re-configured in hardware as vlan metadata/info
was not getting cleared for the VFs which causes vlan PING to stop.

This patch clears the vlan metadata/info so that VLANs gets
re-configured back in the hardware in VF's reload flow and
PING/traffic continues for VLANs created over the VFs.

Fixes: 04f05230c5c13 ("bnx2x: Remove configured vlans as part of unload sequence.")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Sudarsana Kalluru <skalluru@marvell.com>
Signed-off-by: Shahed Shaikh <shshaikh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c  |    7 ++++---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h  |    2 ++
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |   17 ++++++++++++-----
 3 files changed, 18 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -3058,12 +3058,13 @@ int bnx2x_nic_unload(struct bnx2x *bp, i
 	/* if VF indicate to PF this function is going down (PF will delete sp
 	 * elements and clear initializations
 	 */
-	if (IS_VF(bp))
+	if (IS_VF(bp)) {
+		bnx2x_clear_vlan_info(bp);
 		bnx2x_vfpf_close_vf(bp);
-	else if (unload_mode != UNLOAD_RECOVERY)
+	} else if (unload_mode != UNLOAD_RECOVERY) {
 		/* if this is a normal/close unload need to clean up chip*/
 		bnx2x_chip_cleanup(bp, unload_mode, keep_link);
-	else {
+	} else {
 		/* Send the UNLOAD_REQUEST to the MCP */
 		bnx2x_send_unload_req(bp, unload_mode);
 
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
@@ -425,6 +425,8 @@ void bnx2x_set_reset_global(struct bnx2x
 void bnx2x_disable_close_the_gate(struct bnx2x *bp);
 int bnx2x_init_hw_func_cnic(struct bnx2x *bp);
 
+void bnx2x_clear_vlan_info(struct bnx2x *bp);
+
 /**
  * bnx2x_sp_event - handle ramrods completion.
  *
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -8488,11 +8488,21 @@ int bnx2x_set_vlan_one(struct bnx2x *bp,
 	return rc;
 }
 
+void bnx2x_clear_vlan_info(struct bnx2x *bp)
+{
+	struct bnx2x_vlan_entry *vlan;
+
+	/* Mark that hw forgot all entries */
+	list_for_each_entry(vlan, &bp->vlan_reg, link)
+		vlan->hw = false;
+
+	bp->vlan_cnt = 0;
+}
+
 static int bnx2x_del_all_vlans(struct bnx2x *bp)
 {
 	struct bnx2x_vlan_mac_obj *vlan_obj = &bp->sp_objs[0].vlan_obj;
 	unsigned long ramrod_flags = 0, vlan_flags = 0;
-	struct bnx2x_vlan_entry *vlan;
 	int rc;
 
 	__set_bit(RAMROD_COMP_WAIT, &ramrod_flags);
@@ -8501,10 +8511,7 @@ static int bnx2x_del_all_vlans(struct bn
 	if (rc)
 		return rc;
 
-	/* Mark that hw forgot all entries */
-	list_for_each_entry(vlan, &bp->vlan_reg, link)
-		vlan->hw = false;
-	bp->vlan_cnt = 0;
+	bnx2x_clear_vlan_info(bp);
 
 	return 0;
 }



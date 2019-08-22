Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF6F999FB
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390708AbfHVRJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:09:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390699AbfHVRJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:13 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19FCE2343A;
        Thu, 22 Aug 2019 17:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493752;
        bh=1+cD3yyBs8vg4X+NKzUB2ZuYtAnjfvDsOU5GLpaTueE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J7tuL4OfEQE3YeyN37YX0vVNrL5uvwvuxGkRenGAjCF/sDK/ZUdYZpOt5nckfuq27
         UNTr/mvHBJuu+xZ2vRz/N6qcw7ZQQFOtn90xtx4sqZHcevux4ICgMod4z0Mp5YjlbP
         j/gZ7mXG31CHYxx3nytw/dnrx8aILdXWaDxnxGWY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manish Chopra <manishc@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Shahed Shaikh <shshaikh@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 107/135] bnx2x: Fix VF's VLAN reconfiguration in reload.
Date:   Thu, 22 Aug 2019 13:07:43 -0400
Message-Id: <20190822170811.13303-108-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |  7 ++++---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h |  2 ++
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c    | 17 ++++++++++++-----
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 4039a9599d79c..9d582b3ebc88d 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -3057,12 +3057,13 @@ int bnx2x_nic_unload(struct bnx2x *bp, int unload_mode, bool keep_link)
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
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
index c2f6e44e9a3f7..8b08cb18e3638 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
@@ -425,6 +425,8 @@ void bnx2x_set_reset_global(struct bnx2x *bp);
 void bnx2x_disable_close_the_gate(struct bnx2x *bp);
 int bnx2x_init_hw_func_cnic(struct bnx2x *bp);
 
+void bnx2x_clear_vlan_info(struct bnx2x *bp);
+
 /**
  * bnx2x_sp_event - handle ramrods completion.
  *
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 2cc14db8f0ec9..192ff8d5da324 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -8482,11 +8482,21 @@ int bnx2x_set_vlan_one(struct bnx2x *bp, u16 vlan,
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
@@ -8495,10 +8505,7 @@ static int bnx2x_del_all_vlans(struct bnx2x *bp)
 	if (rc)
 		return rc;
 
-	/* Mark that hw forgot all entries */
-	list_for_each_entry(vlan, &bp->vlan_reg, link)
-		vlan->hw = false;
-	bp->vlan_cnt = 0;
+	bnx2x_clear_vlan_info(bp);
 
 	return 0;
 }
-- 
2.20.1


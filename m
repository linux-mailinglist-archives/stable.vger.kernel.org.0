Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE86699A00
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390748AbfHVRJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:09:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390738AbfHVRJV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:21 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E97C323427;
        Thu, 22 Aug 2019 17:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493761;
        bh=qN5xMvra3JxVUtZYr+93qeFSSxlpJaZuuoRwvFoOs4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTdULU+4ya+3oAsxVkrBq3zgjnjjwCM3TXGXUk4Q+eR5857QHF1mdySyv3L6OF0Bd
         6LrNXVlIHnvLrS3akD8mvdPaNLSlcEl6SC9tcmcKJ6L1X5ELwyxT+31MdFlDkcfHIJ
         auSbMv/ePF03ELzGFMKvjST7pkV/QTlHVt7vM5f0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Somnath Kotur <somnath.kotur@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 124/135] bnxt_en: Fix to include flow direction in L2 key
Date:   Thu, 22 Aug 2019 13:08:00 -0400
Message-Id: <20190822170811.13303-125-sashal@kernel.org>
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

From: Somnath Kotur <somnath.kotur@broadcom.com>

[ Upstream commit 9bf46566e80fd94845527d01ebd888eb49313551 ]

FW expects the driver to provide unique flow reference handles
for Tx or Rx flows. When a Tx flow and an Rx flow end up sharing
a reference handle, flow offload does not seem to work.
This could happen in the case of 2 flows having their L2 fields
wildcarded but in different direction.
Fix to incorporate the flow direction as part of the L2 key

v2: Move the dir field to the end of the bnxt_tc_l2_key struct to
fix the warning reported by kbuild test robot <lkp@intel.com>.
There is existing code that initializes the structure using
nested initializer and will warn with the new u8 field added to
the beginning.  The structure also packs nicer when this new u8 is
added to the end of the structure [MChan].

Fixes: abd43a13525d ("bnxt_en: Support for 64-bit flow handle.")
Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c | 4 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index a25ed190b5b2e..434470a6b9f3b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1236,7 +1236,7 @@ static int __bnxt_tc_del_flow(struct bnxt *bp,
 static void bnxt_tc_set_flow_dir(struct bnxt *bp, struct bnxt_tc_flow *flow,
 				 u16 src_fid)
 {
-	flow->dir = (bp->pf.fw_fid == src_fid) ? BNXT_DIR_RX : BNXT_DIR_TX;
+	flow->l2_key.dir = (bp->pf.fw_fid == src_fid) ? BNXT_DIR_RX : BNXT_DIR_TX;
 }
 
 static void bnxt_tc_set_src_fid(struct bnxt *bp, struct bnxt_tc_flow *flow,
@@ -1405,7 +1405,7 @@ static void bnxt_fill_cfa_stats_req(struct bnxt *bp,
 		 * 2. 15th bit of flow_handle must specify the flow
 		 *    direction (TX/RX).
 		 */
-		if (flow_node->flow.dir == BNXT_DIR_RX)
+		if (flow_node->flow.l2_key.dir == BNXT_DIR_RX)
 			handle = CFA_FLOW_INFO_REQ_FLOW_HANDLE_DIR_RX |
 				 CFA_FLOW_INFO_REQ_FLOW_HANDLE_MAX_MASK;
 		else
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
index 8a0968967bc5e..8b0f1510bdc48 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
@@ -23,6 +23,9 @@ struct bnxt_tc_l2_key {
 	__be16		inner_vlan_tci;
 	__be16		ether_type;
 	u8		num_vlans;
+	u8		dir;
+#define BNXT_DIR_RX	1
+#define BNXT_DIR_TX	0
 };
 
 struct bnxt_tc_l3_key {
@@ -98,9 +101,6 @@ struct bnxt_tc_flow {
 
 	/* flow applicable to pkts ingressing on this fid */
 	u16				src_fid;
-	u8				dir;
-#define BNXT_DIR_RX	1
-#define BNXT_DIR_TX	0
 	struct bnxt_tc_l2_key		l2_key;
 	struct bnxt_tc_l2_key		l2_mask;
 	struct bnxt_tc_l3_key		l3_key;
-- 
2.20.1


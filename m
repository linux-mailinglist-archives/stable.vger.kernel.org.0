Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49BC444B67D
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344608AbhKIW1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:27:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:48904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344190AbhKIWZa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:25:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9930761A40;
        Tue,  9 Nov 2021 22:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496379;
        bh=EJJXVXmG0JlikiMwm28/+wIPXTZKWkSlmlQtES4NxxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GyKaVqKyoFiggUpASVQ3FQqbyIVGQrgFQlYtO6sCT5Av4vl4CQ296Nt4C/KNCfVUz
         EzjUH7AIhbQKwl6xXGsfQ/rmr7orSJaZkMS9L+buP7tDvCoWmrpzBGHuPt58uvYYb1
         koJLIEvpi+pC9HAC1aeInTxOMrJBD8u8aIk8HrMu57zaPA8xme/q0Ilg6rNHYIPKsK
         tRmJDB9qbMnzCVl9d1elNlgloEcGGaY0ZHpxwy0Nw+M+L35A1A4sdcgTJqhud0mAu4
         6w+JhJvqNwt+cqsNnUncveR5sNjDHQ3rhYMq3GbzXxjXtE+LfAhdiZH9wu9sNr9638
         B9QswmCiJDnsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, dledford@redhat.com,
        sean.hefty@intel.com, hal.rosenstock@gmail.com,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 17/75] RDMA/bnxt_re: Check if the vlan is valid before reporting
Date:   Tue,  9 Nov 2021 17:18:07 -0500
Message-Id: <20211109221905.1234094-17-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 6bda39149d4b8920fdb8744090653aca3daa792d ]

When VF is configured with default vlan, HW strips the vlan from the
packet and driver receives it in Rx completion. VLAN needs to be reported
for UD work completion only if the vlan is configured on the host. Add a
check for valid vlan in the UD receive path.

Link: https://lore.kernel.org/r/1631709163-2287-12-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index ea0054c60fbc6..4e0c7115c16cf 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3364,8 +3364,11 @@ static void bnxt_re_process_res_ud_wc(struct bnxt_re_qp *qp,
 				      struct ib_wc *wc,
 				      struct bnxt_qplib_cqe *cqe)
 {
+	struct bnxt_re_dev *rdev;
+	u16 vlan_id = 0;
 	u8 nw_type;
 
+	rdev = qp->rdev;
 	wc->opcode = IB_WC_RECV;
 	wc->status = __rc_to_ib_wc_status(cqe->status);
 
@@ -3377,9 +3380,12 @@ static void bnxt_re_process_res_ud_wc(struct bnxt_re_qp *qp,
 		memcpy(wc->smac, cqe->smac, ETH_ALEN);
 		wc->wc_flags |= IB_WC_WITH_SMAC;
 		if (cqe->flags & CQ_RES_UD_FLAGS_META_FORMAT_VLAN) {
-			wc->vlan_id = (cqe->cfa_meta & 0xFFF);
-			if (wc->vlan_id < 0x1000)
-				wc->wc_flags |= IB_WC_WITH_VLAN;
+			vlan_id = (cqe->cfa_meta & 0xFFF);
+		}
+		/* Mark only if vlan_id is non zero */
+		if (vlan_id && bnxt_re_check_if_vlan_valid(rdev, vlan_id)) {
+			wc->vlan_id = vlan_id;
+			wc->wc_flags |= IB_WC_WITH_VLAN;
 		}
 		nw_type = (cqe->flags & CQ_RES_UD_FLAGS_ROCE_IP_VER_MASK) >>
 			   CQ_RES_UD_FLAGS_ROCE_IP_VER_SFT;
-- 
2.33.0


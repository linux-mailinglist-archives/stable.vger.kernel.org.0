Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EFF45C455
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348415AbhKXNrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:47:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:39062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349937AbhKXNpk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:45:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E81363311;
        Wed, 24 Nov 2021 13:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758833;
        bh=uTMo5c9LVjnrfYORMzyT2iHjZJ/DSDPlM+hpqxBkxmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r3GZ2tGA82AvWVuxpF12+MZfH850x9eWw5xHN48DHxwssMkTkbK89ec/2Khx1RuZ+
         0FHa2hYal0LdtuKnP/F9Oewa4kNeuN1h9eZe4vNsXI18ehNXLvMUoANtXsyBCYDLj3
         3fmoTsGWlZltxDsGR/K4XFFhU4vqwJOUG1aE8Ipk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/279] RDMA/bnxt_re: Check if the vlan is valid before reporting
Date:   Wed, 24 Nov 2021 12:55:04 +0100
Message-Id: <20211124115719.351297249@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 408dfbcc47b5e..b7ec3a3926785 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3354,8 +3354,11 @@ static void bnxt_re_process_res_ud_wc(struct bnxt_re_qp *qp,
 				      struct ib_wc *wc,
 				      struct bnxt_qplib_cqe *cqe)
 {
+	struct bnxt_re_dev *rdev;
+	u16 vlan_id = 0;
 	u8 nw_type;
 
+	rdev = qp->rdev;
 	wc->opcode = IB_WC_RECV;
 	wc->status = __rc_to_ib_wc_status(cqe->status);
 
@@ -3367,9 +3370,12 @@ static void bnxt_re_process_res_ud_wc(struct bnxt_re_qp *qp,
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




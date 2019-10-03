Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63DB9CA6F9
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405626AbfJCQtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:49:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405603AbfJCQtJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:49:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 306152070B;
        Thu,  3 Oct 2019 16:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121348;
        bh=uzBkc+s+9oH46cUKSh2Mhd08Dd+i7rdy0iLJBcc4poo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URj3y3oZazaV5AjccW5PIbnYIWoSOyUAAOt5nTxThOLvKXwpy7/h3UGD+B/3nJP2u
         RUzXG+qyfY8yNMvXIcW36qP1aGOUZ4xJyw/+OxGeHpq4an2z1SEij+Tz/zrz+8Xw5r
         JeerirMJzqT5FeC/fNRcra84gm0RyBE/ObPGJYUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.3 245/344] IB/hfi1: Do not update hcrc for a KDETH packet during fault injection
Date:   Thu,  3 Oct 2019 17:53:30 +0200
Message-Id: <20191003154604.580146981@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

commit b2590bdd0b1dfb91737e6cb07ebb47bd74957f7e upstream.

When a KDETH packet is subject to fault injection during transmission,
HCRC is supposed to be omitted from the packet so that the hardware on the
receiver side would drop the packet. When creating pbc, the PbcInsertHcrc
field is set to be PBC_IHCRC_NONE if the KDETH packet is subject to fault
injection, but overwritten with PBC_IHCRC_LKDETH when update_hcrc() is
called later.

This problem is fixed by not calling update_hcrc() when the packet is
subject to fault injection.

Fixes: 6b6cf9357f78 ("IB/hfi1: Set PbcInsertHcrc for TID RDMA packets")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190715164546.74174.99296.stgit@awfm-01.aw.intel.com
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/verbs.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -874,16 +874,17 @@ int hfi1_verbs_send_dma(struct rvt_qp *q
 			else
 				pbc |= (ib_is_sc5(sc5) << PBC_DC_INFO_SHIFT);
 
-			if (unlikely(hfi1_dbg_should_fault_tx(qp, ps->opcode)))
-				pbc = hfi1_fault_tx(qp, ps->opcode, pbc);
 			pbc = create_pbc(ppd,
 					 pbc,
 					 qp->srate_mbps,
 					 vl,
 					 plen);
 
-			/* Update HCRC based on packet opcode */
-			pbc = update_hcrc(ps->opcode, pbc);
+			if (unlikely(hfi1_dbg_should_fault_tx(qp, ps->opcode)))
+				pbc = hfi1_fault_tx(qp, ps->opcode, pbc);
+			else
+				/* Update HCRC based on packet opcode */
+				pbc = update_hcrc(ps->opcode, pbc);
 		}
 		tx->wqe = qp->s_wqe;
 		ret = build_verbs_tx_desc(tx->sde, len, tx, ahg_info, pbc);
@@ -1030,12 +1031,12 @@ int hfi1_verbs_send_pio(struct rvt_qp *q
 		else
 			pbc |= (ib_is_sc5(sc5) << PBC_DC_INFO_SHIFT);
 
+		pbc = create_pbc(ppd, pbc, qp->srate_mbps, vl, plen);
 		if (unlikely(hfi1_dbg_should_fault_tx(qp, ps->opcode)))
 			pbc = hfi1_fault_tx(qp, ps->opcode, pbc);
-		pbc = create_pbc(ppd, pbc, qp->srate_mbps, vl, plen);
-
-		/* Update HCRC based on packet opcode */
-		pbc = update_hcrc(ps->opcode, pbc);
+		else
+			/* Update HCRC based on packet opcode */
+			pbc = update_hcrc(ps->opcode, pbc);
 	}
 	if (cb)
 		iowait_pio_inc(&priv->s_iowait);



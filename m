Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE7D13FCE0
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390424AbgAPXTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:19:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:45422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389269AbgAPXTd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:19:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50FCB2075B;
        Thu, 16 Jan 2020 23:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216772;
        bh=xJ7HMBt6RmkJWNrpRkyRTuCm89+Csy5Me7E0fd2bQbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrMZSXV2WBC5epTh/cSvea0RDdswrACvSS0ozRSzYTRUvkqP+h87qMhXEJl9AcKi8
         4tY4S9M6kOBUC2H2tpVuwPVlAIhFAdGG1GJHlIGBX3Ww5ytxqNTu+MYeDWsaFvOoW/
         ZXf7LclMKOdsJJK072NTl7SQQGTOIPPLtLML2Mn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 005/203] RDMA/bnxt_re: Fix Send Work Entry state check while polling completions
Date:   Fri, 17 Jan 2020 00:15:22 +0100
Message-Id: <20200116231745.547213451@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Selvin Xavier <selvin.xavier@broadcom.com>

commit c5275723580922e5f3264f96751337661a153c7d upstream.

Some adapters need a fence Work Entry to handle retransmission.  Currently
the driver checks for this condition, only if the Send queue entry is
signalled. Implement the condition check, irrespective of the signalled
state of the Work queue entries

Failure to add the fence can result in access to memory that is already
marked as completed, triggering data corruption, transmission failure,
IOMMU failures, etc.

Fixes: 9152e0b722b2 ("RDMA/bnxt_re: HW workarounds for handling specific conditions")
Link: https://lore.kernel.org/r/1574671174-5064-3-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -2283,13 +2283,13 @@ static int bnxt_qplib_cq_process_req(str
 			/* Add qp to flush list of the CQ */
 			bnxt_qplib_add_flush_qp(qp);
 		} else {
+			/* Before we complete, do WA 9060 */
+			if (do_wa9060(qp, cq, cq_cons, sw_sq_cons,
+				      cqe_sq_cons)) {
+				*lib_qp = qp;
+				goto out;
+			}
 			if (swq->flags & SQ_SEND_FLAGS_SIGNAL_COMP) {
-				/* Before we complete, do WA 9060 */
-				if (do_wa9060(qp, cq, cq_cons, sw_sq_cons,
-					      cqe_sq_cons)) {
-					*lib_qp = qp;
-					goto out;
-				}
 				cqe->status = CQ_REQ_STATUS_OK;
 				cqe++;
 				(*budget)--;



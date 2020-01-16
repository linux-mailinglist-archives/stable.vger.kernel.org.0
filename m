Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCE613FEE1
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389619AbgAPX2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:28:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:60456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390442AbgAPX2C (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:28:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EDBD206D9;
        Thu, 16 Jan 2020 23:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217281;
        bh=k1xW4E0PnhvTwxAb+0h6nrBd+l2dC40n2yHqfbRZWxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hu++GIFJpeqw7/ROD8e+b3aFVj1zdW0okcFd002EvL+GwXXgZIm/H4jrtnEgI9Zsv
         Mb/C963L56DxiYDWatOWFteNFyZmijwd2SZuLPz2xqlCIeN+X4qyKMIGsBWx4hPhI8
         pVQ3U2UTV/0Lsk5K2g19dygawtz3SfnRz2OD2p24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.19 19/84] RDMA/bnxt_re: Fix Send Work Entry state check while polling completions
Date:   Fri, 17 Jan 2020 00:17:53 +0100
Message-Id: <20200116231715.935439547@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
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
@@ -2273,13 +2273,13 @@ static int bnxt_qplib_cq_process_req(str
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



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1618DF683
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730890AbfD3Lsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:48:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730882AbfD3Lsj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:48:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1D732054F;
        Tue, 30 Apr 2019 11:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624918;
        bh=MAfJJ0fkkrHOMc0koxXGYQDilkSV0Igey4Ef/k/QcAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rTdE47bFYEvYkWIWb3WK0sEirwATm6aIPP01DUogYvitW/SrHvntY6buYE+oPv9k7
         igDzQtZ0mPRYMFldVvHF+pBCGSvGbdMDDZM0ZfJvlo7jnwCaXBmFOgwvQZU9GHceFJ
         yMB7xVQykdhJcuBkPtFJxxcKQZET5/uo4PoNJFxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Josh Collier <josh.d.collier@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.0 22/89] IB/rdmavt: Fix frwr memory registration
Date:   Tue, 30 Apr 2019 13:38:13 +0200
Message-Id: <20190430113611.094943161@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Collier <josh.d.collier@intel.com>

commit 7c39f7f671d2acc0a1f39ebbbee4303ad499bbfa upstream.

Current implementation was not properly handling frwr memory
registrations. This was uncovered by commit 27f26cec761das ("xprtrdma:
Plant XID in on-the-wire RDMA offset (FRWR)") in which xprtrdma, which is
used for NFS over RDMA, started failing as it was the first ULP to modify
the ib_mr iova resulting in the NFS server getting REMOTE ACCESS ERROR
when attempting to perform RDMA Writes to the client.

The fix is to properly capture the true iova, offset, and length in the
call to ib_map_mr_sg, and then update the iova when processing the
IB_WR_REG_MEM on the send queue.

Fixes: a41081aa5936 ("IB/rdmavt: Add support for ib_map_mr_sg")
Cc: stable@vger.kernel.org
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Josh Collier <josh.d.collier@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/sw/rdmavt/mr.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -611,11 +611,6 @@ static int rvt_set_page(struct ib_mr *ib
 	if (unlikely(mapped_segs == mr->mr.max_segs))
 		return -ENOMEM;
 
-	if (mr->mr.length == 0) {
-		mr->mr.user_base = addr;
-		mr->mr.iova = addr;
-	}
-
 	m = mapped_segs / RVT_SEGSZ;
 	n = mapped_segs % RVT_SEGSZ;
 	mr->mr.map[m]->segs[n].vaddr = (void *)addr;
@@ -633,17 +628,24 @@ static int rvt_set_page(struct ib_mr *ib
  * @sg_nents: number of entries in sg
  * @sg_offset: offset in bytes into sg
  *
+ * Overwrite rvt_mr length with mr length calculated by ib_sg_to_pages.
+ *
  * Return: number of sg elements mapped to the memory region
  */
 int rvt_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
 		  int sg_nents, unsigned int *sg_offset)
 {
 	struct rvt_mr *mr = to_imr(ibmr);
+	int ret;
 
 	mr->mr.length = 0;
 	mr->mr.page_shift = PAGE_SHIFT;
-	return ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset,
-			      rvt_set_page);
+	ret = ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, rvt_set_page);
+	mr->mr.user_base = ibmr->iova;
+	mr->mr.iova = ibmr->iova;
+	mr->mr.offset = ibmr->iova - (u64)mr->mr.map[0]->segs[0].vaddr;
+	mr->mr.length = (size_t)ibmr->length;
+	return ret;
 }
 
 /**
@@ -674,6 +676,7 @@ int rvt_fast_reg_mr(struct rvt_qp *qp, s
 	ibmr->rkey = key;
 	mr->mr.lkey = key;
 	mr->mr.access_flags = access;
+	mr->mr.iova = ibmr->iova;
 	atomic_set(&mr->mr.lkey_invalid, 0);
 
 	return 0;



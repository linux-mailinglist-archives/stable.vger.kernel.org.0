Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B721D852C
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387694AbgERSRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:17:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731778AbgERR5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:57:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0382720715;
        Mon, 18 May 2020 17:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824642;
        bh=LMPH2QjOI+Enc5cMTVOmYGkwoFRvNBy3QoLbbmwcozk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FjP40WLsNlfzDC8Tfu17c3ciDhypdWIapZj8WqfmCfwhT3+j/mPZJRV1NGkEX4UTl
         +y0n6gc7mYhgenprwf0upwXm4cJukBdUmM5KipwfKYa8e+xFn1JGa3g/25famAYMR5
         9Y3Lk/XfsAPbCuWfYEm2xWQQ5oXGb9RAU07o8XKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 094/147] net/rds: Use ERR_PTR for rds_message_alloc_sgs()
Date:   Mon, 18 May 2020 19:36:57 +0200
Message-Id: <20200518173525.256011622@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit 7dba92037baf3fa00b4880a31fd532542264994c upstream.

Returning the error code via a 'int *ret' when the function returns a
pointer is very un-kernely and causes gcc 10's static analysis to choke:

net/rds/message.c: In function ‘rds_message_map_pages’:
net/rds/message.c:358:10: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  358 |   return ERR_PTR(ret);

Use a typical ERR_PTR return instead.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/rds/message.c |   19 ++++++-------------
 net/rds/rdma.c    |   12 ++++++++----
 net/rds/rds.h     |    3 +--
 net/rds/send.c    |    6 ++++--
 4 files changed, 19 insertions(+), 21 deletions(-)

--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -308,26 +308,20 @@ out:
 /*
  * RDS ops use this to grab SG entries from the rm's sg pool.
  */
-struct scatterlist *rds_message_alloc_sgs(struct rds_message *rm, int nents,
-					  int *ret)
+struct scatterlist *rds_message_alloc_sgs(struct rds_message *rm, int nents)
 {
 	struct scatterlist *sg_first = (struct scatterlist *) &rm[1];
 	struct scatterlist *sg_ret;
 
-	if (WARN_ON(!ret))
-		return NULL;
-
 	if (nents <= 0) {
 		pr_warn("rds: alloc sgs failed! nents <= 0\n");
-		*ret = -EINVAL;
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	if (rm->m_used_sgs + nents > rm->m_total_sgs) {
 		pr_warn("rds: alloc sgs failed! total %d used %d nents %d\n",
 			rm->m_total_sgs, rm->m_used_sgs, nents);
-		*ret = -ENOMEM;
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	sg_ret = &sg_first[rm->m_used_sgs];
@@ -343,7 +337,6 @@ struct rds_message *rds_message_map_page
 	unsigned int i;
 	int num_sgs = DIV_ROUND_UP(total_len, PAGE_SIZE);
 	int extra_bytes = num_sgs * sizeof(struct scatterlist);
-	int ret;
 
 	rm = rds_message_alloc(extra_bytes, GFP_NOWAIT);
 	if (!rm)
@@ -352,10 +345,10 @@ struct rds_message *rds_message_map_page
 	set_bit(RDS_MSG_PAGEVEC, &rm->m_flags);
 	rm->m_inc.i_hdr.h_len = cpu_to_be32(total_len);
 	rm->data.op_nents = DIV_ROUND_UP(total_len, PAGE_SIZE);
-	rm->data.op_sg = rds_message_alloc_sgs(rm, num_sgs, &ret);
-	if (!rm->data.op_sg) {
+	rm->data.op_sg = rds_message_alloc_sgs(rm, num_sgs);
+	if (IS_ERR(rm->data.op_sg)) {
 		rds_message_put(rm);
-		return ERR_PTR(ret);
+		return ERR_CAST(rm->data.op_sg);
 	}
 
 	for (i = 0; i < rm->data.op_nents; ++i) {
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -624,9 +624,11 @@ int rds_cmsg_rdma_args(struct rds_sock *
 	op->op_active = 1;
 	op->op_recverr = rs->rs_recverr;
 	WARN_ON(!nr_pages);
-	op->op_sg = rds_message_alloc_sgs(rm, nr_pages, &ret);
-	if (!op->op_sg)
+	op->op_sg = rds_message_alloc_sgs(rm, nr_pages);
+	if (IS_ERR(op->op_sg)) {
+		ret = PTR_ERR(op->op_sg);
 		goto out_pages;
+	}
 
 	if (op->op_notify || op->op_recverr) {
 		/* We allocate an uninitialized notifier here, because
@@ -828,9 +830,11 @@ int rds_cmsg_atomic(struct rds_sock *rs,
 	rm->atomic.op_silent = !!(args->flags & RDS_RDMA_SILENT);
 	rm->atomic.op_active = 1;
 	rm->atomic.op_recverr = rs->rs_recverr;
-	rm->atomic.op_sg = rds_message_alloc_sgs(rm, 1, &ret);
-	if (!rm->atomic.op_sg)
+	rm->atomic.op_sg = rds_message_alloc_sgs(rm, 1);
+	if (IS_ERR(rm->atomic.op_sg)) {
+		ret = PTR_ERR(rm->atomic.op_sg);
 		goto err;
+	}
 
 	/* verify 8 byte-aligned */
 	if (args->local_addr & 0x7) {
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -849,8 +849,7 @@ rds_conn_connecting(struct rds_connectio
 
 /* message.c */
 struct rds_message *rds_message_alloc(unsigned int nents, gfp_t gfp);
-struct scatterlist *rds_message_alloc_sgs(struct rds_message *rm, int nents,
-					  int *ret);
+struct scatterlist *rds_message_alloc_sgs(struct rds_message *rm, int nents);
 int rds_message_copy_from_user(struct rds_message *rm, struct iov_iter *from,
 			       bool zcopy);
 struct rds_message *rds_message_map_pages(unsigned long *page_addrs, unsigned int total_len);
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1274,9 +1274,11 @@ int rds_sendmsg(struct socket *sock, str
 
 	/* Attach data to the rm */
 	if (payload_len) {
-		rm->data.op_sg = rds_message_alloc_sgs(rm, num_sgs, &ret);
-		if (!rm->data.op_sg)
+		rm->data.op_sg = rds_message_alloc_sgs(rm, num_sgs);
+		if (IS_ERR(rm->data.op_sg)) {
+			ret = PTR_ERR(rm->data.op_sg);
 			goto out;
+		}
 		ret = rds_message_copy_from_user(rm, &msg->msg_iter, zcopy);
 		if (ret)
 			goto out;



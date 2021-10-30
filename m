Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6FC4408D7
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 14:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhJ3NAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 09:00:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229640AbhJ3NAY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Oct 2021 09:00:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84541604DA;
        Sat, 30 Oct 2021 12:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635598674;
        bh=315Xs1F/G1vuMu+QxT9RIkWuzwhW8c/OMrGtQTNu1GA=;
        h=Subject:To:Cc:From:Date:From;
        b=osM+ymaSAOQr55y6FpuX7Q98BIvbzdDypI/8/KrxorGCJ3ipsjuQ79vud+sliow/f
         rtZLHs43Lg3oFiKWgyjEJEh+B8nb9hCDvNNAoi1fgr6yUb+j39NPOmZCbHXHgNMKBM
         FkVmObtqUww5o0UmSwPg+JvTeBgxysZPCoSYNfp0=
Subject: FAILED: patch "[PATCH] IB/qib: Protect from buffer overflow in struct" failed to apply to 4.9-stable tree
To:     mike.marciniszyn@cornelisnetworks.com,
        dennis.dalessandro@cornelisnetworks.com, ivansprundel@ioactive.com,
        jgg@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Oct 2021 14:57:43 +0200
Message-ID: <16355986634248@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d39bf40e55e666b5905fdbd46a0dced030ce87be Mon Sep 17 00:00:00 2001
From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Date: Tue, 12 Oct 2021 13:55:19 -0400
Subject: [PATCH] IB/qib: Protect from buffer overflow in struct
 qib_user_sdma_pkt fields

Overflowing either addrlimit or bytes_togo can allow userspace to trigger
a buffer overflow of kernel memory. Check for overflows in all the places
doing math on user controlled buffers.

Fixes: f931551bafe1 ("IB/qib: Add new qib driver for QLogic PCIe InfiniBand adapters")
Link: https://lore.kernel.org/r/20211012175519.7298.77738.stgit@awfm-01.cornelisnetworks.com
Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
index a67599b5a550..ac11943a5ddb 100644
--- a/drivers/infiniband/hw/qib/qib_user_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -602,7 +602,7 @@ static int qib_user_sdma_coalesce(const struct qib_devdata *dd,
 /*
  * How many pages in this iovec element?
  */
-static int qib_user_sdma_num_pages(const struct iovec *iov)
+static size_t qib_user_sdma_num_pages(const struct iovec *iov)
 {
 	const unsigned long addr  = (unsigned long) iov->iov_base;
 	const unsigned long  len  = iov->iov_len;
@@ -658,7 +658,7 @@ static void qib_user_sdma_free_pkt_frag(struct device *dev,
 static int qib_user_sdma_pin_pages(const struct qib_devdata *dd,
 				   struct qib_user_sdma_queue *pq,
 				   struct qib_user_sdma_pkt *pkt,
-				   unsigned long addr, int tlen, int npages)
+				   unsigned long addr, int tlen, size_t npages)
 {
 	struct page *pages[8];
 	int i, j;
@@ -722,7 +722,7 @@ static int qib_user_sdma_pin_pkt(const struct qib_devdata *dd,
 	unsigned long idx;
 
 	for (idx = 0; idx < niov; idx++) {
-		const int npages = qib_user_sdma_num_pages(iov + idx);
+		const size_t npages = qib_user_sdma_num_pages(iov + idx);
 		const unsigned long addr = (unsigned long) iov[idx].iov_base;
 
 		ret = qib_user_sdma_pin_pages(dd, pq, pkt, addr,
@@ -824,8 +824,8 @@ static int qib_user_sdma_queue_pkts(const struct qib_devdata *dd,
 		unsigned pktnw;
 		unsigned pktnwc;
 		int nfrags = 0;
-		int npages = 0;
-		int bytes_togo = 0;
+		size_t npages = 0;
+		size_t bytes_togo = 0;
 		int tiddma = 0;
 		int cfur;
 
@@ -885,7 +885,11 @@ static int qib_user_sdma_queue_pkts(const struct qib_devdata *dd,
 
 			npages += qib_user_sdma_num_pages(&iov[idx]);
 
-			bytes_togo += slen;
+			if (check_add_overflow(bytes_togo, slen, &bytes_togo) ||
+			    bytes_togo > type_max(typeof(pkt->bytes_togo))) {
+				ret = -EINVAL;
+				goto free_pbc;
+			}
 			pktnwc += slen >> 2;
 			idx++;
 			nfrags++;
@@ -904,8 +908,7 @@ static int qib_user_sdma_queue_pkts(const struct qib_devdata *dd,
 		}
 
 		if (frag_size) {
-			int tidsmsize, n;
-			size_t pktsize;
+			size_t tidsmsize, n, pktsize, sz, addrlimit;
 
 			n = npages*((2*PAGE_SIZE/frag_size)+1);
 			pktsize = struct_size(pkt, addr, n);
@@ -923,14 +926,24 @@ static int qib_user_sdma_queue_pkts(const struct qib_devdata *dd,
 			else
 				tidsmsize = 0;
 
-			pkt = kmalloc(pktsize+tidsmsize, GFP_KERNEL);
+			if (check_add_overflow(pktsize, tidsmsize, &sz)) {
+				ret = -EINVAL;
+				goto free_pbc;
+			}
+			pkt = kmalloc(sz, GFP_KERNEL);
 			if (!pkt) {
 				ret = -ENOMEM;
 				goto free_pbc;
 			}
 			pkt->largepkt = 1;
 			pkt->frag_size = frag_size;
-			pkt->addrlimit = n + ARRAY_SIZE(pkt->addr);
+			if (check_add_overflow(n, ARRAY_SIZE(pkt->addr),
+					       &addrlimit) ||
+			    addrlimit > type_max(typeof(pkt->addrlimit))) {
+				ret = -EINVAL;
+				goto free_pbc;
+			}
+			pkt->addrlimit = addrlimit;
 
 			if (tiddma) {
 				char *tidsm = (char *)pkt + pktsize;


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCBE247549
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392386AbgHQTVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730483AbgHQPgG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:36:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17B3C20709;
        Mon, 17 Aug 2020 15:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678565;
        bh=S8A/it39F2Xxbb18KDIT5S6JazvoYNTFxzDnaFj+qk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OKfXu4p6OwxKKQc/AS7A9/3+/t7LCjvKlLjM6+xVRuqZKlzm9dIGyKPNFGOnR4ZAx
         /hKVEct3kS7AAvocaDjXMtr3KQUtYbdllSSEICMMu6h0tho8EeSwbwy5PhtmwutuBW
         tSdw9hxXDmRCj6atkAIsor4MMQF0mnjf9y1xX3Xo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 378/464] svcrdma: Fix page leak in svc_rdma_recv_read_chunk()
Date:   Mon, 17 Aug 2020 17:15:31 +0200
Message-Id: <20200817143851.880578368@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit e814eecbe3bbeaa8b004d25a4b8974d232b765a9 ]

Commit 07d0ff3b0cd2 ("svcrdma: Clean up Read chunk path") moved the
page saver logic so that it gets executed event when an error occurs.
In that case, the I/O is never posted, and those pages are then
leaked. Errors in this path, however, are quite rare.

Fixes: 07d0ff3b0cd2 ("svcrdma: Clean up Read chunk path")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_rw.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_rw.c b/net/sunrpc/xprtrdma/svc_rdma_rw.c
index 5eb35309ecef1..83806fa94def5 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -684,7 +684,6 @@ static int svc_rdma_build_read_chunk(struct svc_rqst *rqstp,
 				     struct svc_rdma_read_info *info,
 				     __be32 *p)
 {
-	unsigned int i;
 	int ret;
 
 	ret = -EINVAL;
@@ -707,12 +706,6 @@ static int svc_rdma_build_read_chunk(struct svc_rqst *rqstp,
 		info->ri_chunklen += rs_length;
 	}
 
-	/* Pages under I/O have been copied to head->rc_pages.
-	 * Prevent their premature release by svc_xprt_release() .
-	 */
-	for (i = 0; i < info->ri_readctxt->rc_page_count; i++)
-		rqstp->rq_pages[i] = NULL;
-
 	return ret;
 }
 
@@ -807,6 +800,26 @@ static int svc_rdma_build_pz_read_chunk(struct svc_rqst *rqstp,
 	return ret;
 }
 
+/* Pages under I/O have been copied to head->rc_pages. Ensure they
+ * are not released by svc_xprt_release() until the I/O is complete.
+ *
+ * This has to be done after all Read WRs are constructed to properly
+ * handle a page that is part of I/O on behalf of two different RDMA
+ * segments.
+ *
+ * Do this only if I/O has been posted. Otherwise, we do indeed want
+ * svc_xprt_release() to clean things up properly.
+ */
+static void svc_rdma_save_io_pages(struct svc_rqst *rqstp,
+				   const unsigned int start,
+				   const unsigned int num_pages)
+{
+	unsigned int i;
+
+	for (i = start; i < num_pages + start; i++)
+		rqstp->rq_pages[i] = NULL;
+}
+
 /**
  * svc_rdma_recv_read_chunk - Pull a Read chunk from the client
  * @rdma: controlling RDMA transport
@@ -860,6 +873,7 @@ int svc_rdma_recv_read_chunk(struct svcxprt_rdma *rdma, struct svc_rqst *rqstp,
 	ret = svc_rdma_post_chunk_ctxt(&info->ri_cc);
 	if (ret < 0)
 		goto out_err;
+	svc_rdma_save_io_pages(rqstp, 0, head->rc_page_count);
 	return 0;
 
 out_err:
-- 
2.25.1




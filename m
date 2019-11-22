Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B280106EDB
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbfKVK7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:59:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730921AbfKVK73 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:59:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E37E20721;
        Fri, 22 Nov 2019 10:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420368;
        bh=UAiA5p4GwIPMn4XuVsudYM5hQDLrQ1ON5FvGJrnxOCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ErhhWtZvP1L3/RlTrgdGc53D0IULmXfvqMyEsYkNWuuGI35YmV2AvK3I9hNZS5Yb
         0gvLZHsak6+AvzmXkdeE6ws29b6bF/xSd4YGDY2GSgnOiYEq5cDRnxc8f2Ff7ZHNaC
         XUHwUKmkcPN5OUiIj3DV85SRaIJSbpeJScoY1I6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhu Yanjun <yanjun.zhu@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 084/220] IB/rxe: avoid srq memory leak
Date:   Fri, 22 Nov 2019 11:27:29 +0100
Message-Id: <20191122100918.550307640@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>

[ Upstream commit aae0484e15f062ad2c2502e68e15dfb8b8f84608 ]

In rxe_queue_init, q and q->buf are allocated. In do_mmap_info, q->ip is
allocated. When error occurs, rxe_srq_from_init and the later error
handler do not free these allocated memories.  This will make memory leak.

Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_srq.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_srq.c b/drivers/infiniband/sw/rxe/rxe_srq.c
index 0d6c04ba7fc36..c41a5fee81f71 100644
--- a/drivers/infiniband/sw/rxe/rxe_srq.c
+++ b/drivers/infiniband/sw/rxe/rxe_srq.c
@@ -31,6 +31,7 @@
  * SOFTWARE.
  */
 
+#include <linux/vmalloc.h>
 #include "rxe.h"
 #include "rxe_loc.h"
 #include "rxe_queue.h"
@@ -129,13 +130,18 @@ int rxe_srq_from_init(struct rxe_dev *rxe, struct rxe_srq *srq,
 
 	err = do_mmap_info(rxe, uresp ? &uresp->mi : NULL, context, q->buf,
 			   q->buf_size, &q->ip);
-	if (err)
+	if (err) {
+		vfree(q->buf);
+		kfree(q);
 		return err;
+	}
 
 	if (uresp) {
 		if (copy_to_user(&uresp->srq_num, &srq->srq_num,
-				 sizeof(uresp->srq_num)))
+				 sizeof(uresp->srq_num))) {
+			rxe_queue_cleanup(q);
 			return -EFAULT;
+		}
 	}
 
 	return 0;
-- 
2.20.1




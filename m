Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D652613EF59
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393050AbgAPSOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:14:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:48758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393027AbgAPRev (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:34:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA93524683;
        Thu, 16 Jan 2020 17:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196090;
        bh=YjIDkagu2Kjrfvvq4dv7nIQnTBUOitovsfwiIT4GZvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XBTcagQys3ANPmkJrob8WnAabBr+O71Ug0vrXOuo9GL5dkJTSPce1E1veC2ENwH5g
         Zopj38gnQzE6qHVQYRynJyXHkYKSvelqqs0+XdgA3THeaAAVsa3IiR+hY4IKQujHKn
         mTgM2sxswvpWtYByh0RvxiMRTdGh0QkgcsLE3FF4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhu Yanjun <yanjun.zhu@oracle.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 004/251] IB/rxe: replace kvfree with vfree
Date:   Thu, 16 Jan 2020 12:30:38 -0500
Message-Id: <20200116173445.21385-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173445.21385-1-sashal@kernel.org>
References: <20200116173445.21385-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>

[ Upstream commit 721ad7e643f7002efa398838693f90284ea216d1 ]

The buf is allocated by vmalloc_user in the function rxe_queue_init.
So it is better to free it by vfree.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_cq.c | 4 ++--
 drivers/infiniband/sw/rxe/rxe_qp.c | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_cq.c b/drivers/infiniband/sw/rxe/rxe_cq.c
index e5e6a5e7dee9..5ac88412f1ff 100644
--- a/drivers/infiniband/sw/rxe/rxe_cq.c
+++ b/drivers/infiniband/sw/rxe/rxe_cq.c
@@ -30,7 +30,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-
+#include <linux/vmalloc.h>
 #include "rxe.h"
 #include "rxe_loc.h"
 #include "rxe_queue.h"
@@ -89,7 +89,7 @@ int rxe_cq_from_init(struct rxe_dev *rxe, struct rxe_cq *cq, int cqe,
 	err = do_mmap_info(rxe, udata, false, context, cq->queue->buf,
 			   cq->queue->buf_size, &cq->queue->ip);
 	if (err) {
-		kvfree(cq->queue->buf);
+		vfree(cq->queue->buf);
 		kfree(cq->queue);
 		return err;
 	}
diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 44b2108253bd..d6672127808b 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -34,6 +34,7 @@
 #include <linux/skbuff.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
+#include <linux/vmalloc.h>
 
 #include "rxe.h"
 #include "rxe_loc.h"
@@ -255,7 +256,7 @@ static int rxe_qp_init_req(struct rxe_dev *rxe, struct rxe_qp *qp,
 			   qp->sq.queue->buf_size, &qp->sq.queue->ip);
 
 	if (err) {
-		kvfree(qp->sq.queue->buf);
+		vfree(qp->sq.queue->buf);
 		kfree(qp->sq.queue);
 		return err;
 	}
@@ -312,7 +313,7 @@ static int rxe_qp_init_resp(struct rxe_dev *rxe, struct rxe_qp *qp,
 				   qp->rq.queue->buf_size,
 				   &qp->rq.queue->ip);
 		if (err) {
-			kvfree(qp->rq.queue->buf);
+			vfree(qp->rq.queue->buf);
 			kfree(qp->rq.queue);
 			return err;
 		}
-- 
2.20.1


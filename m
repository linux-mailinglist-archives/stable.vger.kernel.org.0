Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4345C344276
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbhCVMly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231707AbhCVMj6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:39:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50DAC6191C;
        Mon, 22 Mar 2021 12:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416726;
        bh=GMJF16qsdK+5u+CTfygQXU5eyl6YR52Ow+NCit75Mok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDyqKhgJ3a+M+j2siP62B/iwgSu32HZF+YX11hyPJ4phoknShpJ3Bngn68ZPfaUHg
         oaXafjfIeKFF5SjifF2i1lgg2IQTT8oaptSvqyRAPpGetvWIxnkCru6fbq2DeUSTNl
         34N5NVo83wR7fopV1rREwZZ2Tw329eZemz5UD7RM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/157] RDMA/rtrs: Introduce rtrs_post_send
Date:   Mon, 22 Mar 2021 13:27:07 +0100
Message-Id: <20210322121935.985698014@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

[ Upstream commit e6ab8cf50fa1c38652feba3e4921c60538236f30 ]

Since the three functions share the similar logic, let's introduce one
common function for it.

Link: https://lore.kernel.org/r/20201023074353.21946-12-jinpu.wang@cloud.ionos.com
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs.c | 52 +++++++++++-------------------
 1 file changed, 19 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs.c b/drivers/infiniband/ulp/rtrs/rtrs.c
index 8321e8a52045..97af8f0bb806 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs.c
@@ -104,6 +104,22 @@ int rtrs_post_recv_empty(struct rtrs_con *con, struct ib_cqe *cqe)
 }
 EXPORT_SYMBOL_GPL(rtrs_post_recv_empty);
 
+static int rtrs_post_send(struct ib_qp *qp, struct ib_send_wr *head,
+			     struct ib_send_wr *wr)
+{
+	if (head) {
+		struct ib_send_wr *tail = head;
+
+		while (tail->next)
+			tail = tail->next;
+		tail->next = wr;
+	} else {
+		head = wr;
+	}
+
+	return ib_post_send(qp, head, NULL);
+}
+
 int rtrs_iu_post_send(struct rtrs_con *con, struct rtrs_iu *iu, size_t size,
 		       struct ib_send_wr *head)
 {
@@ -126,17 +142,7 @@ int rtrs_iu_post_send(struct rtrs_con *con, struct rtrs_iu *iu, size_t size,
 		.send_flags = IB_SEND_SIGNALED,
 	};
 
-	if (head) {
-		struct ib_send_wr *tail = head;
-
-		while (tail->next)
-			tail = tail->next;
-		tail->next = &wr;
-	} else {
-		head = &wr;
-	}
-
-	return ib_post_send(con->qp, head, NULL);
+	return rtrs_post_send(con->qp, head, &wr);
 }
 EXPORT_SYMBOL_GPL(rtrs_iu_post_send);
 
@@ -168,17 +174,7 @@ int rtrs_iu_post_rdma_write_imm(struct rtrs_con *con, struct rtrs_iu *iu,
 		if (WARN_ON(sge[i].length == 0))
 			return -EINVAL;
 
-	if (head) {
-		struct ib_send_wr *tail = head;
-
-		while (tail->next)
-			tail = tail->next;
-		tail->next = &wr.wr;
-	} else {
-		head = &wr.wr;
-	}
-
-	return ib_post_send(con->qp, head, NULL);
+	return rtrs_post_send(con->qp, head, &wr.wr);
 }
 EXPORT_SYMBOL_GPL(rtrs_iu_post_rdma_write_imm);
 
@@ -195,17 +191,7 @@ int rtrs_post_rdma_write_imm_empty(struct rtrs_con *con, struct ib_cqe *cqe,
 		.ex.imm_data	= cpu_to_be32(imm_data),
 	};
 
-	if (head) {
-		struct ib_send_wr *tail = head;
-
-		while (tail->next)
-			tail = tail->next;
-		tail->next = &wr;
-	} else {
-		head = &wr;
-	}
-
-	return ib_post_send(con->qp, head, NULL);
+	return rtrs_post_send(con->qp, head, &wr);
 }
 EXPORT_SYMBOL_GPL(rtrs_post_rdma_write_imm_empty);
 
-- 
2.30.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17AFE276CFE
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 11:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgIXJZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 05:25:04 -0400
Received: from mo-csw1115.securemx.jp ([210.130.202.157]:34744 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgIXJZD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Sep 2020 05:25:03 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id 08O9OrZC025321; Thu, 24 Sep 2020 18:24:53 +0900
X-Iguazu-Qid: 2wHH7AleA0PL9OeyDB
X-Iguazu-QSIG: v=2; s=0; t=1600939493; q=2wHH7AleA0PL9OeyDB; m=An9iJbadtDY8i8Gv1u/rJ4UBk0iDlSe1tjW7JPQYc5Y=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1113) id 08O9OqvS034246;
        Thu, 24 Sep 2020 18:24:52 +0900
Received: from enc01.toshiba.co.jp ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 08O9Oqgt027489;
        Thu, 24 Sep 2020 18:24:52 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 08O9OpmY009296;
        Thu, 24 Sep 2020 18:24:52 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     Shamir Rabinovitch <shamir.rabinovitch@oracle.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.4, 4.9, 4.14] RDMA/ucma: ucma_context reference leak in error path
Date:   Thu, 24 Sep 2020 18:24:49 +0900
X-TSB-HOP: ON
Message-Id: <20200924092449.367288-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shamir Rabinovitch <shamir.rabinovitch@oracle.com>

commit ef95a90ae6f4f21990e1f7ced6719784a409e811 upstream.

Validating input parameters should be done before getting the cm_id
otherwise it can leak a cm_id reference.

Fixes: 6a21dfc0d0db ("RDMA/ucma: Limit possible option size")
Signed-off-by: Shamir Rabinovitch <shamir.rabinovitch@oracle.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
[iwamatsu: Backported to 4.4, 4.9 and 4.14: adjust context]
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/infiniband/core/ucma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 3e4d3d5560bf10..6315f77b4a58c1 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1295,13 +1295,13 @@ static ssize_t ucma_set_option(struct ucma_file *file, const char __user *inbuf,
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;

+	if (unlikely(cmd.optlen > KMALLOC_MAX_SIZE))
+		return -EINVAL;
+
 	ctx = ucma_get_ctx(file, cmd.id);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);

-	if (unlikely(cmd.optlen > KMALLOC_MAX_SIZE))
-		return -EINVAL;
-
 	optval = memdup_user((void __user *) (unsigned long) cmd.optval,
 			     cmd.optlen);
 	if (IS_ERR(optval)) {
--
2.28.0


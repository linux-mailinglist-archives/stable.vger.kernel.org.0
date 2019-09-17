Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5E92B4A83
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 11:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfIQJc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 05:32:58 -0400
Received: from smtpbgeu1.qq.com ([52.59.177.22]:33199 "EHLO smtpbgeu1.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbfIQJc5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Sep 2019 05:32:57 -0400
X-QQ-mid: bizesmtp20t1568712769tmk1xyg5
Received: from localhost.localdomain (unknown [218.76.23.26])
        by esmtp6.qq.com (ESMTP) with 
        id ; Tue, 17 Sep 2019 17:32:48 +0800 (CST)
X-QQ-SSF: 01400000000000R0YS90000D0000000
X-QQ-FEAT: mMUtqkfkmejiXdiN8n5ruR7st65az14ECTGjj7nRcPbdfM3Qa0zbMY6ejCsnh
        3ZTGozIFgLEJRfcD6fcmULAFTOqFuGrqBJhiUn11D35FYHLX0fQtnCLaIzyQE1hXZWlO0Jc
        WJaAjjF7CV9C//NrocPdGwXL5Ig9d6Me7o1UPkv2FcDdVxD6UHKgku2irYSix0aOYb6QvxB
        awgzAUUjhnbwPLSJXNxjZ9lGnzzODEDrPYqH8pTGbwtHZRHkoYHTAf7HlYq0TMEwagDumPB
        ab1eSlPF7GBU88BIYj1026Ooq0LrfYWUnuVfrAWLwv1+XlAVgewQ+ZVUgRUmFMJopyWog4h
        +VQ7Z8UvfUz8auf1lU46NLxeH7P0g2BxxeMy0MA
X-QQ-GoodBg: 2
From:   Jackie Liu <liuyun01@kylinos.cn>
To:     wangqi@kylinos.cn
Cc:     nh@kylinos.cn, Jason Gunthorpe <jgg@mellanox.com>,
        stable@vger.kernel.org, Jackie Liu <liuyun01@kylinos.cn>
Subject: [PATCH 3/4] CVE-2018-20855: IB/mlx5: Fix leaking stack memory to userspace
Date:   Tue, 17 Sep 2019 17:32:40 +0800
Message-Id: <1568712761-11089-3-git-send-email-liuyun01@kylinos.cn>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568712761-11089-1-git-send-email-liuyun01@kylinos.cn>
References: <1568712761-11089-1-git-send-email-liuyun01@kylinos.cn>
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:kylinos.cn:qybgforeign:qybgforeign1
X-QQ-Bgrelay: 1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

mlx5_ib_create_qp_resp was never initialized and only the first 4 bytes
were written.

Fixes: 41d902cb7c32 ("RDMA/mlx5: Fix definition of mlx5_ib_create_qp_resp")
Cc: <stable@vger.kernel.org>
Acked-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 drivers/infiniband/hw/mlx5/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index cfcfbb6..359d41e 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -861,7 +861,7 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 {
 	struct mlx5_ib_resources *devr = &dev->devr;
 	struct mlx5_core_dev *mdev = dev->mdev;
-	struct mlx5_ib_create_qp_resp resp;
+	struct mlx5_ib_create_qp_resp resp = {};
 	struct mlx5_create_qp_mbox_in *in;
 	struct mlx5_ib_create_qp ucmd;
 	int inlen = sizeof(*in);
-- 
2.7.4




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C82E205CD6
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388402AbgFWUFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:05:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387925AbgFWUFz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:05:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 094482078A;
        Tue, 23 Jun 2020 20:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942754;
        bh=nWg5h+sTNROnRDUYMcat2gC94nu3sVVVlTkRrjDfKRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lyLC8iPOjD63tXc5xm1qcxVnVhrz9oEh+CvpPFgqwnEOReHS2WMYE7idvfrL33ePy
         mxe6pJKULuLdEbov+g57kLiFIG9nI+GI4mooX4yPuv6EBhuqo7F48ELNHZksRhyvCr
         BDOTqAwzh2LxRW7vAqx1oypkH8+sghXN3NMCqazM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 122/477] RDMA/mlx5: Fix udata response upon SRQ creation
Date:   Tue, 23 Jun 2020 21:51:59 +0200
Message-Id: <20200623195413.373373938@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

[ Upstream commit cf26deff9036cd3270af562dbec545239e5c7f07 ]

Fix udata response upon SRQ creation to use the UAPI structure (i.e.
mlx5_ib_create_srq_resp). It did not zero the reserved field in userspace.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Link: https://lore.kernel.org/r/20200406173540.1466477-1-leon@kernel.org
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/srq.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index b1a8a91750400..6d1ff13d2283c 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -310,12 +310,18 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 	srq->msrq.event = mlx5_ib_srq_event;
 	srq->ibsrq.ext.xrc.srq_num = srq->msrq.srqn;
 
-	if (udata)
-		if (ib_copy_to_udata(udata, &srq->msrq.srqn, sizeof(__u32))) {
+	if (udata) {
+		struct mlx5_ib_create_srq_resp resp = {
+			.srqn = srq->msrq.srqn,
+		};
+
+		if (ib_copy_to_udata(udata, &resp, min(udata->outlen,
+				     sizeof(resp)))) {
 			mlx5_ib_dbg(dev, "copy to user failed\n");
 			err = -EFAULT;
 			goto err_core;
 		}
+	}
 
 	init_attr->attr.max_wr = srq->msrq.max - 1;
 
-- 
2.25.1




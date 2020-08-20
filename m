Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4B924BF70
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbgHTNjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:39:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728131AbgHTJaF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:30:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B92922CB1;
        Thu, 20 Aug 2020 09:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915803;
        bh=xyDZYkyPG1JpMD3a/x9ITUBO7mLGiopl2omnRGsYpl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VWI7xS5jfSbnsdYNFJKSZGPkUc1NIEHf0UXDleCqRkprE0+c4W/l0JR7sMceTE4Bw
         JcPWwa59qU96Eu1+fbydG87ODiMyqr2GB1XK1kYOJh89JW0ZMjOrAyEONekyI1+G4k
         zGJSyu1UIs4AtQQy2zsbPJYwhbzN7+A+AIAVFafQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markz@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 140/232] RDMA/counter: Only bind user QPs in auto mode
Date:   Thu, 20 Aug 2020 11:19:51 +0200
Message-Id: <20200820091619.606650918@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

[ Upstream commit c9f557421e505f75da4234a6af8eff46bc08614b ]

In auto mode only bind user QPs to a dynamic counter, since this feature
is mainly used for system statistic and diagnostic purpose, while there's
no need to counter kernel QPs so far.

Fixes: 99fa331dc862 ("RDMA/counter: Add "auto" configuration mode support")
Link: https://lore.kernel.org/r/20200702082933.424537-3-leon@kernel.org
Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/counters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index 738d1faf4bba5..6deb1901fbd02 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -288,7 +288,7 @@ int rdma_counter_bind_qp_auto(struct ib_qp *qp, u8 port)
 	struct rdma_counter *counter;
 	int ret;
 
-	if (!qp->res.valid)
+	if (!qp->res.valid || rdma_is_kernel_res(&qp->res))
 		return 0;
 
 	if (!rdma_is_port_valid(dev, port))
-- 
2.25.1




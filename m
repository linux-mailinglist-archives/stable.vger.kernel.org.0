Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E85537C2AC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbhELPNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:13:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233526AbhELPJr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:09:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8122C6144D;
        Wed, 12 May 2021 15:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831748;
        bh=2psFHHTfQUgg5dkhTzpcUZYg8i+H9p//21lE1i4VHvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l6QG2fWLliFvJyfT9O3WKXpwAHdIr8wxGB5XyF6IwwF8qy28JhH/QCUv2PmL6hAYk
         yKuLJUvfyvFdxm4VxW+LkPGIuIhLRIK00d2vYMDBn3QklEaEQR/TKnRTNANpy3cDGD
         fQmgmeWdGZiZFDq+nSSxT+9DveSRkSeWYu97+qdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Bernard Metzler <bmt@zurich.ihm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 232/244] RDMA/siw: Fix a use after free in siw_alloc_mr
Date:   Wed, 12 May 2021 16:50:03 +0200
Message-Id: <20210512144750.428222292@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit 3093ee182f01689b89e9f8797b321603e5de4f63 ]

Our code analyzer reported a UAF.

In siw_alloc_mr(), it calls siw_mr_add_mem(mr,..). In the implementation of
siw_mr_add_mem(), mem is assigned to mr->mem and then mem is freed via
kfree(mem) if xa_alloc_cyclic() failed. Here, mr->mem still point to a
freed object. After, the execution continue up to the err_out branch of
siw_alloc_mr, and the freed mr->mem is used in siw_mr_drop_mem(mr).

My patch moves "mr->mem = mem" behind the if (xa_alloc_cyclic(..)<0) {}
section, to avoid the uaf.

Fixes: 2251334dcac9 ("rdma/siw: application buffer management")
Link: https://lore.kernel.org/r/20210426011647.3561-1-lyl2019@mail.ustc.edu.cn
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Reviewed-by: Bernard Metzler <bmt@zurich.ihm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_mem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_mem.c b/drivers/infiniband/sw/siw/siw_mem.c
index e99983f07663..8bffa6e013fc 100644
--- a/drivers/infiniband/sw/siw/siw_mem.c
+++ b/drivers/infiniband/sw/siw/siw_mem.c
@@ -106,8 +106,6 @@ int siw_mr_add_mem(struct siw_mr *mr, struct ib_pd *pd, void *mem_obj,
 	mem->perms = rights & IWARP_ACCESS_MASK;
 	kref_init(&mem->ref);
 
-	mr->mem = mem;
-
 	get_random_bytes(&next, 4);
 	next &= 0x00ffffff;
 
@@ -116,6 +114,8 @@ int siw_mr_add_mem(struct siw_mr *mr, struct ib_pd *pd, void *mem_obj,
 		kfree(mem);
 		return -ENOMEM;
 	}
+
+	mr->mem = mem;
 	/* Set the STag index part */
 	mem->stag = id << 8;
 	mr->base_mr.lkey = mr->base_mr.rkey = mem->stag;
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03DC52E4149
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438979AbgL1OKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:10:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:44654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438976AbgL1OKO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:10:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E980206D8;
        Mon, 28 Dec 2020 14:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164573;
        bh=Y0bj8V92Eo1BPrmlUG9rIJXY31tSQks4F35z2s17nCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vuax8TmucU2hTaVCM0e03B2jE8PohzaX0LSk8S8lc6GCKDKsetRl6rBB7/XkaEkQK
         kN246gDi0Mcax0MXjRn/M3mgfbpl2azxL8Az9OIVuks6Sb6L1cClY6ELbEwx/s0JtW
         k3hfGIrkqNGsJa4EijeYJfd5deHb3kgW1N8bFmAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 223/717] RDMA/core: Track device memory MRs
Date:   Mon, 28 Dec 2020 13:43:41 +0100
Message-Id: <20201228125031.669807985@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit b47a98efa97889c5b16d17e77eed3dc4500674eb ]

Device memory (DM) are registered as MR during initialization flow, these
MRs were not tracked by resource tracker and had res->valid set as a
false. Update the code to manage them too.

Before this change:
$ ibv_rc_pingpong -j &
$ rdma res show mr <-- shows nothing

After this change:
$ ibv_rc_pingpong -j &
$ rdma res show mr
dev ibp0s9 mrn 0 mrlen 4096 pdn 3 pid 734 comm ibv_rc_pingpong

Fixes: be934cca9e98 ("IB/uverbs: Add device memory registration ioctl support")
Link: https://lore.kernel.org/r/20201117070148.1974114-2-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_std_types_mr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_std_types_mr.c b/drivers/infiniband/core/uverbs_std_types_mr.c
index 9b22bb553e8b3..dc58564417292 100644
--- a/drivers/infiniband/core/uverbs_std_types_mr.c
+++ b/drivers/infiniband/core/uverbs_std_types_mr.c
@@ -33,6 +33,7 @@
 #include "rdma_core.h"
 #include "uverbs.h"
 #include <rdma/uverbs_std_types.h>
+#include "restrack.h"
 
 static int uverbs_free_mr(struct ib_uobject *uobject,
 			  enum rdma_remove_reason why,
@@ -134,6 +135,9 @@ static int UVERBS_HANDLER(UVERBS_METHOD_DM_MR_REG)(
 	atomic_inc(&pd->usecnt);
 	atomic_inc(&dm->usecnt);
 
+	rdma_restrack_new(&mr->res, RDMA_RESTRACK_MR);
+	rdma_restrack_set_name(&mr->res, NULL);
+	rdma_restrack_add(&mr->res);
 	uobj->object = mr;
 
 	uverbs_finalize_uobj_create(attrs, UVERBS_ATTR_REG_DM_MR_HANDLE);
-- 
2.27.0




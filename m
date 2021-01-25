Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560E53033B1
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730668AbhAZFDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:03:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:39556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbhAYSwg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:52:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 998B72067B;
        Mon, 25 Jan 2021 18:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600716;
        bh=RUCFYYa4c8Zxln2KprdbBglr4rz5kiKsq80hQsHFOas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nr7P6q/twsqk1JAWau+a9mIiwlIblB3SbTld+WkEmuFybNsiLhRZJ7E9uf8lDwVcz
         hGxrjP7kPn5XUz4UR4KHOi0B9t383Lu8V9ZaoeS3ieipqv+n/k9VVABn506hSMfEjc
         VZnaqnpbIuUowioJrcuXVZrbLBbMDw0m5aqn+XA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aharon Landau <aharonl@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/199] RDMA/umem: Avoid undefined behavior of rounddown_pow_of_two()
Date:   Mon, 25 Jan 2021 19:38:35 +0100
Message-Id: <20210125183220.198705879@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

[ Upstream commit b79f2dc5ffe17b03ec8c55f0d63f65e87bcac676 ]

rounddown_pow_of_two() is undefined when the input is 0. Therefore we need
to avoid it in ib_umem_find_best_pgsz and return 0.  Otherwise, it could
result in not rejecting an invalid page size which eventually causes a
kernel oops due to the logical inconsistency.

Fixes: 3361c29e9279 ("RDMA/umem: Use simpler logic for ib_umem_find_best_pgsz()")
Link: https://lore.kernel.org/r/20210113121703.559778-2-leon@kernel.org
Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/umem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index e9fecbdf391bc..5157ae29a4460 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -126,7 +126,7 @@ unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
 	 */
 	if (mask)
 		pgsz_bitmap &= GENMASK(count_trailing_zeros(mask), 0);
-	return rounddown_pow_of_two(pgsz_bitmap);
+	return pgsz_bitmap ? rounddown_pow_of_two(pgsz_bitmap) : 0;
 }
 EXPORT_SYMBOL(ib_umem_find_best_pgsz);
 
-- 
2.27.0




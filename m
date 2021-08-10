Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEEE3E7FF9
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbhHJRpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:45:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234012AbhHJRnx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:43:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBFCB606A5;
        Tue, 10 Aug 2021 17:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617162;
        bh=XJBcsXSIRcusmHj+x5GP3rBMU2877z0rlhQN0e2SMvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBRyyjXudmEr1EQI1vq5OMWB34kltepa6cvcTfqaklhnh7WPsf/HnF6z2HW6km/eQ
         wZoKIlPV+Egax2i/I1dha0Z3ZhpWHPZ5eI8Dv6LY+wKKXI5ktn42g+mBG0G4KP/IKf
         gLDuBPESMop+vSzJJf/cV36+HcF9l2t7HdXlTYaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aharon Landau <aharonl@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/135] RDMA/mlx5: Delay emptying a cache entry when a new MR is added to it recently
Date:   Tue, 10 Aug 2021 19:29:32 +0200
Message-Id: <20210810172956.979317851@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

[ Upstream commit d6793ca97b76642b77629dd0783ec64782a50bdb ]

Fixing a typo that causes a cache entry to shrink immediately after adding
to it new MRs if the entry size exceeds the high limit.  In doing so, the
cache misses its purpose to prevent the creation of new mkeys on the
runtime by using the cached ones.

Fixes: b9358bdbc713 ("RDMA/mlx5: Fix locking in MR cache work queue")
Link: https://lore.kernel.org/r/fcb546986be346684a016f5ca23a0567399145fa.1627370131.git.leonro@nvidia.com
Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 971694e781b6..19346693c1da 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -526,8 +526,8 @@ static void __cache_work_func(struct mlx5_cache_ent *ent)
 		 */
 		spin_unlock_irq(&ent->lock);
 		need_delay = need_resched() || someone_adding(cache) ||
-			     time_after(jiffies,
-					READ_ONCE(cache->last_add) + 300 * HZ);
+			     !time_after(jiffies,
+					 READ_ONCE(cache->last_add) + 300 * HZ);
 		spin_lock_irq(&ent->lock);
 		if (ent->disabled)
 			goto out;
-- 
2.30.2




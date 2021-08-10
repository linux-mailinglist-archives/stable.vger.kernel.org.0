Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1053E8111
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235678AbhHJRzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236398AbhHJRww (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:52:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFE3361103;
        Tue, 10 Aug 2021 17:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617417;
        bh=z/PDpCbA74JLGEAHXEkXfauGbrRffLVIih0flNAO4RE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L6zhrQrBgKneddJmW2sM/ghwdoqIPNkvIAomKaGCjpx/qPGktB76iA+D3F96RaRuE
         f1/31areXflhpYGMxZjxnrRn9lKayTKCBBalTiVGEju1aiYaU//ZUkqLkS6MgX4ieh
         stTwbf/kF86sc4Hloz+PNQNEVQqdf49zBD1URMpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aharon Landau <aharonl@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 049/175] RDMA/mlx5: Delay emptying a cache entry when a new MR is added to it recently
Date:   Tue, 10 Aug 2021 19:29:17 +0200
Message-Id: <20210810173002.560193432@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
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
index 425423dfac72..fd113ddf6e86 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -530,8 +530,8 @@ static void __cache_work_func(struct mlx5_cache_ent *ent)
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




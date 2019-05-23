Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD78028992
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389644AbfEWTVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:21:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390251AbfEWTVX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:21:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E0AF21841;
        Thu, 23 May 2019 19:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639282;
        bh=6N8fhzPrYRvSgTF2+kpthjURSoMeS6rdVqEgNaWNgpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRPJQb4y38+2WUuYuOjQfSOGZiCn36iQ9nMga8P47mStOuf4ZxhQfL490MzZyFJOt
         I9oqn+sr8bJrsEHBT5eJIzGnIPGZNd3NwQpaeMW1ijlmvB+UlZ2InnSOenvvq095kE
         +Vygw06J9edLt9LhIwcsTL6VzrdSdJW3bGAA8ngk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>,
        Haggai Eran <haggaie@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH 5.0 047/139] RDMA/mlx5: Use get_zeroed_page() for clock_info
Date:   Thu, 23 May 2019 21:05:35 +0200
Message-Id: <20190523181726.804257772@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit ddcdc368b1033e19fd3a5f750752e10e28a87826 upstream.

get_zeroed_page() returns a virtual address for the page which is better
than allocating a struct page and doing a permanent kmap on it.

Cc: stable@vger.kernel.org
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Haggai Eran <haggaie@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/main.c                   |    5 ++-
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c |   30 +++++++-------------
 include/linux/mlx5/driver.h                         |    1 
 3 files changed, 14 insertions(+), 22 deletions(-)

--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1986,11 +1986,12 @@ static int mlx5_ib_mmap_clock_info_page(
 		return -EPERM;
 	vma->vm_flags &= ~VM_MAYWRITE;
 
-	if (!dev->mdev->clock_info_page)
+	if (!dev->mdev->clock_info)
 		return -EOPNOTSUPP;
 
 	return rdma_user_mmap_page(&context->ibucontext, vma,
-				   dev->mdev->clock_info_page, PAGE_SIZE);
+				   virt_to_page(dev->mdev->clock_info),
+				   PAGE_SIZE);
 }
 
 static int uar_mmap(struct mlx5_ib_dev *dev, enum mlx5_ib_mmap_cmd cmd,
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -535,23 +535,16 @@ void mlx5_init_clock(struct mlx5_core_de
 	do_div(ns, NSEC_PER_SEC / HZ);
 	clock->overflow_period = ns;
 
-	mdev->clock_info_page = alloc_page(GFP_KERNEL);
-	if (mdev->clock_info_page) {
-		mdev->clock_info = kmap(mdev->clock_info_page);
-		if (!mdev->clock_info) {
-			__free_page(mdev->clock_info_page);
-			mlx5_core_warn(mdev, "failed to map clock page\n");
-		} else {
-			mdev->clock_info->sign   = 0;
-			mdev->clock_info->nsec   = clock->tc.nsec;
-			mdev->clock_info->cycles = clock->tc.cycle_last;
-			mdev->clock_info->mask   = clock->cycles.mask;
-			mdev->clock_info->mult   = clock->nominal_c_mult;
-			mdev->clock_info->shift  = clock->cycles.shift;
-			mdev->clock_info->frac   = clock->tc.frac;
-			mdev->clock_info->overflow_period =
-						clock->overflow_period;
-		}
+	mdev->clock_info =
+		(struct mlx5_ib_clock_info *)get_zeroed_page(GFP_KERNEL);
+	if (mdev->clock_info) {
+		mdev->clock_info->nsec = clock->tc.nsec;
+		mdev->clock_info->cycles = clock->tc.cycle_last;
+		mdev->clock_info->mask = clock->cycles.mask;
+		mdev->clock_info->mult = clock->nominal_c_mult;
+		mdev->clock_info->shift = clock->cycles.shift;
+		mdev->clock_info->frac = clock->tc.frac;
+		mdev->clock_info->overflow_period = clock->overflow_period;
 	}
 
 	INIT_WORK(&clock->pps_info.out_work, mlx5_pps_out);
@@ -599,8 +592,7 @@ void mlx5_cleanup_clock(struct mlx5_core
 	cancel_delayed_work_sync(&clock->overflow_work);
 
 	if (mdev->clock_info) {
-		kunmap(mdev->clock_info_page);
-		__free_page(mdev->clock_info_page);
+		free_page((unsigned long)mdev->clock_info);
 		mdev->clock_info = NULL;
 	}
 
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -677,7 +677,6 @@ struct mlx5_core_dev {
 #endif
 	struct mlx5_clock        clock;
 	struct mlx5_ib_clock_info  *clock_info;
-	struct page             *clock_info_page;
 	struct mlx5_fw_tracer   *tracer;
 };
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCBEA2D0482
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgLFLqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:46:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727866AbgLFLpd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:45:33 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 37/46] net/mlx5: Fix wrong address reclaim when command interface is down
Date:   Sun,  6 Dec 2020 12:17:45 +0100
Message-Id: <20201206111558.245562509@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111556.455533723@linuxfoundation.org>
References: <20201206111556.455533723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eran Ben Elisha <eranbe@nvidia.com>

[ Upstream commit 1d2bb5ad89f47d8ce8aedc70ef85059ab3870292 ]

When command interface is down, driver to reclaim all 4K page chucks that
were hold by the Firmeware. Fix a bug for 64K page size systems, where
driver repeatedly released only the first chunk of the page.

Define helper function to fill 4K chunks for a given Firmware pages.
Iterate over all unreleased Firmware pages and call the hepler per each.

Fixes: 5adff6a08862 ("net/mlx5: Fix incorrect page count when in internal error")
Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c |   21 ++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -422,6 +422,24 @@ static void release_all_pages(struct mlx
 		      npages, ec_function, func_id);
 }
 
+static u32 fwp_fill_manage_pages_out(struct fw_page *fwp, u32 *out, u32 index,
+				     u32 npages)
+{
+	u32 pages_set = 0;
+	unsigned int n;
+
+	for_each_clear_bit(n, &fwp->bitmask, MLX5_NUM_4K_IN_PAGE) {
+		MLX5_ARRAY_SET64(manage_pages_out, out, pas, index + pages_set,
+				 fwp->addr + (n * MLX5_ADAPTER_PAGE_SIZE));
+		pages_set++;
+
+		if (!--npages)
+			break;
+	}
+
+	return pages_set;
+}
+
 static int reclaim_pages_cmd(struct mlx5_core_dev *dev,
 			     u32 *in, int in_size, u32 *out, int out_size)
 {
@@ -448,8 +466,7 @@ static int reclaim_pages_cmd(struct mlx5
 		fwp = rb_entry(p, struct fw_page, rb_node);
 		p = rb_next(p);
 
-		MLX5_ARRAY_SET64(manage_pages_out, out, pas, i, fwp->addr);
-		i++;
+		i += fwp_fill_manage_pages_out(fwp, out, i, npages - i);
 	}
 
 	MLX5_SET(manage_pages_out, out, output_num_entries, i);



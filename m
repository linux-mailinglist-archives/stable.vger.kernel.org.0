Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7E7468B19
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 14:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbhLENjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 08:39:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhLENjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 08:39:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045F6C061714
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 05:35:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E6B460FED
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 13:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408FBC341C1;
        Sun,  5 Dec 2021 13:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638711347;
        bh=6Gtv1pgBwso7BggHrk4JTD250hKo3JhFk8GTUy9an+0=;
        h=Subject:To:Cc:From:Date:From;
        b=L2WXb8A8SvbknAc7LIdojW+w6w4CPPJbXnNGZ3VK6yMI9BcfIzBcSYqOMLe1PwD3F
         dsprftx2d3I+wMZvl/jBGz9d/6Iu3DLdxksCAcil7ORZzvRXhtwxl7vszrIIXCLdAD
         HIWcIXMOOGk0GrZrutzzJpApgF+AZyqdEtSOGABA=
Subject: FAILED: patch "[PATCH] net/mlx4_en: Fix an use-after-free bug in" failed to apply to 4.9-stable tree
To:     zhou1615@umn.edu, kuba@kernel.org, leonro@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 05 Dec 2021 14:35:45 +0100
Message-ID: <1638711345432@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From addad7643142f500080417dd7272f49b7a185570 Mon Sep 17 00:00:00 2001
From: Zhou Qingyang <zhou1615@umn.edu>
Date: Wed, 1 Dec 2021 00:44:38 +0800
Subject: [PATCH] net/mlx4_en: Fix an use-after-free bug in
 mlx4_en_try_alloc_resources()

In mlx4_en_try_alloc_resources(), mlx4_en_copy_priv() is called and
tmp->tx_cq will be freed on the error path of mlx4_en_copy_priv().
After that mlx4_en_alloc_resources() is called and there is a dereference
of &tmp->tx_cq[t][i] in mlx4_en_alloc_resources(), which could lead to
a use after free problem on failure of mlx4_en_copy_priv().

Fix this bug by adding a check of mlx4_en_copy_priv()

This bug was found by a static analyzer. The analysis employs
differential checking to identify inconsistent security operations
(e.g., checks or kfrees) between two code paths and confirms that the
inconsistent operations are not recovered in the current function or
the callers, so they constitute bugs.

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

Builds with CONFIG_MLX4_EN=m show no new warnings,
and our static analyzer no longer warns about this code.

Fixes: ec25bc04ed8e ("net/mlx4_en: Add resilience in low memory systems")
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20211130164438.190591-1-zhou1615@umn.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 3f6d5c384637..f1c10f2bda78 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2286,9 +2286,14 @@ int mlx4_en_try_alloc_resources(struct mlx4_en_priv *priv,
 				bool carry_xdp_prog)
 {
 	struct bpf_prog *xdp_prog;
-	int i, t;
+	int i, t, ret;
 
-	mlx4_en_copy_priv(tmp, priv, prof);
+	ret = mlx4_en_copy_priv(tmp, priv, prof);
+	if (ret) {
+		en_warn(priv, "%s: mlx4_en_copy_priv() failed, return\n",
+			__func__);
+		return ret;
+	}
 
 	if (mlx4_en_alloc_resources(tmp)) {
 		en_warn(priv,


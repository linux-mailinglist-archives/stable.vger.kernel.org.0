Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64D52F7A89
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732847AbhAOMum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:50:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:42952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387823AbhAOMgH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:36:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56A00207C4;
        Fri, 15 Jan 2021 12:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714151;
        bh=DI5UL3pn0UfozUlu804hzO6HXm4kw6L72vj/b0BHaxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJcU0l7mGO3hV2YL8Vhvtnb/aszROTq20G4Zm+lBGB4wdubDnOb2SETzjzt373NxE
         GVeGT/kj/2eQCJf8f0bx1PavGRQgSY65B80MeoD3mbqeVEvN1ZJmCisa9DM+HyqaSi
         +8XLDRNWv7rJ8bNp0vD9kAmdxQW5sZ5wcK6YO6YI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.4 53/62] net/mlx5e: Fix memleak in mlx5e_create_l2_table_groups
Date:   Fri, 15 Jan 2021 13:28:15 +0100
Message-Id: <20210115122000.953360322@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

commit 5b0bb12c58ac7d22e05b5bfdaa30a116c8c32e32 upstream.

When mlx5_create_flow_group() fails, ft->g should be
freed just like when kvzalloc() fails. The caller of
mlx5e_create_l2_table_groups() does not catch this
issue on failure, which leads to memleak.

Fixes: 33cfaaa8f36f ("net/mlx5e: Split the main flow steering table")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1346,6 +1346,7 @@ err_destroy_groups:
 	ft->g[ft->num_groups] = NULL;
 	mlx5e_destroy_groups(ft);
 	kvfree(in);
+	kfree(ft->g);
 
 	return err;
 }



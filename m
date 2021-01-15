Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546132F7B50
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733107AbhAONA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:00:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733106AbhAOMdR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:33:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2D56238E3;
        Fri, 15 Jan 2021 12:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713982;
        bh=PJzgqFqKZVgFLlgeDp7lTZbFkIcGuHXKZypxC+ix11k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GVKN2VkSayjor7AKv3ESVoT/mLbJL4nk6mEsmh+/Lp+myPz8BKyxr23nCjT819ZcD
         rAhWmKpvHecDRQ5aZWWGHJ13tdfAsgCFtZQ8G1VCakszYFIvzU+hrWYEOHe6S9hWVT
         RldEZtYun4aV8v3DlLzh+dKmuVaImGI7edpic1to=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 4.19 37/43] net/mlx5e: Fix two double free cases
Date:   Fri, 15 Jan 2021 13:28:07 +0100
Message-Id: <20210115121958.840039375@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121957.037407908@linuxfoundation.org>
References: <20210115121957.037407908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

commit 7a6eb072a9548492ead086f3e820e9aac71c7138 upstream.

mlx5e_create_ttc_table_groups() frees ft->g on failure of
kvzalloc(), but such failure will be caught by its caller
in mlx5e_create_ttc_table() and ft->g will be freed again
in mlx5e_destroy_flow_table(). The same issue also occurs
in mlx5e_create_ttc_table_groups(). Set ft->g to NULL after
kfree() to avoid double free.

Fixes: 7b3722fa9ef6 ("net/mlx5e: Support RSS for GRE tunneled packets")
Fixes: 33cfaaa8f36f ("net/mlx5e: Split the main flow steering table")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -893,6 +893,7 @@ static int mlx5e_create_ttc_table_groups
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in) {
 		kfree(ft->g);
+		ft->g = NULL;
 		return -ENOMEM;
 	}
 
@@ -1033,6 +1034,7 @@ static int mlx5e_create_inner_ttc_table_
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in) {
 		kfree(ft->g);
+		ft->g = NULL;
 		return -ENOMEM;
 	}
 



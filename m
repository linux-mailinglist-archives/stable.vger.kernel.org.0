Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164C02F79AA
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387833AbhAOMjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:39:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:46982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388301AbhAOMj0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:39:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC7DA2256F;
        Fri, 15 Jan 2021 12:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714326;
        bh=iSaDCwOeyuyszWHk6CdzwGZ7Exb7zJFu4En/FhfE25A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ex5NBkys3uk3F8VlUThmMnybJ4C3TCEkrj66t1eVBz5jNV9LGASDHA6iRwpozsQHD
         EHVeICMA946sRF56JQLYEWx+i7IiFplxq6ZgLz1xq+EUm3UhH16LU5A2bez4dvwEmA
         oCg/ic2Dz4dkqt6eCK6TX19B3EjB29HmXZnOdpEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.10 085/103] net/mlx5e: Fix two double free cases
Date:   Fri, 15 Jan 2021 13:28:18 +0100
Message-Id: <20210115122010.129693003@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
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
@@ -936,6 +936,7 @@ static int mlx5e_create_ttc_table_groups
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in) {
 		kfree(ft->g);
+		ft->g = NULL;
 		return -ENOMEM;
 	}
 
@@ -1081,6 +1082,7 @@ static int mlx5e_create_inner_ttc_table_
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in) {
 		kfree(ft->g);
+		ft->g = NULL;
 		return -ENOMEM;
 	}
 



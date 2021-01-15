Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0792F7AC7
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732080AbhAOMyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:54:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:42246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387670AbhAOMfb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:35:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E60742333E;
        Fri, 15 Jan 2021 12:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714116;
        bh=3qj1XT4JF/OLljUzGJPB1ccTlERMnieAxKgwnFFaGKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NXHyMLOk/TjkagMUAcodXJLBVEjvNrGwlt5kswuNM2fCcT7Oc0dhuu+RZceHf7QMV
         9bkY+nx35/bUIbXBysA5LfA8ZHrjd7O64H+dv3MIv6I9BvWm7VIqVRTGmaFIMxu9oJ
         +yELRedRCJ87AbFvvhRiw1CZvqoECeSEwnh46gJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.4 54/62] net/mlx5e: Fix two double free cases
Date:   Fri, 15 Jan 2021 13:28:16 +0100
Message-Id: <20210115122001.001805010@linuxfoundation.org>
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
@@ -927,6 +927,7 @@ static int mlx5e_create_ttc_table_groups
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in) {
 		kfree(ft->g);
+		ft->g = NULL;
 		return -ENOMEM;
 	}
 
@@ -1067,6 +1068,7 @@ static int mlx5e_create_inner_ttc_table_
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in) {
 		kfree(ft->g);
+		ft->g = NULL;
 		return -ENOMEM;
 	}
 



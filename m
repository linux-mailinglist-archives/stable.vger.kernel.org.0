Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0CC2F7B86
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732274AbhAONCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:02:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:38812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730547AbhAOMc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:32:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E0C72336F;
        Fri, 15 Jan 2021 12:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713907;
        bh=KKI8c2MnX3T8Cm0yAMypUIKdS5rZfUM5pbM2z1a3cWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Esm9vDJTxF1aHESU0VTrBw7l18C29vTt/j1A+Ndaujgjyy41hwKsujIXDg+1mRaOd
         DIKDWT9seaHu0/suQcz4yTBDdfX5C+/eRwzCr7NC5Gaa+EAfKBzlTjgQE3QPBrmLL5
         Fd8j9zKGw6C6NwOZBUmTjDAaCXrop+kUHKsOLNUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 4.14 24/28] net/mlx5e: Fix two double free cases
Date:   Fri, 15 Jan 2021 13:28:01 +0100
Message-Id: <20210115121957.959826861@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121956.731354372@linuxfoundation.org>
References: <20210115121956.731354372@linuxfoundation.org>
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
@@ -961,6 +961,7 @@ static int mlx5e_create_inner_ttc_table_
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in) {
 		kfree(ft->g);
+		ft->g = NULL;
 		return -ENOMEM;
 	}
 
@@ -1181,6 +1182,7 @@ static int mlx5e_create_l2_table_groups(
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in) {
 		kfree(ft->g);
+		ft->g = NULL;
 		return -ENOMEM;
 	}
 



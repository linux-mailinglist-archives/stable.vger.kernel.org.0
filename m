Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19962F7B73
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732908AbhAOMcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:32:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:36246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732902AbhAOMcA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:32:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9BD42339D;
        Fri, 15 Jan 2021 12:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713905;
        bh=yyKG51TFr5nmyyBWUHygy67mu7D8MjIYdZJXAt2amRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K4vlsCG986xQT/iGOLIIDIcZPtyyiBZcVgfzsyA+DyZ7oRU6tfVCUVz9v4fm4aG59
         rnbNM6lveDS2KO/G+fePGOMgneie4FR1qAF93V6aPo94JU24mg07XjIHqwrc2qmDHQ
         sMJw9DzB8hGXptSLOdE6NNxB+B4DgttLlavwanDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 4.14 23/28] net/mlx5e: Fix memleak in mlx5e_create_l2_table_groups
Date:   Fri, 15 Jan 2021 13:28:00 +0100
Message-Id: <20210115121957.908836920@linuxfoundation.org>
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
@@ -1226,6 +1226,7 @@ err_destroy_groups:
 	ft->g[ft->num_groups] = NULL;
 	mlx5e_destroy_groups(ft);
 	kvfree(in);
+	kfree(ft->g);
 
 	return err;
 }



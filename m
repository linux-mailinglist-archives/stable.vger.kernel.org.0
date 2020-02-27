Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 483B3171D39
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389969AbgB0OTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:19:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389676AbgB0OTE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:19:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFB0F2468F;
        Thu, 27 Feb 2020 14:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813144;
        bh=OWTPxU+/A5iHErJHBufe6ko4/tT/IkEB8jQDEA3c+Po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WnytzcGkOaEDGh3QUp29ByYHooYFq0ZhvbtAAhn6fvIygIOVaVM1zX53oQ7UyCYQq
         ClvQyt37puiHICKGDlLUTYmreIu9A/S6Opkx32AsxrjDbgjfCGwa9y55a3O1dEKGMz
         V9VbH0EZjgu+dwlBtZPj/O0nV5w8kK9AKQGCHsSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.5 147/150] net/mlx5e: Fix crash in recovery flow without devlink reporter
Date:   Thu, 27 Feb 2020 14:38:04 +0100
Message-Id: <20200227132253.974805405@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

commit 1ad6c43c6a7b8627240c6cc19c69e31fedc596a7 upstream.

When health reporters are not supported, recovery function is invoked
directly, not via devlink health reporters.

In this direct flow, the recover function input parameter was passed
incorrectly and is causing a kernel oops. This patch is fixing the input
parameter.

Following call trace is observed on rx error health reporting.

Internal error: Oops: 96000007 [#1] PREEMPT SMP
Process kworker/u16:4 (pid: 4584, stack limit = 0x00000000c9e45703)
Call trace:
mlx5e_rx_reporter_err_rq_cqe_recover+0x30/0x164 [mlx5_core]
mlx5e_health_report+0x60/0x6c [mlx5_core]
mlx5e_reporter_rq_cqe_err+0x6c/0x90 [mlx5_core]
mlx5e_rq_err_cqe_work+0x20/0x2c [mlx5_core]
process_one_work+0x168/0x3d0
worker_thread+0x58/0x3d0
kthread+0x108/0x134

Fixes: c50de4af1d63 ("net/mlx5e: Generalize tx reporter's functionality")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/en/health.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -200,7 +200,7 @@ int mlx5e_health_report(struct mlx5e_pri
 	netdev_err(priv->netdev, err_str);
 
 	if (!reporter)
-		return err_ctx->recover(&err_ctx->ctx);
+		return err_ctx->recover(err_ctx->ctx);
 
 	return devlink_health_report(reporter, err_str, err_ctx);
 }



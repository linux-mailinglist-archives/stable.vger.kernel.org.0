Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF48F19909F
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbgCaJNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:13:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730454AbgCaJNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:13:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34CDC2072E;
        Tue, 31 Mar 2020 09:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645993;
        bh=/2L0WStGCXcbg6c7Vn/mg/6aE4n9UllFDT9nENybAmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wFUUuax1pC6dJtLy3rskZlqKFRKhLH3PQi+dNM5L/hDhVcsAKbny+porf+3BSsBvs
         QjT2Wi3OFtj/C6KGMgA2K0tScc+1D07QWA9jSbp1dkltZ+1yknHWSvDXk0zl9gkQvv
         3a2kRIYy/gIpRDC5IlYgeSiPMqx9Z6MN42zCnydE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hamdan Igbaria <hamdani@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.4 049/155] net/mlx5: DR, Fix postsend actions write length
Date:   Tue, 31 Mar 2020 10:58:09 +0200
Message-Id: <20200331085423.983029960@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hamdan Igbaria <hamdani@mellanox.com>

[ Upstream commit 692b0399a22530b2de8490bea75a7d20d59391d0 ]

Fix the send info write length to be (actions x action) size in bytes.

Fixes: 297cccebdc5a ("net/mlx5: DR, Expose an internal API to issue RDMA operations")
Signed-off-by: Hamdan Igbaria <hamdani@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c |    1 -
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c   |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -930,7 +930,6 @@ static int dr_actions_l2_rewrite(struct
 
 	action->rewrite.data = (void *)ops;
 	action->rewrite.num_of_actions = i;
-	action->rewrite.chunk->byte_size = i * sizeof(*ops);
 
 	ret = mlx5dr_send_postsend_action(dmn, action);
 	if (ret) {
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -558,7 +558,8 @@ int mlx5dr_send_postsend_action(struct m
 	int ret;
 
 	send_info.write.addr = (uintptr_t)action->rewrite.data;
-	send_info.write.length = action->rewrite.chunk->byte_size;
+	send_info.write.length = action->rewrite.num_of_actions *
+				 DR_MODIFY_ACTION_SIZE;
 	send_info.write.lkey = 0;
 	send_info.remote_addr = action->rewrite.chunk->mr_addr;
 	send_info.rkey = action->rewrite.chunk->rkey;



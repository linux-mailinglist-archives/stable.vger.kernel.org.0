Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A23A2F7966
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387740AbhAOMft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:35:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:42934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387738AbhAOMfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:35:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32631224F9;
        Fri, 15 Jan 2021 12:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714107;
        bh=abM/FdqvRGvXSce0XqSOJVe7ENalMwRf16m13G9y+bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thOhImtgbqxk4wcaXoNyJNOkzHVcccD+6PhTjjehXKBZwimLIkUIi2IrwaSPtdG+K
         1x16ONzghfsAU66C0ZpUvjBWJ9J6s0/Yqo1CJASYv4qDTPsZ40KkUryUFRsE+uTmE3
         CuhV2E4h8JbmIsMIxWuRjVK1JFMqhf0oME4gREJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markzhang@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.4 19/62] net/mlx5: Use port_num 1 instead of 0 when delete a RoCE address
Date:   Fri, 15 Jan 2021 13:27:41 +0100
Message-Id: <20210115121959.332308387@linuxfoundation.org>
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

From: Mark Zhang <markzhang@nvidia.com>

[ Upstream commit 0f2dcade69f2af56b74bce432e48ff3957830ce2 ]

In multi-port mode, FW reports syndrome 0x2ea48 (invalid vhca_port_number)
if the port_num is not 1 or 2.

Fixes: 80f09dfc237f ("net/mlx5: Eswitch, enable RoCE loopback traffic")
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
@@ -116,7 +116,7 @@ free:
 static void mlx5_rdma_del_roce_addr(struct mlx5_core_dev *dev)
 {
 	mlx5_core_roce_gid_set(dev, 0, 0, 0,
-			       NULL, NULL, false, 0, 0);
+			       NULL, NULL, false, 0, 1);
 }
 
 static void mlx5_rdma_make_default_gid(struct mlx5_core_dev *dev, union ib_gid *gid)



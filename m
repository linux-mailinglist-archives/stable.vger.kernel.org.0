Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA392F7A3F
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731846AbhAOMrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:47:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:44438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387982AbhAOMh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C874F235F9;
        Fri, 15 Jan 2021 12:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714233;
        bh=abM/FdqvRGvXSce0XqSOJVe7ENalMwRf16m13G9y+bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AuddtSFQO1KT3oOWkTlJ3sozw9HMmQwS83StWf+yLtsf+xDNLK1l6h88LM38k/WMb
         MrHchFGWhrZOKbqUlgHjDxFJmoDGDS2kALWNCNU0vRVyH/uHRATp2sbuZ1V7fj4aNu
         9FsxDEgLxK5QzgQWCpCIZBQz/mVpTOxmmB3mlN7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markzhang@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.10 044/103] net/mlx5: Use port_num 1 instead of 0 when delete a RoCE address
Date:   Fri, 15 Jan 2021 13:27:37 +0100
Message-Id: <20210115122008.190432822@linuxfoundation.org>
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



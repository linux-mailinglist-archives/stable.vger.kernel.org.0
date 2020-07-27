Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E7D22EEE4
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbgG0OLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:11:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729462AbgG0OLh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:11:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65FFE20838;
        Mon, 27 Jul 2020 14:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859096;
        bh=xktWI9fCSwXjPxNTjhqPpZdgrshtIPyzhmM3HwvBRKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iWLEP6upG5Dz/q1hcPwQII5uF100NQ0CTyzlP0fppA32+k6/ypBuuxcyN0h8NBYzs
         y/58vo040o74iEOadBZK2E9uofibE/vntFmDAR816ATBrRza34NUTlb8ptNN0JCcqi
         6CkMKkc/iB19In2jkad1QHeyq1g2t1vB2EU7Ur0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Jian <liujian56@huawei.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 34/86] mlxsw: destroy workqueue when trap_register in mlxsw_emad_init
Date:   Mon, 27 Jul 2020 16:04:08 +0200
Message-Id: <20200727134916.147556225@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
References: <20200727134914.312934924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit 5dbaeb87f2b309936be0aeae00cbc9e7f20ab296 ]

When mlxsw_core_trap_register fails in mlxsw_emad_init,
destroy_workqueue() shouled be called to destroy mlxsw_core->emad_wq.

Fixes: d965465b60ba ("mlxsw: core: Fix possible deadlock")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 2e6df5804b356..e180ec4f1a248 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -587,7 +587,7 @@ static int mlxsw_emad_init(struct mlxsw_core *mlxsw_core)
 	err = mlxsw_core_trap_register(mlxsw_core, &mlxsw_emad_rx_listener,
 				       mlxsw_core);
 	if (err)
-		return err;
+		goto err_trap_register;
 
 	err = mlxsw_core->driver->basic_trap_groups_set(mlxsw_core);
 	if (err)
@@ -599,6 +599,7 @@ static int mlxsw_emad_init(struct mlxsw_core *mlxsw_core)
 err_emad_trap_set:
 	mlxsw_core_trap_unregister(mlxsw_core, &mlxsw_emad_rx_listener,
 				   mlxsw_core);
+err_trap_register:
 	destroy_workqueue(mlxsw_core->emad_wq);
 	return err;
 }
-- 
2.25.1




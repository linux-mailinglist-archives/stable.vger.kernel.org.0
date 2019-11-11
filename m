Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3A0CF7D60
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730541AbfKKS4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:56:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:54256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730389AbfKKS4M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:56:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB86F20818;
        Mon, 11 Nov 2019 18:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498571;
        bh=sjLZBAzcI2tBfauyZGEYtWsLqWgYIqS9Vl/deyM0PPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ymbbcUoFDedAI/Ir8rjmXm2yvYs5oI6C/itIaN9EFEBDcROGgYt9baef1iY5ZXZ3A
         ec6ZJZdjkn9gazig+O6epp8MJ6e3NMtmMYarFckSh99ft3g9Foi0aPgmSekYYhY20P
         53wXHHWVIBwSMafi0oMPnQNc0cQfntjbVo6aq0E8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 108/193] net/mlx5: fix memory leak in mlx5_fw_fatal_reporter_dump
Date:   Mon, 11 Nov 2019 19:28:10 +0100
Message-Id: <20191111181509.095939043@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit c7ed6d0183d5ea9bc31bcaeeba4070bd62546471 ]

In mlx5_fw_fatal_reporter_dump if mlx5_crdump_collect fails the
allocated memory for cr_data must be released otherwise there will be
memory leak. To fix this, this commit changes the return instruction
into goto error handling.

Fixes: 9b1f29823605 ("net/mlx5: Add support for FW fatal reporter dump")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index d685122d9ff76..c07f3154437c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -572,7 +572,7 @@ mlx5_fw_fatal_reporter_dump(struct devlink_health_reporter *reporter,
 		return -ENOMEM;
 	err = mlx5_crdump_collect(dev, cr_data);
 	if (err)
-		return err;
+		goto free_data;
 
 	if (priv_ctx) {
 		struct mlx5_fw_reporter_ctx *fw_reporter_ctx = priv_ctx;
-- 
2.20.1




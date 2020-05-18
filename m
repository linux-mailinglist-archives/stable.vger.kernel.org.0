Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E091D8739
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgERSb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:31:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729182AbgERRkz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:40:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 700B32087D;
        Mon, 18 May 2020 17:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823654;
        bh=wqAq2HhOHtSM7NLL0bwtPXkoYRUSd/oZsyTma1y0pF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n7ejdc2ljDW1V/fL3doinggDs0JHNqcVlvQU5natPBL4i0bEiF+PlSMU/WudVkRkZ
         gskSohynRXms9FgOkUbShmfRleTmt3c/1eFdGTZ/xGLY/z1pzSbXgrpIbdDb3+pd0o
         Wjw0oTJP6UkH0NEhSLOFWx+sryEfB1oKPXXfoIWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gal Pressman <galp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 52/86] net/mlx5: Fix driver load error flow when firmware is stuck
Date:   Mon, 18 May 2020 19:36:23 +0200
Message-Id: <20200518173501.068720455@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gal Pressman <galp@mellanox.com>

[ Upstream commit 8ce59b16b4b6eacedaec1f7b652b4781cdbfe15f ]

When wait for firmware init fails, previous code would mistakenly
return success and cause inconsistency in the driver state.

Fixes: 6c780a0267b8 ("net/mlx5: Wait for FW readiness before initializing command interface")
Signed-off-by: Gal Pressman <galp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index bf4447581072f..e88605de84cca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -933,7 +933,7 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv)
 	if (err) {
 		dev_err(&dev->pdev->dev, "Firmware over %d MS in pre-initializing state, aborting\n",
 			FW_PRE_INIT_TIMEOUT_MILI);
-		goto out;
+		goto out_err;
 	}
 
 	err = mlx5_cmd_init(dev);
-- 
2.20.1




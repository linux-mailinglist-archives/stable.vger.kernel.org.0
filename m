Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1B8914BA36
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730969AbgA1OT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:19:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:44462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730963AbgA1OTy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:19:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E93A92071E;
        Tue, 28 Jan 2020 14:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221193;
        bh=D8fBwoZBDMUsrKEpYFRmpjicuXupUwfS+5KO69103g0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dhJChARiIQGnQC+fHifg1TdszMILFnvdNvSRiuEtGrXET/GLGuJin5qYgK2dfi5hL
         s2iLiWKWNc24P+U9SleQ+qxM1uReWhZBQ53FCFplVB9PZiibFk4I4ATOcNhJadVs9v
         G9V+aVbZO3NuHhb0I70HwDNAnzvsisL0jMJWd/YE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 127/271] IB/mlx5: Add missing XRC options to QP optional params mask
Date:   Tue, 28 Jan 2020 15:04:36 +0100
Message-Id: <20200128135902.050977654@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

[ Upstream commit 8f4426aa19fcdb9326ac44154a117b1a3a5ae126 ]

The QP transition optional parameters for the various transition for XRC
QPs are identical to those for RC QPs.

Many of the XRC QP transition optional parameter bits are missing from the
QP optional mask table.  These omissions caused failures when doing XRC QP
state transitions.

For example, when trying to change the response timer of an XRC receive QP
via the RTS2RTS transition, the new timer value was ignored because
MLX5_QP_OPTPAR_RNR_TIMEOUT bit was missing from the optional params mask
for XRC qps for the RTS2RTS transition.

Fix this by adding the missing XRC optional parameters for all QP
transitions to the opt_mask table.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Fixes: a4774e9095de ("IB/mlx5: Fix opt param mask according to firmware spec")
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index a7bc89f5dae7e..4d906a7904818 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2324,6 +2324,11 @@ static enum mlx5_qp_optpar opt_mask[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE][MLX5_Q
 			[MLX5_QP_ST_UD] = MLX5_QP_OPTPAR_PKEY_INDEX	|
 					  MLX5_QP_OPTPAR_Q_KEY		|
 					  MLX5_QP_OPTPAR_PRI_PORT,
+			[MLX5_QP_ST_XRC] = MLX5_QP_OPTPAR_RRE		|
+					  MLX5_QP_OPTPAR_RAE		|
+					  MLX5_QP_OPTPAR_RWE		|
+					  MLX5_QP_OPTPAR_PKEY_INDEX	|
+					  MLX5_QP_OPTPAR_PRI_PORT,
 		},
 		[MLX5_QP_STATE_RTR] = {
 			[MLX5_QP_ST_RC] = MLX5_QP_OPTPAR_ALT_ADDR_PATH  |
@@ -2357,6 +2362,12 @@ static enum mlx5_qp_optpar opt_mask[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE][MLX5_Q
 					  MLX5_QP_OPTPAR_RWE		|
 					  MLX5_QP_OPTPAR_PM_STATE,
 			[MLX5_QP_ST_UD] = MLX5_QP_OPTPAR_Q_KEY,
+			[MLX5_QP_ST_XRC] = MLX5_QP_OPTPAR_ALT_ADDR_PATH	|
+					  MLX5_QP_OPTPAR_RRE		|
+					  MLX5_QP_OPTPAR_RAE		|
+					  MLX5_QP_OPTPAR_RWE		|
+					  MLX5_QP_OPTPAR_PM_STATE	|
+					  MLX5_QP_OPTPAR_RNR_TIMEOUT,
 		},
 	},
 	[MLX5_QP_STATE_RTS] = {
@@ -2373,6 +2384,12 @@ static enum mlx5_qp_optpar opt_mask[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE][MLX5_Q
 			[MLX5_QP_ST_UD] = MLX5_QP_OPTPAR_Q_KEY		|
 					  MLX5_QP_OPTPAR_SRQN		|
 					  MLX5_QP_OPTPAR_CQN_RCV,
+			[MLX5_QP_ST_XRC] = MLX5_QP_OPTPAR_RRE		|
+					  MLX5_QP_OPTPAR_RAE		|
+					  MLX5_QP_OPTPAR_RWE		|
+					  MLX5_QP_OPTPAR_RNR_TIMEOUT	|
+					  MLX5_QP_OPTPAR_PM_STATE	|
+					  MLX5_QP_OPTPAR_ALT_ADDR_PATH,
 		},
 	},
 	[MLX5_QP_STATE_SQER] = {
@@ -2384,6 +2401,10 @@ static enum mlx5_qp_optpar opt_mask[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE][MLX5_Q
 					   MLX5_QP_OPTPAR_RWE		|
 					   MLX5_QP_OPTPAR_RAE		|
 					   MLX5_QP_OPTPAR_RRE,
+			[MLX5_QP_ST_XRC]  = MLX5_QP_OPTPAR_RNR_TIMEOUT	|
+					   MLX5_QP_OPTPAR_RWE		|
+					   MLX5_QP_OPTPAR_RAE		|
+					   MLX5_QP_OPTPAR_RRE,
 		},
 	},
 };
-- 
2.20.1




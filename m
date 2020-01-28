Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED34114B707
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbgA1OKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:10:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:59368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727129AbgA1OKd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:10:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 717DF22522;
        Tue, 28 Jan 2020 14:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220631;
        bh=pv1hu2EFHzRvnISsGUXaVLZ6f/q/Eeg8I5rNzw1c06Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7CYGAmhoevHZR25wvVlAPeoN+QUOr0FgwquXFlabB2zwMu7EYF0gsySdttpm0GBz
         cbxDv4F0HTjJ4Z8KKYcXcrV/1zHN6UR0dBf1WoLcjAFso0vY2wPiFcGOKkwgFlEzuX
         qZDEYa7ppVOS+guH5ub/H8jl7nhhNDe5DFNA6TQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 085/183] IB/mlx5: Add missing XRC options to QP optional params mask
Date:   Tue, 28 Jan 2020 15:05:04 +0100
Message-Id: <20200128135838.461808358@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
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
index 43d277a931c2a..eac5f5eff8d22 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1426,6 +1426,11 @@ static enum mlx5_qp_optpar opt_mask[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE][MLX5_Q
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
@@ -1459,6 +1464,12 @@ static enum mlx5_qp_optpar opt_mask[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE][MLX5_Q
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
@@ -1475,6 +1486,12 @@ static enum mlx5_qp_optpar opt_mask[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE][MLX5_Q
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
@@ -1486,6 +1503,10 @@ static enum mlx5_qp_optpar opt_mask[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE][MLX5_Q
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




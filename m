Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E78113E42C
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388975AbgAPRGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:06:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:37350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388974AbgAPRGn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:06:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A15D32081E;
        Thu, 16 Jan 2020 17:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194402;
        bh=FNOQzJoFt9NO9rWRNVNyBAn/A5LtMTkJ6NiP6s5cEcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=limP4l0d8wspYeu7np5jkieTw/t/Cid84yeDsxLGovkvjkBl6JdpYWufmxPrZSUmo
         r5eiP6xctmkDbcGreOr3+0KRKjqYeKibzHNd4SdS2FMxMSRtS8oN/1iLq6W6ExTocC
         NeuAypa/vfdUPY1f/kXIY6YCCcGM/OILn9Hfk9zI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 327/671] IB/mlx5: Add missing XRC options to QP optional params mask
Date:   Thu, 16 Jan 2020 11:59:25 -0500
Message-Id: <20200116170509.12787-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index ef0f710587ad..4c0f0ce02d2f 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2598,6 +2598,11 @@ static enum mlx5_qp_optpar opt_mask[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE][MLX5_Q
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
@@ -2631,6 +2636,12 @@ static enum mlx5_qp_optpar opt_mask[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE][MLX5_Q
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
@@ -2647,6 +2658,12 @@ static enum mlx5_qp_optpar opt_mask[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE][MLX5_Q
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
@@ -2658,6 +2675,10 @@ static enum mlx5_qp_optpar opt_mask[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE][MLX5_Q
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


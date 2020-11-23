Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324EC2C0977
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388327AbgKWNH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:07:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:34026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732868AbgKWMtI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:49:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95ED520732;
        Mon, 23 Nov 2020 12:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135746;
        bh=XJvUy6LFAHuMl7hB8fm3zdpt4TH3k4dbMbpzDvegX9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=le+olQs3Whut1EnQEvmBghM35RpbgNP5KEI50gO+ILK23ZfLmpePw5VM2y2xMHvmw
         isiZTkgKfBvWXS0rQRNmKeCK9cr/sWG6eozNiDI/8dCsh25vskySNCmf/otymhbkIu
         lox0bqSfqnHyCFusgfcD29CRdQCvCryCxH0JH+Q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 150/252] net/mlx5: E-Switch, Fail mlx5_esw_modify_vport_rate if qos disabled
Date:   Mon, 23 Nov 2020 13:21:40 +0100
Message-Id: <20201123121842.839312293@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit 5b8631c7b21ca8bc039f0bc030048973b039e0d2 ]

Avoid calling mlx5_esw_modify_vport_rate() if qos is not enabled and
avoid unnecessary syndrome messages from firmware.

Fixes: fcb64c0f5640 ("net/mlx5: E-Switch, add ingress rate support")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 5ad2308a2a6bd..d4ee0a9c03dbf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1142,6 +1142,10 @@ int mlx5_esw_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num,
 	struct mlx5_vport *vport;
 
 	vport = mlx5_eswitch_get_vport(esw, vport_num);
+
+	if (!vport->qos.enabled)
+		return -EOPNOTSUPP;
+
 	MLX5_SET(scheduling_context, ctx, max_average_bw, rate_mbps);
 
 	return mlx5_modify_scheduling_element_cmd(esw->dev,
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8052C0B1D
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732174AbgKWMjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:39:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732189AbgKWMjI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:39:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22D042065E;
        Mon, 23 Nov 2020 12:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135148;
        bh=PLnBiQZaP5+2vKe4PZ3YtGxZ5gwfrefsH5lvYP4jUlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YSkuHZd8P9uTDycYaYtBRZSpyLCQagkn/p/FmzirKZwMCLG7zNJcRxp8PYrZbVsMR
         OOML2F6HZpBkujbz7pfPtf6fFnHjtz9oO98wve1v+fR0LqOg1JV9Ids2uKw/COANgY
         yKTd2IU++NAvMoKWtpBpnlAjXa/4lm6n9PKcJqGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 092/158] net/mlx5: E-Switch, Fail mlx5_esw_modify_vport_rate if qos disabled
Date:   Mon, 23 Nov 2020 13:22:00 +0100
Message-Id: <20201123121824.369548870@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
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
index d2d407ebe6872..009d383d83f4b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1592,6 +1592,10 @@ int mlx5_esw_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num,
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




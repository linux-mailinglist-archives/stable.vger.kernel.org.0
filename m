Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE76C469F24
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391444AbhLFPpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390539AbhLFPma (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B05FC0698D1;
        Mon,  6 Dec 2021 07:28:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38ADF612D3;
        Mon,  6 Dec 2021 15:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9EBC34901;
        Mon,  6 Dec 2021 15:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804481;
        bh=g/9zHOtlX5PxU3M8G+NV5W9fhHNubtlpi5omzE3Y+Pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJTorl48mZf6ckFnYJs3EHWvbyOQSXhhhAOmwO1xw81e6Ms4SuhcyGxKs9NO7GK9Q
         APzD7V90hyVrqtDGs/NhDv9KXEci/6IrJTPiguqOu3BPTOd1FBvzgpQtfx6bl4BV6R
         wlsQY9dOL1rdrdnvL0nMaQXtuTZpn2CMz30e6Z/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Alaa Hleihel <alaa@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/207] net/mlx5e: Fix missing IPsec statistics on uplink representor
Date:   Mon,  6 Dec 2021 15:56:56 +0100
Message-Id: <20211206145615.879802994@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

[ Upstream commit 51ebf5db67f5c6aed79c05f1aa5137bdf5ca6614 ]

The cited patch added the IPsec support to uplink representor, however
as uplink representors have his private statistics where IPsec stats
is not part of it, that effectively makes IPsec stats hidden when uplink
representor stats queried.

Resolve by adding IPsec stats to uplink representor private statistics.

Fixes: 5589b8f1a2c7 ("net/mlx5e: Add IPsec support to uplink representor")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Alaa Hleihel <alaa@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 0684ac6699b2d..c100728c381cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1070,6 +1070,10 @@ static mlx5e_stats_grp_t mlx5e_ul_rep_stats_grps[] = {
 	&MLX5E_STATS_GRP(pme),
 	&MLX5E_STATS_GRP(channels),
 	&MLX5E_STATS_GRP(per_port_buff_congest),
+#ifdef CONFIG_MLX5_EN_IPSEC
+	&MLX5E_STATS_GRP(ipsec_sw),
+	&MLX5E_STATS_GRP(ipsec_hw),
+#endif
 };
 
 static unsigned int mlx5e_ul_rep_stats_grps_num(struct mlx5e_priv *priv)
-- 
2.33.0




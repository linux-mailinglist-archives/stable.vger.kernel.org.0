Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D2F396297
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbhEaO6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231693AbhEaO4F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:56:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCD9261CBB;
        Mon, 31 May 2021 14:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469607;
        bh=Pfm5elhLty2T0dvGkOYXa40LNca4aqBke3gcjM3Vgmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MnDC7eImJJ1fAqyEn8RyI2VQlboUp+yDgeBV/WH1Hd1dGSNqL8Te7wYwuvIKBcnK9
         mChOTWhsW8peufaBm1Jac0NrBFrP4vBZex6hpnjjqBVU33Bo4p+WMNmnOBdK781RTD
         5HOfCgeDC8BmsuIYcp3oyd2hMPnhpfPUTC2zwTOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 263/296] net/mlx5e: Reject mirroring on source port change encap rules
Date:   Mon, 31 May 2021 15:15:18 +0200
Message-Id: <20210531130712.590916301@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit 7d1a3d08c8a6398e7497a98cf3f7b73ea13d9939 ]

Rules with MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE dest flag are
translated to destination FT in eswitch. Currently it is not possible to
mirror such rules because firmware doesn't support mixing FT and Vport
destinations in single rule when one of them adds encapsulation. Since the
only use case for MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE destination is
support for tunnel endpoints on VF and trying to offload such rule with
mirror action causes either crash in fs_core or firmware error with
syndrome 0xff6a1d, reject all such rules in mlx5 TC layer.

Fixes: 10742efc20a4 ("net/mlx5e: VF tunnel TX traffic offloading")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2d28116be8d0..840cc9d8a2ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1353,6 +1353,12 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		esw_attr->dests[out_index].mdev = out_priv->mdev;
 	}
 
+	if (vf_tun && esw_attr->out_count > 1) {
+		NL_SET_ERR_MSG_MOD(extack, "VF tunnel encap with mirroring is not supported");
+		err = -EOPNOTSUPP;
+		goto err_out;
+	}
+
 	err = mlx5_eswitch_add_vlan_action(esw, attr);
 	if (err)
 		goto err_out;
-- 
2.30.2




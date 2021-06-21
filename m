Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EC03AEE85
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhFUQ3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:29:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230338AbhFUQ2Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:28:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59B6F611CE;
        Mon, 21 Jun 2021 16:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292608;
        bh=3yebqtSFo04ZF3moA16Tx2wVoONODRdt2MiuGFWWheY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NLdt52KdFpj6mYwJ/haCACkAj5JgIjTQe4XYjMPVmtD9eGiEJ4CSmA7il1YYV/R9G
         uGkeSpLh2+Lr9/KtUP4Ypl3u5dO27p1+fQeDyYP3sj0QX7GFgP1eOIjW1/iG97p9Rh
         WfQMOYiY2ASXrMU7iIA/YrqxeRbnTBAGZLAeMCLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuval Avnery <yuvalav@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Bodong Wang <bodong@nvidia.com>,
        Alaa Hleihel <alaa@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/146] net/mlx5: E-Switch, Allow setting GUID for host PF vport
Date:   Mon, 21 Jun 2021 18:14:53 +0200
Message-Id: <20210621154914.725600297@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit ca36fc4d77b35b8d142cf1ed0eae5ec2e071dc3c ]

E-switch should be able to set the GUID of host PF vport.
Currently it returns an error. This results in below error
when user attempts to configure MAC address of the PF of an
external controller.

$ devlink port function set pci/0000:03:00.0/196608 \
   hw_addr 00:00:00:11:22:33

mlx5_core 0000:03:00.0: mlx5_esw_set_vport_mac_locked:1876:(pid 6715):\
"Failed to set vport 0 node guid, err = -22.
RDMA_CM will not function properly for this VF."

Check for zero vport is no longer needed.

Fixes: 330077d14de1 ("net/mlx5: E-switch, Supporting setting devlink port function mac address")
Signed-off-by: Yuval Avnery <yuvalav@nvidia.com>
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Bodong Wang <bodong@nvidia.com>
Reviewed-by: Alaa Hleihel <alaa@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/vport.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index bdafc85fd874..fc91bbf7d0c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -464,8 +464,6 @@ int mlx5_modify_nic_vport_node_guid(struct mlx5_core_dev *mdev,
 	void *in;
 	int err;
 
-	if (!vport)
-		return -EINVAL;
 	if (!MLX5_CAP_GEN(mdev, vport_group_manager))
 		return -EACCES;
 
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D4E3AEE81
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbhFUQ3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:29:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231135AbhFUQ2S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:28:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24B3E613F6;
        Mon, 21 Jun 2021 16:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292603;
        bh=i94NsUeRymaRwMuzYSEeJB5OQm5sq6w2sx8vAc4VzAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qNwol7dmS0Y/iOOFoMu2OgjIgihS7S0UoayyOgTB+JeuAxoQYG08aa9IIDJ/zeLf7
         x9uzeO06JxTmdlC2hXR4OuGzhXN0LaL/ZFPhshnpk715L/IR96krOAd89YUMB39JTg
         LsQYNomhDKD2MhPhOgLTfCoopW4//YgkxdeE5b9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bodong Wang <bodong@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Alaa Hleihel <alaa@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/146] net/mlx5: E-Switch, Read PF mac address
Date:   Mon, 21 Jun 2021 18:14:52 +0200
Message-Id: <20210621154914.622731223@linuxfoundation.org>
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

[ Upstream commit bbc8222dc49db8d49add0f27bcac33f4b92193dc ]

External controller PF's MAC address is not read from the device during
vport setup. Fail to read this results in showing all zeros to user
while the factory programmed MAC is a valid value.

$ devlink port show eth1 -jp
{
    "port": {
        "pci/0000:03:00.0/196608": {
            "type": "eth",
            "netdev": "eth1",
            "flavour": "pcipf",
            "controller": 1,
            "pfnum": 0,
            "splittable": false,
            "function": {
                "hw_addr": "00:00:00:00:00:00"
            }
        }
    }
}

Hence, read it when enabling a vport.

After the fix,

$ devlink port show eth1 -jp
{
    "port": {
        "pci/0000:03:00.0/196608": {
            "type": "eth",
            "netdev": "eth1",
            "flavour": "pcipf",
            "controller": 1,
            "pfnum": 0,
            "splittable": false,
            "function": {
                "hw_addr": "98:03:9b:a0:60:11"
            }
        }
    }
}

Fixes: f099fde16db3 ("net/mlx5: E-switch, Support querying port function mac address")
Signed-off-by: Bodong Wang <bodong@nvidia.com>
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Alaa Hleihel <alaa@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index d61539b5567c..401b2f5128dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1302,6 +1302,12 @@ static int esw_enable_vport(struct mlx5_eswitch *esw, u16 vport_num,
 	    (!vport_num && mlx5_core_is_ecpf(esw->dev)))
 		vport->info.trusted = true;
 
+	/* External controller host PF has factory programmed MAC.
+	 * Read it from the device.
+	 */
+	if (mlx5_core_is_ecpf(esw->dev) && vport_num == MLX5_VPORT_PF)
+		mlx5_query_nic_vport_mac_address(esw->dev, vport_num, true, vport->info.mac);
+
 	esw_vport_change_handle_locked(vport);
 
 	esw->enabled_vports++;
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A521B0C27
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 15:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbgDTNAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 09:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727049AbgDTMkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:40:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C839206D4;
        Mon, 20 Apr 2020 12:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386420;
        bh=BsBpxgkA7LjJhrwwCzXt8Jh5HBzzAwGcfeocf8D40Fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KAAPTgeQSJwPnqB/tFBrwFjQ3S4/bOj/nLgSJcT1+/2qTNVPjm09Pp5zEvJXV6cwz
         BO5nBrCNMdkw0aUryEJtahvBs6oiLFVUqAqkuOHgD3CG+dkfCITYKKRCwo3OPZSYrF
         DMen7cgO5v2I8CwGnGkJdqFgHOjZ3qQI49f9eJns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.5 16/65] net/mlx5e: Fix pfnum in devlink port attribute
Date:   Mon, 20 Apr 2020 14:38:20 +0200
Message-Id: <20200420121509.759300620@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121505.909671922@linuxfoundation.org>
References: <20200420121505.909671922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit 7482d9cb5b974b7ad1a58fa8714f7a8c05b5d278 ]

Cited patch missed to extract PCI pf number accurately for PF and VF
port flavour. It considered PCI device + function number.
Due to this, device having non zero device number shown large pfnum.

Hence, use only PCI function number; to avoid similar errors, derive
pfnum one time for all port flavours.

Fixes: f60f315d339e ("net/mlx5e: Register devlink ports for physical link, PCI PF, VFs")
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1854,29 +1854,30 @@ static int register_devlink_port(struct
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
 	struct netdev_phys_item_id ppid = {};
 	unsigned int dl_port_index = 0;
+	u16 pfnum;
 
 	if (!is_devlink_port_supported(dev, rpriv))
 		return 0;
 
 	mlx5e_rep_get_port_parent_id(rpriv->netdev, &ppid);
+	pfnum = PCI_FUNC(dev->pdev->devfn);
 
 	if (rep->vport == MLX5_VPORT_UPLINK) {
 		devlink_port_attrs_set(&rpriv->dl_port,
 				       DEVLINK_PORT_FLAVOUR_PHYSICAL,
-				       PCI_FUNC(dev->pdev->devfn), false, 0,
+				       pfnum, false, 0,
 				       &ppid.id[0], ppid.id_len);
 		dl_port_index = vport_to_devlink_port_index(dev, rep->vport);
 	} else if (rep->vport == MLX5_VPORT_PF) {
 		devlink_port_attrs_pci_pf_set(&rpriv->dl_port,
 					      &ppid.id[0], ppid.id_len,
-					      dev->pdev->devfn);
+					      pfnum);
 		dl_port_index = rep->vport;
 	} else if (mlx5_eswitch_is_vf_vport(dev->priv.eswitch,
 					    rpriv->rep->vport)) {
 		devlink_port_attrs_pci_vf_set(&rpriv->dl_port,
 					      &ppid.id[0], ppid.id_len,
-					      dev->pdev->devfn,
-					      rep->vport - 1);
+					      pfnum, rep->vport - 1);
 		dl_port_index = vport_to_devlink_port_index(dev, rep->vport);
 	}
 



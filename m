Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B7A76DED
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387993AbfGZP0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387976AbfGZP0e (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:26:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5F97205F4;
        Fri, 26 Jul 2019 15:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154793;
        bh=5RYlE/PzhWIeGqoHSSU1wVSgtVIkc9GzHbSiCAM3ggQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cgR06q82NieOUp/AP5s+psE6ztcMW/DsmFVdEzuiSqb/Wa40fZb0oWlyPoDJmkbjo
         FWQVcHSvaMhYlGerFTR0foNo+JfCsShm2xKAu+TRiYISnaFAPRzSlNw/agsZjlGOuR
         gAkhEbWX75Z8GZacwJzixSTLP79pCTvZsdeD4tvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.2 27/66] net/mlx5e: IPoIB, Add error path in mlx5_rdma_setup_rn
Date:   Fri, 26 Jul 2019 17:24:26 +0200
Message-Id: <20190726152304.743696965@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

[ Upstream commit ef1ce7d7b67b46661091c7ccc0396186b7a247ef ]

Check return value from mlx5e_attach_netdev, add error path on failure.

Fixes: 48935bbb7ae8 ("net/mlx5e: IPoIB, Add netdevice profile skeleton")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Feras Daoud <ferasda@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -698,7 +698,9 @@ static int mlx5_rdma_setup_rn(struct ib_
 
 	prof->init(mdev, netdev, prof, ipriv);
 
-	mlx5e_attach_netdev(epriv);
+	err = mlx5e_attach_netdev(epriv);
+	if (err)
+		goto detach;
 	netif_carrier_off(netdev);
 
 	/* set rdma_netdev func pointers */
@@ -714,6 +716,11 @@ static int mlx5_rdma_setup_rn(struct ib_
 
 	return 0;
 
+detach:
+	prof->cleanup(epriv);
+	if (ipriv->sub_interface)
+		return err;
+	mlx5e_destroy_mdev_resources(mdev);
 destroy_ht:
 	mlx5i_pkey_qpn_ht_cleanup(netdev);
 	return err;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC8EC76DDF
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387400AbfGZP3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:29:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387845AbfGZP3r (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:29:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D51FC22CBE;
        Fri, 26 Jul 2019 15:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154986;
        bh=5RYlE/PzhWIeGqoHSSU1wVSgtVIkc9GzHbSiCAM3ggQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oamyHRpfBF8Dor70wbCcvHJoOipxj2tVKc2Kmr24l8kOlGO3FY4n4MEhDkfGA+b8B
         seFu6jUMfnXUZvSKS6rq6CvuflwIkVV0MMTi324AO1nCE2tsXcX56Ny3wOcOjumIr6
         f/3LKBXVjZDFhmpb8o0W9DszaOGvgNhPUdlUdGCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.1 27/62] net/mlx5e: IPoIB, Add error path in mlx5_rdma_setup_rn
Date:   Fri, 26 Jul 2019 17:24:39 +0200
Message-Id: <20190726152304.567036815@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.720139286@linuxfoundation.org>
References: <20190726152301.720139286@linuxfoundation.org>
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



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E803F1A510C
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgDKMTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728883AbgDKMTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:19:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CFD820787;
        Sat, 11 Apr 2020 12:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607592;
        bh=xppe7L99I5fyzlcJPPlSvogip0y4o8EV2liitqiwtA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNqNzImdn+u6iMEfHUMsnKmTEqw7ekYrlGjW4aRc1UbDw/NUFQFoOyj7PoqUJS0ay
         JGdJW7KPsd2D1cmxKjvE/acdR5/PfvMSlhIAjoPFsj/te67H6nnsWmyaS6tVkaFy1I
         cuhpArCSqCHDxpGQWNlxTeoS24bv7NLavpbOSQsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Vesker <valex@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.5 40/44] IB/mlx5: Replace tunnel mpls capability bits for tunnel_offloads
Date:   Sat, 11 Apr 2020 14:10:00 +0200
Message-Id: <20200411115500.804691427@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115456.934174282@linuxfoundation.org>
References: <20200411115456.934174282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

commit 41e684ef3f37ce6e5eac3fb5b9c7c1853f4b0447 upstream.

Until now the flex parser capability was used in ib_query_device() to
indicate tunnel_offloads_caps support for mpls_over_gre/mpls_over_udp.

Newer devices and firmware will have configurations with the flexparser
but without mpls support.

Testing for the flex parser capability was a mistake, the tunnel_stateless
capability was intended for detecting mpls and was introduced at the same
time as the flex parser capability.

Otherwise userspace will be incorrectly informed that a future device
supports MPLS when it does not.

Link: https://lore.kernel.org/r/20200305123841.196086-1-leon@kernel.org
Cc: <stable@vger.kernel.org> # 4.17
Fixes: e818e255a58d ("IB/mlx5: Expose MPLS related tunneling offloads")
Signed-off-by: Alex Vesker <valex@mellanox.com>
Reviewed-by: Ariel Levkovich <lariel@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/main.c |    6 ++----
 include/linux/mlx5/mlx5_ifc.h     |    6 +++++-
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1175,12 +1175,10 @@ static int mlx5_ib_query_device(struct i
 		if (MLX5_CAP_ETH(mdev, tunnel_stateless_gre))
 			resp.tunnel_offloads_caps |=
 				MLX5_IB_TUNNELED_OFFLOADS_GRE;
-		if (MLX5_CAP_GEN(mdev, flex_parser_protocols) &
-		    MLX5_FLEX_PROTO_CW_MPLS_GRE)
+		if (MLX5_CAP_ETH(mdev, tunnel_stateless_mpls_over_gre))
 			resp.tunnel_offloads_caps |=
 				MLX5_IB_TUNNELED_OFFLOADS_MPLS_GRE;
-		if (MLX5_CAP_GEN(mdev, flex_parser_protocols) &
-		    MLX5_FLEX_PROTO_CW_MPLS_UDP)
+		if (MLX5_CAP_ETH(mdev, tunnel_stateless_mpls_over_udp))
 			resp.tunnel_offloads_caps |=
 				MLX5_IB_TUNNELED_OFFLOADS_MPLS_UDP;
 	}
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -857,7 +857,11 @@ struct mlx5_ifc_per_protocol_networking_
 	u8         swp_csum[0x1];
 	u8         swp_lso[0x1];
 	u8         cqe_checksum_full[0x1];
-	u8         reserved_at_24[0x5];
+	u8         tunnel_stateless_geneve_tx[0x1];
+	u8         tunnel_stateless_mpls_over_udp[0x1];
+	u8         tunnel_stateless_mpls_over_gre[0x1];
+	u8         tunnel_stateless_vxlan_gpe[0x1];
+	u8         tunnel_stateless_ipv4_over_vxlan[0x1];
 	u8         tunnel_stateless_ip_over_ip[0x1];
 	u8         reserved_at_2a[0x6];
 	u8         max_vxlan_udp_ports[0x8];



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B54F56A1
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391810AbfKHTJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:09:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:42008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391825AbfKHTJ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:09:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80E062196F;
        Fri,  8 Nov 2019 19:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240198;
        bh=oDbZB7orneX006l4dQrazAI3AMgWkUEeoDS5nYSAriU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jcMnwfl84vdrXID4t8qBUrTIae9rDxGnOoaIIilOJNXjBmGVQ/j1xyVFzcXEtwDUX
         79JPocC52zAmUH2klSYb5gCeCJCA+69qt3SGEFHNUGGfVWqb+YO37tMzaD958utb/8
         fqgCAWxtkcyrQfkHXpRWjxu2aHZU6IPfhrzj0eAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.3 115/140] net/mlx5: Fix rtable reference leak
Date:   Fri,  8 Nov 2019 19:50:43 +0100
Message-Id: <20191108174912.063099581@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

[ Upstream commit 2347cee83b2bd868bde2d283db0fac89f22be4e0 ]

If the rt entry gateway family is not AF_INET for multipath device,
rtable reference is leaked.
Hence, fix it by releasing the reference.

Fixes: 5fb091e8130b ("net/mlx5e: Use hint to resolve route when in HW multipath mode")
Fixes: e32ee6c78efa ("net/mlx5e: Support tunnel encap over tagged Ethernet")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -90,15 +90,19 @@ static int mlx5e_route_lookup_ipv4(struc
 	if (ret)
 		return ret;
 
-	if (mlx5_lag_is_multipath(mdev) && rt->rt_gw_family != AF_INET)
+	if (mlx5_lag_is_multipath(mdev) && rt->rt_gw_family != AF_INET) {
+		ip_rt_put(rt);
 		return -ENETUNREACH;
+	}
 #else
 	return -EOPNOTSUPP;
 #endif
 
 	ret = get_route_and_out_devs(priv, rt->dst.dev, route_dev, out_dev);
-	if (ret < 0)
+	if (ret < 0) {
+		ip_rt_put(rt);
 		return ret;
+	}
 
 	if (!(*out_ttl))
 		*out_ttl = ip4_dst_hoplimit(&rt->dst);
@@ -142,8 +146,10 @@ static int mlx5e_route_lookup_ipv6(struc
 		*out_ttl = ip6_dst_hoplimit(dst);
 
 	ret = get_route_and_out_devs(priv, dst->dev, route_dev, out_dev);
-	if (ret < 0)
+	if (ret < 0) {
+		dst_release(dst);
 		return ret;
+	}
 #else
 	return -EOPNOTSUPP;
 #endif



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73FEB289A2
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389456AbfEWTUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:20:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389713AbfEWTUv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:20:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8FDD205ED;
        Thu, 23 May 2019 19:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639250;
        bh=bFFi6EOSIOQFkTu+2YVu3dVQ+FAQreGRg6gIFGWumq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fX7qr0qYBDQIb5XkthosZKFIeYdj2OCHAqKU9HlBEx7b0MPTazbBG7oW5tM7MxcqP
         jnVHCqL9FcYUTCjjnJM68GvVlGvWAgBC2x14DIzf3bh9buSZCI18oIsNqvKfjSh7Mh
         pJGi/g1NEheRtEe87mJ4GbJV7zfFn29zwoKpBL6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.0 017/139] net/mlx5: Imply MLXFW in mlx5_core
Date:   Thu, 23 May 2019 21:05:05 +0200
Message-Id: <20190523181722.797435365@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>

[ Upstream commit bad861f31bb15a99becef31aab59640eaeb247e2 ]

mlxfw can be compiled as external module while mlx5_core can be
builtin, in such case mlx5 will act like mlxfw is disabled.

Since mlxfw is just a service library for mlx* drivers,
imply it in mlx5_core to make it always reachable if it was enabled.

Fixes: 3ffaabecd1a1 ("net/mlx5e: Support the flash device ethtool callback")
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -8,6 +8,7 @@ config MLX5_CORE
 	depends on PCI
 	imply PTP_1588_CLOCK
 	imply VXLAN
+	imply MLXFW
 	default n
 	---help---
 	  Core driver for low level functionality of the ConnectX-4 and



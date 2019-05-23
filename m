Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCF328876
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389967AbfEWT0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:26:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391362AbfEWT0c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:26:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51FE72054F;
        Thu, 23 May 2019 19:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639591;
        bh=n6s3IH4aHVsyV1IC6V4r+732vbgmcAV58aY8KqxAqj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZ1VH8/ZvWJ4aIpD2Iklij11tMD7xgsN4cAPqbJFAQUWZTMJiBof9Bt2gZF7RrmYc
         2fZm5CVWiGjDf9ZTbMyOpAusMIhyvk8/FpSI6hsEYoNCAsn0CpdSV5bYg7Df9dmUlt
         nbcP9est7d0bJvrVCi4bvpm0d0hDrgcXBPcy0TRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.1 022/122] net/mlx5: Imply MLXFW in mlx5_core
Date:   Thu, 23 May 2019 21:05:44 +0200
Message-Id: <20190523181707.733914871@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
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
@@ -7,6 +7,7 @@ config MLX5_CORE
 	depends on PCI
 	imply PTP_1588_CLOCK
 	imply VXLAN
+	imply MLXFW
 	default n
 	---help---
 	  Core driver for low level functionality of the ConnectX-4 and



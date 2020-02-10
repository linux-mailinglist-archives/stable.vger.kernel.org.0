Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 276D1157590
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbgBJMl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:41:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:45374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729848AbgBJMl6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:58 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE90C2080C;
        Mon, 10 Feb 2020 12:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338517;
        bh=ZwCh4PI0k3iX86il9UUz6yoisxLhxM9v4HlkeicYIs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SfwIXsDcR40omjCqxmenQIy1BR254wBu7dNusq9a7nUM4ECWIs1/vwh86oMqqr3/0
         TPLLYNUa6ZxVZp1Ae2oJ3534oYgA01RIQwH5Up9nm17M3Lm/iWpKHaCHq21yJ30PQI
         HYYS/jfVaKshCerUhO5EtorwmLw3xvEXOImdMqfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raed Salem <raeds@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.5 326/367] net/mlx5: IPsec, Fix esp modify function attribute
Date:   Mon, 10 Feb 2020 04:33:59 -0800
Message-Id: <20200210122453.023667415@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

[ Upstream commit 0dc2c534f17c05bed0622b37a744bc38b48ca88a ]

The function mlx5_fpga_esp_validate_xfrm_attrs is wrongly used
with negative negation as zero value indicates success but it
used as failure return value instead.

Fix by remove the unary not negation operator.

Fixes: 05564d0ae075 ("net/mlx5: Add flow-steering commands for FPGA IPSec implementation")
Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
@@ -1478,7 +1478,7 @@ int mlx5_fpga_esp_modify_xfrm(struct mlx
 	if (!memcmp(&xfrm->attrs, attrs, sizeof(xfrm->attrs)))
 		return 0;
 
-	if (!mlx5_fpga_esp_validate_xfrm_attrs(mdev, attrs)) {
+	if (mlx5_fpga_esp_validate_xfrm_attrs(mdev, attrs)) {
 		mlx5_core_warn(mdev, "Tried to create an esp with unsupported attrs\n");
 		return -EOPNOTSUPP;
 	}



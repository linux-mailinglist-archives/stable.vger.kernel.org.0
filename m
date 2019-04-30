Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22B61F80E
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbfD3LlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:41:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728808AbfD3LlO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:41:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3DBA21734;
        Tue, 30 Apr 2019 11:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624473;
        bh=v56iP0Auzc2t58KRgL+KBiKAcquNGPm5lLMKIoWplFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EhIHUtdR0gW/lISQcROBEQrxoMR+C2s6fZxgpFcR/BxTvhHw1L5bIjgRi9qP+yRVy
         dwqEZe8Zc/LVnu6sP5GdmLPCltnGKDUx7uIg6goXfVgZoFDShEsgXiXQdrXQeg7raV
         3c3i9rq8CDCoajolNdn17zomrG1JnGUnRzouDozU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erez Alfasi <ereza@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.9 32/41] net/mlx5e: ethtool, Remove unsupported SFP EEPROM high pages query
Date:   Tue, 30 Apr 2019 13:38:43 +0200
Message-Id: <20190430113532.035142535@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113524.451237916@linuxfoundation.org>
References: <20190430113524.451237916@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erez Alfasi <ereza@mellanox.com>

[ Upstream commit ace329f4ab3ba434be2adf618073c752d083b524 ]

Querying EEPROM high pages data for SFP module is currently
not supported by our driver and yet queried, resulting in
invalid FW queries.

Set the EEPROM ethtool data length to 256 for SFP module will
limit the reading for page 0 only and prevent invalid FW queries.

Fixes: bb64143eee8c ("net/mlx5e: Add ethtool support for dump module EEPROM")
Signed-off-by: Erez Alfasi <ereza@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c       |    4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1365,7 +1365,7 @@ static int mlx5e_get_module_info(struct
 		break;
 	case MLX5_MODULE_ID_SFP:
 		modinfo->type       = ETH_MODULE_SFF_8472;
-		modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
+		modinfo->eeprom_len = MLX5_EEPROM_PAGE_LENGTH;
 		break;
 	default:
 		netdev_err(priv->netdev, "%s: cable type not recognized:0x%x\n",
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -368,10 +368,6 @@ int mlx5_query_module_eeprom(struct mlx5
 		size -= offset + size - MLX5_EEPROM_PAGE_LENGTH;
 
 	i2c_addr = MLX5_I2C_ADDR_LOW;
-	if (offset >= MLX5_EEPROM_PAGE_LENGTH) {
-		i2c_addr = MLX5_I2C_ADDR_HIGH;
-		offset -= MLX5_EEPROM_PAGE_LENGTH;
-	}
 
 	MLX5_SET(mcia_reg, in, l, 0);
 	MLX5_SET(mcia_reg, in, module, module_num);



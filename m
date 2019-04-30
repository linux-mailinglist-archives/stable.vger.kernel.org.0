Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 739A1F7F4
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729621AbfD3Lm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:42:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729646AbfD3Lm4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:42:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D076120449;
        Tue, 30 Apr 2019 11:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624575;
        bh=6jCE/LR6S7PqdS6et0GPFxE6fo1xtZ44ydYFUFAAU+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8DOhaN6APZCTliv/nEtO2jbcHm04p1R5Aa8fs/2e4BwGHNZUhNQtgdj/B63oDhp+
         z7gJDsGyX7zk4CDHZsr7UcoPfzTF0dPF88nzyPh2y3LHcwexmnAmlgEdb09rNcUkuF
         PH9l+8uh7FzUZEWPItJh2RgNvlfaogRPIFzyAQpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erez Alfasi <ereza@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.14 46/53] net/mlx5e: ethtool, Remove unsupported SFP EEPROM high pages query
Date:   Tue, 30 Apr 2019 13:38:53 +0200
Message-Id: <20190430113558.788242317@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113549.400132183@linuxfoundation.org>
References: <20190430113549.400132183@linuxfoundation.org>
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
@@ -1622,7 +1622,7 @@ static int mlx5e_get_module_info(struct
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
@@ -392,10 +392,6 @@ int mlx5_query_module_eeprom(struct mlx5
 		size -= offset + size - MLX5_EEPROM_PAGE_LENGTH;
 
 	i2c_addr = MLX5_I2C_ADDR_LOW;
-	if (offset >= MLX5_EEPROM_PAGE_LENGTH) {
-		i2c_addr = MLX5_I2C_ADDR_HIGH;
-		offset -= MLX5_EEPROM_PAGE_LENGTH;
-	}
 
 	MLX5_SET(mcia_reg, in, l, 0);
 	MLX5_SET(mcia_reg, in, module, module_num);



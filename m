Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F36F53A7F3
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730769AbfFIQz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732773AbfFIQzZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:55:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1B94205ED;
        Sun,  9 Jun 2019 16:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099324;
        bh=5DAdWmU4+rn2k8pRq7sq3fuN1ox/Q3VzobqIHTsLe5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f3oCGWnp9FyacGViekqc4DRyn9QtkAISfw0VmCAH75pIJrdiC2KgFLKLOrfQs70QT
         /Cok2vRcejkTKnnQPg9Uv12aGbG4eb8JZ0eW9jin6YSAWqRuY1pV5ZHk4rrjQehBNX
         ttG0+m5geX0iSqdf1Baq0LGyFH0poJWX9SqJwtg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erez Alfasi <ereza@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 64/83] net/mlx4_en: ethtool, Remove unsupported SFP EEPROM high pages query
Date:   Sun,  9 Jun 2019 18:42:34 +0200
Message-Id: <20190609164133.262881400@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erez Alfasi <ereza@mellanox.com>

[ Upstream commit 135dd9594f127c8a82d141c3c8430e9e2143216a ]

Querying EEPROM high pages data for SFP module is currently
not supported by our driver but is still tried, resulting in
invalid FW queries.

Set the EEPROM ethtool data length to 256 for SFP module to
limit the reading for page 0 only and prevent invalid FW queries.

Fixes: 7202da8b7f71 ("ethtool, net/mlx4_en: Cable info, get_module_info/eeprom ethtool support")
Signed-off-by: Erez Alfasi <ereza@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c |    4 +++-
 drivers/net/ethernet/mellanox/mlx4/port.c       |    5 -----
 2 files changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -1930,6 +1930,8 @@ static int mlx4_en_set_tunable(struct ne
 	return ret;
 }
 
+#define MLX4_EEPROM_PAGE_LEN 256
+
 static int mlx4_en_get_module_info(struct net_device *dev,
 				   struct ethtool_modinfo *modinfo)
 {
@@ -1964,7 +1966,7 @@ static int mlx4_en_get_module_info(struc
 		break;
 	case MLX4_MODULE_ID_SFP:
 		modinfo->type = ETH_MODULE_SFF_8472;
-		modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
+		modinfo->eeprom_len = MLX4_EEPROM_PAGE_LEN;
 		break;
 	default:
 		return -ENOSYS;
--- a/drivers/net/ethernet/mellanox/mlx4/port.c
+++ b/drivers/net/ethernet/mellanox/mlx4/port.c
@@ -1960,11 +1960,6 @@ int mlx4_get_module_info(struct mlx4_dev
 		size -= offset + size - I2C_PAGE_SIZE;
 
 	i2c_addr = I2C_ADDR_LOW;
-	if (offset >= I2C_PAGE_SIZE) {
-		/* Reset offset to high page */
-		i2c_addr = I2C_ADDR_HIGH;
-		offset -= I2C_PAGE_SIZE;
-	}
 
 	cable_info = (struct mlx4_cable_info *)inmad->data;
 	cable_info->dev_mem_address = cpu_to_be16(offset);



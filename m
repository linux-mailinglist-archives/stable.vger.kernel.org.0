Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE903961B8
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhEaOph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:45:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234004AbhEaOn2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:43:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A918761C79;
        Mon, 31 May 2021 13:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469253;
        bh=2o9jGx1w/8/zQK/iRaMTyj1xBl2wc65nIZvGqvfSc5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/LlcGY2kIqIjfltDsF3fq0DHqXHRzClAHvkAyT0bqyFaX5L4miByPLlkKDlU+zPW
         nI8K2B3IfHTUxNBSdc9ZXS+jS9m4MyD4on3iNzaG/cfSsudr1TFdP+YmIotx6lraac
         PrNYdnQ/WCD4kZAMDc9gYCRidmsU4j0EK7vLTv8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 126/296] net/mlx4: Fix EEPROM dump support
Date:   Mon, 31 May 2021 15:13:01 +0200
Message-Id: <20210531130708.137094851@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

commit db825feefc6868896fed5e361787ba3bee2fd906 upstream.

Fix SFP and QSFP* EEPROM queries by setting i2c_address, offset and page
number correctly. For SFP set the following params:
- I2C address for offsets 0-255 is 0x50. For 256-511 - 0x51.
- Page number is zero.
- Offset is 0-255.

At the same time, QSFP* parameters are different:
- I2C address is always 0x50.
- Page number is not limited to zero.
- Offset is 0-255 for page zero and 128-255 for others.

To set parameters accordingly to cable used, implement function to query
module ID and implement respective helper functions to set parameters
correctly.

Fixes: 135dd9594f12 ("net/mlx4_en: ethtool, Remove unsupported SFP EEPROM high pages query")
Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c |    4 
 drivers/net/ethernet/mellanox/mlx4/port.c       |  107 +++++++++++++++++++++++-
 2 files changed, 104 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -2027,8 +2027,6 @@ static int mlx4_en_set_tunable(struct ne
 	return ret;
 }
 
-#define MLX4_EEPROM_PAGE_LEN 256
-
 static int mlx4_en_get_module_info(struct net_device *dev,
 				   struct ethtool_modinfo *modinfo)
 {
@@ -2063,7 +2061,7 @@ static int mlx4_en_get_module_info(struc
 		break;
 	case MLX4_MODULE_ID_SFP:
 		modinfo->type = ETH_MODULE_SFF_8472;
-		modinfo->eeprom_len = MLX4_EEPROM_PAGE_LEN;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
 		break;
 	default:
 		return -EINVAL;
--- a/drivers/net/ethernet/mellanox/mlx4/port.c
+++ b/drivers/net/ethernet/mellanox/mlx4/port.c
@@ -1973,6 +1973,7 @@ EXPORT_SYMBOL(mlx4_get_roce_gid_from_sla
 #define I2C_ADDR_LOW  0x50
 #define I2C_ADDR_HIGH 0x51
 #define I2C_PAGE_SIZE 256
+#define I2C_HIGH_PAGE_SIZE 128
 
 /* Module Info Data */
 struct mlx4_cable_info {
@@ -2026,6 +2027,88 @@ static inline const char *cable_info_mad
 	return "Unknown Error";
 }
 
+static int mlx4_get_module_id(struct mlx4_dev *dev, u8 port, u8 *module_id)
+{
+	struct mlx4_cmd_mailbox *inbox, *outbox;
+	struct mlx4_mad_ifc *inmad, *outmad;
+	struct mlx4_cable_info *cable_info;
+	int ret;
+
+	inbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(inbox))
+		return PTR_ERR(inbox);
+
+	outbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(outbox)) {
+		mlx4_free_cmd_mailbox(dev, inbox);
+		return PTR_ERR(outbox);
+	}
+
+	inmad = (struct mlx4_mad_ifc *)(inbox->buf);
+	outmad = (struct mlx4_mad_ifc *)(outbox->buf);
+
+	inmad->method = 0x1; /* Get */
+	inmad->class_version = 0x1;
+	inmad->mgmt_class = 0x1;
+	inmad->base_version = 0x1;
+	inmad->attr_id = cpu_to_be16(0xFF60); /* Module Info */
+
+	cable_info = (struct mlx4_cable_info *)inmad->data;
+	cable_info->dev_mem_address = 0;
+	cable_info->page_num = 0;
+	cable_info->i2c_addr = I2C_ADDR_LOW;
+	cable_info->size = cpu_to_be16(1);
+
+	ret = mlx4_cmd_box(dev, inbox->dma, outbox->dma, port, 3,
+			   MLX4_CMD_MAD_IFC, MLX4_CMD_TIME_CLASS_C,
+			   MLX4_CMD_NATIVE);
+	if (ret)
+		goto out;
+
+	if (be16_to_cpu(outmad->status)) {
+		/* Mad returned with bad status */
+		ret = be16_to_cpu(outmad->status);
+		mlx4_warn(dev,
+			  "MLX4_CMD_MAD_IFC Get Module ID attr(%x) port(%d) i2c_addr(%x) offset(%d) size(%d): Response Mad Status(%x) - %s\n",
+			  0xFF60, port, I2C_ADDR_LOW, 0, 1, ret,
+			  cable_info_mad_err_str(ret));
+		ret = -ret;
+		goto out;
+	}
+	cable_info = (struct mlx4_cable_info *)outmad->data;
+	*module_id = cable_info->data[0];
+out:
+	mlx4_free_cmd_mailbox(dev, inbox);
+	mlx4_free_cmd_mailbox(dev, outbox);
+	return ret;
+}
+
+static void mlx4_sfp_eeprom_params_set(u8 *i2c_addr, u8 *page_num, u16 *offset)
+{
+	*i2c_addr = I2C_ADDR_LOW;
+	*page_num = 0;
+
+	if (*offset < I2C_PAGE_SIZE)
+		return;
+
+	*i2c_addr = I2C_ADDR_HIGH;
+	*offset -= I2C_PAGE_SIZE;
+}
+
+static void mlx4_qsfp_eeprom_params_set(u8 *i2c_addr, u8 *page_num, u16 *offset)
+{
+	/* Offsets 0-255 belong to page 0.
+	 * Offsets 256-639 belong to pages 01, 02, 03.
+	 * For example, offset 400 is page 02: 1 + (400 - 256) / 128 = 2
+	 */
+	if (*offset < I2C_PAGE_SIZE)
+		*page_num = 0;
+	else
+		*page_num = 1 + (*offset - I2C_PAGE_SIZE) / I2C_HIGH_PAGE_SIZE;
+	*i2c_addr = I2C_ADDR_LOW;
+	*offset -= *page_num * I2C_HIGH_PAGE_SIZE;
+}
+
 /**
  * mlx4_get_module_info - Read cable module eeprom data
  * @dev: mlx4_dev.
@@ -2045,12 +2128,30 @@ int mlx4_get_module_info(struct mlx4_dev
 	struct mlx4_cmd_mailbox *inbox, *outbox;
 	struct mlx4_mad_ifc *inmad, *outmad;
 	struct mlx4_cable_info *cable_info;
-	u16 i2c_addr;
+	u8 module_id, i2c_addr, page_num;
 	int ret;
 
 	if (size > MODULE_INFO_MAX_READ)
 		size = MODULE_INFO_MAX_READ;
 
+	ret = mlx4_get_module_id(dev, port, &module_id);
+	if (ret)
+		return ret;
+
+	switch (module_id) {
+	case MLX4_MODULE_ID_SFP:
+		mlx4_sfp_eeprom_params_set(&i2c_addr, &page_num, &offset);
+		break;
+	case MLX4_MODULE_ID_QSFP:
+	case MLX4_MODULE_ID_QSFP_PLUS:
+	case MLX4_MODULE_ID_QSFP28:
+		mlx4_qsfp_eeprom_params_set(&i2c_addr, &page_num, &offset);
+		break;
+	default:
+		mlx4_err(dev, "Module ID not recognized: %#x\n", module_id);
+		return -EINVAL;
+	}
+
 	inbox = mlx4_alloc_cmd_mailbox(dev);
 	if (IS_ERR(inbox))
 		return PTR_ERR(inbox);
@@ -2076,11 +2177,9 @@ int mlx4_get_module_info(struct mlx4_dev
 		 */
 		size -= offset + size - I2C_PAGE_SIZE;
 
-	i2c_addr = I2C_ADDR_LOW;
-
 	cable_info = (struct mlx4_cable_info *)inmad->data;
 	cable_info->dev_mem_address = cpu_to_be16(offset);
-	cable_info->page_num = 0;
+	cable_info->page_num = page_num;
 	cable_info->i2c_addr = i2c_addr;
 	cable_info->size = cpu_to_be16(size);
 



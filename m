Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C86B22F006
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731136AbgG0OVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:21:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731693AbgG0OVP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:21:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 682982070A;
        Mon, 27 Jul 2020 14:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859675;
        bh=HkCI3tdq/1QMvXaY6XYTNA4xcryBpwVpFoDfgcEFgnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDDm4I0SBjB9p1//LUsf68PKr90RZznb0J1+teFO5FJnTH8Pl/bMMww/6QCDAKt/y
         KbwDM9UcBMD85EHrrGNC1xFR1wPWcqGbM6Ot+S8dTejQJpCGGKxU3b4IjVkwxvafhn
         IGQcgg22qEeZ2LwNcHJeUkgShhoqagp3gJo3K7F0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 062/179] mlxsw: core: Fix wrong SFP EEPROM reading for upper pages 1-3
Date:   Mon, 27 Jul 2020 16:03:57 +0200
Message-Id: <20200727134935.692333669@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

[ Upstream commit 9b8737788af6c76ef93e3161ee2cdc4ddcc034ca ]

Fix wrong reading of upper pages for SFP EEPROM. According to "Memory
Organization" figure in SFF-8472 spec: When reading upper pages 1, 2 and
3 the offset should be set relative to zero and I2C high address 0x51
[1010001X (A2h)] is to be used.

Fixes: a45bfb5a5070 ("mlxsw: core: Extend QSFP EEPROM size for ethtool")
Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 48 ++++++++++++-------
 1 file changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 08215fed193d3..a7d86df7123ff 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -45,7 +45,7 @@ static int mlxsw_env_validate_cable_ident(struct mlxsw_core *core, int id,
 static int
 mlxsw_env_query_module_eeprom(struct mlxsw_core *mlxsw_core, int module,
 			      u16 offset, u16 size, void *data,
-			      unsigned int *p_read_size)
+			      bool qsfp, unsigned int *p_read_size)
 {
 	char eeprom_tmp[MLXSW_REG_MCIA_EEPROM_SIZE];
 	char mcia_pl[MLXSW_REG_MCIA_LEN];
@@ -54,6 +54,10 @@ mlxsw_env_query_module_eeprom(struct mlxsw_core *mlxsw_core, int module,
 	int status;
 	int err;
 
+	/* MCIA register accepts buffer size <= 48. Page of size 128 should be
+	 * read by chunks of size 48, 48, 32. Align the size of the last chunk
+	 * to avoid reading after the end of the page.
+	 */
 	size = min_t(u16, size, MLXSW_REG_MCIA_EEPROM_SIZE);
 
 	if (offset < MLXSW_REG_MCIA_EEPROM_PAGE_LENGTH &&
@@ -63,18 +67,25 @@ mlxsw_env_query_module_eeprom(struct mlxsw_core *mlxsw_core, int module,
 
 	i2c_addr = MLXSW_REG_MCIA_I2C_ADDR_LOW;
 	if (offset >= MLXSW_REG_MCIA_EEPROM_PAGE_LENGTH) {
-		page = MLXSW_REG_MCIA_PAGE_GET(offset);
-		offset -= MLXSW_REG_MCIA_EEPROM_UP_PAGE_LENGTH * page;
-		/* When reading upper pages 1, 2 and 3 the offset starts at
-		 * 128. Please refer to "QSFP+ Memory Map" figure in SFF-8436
-		 * specification for graphical depiction.
-		 * MCIA register accepts buffer size <= 48. Page of size 128
-		 * should be read by chunks of size 48, 48, 32. Align the size
-		 * of the last chunk to avoid reading after the end of the
-		 * page.
-		 */
-		if (offset + size > MLXSW_REG_MCIA_EEPROM_PAGE_LENGTH)
-			size = MLXSW_REG_MCIA_EEPROM_PAGE_LENGTH - offset;
+		if (qsfp) {
+			/* When reading upper pages 1, 2 and 3 the offset
+			 * starts at 128. Please refer to "QSFP+ Memory Map"
+			 * figure in SFF-8436 specification for graphical
+			 * depiction.
+			 */
+			page = MLXSW_REG_MCIA_PAGE_GET(offset);
+			offset -= MLXSW_REG_MCIA_EEPROM_UP_PAGE_LENGTH * page;
+			if (offset + size > MLXSW_REG_MCIA_EEPROM_PAGE_LENGTH)
+				size = MLXSW_REG_MCIA_EEPROM_PAGE_LENGTH - offset;
+		} else {
+			/* When reading upper pages 1, 2 and 3 the offset
+			 * starts at 0 and I2C high address is used. Please refer
+			 * refer to "Memory Organization" figure in SFF-8472
+			 * specification for graphical depiction.
+			 */
+			i2c_addr = MLXSW_REG_MCIA_I2C_ADDR_HIGH;
+			offset -= MLXSW_REG_MCIA_EEPROM_PAGE_LENGTH;
+		}
 	}
 
 	mlxsw_reg_mcia_pack(mcia_pl, module, 0, page, offset, size, i2c_addr);
@@ -166,7 +177,7 @@ int mlxsw_env_get_module_info(struct mlxsw_core *mlxsw_core, int module,
 	int err;
 
 	err = mlxsw_env_query_module_eeprom(mlxsw_core, module, 0, offset,
-					    module_info, &read_size);
+					    module_info, false, &read_size);
 	if (err)
 		return err;
 
@@ -197,7 +208,7 @@ int mlxsw_env_get_module_info(struct mlxsw_core *mlxsw_core, int module,
 		/* Verify if transceiver provides diagnostic monitoring page */
 		err = mlxsw_env_query_module_eeprom(mlxsw_core, module,
 						    SFP_DIAGMON, 1, &diag_mon,
-						    &read_size);
+						    false, &read_size);
 		if (err)
 			return err;
 
@@ -225,17 +236,22 @@ int mlxsw_env_get_module_eeprom(struct net_device *netdev,
 	int offset = ee->offset;
 	unsigned int read_size;
 	int i = 0;
+	bool qsfp;
 	int err;
 
 	if (!ee->len)
 		return -EINVAL;
 
 	memset(data, 0, ee->len);
+	/* Validate module identifier value. */
+	err = mlxsw_env_validate_cable_ident(mlxsw_core, module, &qsfp);
+	if (err)
+		return err;
 
 	while (i < ee->len) {
 		err = mlxsw_env_query_module_eeprom(mlxsw_core, module, offset,
 						    ee->len - i, data + i,
-						    &read_size);
+						    qsfp, &read_size);
 		if (err) {
 			netdev_err(netdev, "Eeprom query failed\n");
 			return err;
-- 
2.25.1




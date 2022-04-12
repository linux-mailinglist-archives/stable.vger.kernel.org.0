Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8988A4FD5DC
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377057AbiDLHrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357169AbiDLHju (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AE613F70;
        Tue, 12 Apr 2022 00:13:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC8B56153F;
        Tue, 12 Apr 2022 07:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B44C385A1;
        Tue, 12 Apr 2022 07:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747603;
        bh=YgBs7SCqNKxfkEo9PqweIDQmp3ZWSfZhb89F6s7+12c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sxsGcLuYm28rCDJxFsUD5y1Fl756+A7c1xBH6gju3YtzwnF75m46NVzjNx2sgqVq1
         7XQuxW4851Z+MlOY/7ZQesS10muEuMGvj69wSi6NoVboCNM+CVBHZpzdYNqVyQdcj9
         eOAfVoa2AUkN8KEamicmGujyGweS3xhHBv6p3y7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 138/343] net/mlx5e: Remove overzealous validations in netlink EEPROM query
Date:   Tue, 12 Apr 2022 08:29:16 +0200
Message-Id: <20220412062955.369912798@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 970adfb76095fa719778d70a6b86030d2feb88dd ]

Unlike the legacy EEPROM callbacks, when using the netlink EEPROM query
(get_module_eeprom_by_page) the driver should not try to validate the
query parameters, but just perform the read requested by the userspace.

Recent discussion in the mailing list:
https://lore.kernel.org/netdev/20220120093051.70845141@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net/

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/port.c    | 23 -------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 7b16a1188aab..fd79860de723 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -433,35 +433,12 @@ int mlx5_query_module_eeprom_by_page(struct mlx5_core_dev *dev,
 				     struct mlx5_module_eeprom_query_params *params,
 				     u8 *data)
 {
-	u8 module_id;
 	int err;
 
 	err = mlx5_query_module_num(dev, &params->module_number);
 	if (err)
 		return err;
 
-	err = mlx5_query_module_id(dev, params->module_number, &module_id);
-	if (err)
-		return err;
-
-	switch (module_id) {
-	case MLX5_MODULE_ID_SFP:
-		if (params->page > 0)
-			return -EINVAL;
-		break;
-	case MLX5_MODULE_ID_QSFP:
-	case MLX5_MODULE_ID_QSFP28:
-	case MLX5_MODULE_ID_QSFP_PLUS:
-		if (params->page > 3)
-			return -EINVAL;
-		break;
-	case MLX5_MODULE_ID_DSFP:
-		break;
-	default:
-		mlx5_core_err(dev, "Module ID not recognized: 0x%x\n", module_id);
-		return -EINVAL;
-	}
-
 	if (params->i2c_address != MLX5_I2C_ADDR_HIGH &&
 	    params->i2c_address != MLX5_I2C_ADDR_LOW) {
 		mlx5_core_err(dev, "I2C address not recognized: 0x%x\n", params->i2c_address);
-- 
2.35.1




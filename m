Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6314A9646
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357658AbiBDJYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:24:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52230 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357884AbiBDJX1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:23:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81C05B836EE;
        Fri,  4 Feb 2022 09:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB08C340ED;
        Fri,  4 Feb 2022 09:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966605;
        bh=5t6xZ8N2V27Dp728hG9yGXYaE7Em90wkdi7HfCFR3sA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iV7NLIO8whAVczXOHjE6/SYPj0oL5O4yTZLqGucyAXpESWg4WMkrg5DTHWkRxQcsF
         +80HzV5iUKu49wNlKeGJAtDGAbW5TxG8YQduVqNIu+9ArY7c8paFmhXhNmRe43PBp8
         UxuMA71CNjw/XxILdjNsibvZ4m2YQYrXEHnbNM0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Yugui <wangyugui@e16-tech.com>,
        Gal Pressman <gal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.15 16/32] net/mlx5e: Fix module EEPROM query
Date:   Fri,  4 Feb 2022 10:22:26 +0100
Message-Id: <20220204091915.794329234@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091915.247906930@linuxfoundation.org>
References: <20220204091915.247906930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

commit 4a08a131351e375a2969b98e46df260ed04dcba7 upstream.

When querying the module EEPROM, there was a misusage of the 'offset'
variable vs the 'query.offset' field.
Fix that by always using 'offset' and assigning its value to
'query.offset' right before the mcia register read call.

While at it, the cross-pages read size adjustment was changed to be more
intuitive.

Fixes: e19b0a3474ab ("net/mlx5: Refactor module EEPROM query")
Reported-by: Wang Yugui <wangyugui@e16-tech.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/port.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -406,23 +406,24 @@ int mlx5_query_module_eeprom(struct mlx5
 
 	switch (module_id) {
 	case MLX5_MODULE_ID_SFP:
-		mlx5_sfp_eeprom_params_set(&query.i2c_address, &query.page, &query.offset);
+		mlx5_sfp_eeprom_params_set(&query.i2c_address, &query.page, &offset);
 		break;
 	case MLX5_MODULE_ID_QSFP:
 	case MLX5_MODULE_ID_QSFP_PLUS:
 	case MLX5_MODULE_ID_QSFP28:
-		mlx5_qsfp_eeprom_params_set(&query.i2c_address, &query.page, &query.offset);
+		mlx5_qsfp_eeprom_params_set(&query.i2c_address, &query.page, &offset);
 		break;
 	default:
 		mlx5_core_err(dev, "Module ID not recognized: 0x%x\n", module_id);
 		return -EINVAL;
 	}
 
-	if (query.offset + size > MLX5_EEPROM_PAGE_LENGTH)
+	if (offset + size > MLX5_EEPROM_PAGE_LENGTH)
 		/* Cross pages read, read until offset 256 in low page */
-		size -= offset + size - MLX5_EEPROM_PAGE_LENGTH;
+		size = MLX5_EEPROM_PAGE_LENGTH - offset;
 
 	query.size = size;
+	query.offset = offset;
 
 	return mlx5_query_mcia(dev, &query, data);
 }



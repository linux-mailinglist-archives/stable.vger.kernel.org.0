Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5314C735E
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237439AbiB1Rel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237542AbiB1ReE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:34:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4366A939BA;
        Mon, 28 Feb 2022 09:30:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46921B815AC;
        Mon, 28 Feb 2022 17:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9DEC340E7;
        Mon, 28 Feb 2022 17:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069446;
        bh=kyKWOYt+j8NdpzKA9EZ5lJe6018rgYKEaDnb7/Q3m2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LwEKSpik9A3sl4hCUOVAVkQ0O7tS/rM6ahtM+3SZS52PJA3vhm2GaIiOSGQk1Yr1D
         dK0Tq7H5NkICFvMY62Wp5FZxsGAAWltBz8tV5HvtHXwemJDC058AAcUahu500a/se2
         LBDCWGRwHj1Am00eArzb0nJwxOLc2/mPLQqFKCC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.4 22/53] net/mlx5e: Fix wrong return value on ioctl EEPROM query failure
Date:   Mon, 28 Feb 2022 18:24:20 +0100
Message-Id: <20220228172249.931709849@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172248.232273337@linuxfoundation.org>
References: <20220228172248.232273337@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

commit 0b89429722353d112f8b8b29ca397e95fa994d27 upstream.

The ioctl EEPROM query wrongly returns success on read failures, fix
that by returning the appropriate error code.

Fixes: bb64143eee8c ("net/mlx5e: Add ethtool support for dump module EEPROM")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1683,7 +1683,7 @@ static int mlx5e_get_module_eeprom(struc
 		if (size_read < 0) {
 			netdev_err(priv->netdev, "%s: mlx5_query_eeprom failed:0x%x\n",
 				   __func__, size_read);
-			return 0;
+			return size_read;
 		}
 
 		i += size_read;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53B144C72A8
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235992AbiB1R2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236994AbiB1R2C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:28:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BC3887B6;
        Mon, 28 Feb 2022 09:27:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7884B815A6;
        Mon, 28 Feb 2022 17:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DA8C340E7;
        Mon, 28 Feb 2022 17:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069236;
        bh=8/VzF5YyFB6FzSHyHsm9QRDs3/DOdSXYW/DlJ3TynqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4ojXVjbtAoKNIdS3geGPOUrZxecAcLptTiycEQ8GHJSCJ9eJVYKp34dFXOKGgcxm
         /BUAM9XLf799sno6LPMvBhxEZiGHOGN6tWB7o/FoXm4YDHS0493nbuDSg+nORD/i9m
         v/4F0okGZ3v6wxlvRgRRarjn6vfc6DXOBHiW6ZGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 4.14 13/31] net/mlx5e: Fix wrong return value on ioctl EEPROM query failure
Date:   Mon, 28 Feb 2022 18:24:09 +0100
Message-Id: <20220228172201.151696974@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172159.515152296@linuxfoundation.org>
References: <20220228172159.515152296@linuxfoundation.org>
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
@@ -1662,7 +1662,7 @@ static int mlx5e_get_module_eeprom(struc
 		if (size_read < 0) {
 			netdev_err(priv->netdev, "%s: mlx5_query_eeprom failed:0x%x\n",
 				   __func__, size_read);
-			return 0;
+			return size_read;
 		}
 
 		i += size_read;



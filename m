Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D516A1236AF
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbfLQULA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:11:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:37350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728565AbfLQUK7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:10:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEE922146E;
        Tue, 17 Dec 2019 20:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613459;
        bh=SgO7xpzq/QCIXVwr0jVUMvpcjjvQKApQVJ0AjnX/4Rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VpebPbzXhnxvKLNQdv7Fl83DXcNzFlrZtnpQFS0HW3kpAr94R+ptav9uKj5T26hLZ
         gXaK6BHntPlsRYzwKPtKVbRScyEiG8cyg8i/cpog2uq16DMsdPvBencqdNcHVSA+sr
         9pWBsCftTNFBc2KY08ZgZzqeIUMM0f1qfF2BOCfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.4 29/37] net/mlx5e: Fix SFF 8472 eeprom length
Date:   Tue, 17 Dec 2019 21:09:50 +0100
Message-Id: <20191217200732.793443653@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217200721.741054904@linuxfoundation.org>
References: <20191217200721.741054904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

[ Upstream commit c431f8597863a91eea6024926e0c1b179cfa4852 ]

SFF 8472 eeprom length is 512 bytes. Fix module info return value to
support 512 bytes read.

Fixes: ace329f4ab3b ("net/mlx5e: ethtool, Remove unsupported SFP EEPROM high pages query")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1643,7 +1643,7 @@ static int mlx5e_get_module_info(struct
 		break;
 	case MLX5_MODULE_ID_SFP:
 		modinfo->type       = ETH_MODULE_SFF_8472;
-		modinfo->eeprom_len = MLX5_EEPROM_PAGE_LENGTH;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
 		break;
 	default:
 		netdev_err(priv->netdev, "%s: cable type not recognized:0x%x\n",



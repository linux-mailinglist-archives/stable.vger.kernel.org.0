Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D016599F89
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349805AbiHSQTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352422AbiHSQQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:16:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F292115B61;
        Fri, 19 Aug 2022 08:59:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44AFDB8280C;
        Fri, 19 Aug 2022 15:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3887C433D7;
        Fri, 19 Aug 2022 15:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924785;
        bh=mhpuv9HjBqol44psX3H2JTsxdSQzFEryQdIpjKeeeGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U5PNgSc5+YWpGJmhI1tmlN4fkkvfGl3zvxNqXAHlx1CLfz6hULuMwODP91IQp/eYc
         mAaEnppOHu6nHqyTGA8F+uQRlEd+d6NrRBBm2V7eaXe/TKV11AF0LBX+oAvXygsDme
         kNzyocCtBueVtMVlitrWnOtjKHZhIO0kpgtO3D7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 252/545] net/mlx5e: Remove WARN_ON when trying to offload an unsupported TLS cipher/version
Date:   Fri, 19 Aug 2022 17:40:22 +0200
Message-Id: <20220819153840.638107979@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 115d9f95ea7ab780ef315dc356bebba2e07cb731 ]

The driver reports whether TX/RX TLS device offloads are supported, but
not which ciphers/versions, these should be handled by returning
-EOPNOTSUPP when .tls_dev_add() is called.

Remove the WARN_ON kernel trace when the driver gets a request to
offload a cipher/version that is not supported as it is expected.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index 1b392696280d..f824d781b99e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -15,7 +15,7 @@ static int mlx5e_ktls_add(struct net_device *netdev, struct sock *sk,
 	struct mlx5_core_dev *mdev = priv->mdev;
 	int err;
 
-	if (WARN_ON(!mlx5e_ktls_type_check(mdev, crypto_info)))
+	if (!mlx5e_ktls_type_check(mdev, crypto_info))
 		return -EOPNOTSUPP;
 
 	if (direction == TLS_OFFLOAD_CTX_DIR_TX)
-- 
2.35.1




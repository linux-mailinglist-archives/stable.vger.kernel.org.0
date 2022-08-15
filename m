Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE73594FA8
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiHPEbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiHPEa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:30:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F228C6CD4;
        Mon, 15 Aug 2022 13:19:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94F9BB81183;
        Mon, 15 Aug 2022 20:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF513C433D6;
        Mon, 15 Aug 2022 20:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594774;
        bh=/PE/VnPD0NDQG2VHMotRq0wJwclw6zgN3rB+S+yaYaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O6F31XYpwh8HS8M0MCOm0V8aHPoIVW7Ant69I/DmEwpZXY6r5Zi3AmnMXxVKuEg9Z
         o0SLbAnE4u3u4591dPi4733HyxLTCMu1DXHNIhh3q2YSJERCqN0sBkbipp2EoOKzjX
         GjS4L7DuzXQeVmeDhKKEHiqIkenUr7yYIXnDDxyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0547/1157] net/mlx5e: Remove WARN_ON when trying to offload an unsupported TLS cipher/version
Date:   Mon, 15 Aug 2022 19:58:23 +0200
Message-Id: <20220815180501.527552015@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 814f2a56f633..30a70d139046 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -54,7 +54,7 @@ static int mlx5e_ktls_add(struct net_device *netdev, struct sock *sk,
 	struct mlx5_core_dev *mdev = priv->mdev;
 	int err;
 
-	if (WARN_ON(!mlx5e_ktls_type_check(mdev, crypto_info)))
+	if (!mlx5e_ktls_type_check(mdev, crypto_info))
 		return -EOPNOTSUPP;
 
 	if (direction == TLS_OFFLOAD_CTX_DIR_TX)
-- 
2.35.1




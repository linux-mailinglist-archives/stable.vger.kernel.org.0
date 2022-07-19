Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1557579BA3
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbiGSMa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240871AbiGSMaF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:30:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2EA86D556;
        Tue, 19 Jul 2022 05:11:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84663616F8;
        Tue, 19 Jul 2022 12:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B4CC341C6;
        Tue, 19 Jul 2022 12:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232699;
        bh=uE271MLnW5X1i/J+uUgC5TM0tctvCfDzZq2l/nPJUQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V/D/P0zAYqAhYvrD9TR45v2wXOEe2zJyp5DgFuJj5QRIQIPHvMaLNdP8j2zG95I9M
         ELlNhZsivGAHbdBQvnzo7Ygb67dYKr5Jn+zAHzwauLynmaq/G1HPKYNAjs/9/6mc7I
         5tCdDMnpKLhGMQhleDQHqZN/1ltPgwS/23eCRlbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/167] net/mlx5e: kTLS, Fix build time constant test in TX
Date:   Tue, 19 Jul 2022 13:52:47 +0200
Message-Id: <20220719114700.110782274@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit 6cc2714e85754a621219693ea8aa3077d6fca0cb ]

Use the correct constant (TLS_DRIVER_STATE_SIZE_TX) in the comparison
against the size of the private TX TLS driver context.

Fixes: df8d866770f9 ("net/mlx5e: kTLS, Use kernel API to extract private offload context")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 9ad3459fb63a..dadb71081ed0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -68,8 +68,7 @@ mlx5e_set_ktls_tx_priv_ctx(struct tls_context *tls_ctx,
 	struct mlx5e_ktls_offload_context_tx **ctx =
 		__tls_driver_ctx(tls_ctx, TLS_OFFLOAD_CTX_DIR_TX);
 
-	BUILD_BUG_ON(sizeof(struct mlx5e_ktls_offload_context_tx *) >
-		     TLS_OFFLOAD_CONTEXT_SIZE_TX);
+	BUILD_BUG_ON(sizeof(priv_tx) > TLS_DRIVER_STATE_SIZE_TX);
 
 	*ctx = priv_tx;
 }
-- 
2.35.1




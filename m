Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B57E657901
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbiL1O4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232969AbiL1O4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:56:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394B2B69
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:56:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5B14B8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662B2C433D2;
        Wed, 28 Dec 2022 14:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239390;
        bh=p+HTs6bOvzPzTxsN5kukdUQxz9y+aivu3aMHZf4t6CM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V5scA9ONgbY/502uhGkzGTzJpfPWnZR3gOVnkFigIgbXawpsVwvO4b/Dv1GWXAd3D
         U7EX0pQSbRHEb9hTo+zDcbIy4JrFwllAF06ytorbqzUtG1rokP5JYwfhWrPx7Xnbkw
         e3jY6VjCdIGLNe7HTqnWG6z5zlhh6YABplSzMDDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Cong Dang <cong.dang.xn@renesas.com>,
        Hai Pham <hai.pham.ud@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0021/1073] memory: renesas-rpc-if: Clear HS bit during hardware initialization
Date:   Wed, 28 Dec 2022 15:26:49 +0100
Message-Id: <20221228144328.728837821@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Dang <cong.dang.xn@renesas.com>

[ Upstream commit 5192481f908e576be42bd39ec12979b79e11f7e0 ]

According to the datasheet, HS bit should be specified to 1 when using
DMA transfer. As DMA transfer is not supported, it should be cleared to
0.

Previously, the driver relied on the HS bit being cleared by prior
firmware but this is not always the case.

Fix this by ensuring the bit is cleared during hardware initialization.

Fixes: ca7d8b980b67 ("memory: add Renesas RPC-IF driver")
Signed-off-by: Cong Dang <cong.dang.xn@renesas.com>
Signed-off-by: Hai Pham <hai.pham.ud@renesas.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/08d9fb10b3051decebf871267a6e2e7cb2d4faf9.1665583089.git.geert+renesas@glider.be
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/renesas-rpc-if.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/memory/renesas-rpc-if.c b/drivers/memory/renesas-rpc-if.c
index 4316988d791a..61c288d40375 100644
--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -317,6 +317,9 @@ int rpcif_hw_init(struct rpcif *rpc, bool hyperflash)
 	regmap_update_bits(rpc->regmap, RPCIF_PHYCNT, RPCIF_PHYCNT_PHYMEM_MASK,
 			   RPCIF_PHYCNT_PHYMEM(hyperflash ? 3 : 0));
 
+	/* DMA Transfer is not supported */
+	regmap_update_bits(rpc->regmap, RPCIF_PHYCNT, RPCIF_PHYCNT_HS, 0);
+
 	if (rpc->type == RPCIF_RCAR_GEN3)
 		regmap_update_bits(rpc->regmap, RPCIF_PHYCNT,
 				   RPCIF_PHYCNT_STRTIM(7), RPCIF_PHYCNT_STRTIM(7));
-- 
2.35.1




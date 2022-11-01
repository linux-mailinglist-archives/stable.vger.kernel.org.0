Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80408614890
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiKAL2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiKAL2D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:28:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A171A21C;
        Tue,  1 Nov 2022 04:27:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD854615E0;
        Tue,  1 Nov 2022 11:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A12C433D6;
        Tue,  1 Nov 2022 11:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302073;
        bh=ev0VM6Oimx9Zw4+Ukn4/pCJJiqGUwoJw4OAPFesTkmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uupu94SFPGGUWoDTfi/C5/M1imqDVWmlSNMQU51J5lqNH8eidNHgosB4CGvHhkP78
         pGt2zlprLd4hKR1tW2Vat2xmU40Z1WJysCwdsefOR4jcVLCXPZVttrdSgz6pIyF2JL
         2DgQ6rJCFjxJf1XjSH67rvaemMLElU8MC33m9+aTpapXGf5G1mP9UMMOK4MA8oDidi
         +6xlLb1XiPwA/r1vjDdZh3dspeEXhV9btMY2PYj0WnUP3zCUuONccIHbQG7P7Zhpqf
         KdV5Tf0H0UrD/GIVEjgFjSr7izoWbyztN4cD/6SBhlaSTAvYRYGF+2bKRiyRPF6PWi
         TRcuWdeszuYqQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Gaignard <benjamin.gaignard@collabora.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, p.zabel@pengutronix.de,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        linux-rockchip@lists.infradead.org, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 12/34] media: hantro: HEVC: Fix auxilary buffer size calculation
Date:   Tue,  1 Nov 2022 07:27:04 -0400
Message-Id: <20221101112726.799368-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101112726.799368-1-sashal@kernel.org>
References: <20221101112726.799368-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Gaignard <benjamin.gaignard@collabora.com>

[ Upstream commit 8a438580a09ecef78cd6c5825d628b4d5ae1c127 ]

SAO and FILTER buffers size depend of the bit depth.
Make sure we have enough space for 10bit bitstreams.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/hantro/hantro_hevc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/hantro/hantro_hevc.c b/drivers/staging/media/hantro/hantro_hevc.c
index b990bc98164c..9383fb7081f6 100644
--- a/drivers/staging/media/hantro/hantro_hevc.c
+++ b/drivers/staging/media/hantro/hantro_hevc.c
@@ -104,7 +104,7 @@ static int tile_buffer_reallocate(struct hantro_ctx *ctx)
 		hevc_dec->tile_bsd.cpu = NULL;
 	}
 
-	size = VERT_FILTER_RAM_SIZE * height64 * (num_tile_cols - 1);
+	size = (VERT_FILTER_RAM_SIZE * height64 * (num_tile_cols - 1) * ctx->bit_depth) / 8;
 	hevc_dec->tile_filter.cpu = dma_alloc_coherent(vpu->dev, size,
 						       &hevc_dec->tile_filter.dma,
 						       GFP_KERNEL);
@@ -112,7 +112,7 @@ static int tile_buffer_reallocate(struct hantro_ctx *ctx)
 		goto err_free_tile_buffers;
 	hevc_dec->tile_filter.size = size;
 
-	size = VERT_SAO_RAM_SIZE * height64 * (num_tile_cols - 1);
+	size = (VERT_SAO_RAM_SIZE * height64 * (num_tile_cols - 1) * ctx->bit_depth) / 8;
 	hevc_dec->tile_sao.cpu = dma_alloc_coherent(vpu->dev, size,
 						    &hevc_dec->tile_sao.dma,
 						    GFP_KERNEL);
-- 
2.35.1


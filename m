Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F6B614897
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiKAL2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiKAL2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:28:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6301A22A;
        Tue,  1 Nov 2022 04:27:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3C76615DD;
        Tue,  1 Nov 2022 11:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69A4C433D7;
        Tue,  1 Nov 2022 11:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302075;
        bh=b+tOwlQfc42Ncz47RnuqxCIhFUSWfgZuPWXMdk9EOzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K8x6Te07yn+54I5W0CN7L52abTQvozAySpzSqJWCCyrbdx9hSkS3WsCNFX40WRBHj
         oNGgvsM/sanzknXwr0/ndG6RQzc+eHi/PcR/wc1ZrTEQrDbgTw1gcscrNl7PzHxsEB
         a0iS2FTngGkEfLNW3NGUrgXTJ0DMH1fz2PQUS9OdUr+cFAW7YIfc1JxeW80XfykH8u
         GzHw2kra/efqXtS8Ab1vKP2fxtiffjS6wgvZ38fArJ3XF/gUvhAT9csnMWXJTaEkdX
         SwJE2kLfV0FbI21/Nd1diYDw4KlIXHVj/SvNzdBOcd6TKfCuTH8DBT7kyF40x1MLRR
         6uRFCXcTyY6rQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Gaignard <benjamin.gaignard@collabora.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, p.zabel@pengutronix.de,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        linux-rockchip@lists.infradead.org, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 13/34] media: hantro: HEVC: Fix chroma offset computation
Date:   Tue,  1 Nov 2022 07:27:05 -0400
Message-Id: <20221101112726.799368-13-sashal@kernel.org>
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

[ Upstream commit f64853ad7f964b3bf7c1d63b27ca7ef972797a1c ]

The chroma offset depends of the bitstream depth.
Make sure that ctx->bit_depth is used to compute it.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/hantro/hantro_g2_hevc_dec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/hantro/hantro_g2_hevc_dec.c b/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
index 233ecd863d5f..a917079a6ed3 100644
--- a/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
+++ b/drivers/staging/media/hantro/hantro_g2_hevc_dec.c
@@ -12,7 +12,7 @@
 
 static size_t hantro_hevc_chroma_offset(struct hantro_ctx *ctx)
 {
-	return ctx->dst_fmt.width * ctx->dst_fmt.height;
+	return ctx->dst_fmt.width * ctx->dst_fmt.height * ctx->bit_depth / 8;
 }
 
 static size_t hantro_hevc_motion_vectors_offset(struct hantro_ctx *ctx)
-- 
2.35.1


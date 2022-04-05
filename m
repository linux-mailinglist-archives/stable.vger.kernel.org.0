Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793EE4F3628
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244563AbiDEK7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347124AbiDEJqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:46:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365227B12C;
        Tue,  5 Apr 2022 02:32:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3297B81CC1;
        Tue,  5 Apr 2022 09:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC30C385A0;
        Tue,  5 Apr 2022 09:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151145;
        bh=zSXBeACCOZxTOck0fxbCJC2b7fv0Xz8PKX42CxmY2SQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W/I8Tg3+dZPC3rpgswjbh0liTinis/GV8Fa0JKovr+1K5QII1FmTndsJFvy8mlPGE
         nFZJnE1PqUl8U13QTzehs0utmpYhVFz+PcfkjihrWMdrMLeqahviXdFvxm57uFtK6P
         SG0yK0v2xV0L+9IGbA+DzvcT4mO5wlYNo7RE0+7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 310/913] media: mexon-ge2d: fixup frames size in registers
Date:   Tue,  5 Apr 2022 09:22:52 +0200
Message-Id: <20220405070349.146965875@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PDS_OTHER_BAD_TLD,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit 79e8c421a099bfbcebe59740153e55aa0442ced6 ]

The CLIP, SRC & DST registers are coded to take the pixel/line start & end,
starting from 0. Thus the end should be the width/height minus 1.

It can be an issue with clipping and rotation, where it will add spurious
lines from uninitialized or unwanted data with a shift in the result.

Fixes: 59a635327ca7 ("media: meson: Add M2M driver for the Amlogic GE2D Accelerator Unit")
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/meson/ge2d/ge2d.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/meson/ge2d/ge2d.c b/drivers/media/platform/meson/ge2d/ge2d.c
index 9b1e973e78da..a373dea9866b 100644
--- a/drivers/media/platform/meson/ge2d/ge2d.c
+++ b/drivers/media/platform/meson/ge2d/ge2d.c
@@ -215,35 +215,35 @@ static void ge2d_hw_start(struct meson_ge2d *ge2d)
 
 	regmap_write(ge2d->map, GE2D_SRC1_CLIPY_START_END,
 		     FIELD_PREP(GE2D_START, ctx->in.crop.top) |
-		     FIELD_PREP(GE2D_END, ctx->in.crop.top + ctx->in.crop.height));
+		     FIELD_PREP(GE2D_END, ctx->in.crop.top + ctx->in.crop.height - 1));
 	regmap_write(ge2d->map, GE2D_SRC1_CLIPX_START_END,
 		     FIELD_PREP(GE2D_START, ctx->in.crop.left) |
-		     FIELD_PREP(GE2D_END, ctx->in.crop.left + ctx->in.crop.width));
+		     FIELD_PREP(GE2D_END, ctx->in.crop.left + ctx->in.crop.width - 1));
 	regmap_write(ge2d->map, GE2D_SRC2_CLIPY_START_END,
 		     FIELD_PREP(GE2D_START, ctx->out.crop.top) |
-		     FIELD_PREP(GE2D_END, ctx->out.crop.top + ctx->out.crop.height));
+		     FIELD_PREP(GE2D_END, ctx->out.crop.top + ctx->out.crop.height - 1));
 	regmap_write(ge2d->map, GE2D_SRC2_CLIPX_START_END,
 		     FIELD_PREP(GE2D_START, ctx->out.crop.left) |
-		     FIELD_PREP(GE2D_END, ctx->out.crop.left + ctx->out.crop.width));
+		     FIELD_PREP(GE2D_END, ctx->out.crop.left + ctx->out.crop.width - 1));
 	regmap_write(ge2d->map, GE2D_DST_CLIPY_START_END,
 		     FIELD_PREP(GE2D_START, ctx->out.crop.top) |
-		     FIELD_PREP(GE2D_END, ctx->out.crop.top + ctx->out.crop.height));
+		     FIELD_PREP(GE2D_END, ctx->out.crop.top + ctx->out.crop.height - 1));
 	regmap_write(ge2d->map, GE2D_DST_CLIPX_START_END,
 		     FIELD_PREP(GE2D_START, ctx->out.crop.left) |
-		     FIELD_PREP(GE2D_END, ctx->out.crop.left + ctx->out.crop.width));
+		     FIELD_PREP(GE2D_END, ctx->out.crop.left + ctx->out.crop.width - 1));
 
 	regmap_write(ge2d->map, GE2D_SRC1_Y_START_END,
-		     FIELD_PREP(GE2D_END, ctx->in.pix_fmt.height));
+		     FIELD_PREP(GE2D_END, ctx->in.pix_fmt.height - 1));
 	regmap_write(ge2d->map, GE2D_SRC1_X_START_END,
-		     FIELD_PREP(GE2D_END, ctx->in.pix_fmt.width));
+		     FIELD_PREP(GE2D_END, ctx->in.pix_fmt.width - 1));
 	regmap_write(ge2d->map, GE2D_SRC2_Y_START_END,
-		     FIELD_PREP(GE2D_END, ctx->out.pix_fmt.height));
+		     FIELD_PREP(GE2D_END, ctx->out.pix_fmt.height - 1));
 	regmap_write(ge2d->map, GE2D_SRC2_X_START_END,
-		     FIELD_PREP(GE2D_END, ctx->out.pix_fmt.width));
+		     FIELD_PREP(GE2D_END, ctx->out.pix_fmt.width - 1));
 	regmap_write(ge2d->map, GE2D_DST_Y_START_END,
-		     FIELD_PREP(GE2D_END, ctx->out.pix_fmt.height));
+		     FIELD_PREP(GE2D_END, ctx->out.pix_fmt.height - 1));
 	regmap_write(ge2d->map, GE2D_DST_X_START_END,
-		     FIELD_PREP(GE2D_END, ctx->out.pix_fmt.width));
+		     FIELD_PREP(GE2D_END, ctx->out.pix_fmt.width - 1));
 
 	/* Color, no blend, use source color */
 	reg = GE2D_ALU_DO_COLOR_OPERATION_LOGIC(LOGIC_OPERATION_COPY,
-- 
2.34.1




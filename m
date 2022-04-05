Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE514F2D8E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343843AbiDEJOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244912AbiDEIwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7642495B;
        Tue,  5 Apr 2022 01:46:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BDD43CE1C6B;
        Tue,  5 Apr 2022 08:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD881C385A1;
        Tue,  5 Apr 2022 08:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148370;
        bh=1svdJ2AKn28hyj1/xHu6DgEkXapWfzQJ39MN6QrfE6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iEuqv41BEivql8IjFbh0TAUS1NGX61iGbTBzGJ3upyDgpV/nEAgOWc9L9HoEjdVtK
         n0D5EbdIokWH7FMvaWE4aSp8GMMKjSm0XMXEsoV9PtYYk4aETKLMD21gdOXk0GyeHb
         G6PW4dtdpQTtxnvsOKWWAfeX/vemEZclqtn2IYac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0331/1017] media: mexon-ge2d: fixup frames size in registers
Date:   Tue,  5 Apr 2022 09:20:44 +0200
Message-Id: <20220405070404.106880475@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index ccda18e5a377..5e7b319f300d 100644
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




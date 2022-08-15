Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01850594728
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353976AbiHOXrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354798AbiHOXq0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:46:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E133C0B62;
        Mon, 15 Aug 2022 13:14:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FB98B80EAD;
        Mon, 15 Aug 2022 20:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BEFC433D6;
        Mon, 15 Aug 2022 20:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594485;
        bh=sYRBNcx3JEX19z5haS8TFFrgOPcKTVSzhQglR1OoOgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EoaRk3OcHoGloEZnD2zfI7a4VWMxrQDQ+KA+ZeMul80OQuavw3G6k7HlPQc+cNoDw
         KnbqZJ59N3CotoNmyFPgl4jvEGR+gK9/2br5pFllrQLeslRUKMg/E6WOGwoMDFHvXa
         DCR32ud6Z6yi2MyS0JmPhBo2Yagcr5r4wVFsRADE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        Yunfei Dong <yunfei.dong@mediatek.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0462/1157] media: mediatek: vcodec: Initialize decoder parameters for each instance
Date:   Mon, 15 Aug 2022 19:56:58 +0200
Message-Id: <20220815180458.088580623@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit fe3d651627d61210c6905339e5281d3b9db75033 ]

The decoder parameters are stored in each instance's context data. This
needs to be initialized per-instance, but a previous fix incorrectly
changed it to only be initialized for the first opened instance. This
resulted in subsequent instances not correctly signaling the requirement
for the Requests API.

Fix this by calling the initializing function outside of the
v4l2_fh_is_singular() conditional block.

Fixes: faddaa735c20 ("media: mediatek: vcodec: Initialize decoder parameters after getting dec_capability")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Yunfei Dong <yunfei.dong@mediatek.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c
index 99d7b15f2b9d..eed11a62febf 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c
@@ -208,11 +208,12 @@ static int fops_vcodec_open(struct file *file)
 
 		dev->dec_capability =
 			mtk_vcodec_fw_get_vdec_capa(dev->fw_handler);
-		ctx->dev->vdec_pdata->init_vdec_params(ctx);
 
 		mtk_v4l2_debug(0, "decoder capability %x", dev->dec_capability);
 	}
 
+	ctx->dev->vdec_pdata->init_vdec_params(ctx);
+
 	list_add(&ctx->list, &dev->ctx_list);
 
 	mutex_unlock(&dev->dev_mutex);
-- 
2.35.1




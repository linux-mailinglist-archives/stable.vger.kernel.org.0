Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8908F5941B2
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244955AbiHOVCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346999AbiHOVBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:01:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9382CC7FB0;
        Mon, 15 Aug 2022 12:13:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D82CAB810A3;
        Mon, 15 Aug 2022 19:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0654EC433C1;
        Mon, 15 Aug 2022 19:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590808;
        bh=z1yANs3BlEP7elGY8q4zDxeiJDlZsTMIrYLWeQA7WAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vP5awG0Rwu9h44khaCvhA02EPg6gOt2vMvJkaWFisGy0uXqXK/dMLXN/ZQCtoa/QE
         A45A7w3OAy5sUeQxC5rEh/5uBSIUX28+DN3mdR2zLuWFC1Opz1IHNJiGvcaEJekGql
         o25vUvBaUErzT8lkHLcTEzmMRJlWCeBrR6hsjdZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunfei Dong <yunfei.dong@mediatek.com>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0378/1095] media: mediatek: vcodec: Initialize decoder parameters after getting dec_capability
Date:   Mon, 15 Aug 2022 19:56:17 +0200
Message-Id: <20220815180445.330118996@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Yunfei Dong <yunfei.dong@mediatek.com>

[ Upstream commit faddaa735c208560a3f419038e8d154a01b584e3 ]

Need to get dec_capability from scp first, then initialize decoder
supported format and other parameters according to dec_capability value.

Fixes: fd00d90330d1 ("media: mtk-vcodec: vdec: move stateful ops into their own file")
Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Tested-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c     | 2 --
 drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c
index c8ee5e2b4f69..4bb8a2751271 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c
@@ -112,8 +112,6 @@ void mtk_vcodec_dec_set_default_params(struct mtk_vcodec_ctx *ctx)
 {
 	struct mtk_q_data *q_data;
 
-	ctx->dev->vdec_pdata->init_vdec_params(ctx);
-
 	ctx->m2m_ctx->q_lock = &ctx->dev->dev_mutex;
 	ctx->fh.m2m_ctx = ctx->m2m_ctx;
 	ctx->fh.ctrl_handler = &ctx->ctrl_hdl;
diff --git a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c
index fe7b2f1739b1..bd1ee9901da0 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c
@@ -211,6 +211,8 @@ static int fops_vcodec_open(struct file *file)
 
 		dev->dec_capability =
 			mtk_vcodec_fw_get_vdec_capa(dev->fw_handler);
+		ctx->dev->vdec_pdata->init_vdec_params(ctx);
+
 		mtk_v4l2_debug(0, "decoder capability %x", dev->dec_capability);
 	}
 
-- 
2.35.1




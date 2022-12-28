Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A13658460
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235302AbiL1Q5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:57:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235285AbiL1Q4g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:56:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A631DA4E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:52:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 528636156B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663E9C433D2;
        Wed, 28 Dec 2022 16:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246347;
        bh=9tm+8jRDQilPkH7rR150lBeFa5xhvMEIY4E7qaiUcWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F885V4p2dX77vFBkyI/C2DpSNwMl9g1uCYvH2JNTM6AifF+PAeG+y5atQsfvKVVNZ
         A5Y+ipMggZRLgrt6YgqOT7ToRAQwFLilWoV3w3WxEgQAXpifvCuSBjX43NYjjmGQNK
         DG+Z26qYxB9/pAqoU6kBrsfTpO1/3L0sWIr3ic74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yunfei Dong <yunfei.dong@mediatek.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1025/1146] media: mediatek: vcodec: Cant set dst buffer to done when lat decode error
Date:   Wed, 28 Dec 2022 15:42:44 +0100
Message-Id: <20221228144358.206843958@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Yunfei Dong <yunfei.dong@mediatek.com>

[ Upstream commit 3568ecd3f3a6d133ab7feffbba34955c8c79bbc4 ]

Core thread will call v4l2_m2m_buf_done to set dst buffer done for
lat architecture. If lat call v4l2_m2m_buf_done_and_job_finish to
free dst buffer when lat decode error, core thread will access kernel
NULL pointer dereference, then crash.

Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/mediatek/vcodec/mtk_vcodec_dec_stateless.c   | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateless.c b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateless.c
index e86809052a9f..ffbcee04dc26 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateless.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateless.c
@@ -253,7 +253,7 @@ static void mtk_vdec_worker(struct work_struct *work)
 
 	state = ret ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE;
 	if (!IS_VDEC_LAT_ARCH(dev->vdec_pdata->hw_arch) ||
-	    ctx->current_codec == V4L2_PIX_FMT_VP8_FRAME || ret) {
+	    ctx->current_codec == V4L2_PIX_FMT_VP8_FRAME) {
 		v4l2_m2m_buf_done_and_job_finish(dev->m2m_dev_dec, ctx->m2m_ctx, state);
 		if (src_buf_req)
 			v4l2_ctrl_request_complete(src_buf_req, &ctx->ctrl_hdl);
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84A20650182
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbiLRQbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbiLRQbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:31:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5654C15A28;
        Sun, 18 Dec 2022 08:11:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E031B80BA8;
        Sun, 18 Dec 2022 16:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13194C433EF;
        Sun, 18 Dec 2022 16:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379872;
        bh=OPvkiT7QvUdo/gNXFO9oYOmBeAvWlq2GcTA3WpacEwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXSO/KEWGncG+FZEbPuG99CreR0ou8KUlULcbGf9HQfhIiBar77xVhmD+gMYZrEnY
         H55/Th9q01pwK8qKcrypjZa7jngLCaGgjDRF3OM4N0diJ3bPXw4FchIiTikcpDN22m
         BKkvlxVUIyugd0t8Y+pgT/sEolWc/oBofP7fq9b7r30Pk4ObVJv+cpW7yBD/Dmg9Sr
         ZF0caud39mOfdUnIZTmFupdatvxB3kzahp5pUvDTL62cz6dZms5InNprNYWKeRg+9f
         LKtbao/zO3xXi4E91fBJVenncaobll3k/fH0Zzm7/RW6k3brPNkVRIjK9nWx9TFZ0W
         7ZadX3Vr/oCQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunfei Dong <yunfei.dong@mediatek.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, tiffany.lin@mediatek.com,
        andrew-ct.chen@mediatek.com, matthias.bgg@gmail.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 53/73] media: mediatek: vcodec: Can't set dst buffer to done when lat decode error
Date:   Sun, 18 Dec 2022 11:07:21 -0500
Message-Id: <20221218160741.927862-53-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160741.927862-1-sashal@kernel.org>
References: <20221218160741.927862-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index c45bd2599bb2..f41a3ff17b04 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateless.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateless.c
@@ -250,7 +250,7 @@ static void mtk_vdec_worker(struct work_struct *work)
 
 	state = ret ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE;
 	if (!IS_VDEC_LAT_ARCH(dev->vdec_pdata->hw_arch) ||
-	    ctx->current_codec == V4L2_PIX_FMT_VP8_FRAME || ret) {
+	    ctx->current_codec == V4L2_PIX_FMT_VP8_FRAME) {
 		v4l2_m2m_buf_done_and_job_finish(dev->m2m_dev_dec, ctx->m2m_ctx, state);
 		if (src_buf_req)
 			v4l2_ctrl_request_complete(src_buf_req, &ctx->ctrl_hdl);
-- 
2.35.1


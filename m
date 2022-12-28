Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210E8657E64
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbiL1PxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234153AbiL1PxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:53:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD30E186CB
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:53:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90A33B81732
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2798C433F1;
        Wed, 28 Dec 2022 15:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242787;
        bh=6WPVI2RzqdiPWNz6u8FMFbRCToeTpaZF137s1wsRmk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAveAhLr8WHxkqG6/Wxu66G6g3HQLaI1Zyi/RKW0ifImvIzXKdPZVTujcXYwuEdCu
         Q/DYC+lva5spn+pmXi2FNyzOx3KZIBWY2S3JKu+P2/tF6oP7lPwp68u5LDiVpGFZUr
         KLts3b/byYYR4YWL4PhFwC766k11NkeUJAwHg6zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yunfei Dong <yunfei.dong@mediatek.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0413/1146] media: mediatek: vcodec: Fix getting NULL pointer for dst buffer
Date:   Wed, 28 Dec 2022 15:32:32 +0100
Message-Id: <20221228144341.386152893@linuxfoundation.org>
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

[ Upstream commit d879f770e4d1d5f0d9b692d3a2702f23ee441dbb ]

The driver may can't get v4l2 buffer when lat or core decode timeout,
will lead to crash when call v4l2_m2m_buf_done to set dst buffer
(NULL pointer) done.

Fixes: 7b182b8d9c85 ("media: mediatek: vcodec: Refactor get and put capture buffer flow")
Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mediatek/vcodec/mtk_vcodec_dec_stateless.c        | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateless.c b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateless.c
index c45bd2599bb2..e86809052a9f 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateless.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_stateless.c
@@ -138,10 +138,13 @@ static void mtk_vdec_stateless_cap_to_disp(struct mtk_vcodec_ctx *ctx, int error
 		state = VB2_BUF_STATE_DONE;
 
 	vb2_dst = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
-	v4l2_m2m_buf_done(vb2_dst, state);
-
-	mtk_v4l2_debug(2, "free frame buffer id:%d to done list",
-		       vb2_dst->vb2_buf.index);
+	if (vb2_dst) {
+		v4l2_m2m_buf_done(vb2_dst, state);
+		mtk_v4l2_debug(2, "free frame buffer id:%d to done list",
+			       vb2_dst->vb2_buf.index);
+	} else {
+		mtk_v4l2_err("dst buffer is NULL");
+	}
 
 	if (src_buf_req)
 		v4l2_ctrl_request_complete(src_buf_req, &ctx->ctrl_hdl);
-- 
2.35.1




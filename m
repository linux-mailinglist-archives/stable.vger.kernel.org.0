Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F27D59472D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353876AbiHOXmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354172AbiHOXle (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EB7155CAC;
        Mon, 15 Aug 2022 13:10:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A91560F0C;
        Mon, 15 Aug 2022 20:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640E7C433D6;
        Mon, 15 Aug 2022 20:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594256;
        bh=uw//HsiRMHBa899GZSRbrnUZcOQGxjsDm5ULzHnOqJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQwqYYEWiRNsEofHxse2jRC0GEN1EYRgEox+7NPYTY/mULlThaZlA5Vdyg5itsIgY
         xTBzFdiCIIY06H5CgDjk+5ies0QrnY9tjvJR557tIK5pvCeqV317n3/jdNCL8U0Dnr
         vLoOLUstNXGIF9G9soJrbI6CNJYVXktrPBkqCHag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0402/1157] media: mediatek: vcodec: Skip SOURCE_CHANGE & EOS events for stateless
Date:   Mon, 15 Aug 2022 19:55:58 +0200
Message-Id: <20220815180455.755899657@linuxfoundation.org>
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

[ Upstream commit e13ca460e20ed42fe57a3845b0bb9a82f81f05cd ]

The stateless decoder API does not specify the usage of SOURCE_CHANGE
and EOF events. These events are used by stateful decoders to signal
changes in the bitstream. They do not make sense for stateless decoders.

Do not handle subscription for these two types of events for stateless
decoder instances. This fixes the last v4l2-compliance error:

Control ioctls:
		fail: v4l2-test-controls.cpp(946): have_source_change || have_eos
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL

Fixes: 8cdc3794b2e3 ("media: mtk-vcodec: vdec: support stateless API")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c
index 50cfb18f85ae..01836a1c7d3f 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c
@@ -196,6 +196,11 @@ static int vidioc_vdec_querycap(struct file *file, void *priv,
 static int vidioc_vdec_subscribe_evt(struct v4l2_fh *fh,
 				     const struct v4l2_event_subscription *sub)
 {
+	struct mtk_vcodec_ctx *ctx = fh_to_ctx(fh);
+
+	if (ctx->dev->vdec_pdata->uses_stateless_api)
+		return v4l2_ctrl_subscribe_event(fh, sub);
+
 	switch (sub->type) {
 	case V4L2_EVENT_EOS:
 		return v4l2_event_subscribe(fh, sub, 2, NULL);
-- 
2.35.1




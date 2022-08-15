Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC715947BA
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353872AbiHOXrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354756AbiHOXqW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:46:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D29AC0B46;
        Mon, 15 Aug 2022 13:14:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 55F34CE12EB;
        Mon, 15 Aug 2022 20:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E01C433C1;
        Mon, 15 Aug 2022 20:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594478;
        bh=3CZ5wl9UdJY2sGEAbYMMmbROfNcOiZEAYA1vCGjrkck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z5v+oEL0g/tmT/zZNSggAf1/yCbCa2+tD5Z2tCx39gs7iMTCK/9WHyc8O0w1I6xiG
         JhmwW/IZhZll0jESZn7Rre59ilzx5JuxqkODGcyVptUWPddRpH0Ze+SF4gcXpLzHk1
         9tf/KiT8GRQGhMs2WrytlT61WxeagkJFpw5Chspk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0460/1157] media: mediatek: vcodec: decoder: Skip alignment for default resolution
Date:   Mon, 15 Aug 2022 19:56:56 +0200
Message-Id: <20220815180458.010400113@linuxfoundation.org>
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

[ Upstream commit 3b6a81a31370539f1fd0e9bdd315503aa154285e ]

The default resolution of 64x64 is already aligned, according to the
call to v4l_bound_align_image() in mtk_vcodec_dec_set_default_params().

Drop the redundant v4l_bound_align_image() call. This also removes one
usage of ctx->max_{width,height}.

Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c
index 42b29f0a7436..7d654efabdfe 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c
@@ -142,13 +142,6 @@ void mtk_vcodec_dec_set_default_params(struct mtk_vcodec_ctx *ctx)
 	ctx->max_width = MTK_VDEC_MAX_W;
 	ctx->max_height = MTK_VDEC_MAX_H;
 
-	v4l_bound_align_image(&q_data->coded_width,
-				MTK_VDEC_MIN_W,
-				ctx->max_width, 4,
-				&q_data->coded_height,
-				MTK_VDEC_MIN_H,
-				ctx->max_height, 5, 6);
-
 	q_data->sizeimage[0] = q_data->coded_width * q_data->coded_height;
 	q_data->bytesperline[0] = q_data->coded_width;
 	q_data->sizeimage[1] = q_data->sizeimage[0] / 2;
-- 
2.35.1




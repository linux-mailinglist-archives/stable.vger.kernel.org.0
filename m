Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E871F59377D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243728AbiHOSpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243344AbiHOSnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:43:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B912F66B;
        Mon, 15 Aug 2022 11:27:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21F4B60FC4;
        Mon, 15 Aug 2022 18:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14834C433D7;
        Mon, 15 Aug 2022 18:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588028;
        bh=lnkl56a31MbvW6ouXWsb6NWSAKbk0Xa/VASYs6iBCg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zHbM7MXTHaHuNWxcT0J2sRXEEM8TaIg3Qx/dwsm7Oh3lvgtFCO8S+aLpbXiJNQRLp
         Y95j4eA4ENVN4GvE3OO1lrkX62RVGbT4liTBeeMsXfYafZRrbgu+5FHLghxW/u3lAZ
         NCK/wfmTAHGQCfgfaeEfTUpVyOHt13zA0AVYBVeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Mirela Rabulea <mirela.rabulea@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 273/779] media: imx-jpeg: Refactor function mxc_jpeg_parse
Date:   Mon, 15 Aug 2022 19:58:37 +0200
Message-Id: <20220815180348.974481341@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 8dd504a3a0a5f73b4c137ce3afc35936a4ecd871 ]

Refine code to support dynamic resolution change

Signed-off-by: Ming Qian <ming.qian@nxp.com>
Reviewed-by: Mirela Rabulea <mirela.rabulea@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/imx-jpeg/mxc-jpeg.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
index 2d0c1307180f..5064a994a42e 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
@@ -1236,8 +1236,7 @@ static void mxc_jpeg_sizeimage(struct mxc_jpeg_q_data *q)
 	}
 }
 
-static int mxc_jpeg_parse(struct mxc_jpeg_ctx *ctx,
-			  u8 *src_addr, u32 size, bool *dht_needed)
+static int mxc_jpeg_parse(struct mxc_jpeg_ctx *ctx, struct vb2_buffer *vb)
 {
 	struct device *dev = ctx->mxc_jpeg->dev;
 	struct mxc_jpeg_q_data *q_data_out, *q_data_cap;
@@ -1247,6 +1246,9 @@ static int mxc_jpeg_parse(struct mxc_jpeg_ctx *ctx,
 	struct v4l2_jpeg_header header;
 	struct mxc_jpeg_sof *psof = NULL;
 	struct mxc_jpeg_sos *psos = NULL;
+	struct mxc_jpeg_src_buf *jpeg_src_buf = vb2_to_mxc_buf(vb);
+	u8 *src_addr = (u8 *)vb2_plane_vaddr(vb, 0);
+	u32 size = vb2_get_plane_payload(vb, 0);
 	int ret;
 
 	memset(&header, 0, sizeof(header));
@@ -1257,7 +1259,7 @@ static int mxc_jpeg_parse(struct mxc_jpeg_ctx *ctx,
 	}
 
 	/* if DHT marker present, no need to inject default one */
-	*dht_needed = (header.num_dht == 0);
+	jpeg_src_buf->dht_needed = (header.num_dht == 0);
 
 	q_data_out = mxc_jpeg_get_q_data(ctx,
 					 V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
@@ -1372,10 +1374,7 @@ static void mxc_jpeg_buf_queue(struct vb2_buffer *vb)
 
 	jpeg_src_buf = vb2_to_mxc_buf(vb);
 	jpeg_src_buf->jpeg_parse_error = false;
-	ret = mxc_jpeg_parse(ctx,
-			     (u8 *)vb2_plane_vaddr(vb, 0),
-			     vb2_get_plane_payload(vb, 0),
-			     &jpeg_src_buf->dht_needed);
+	ret = mxc_jpeg_parse(ctx, vb);
 	if (ret)
 		jpeg_src_buf->jpeg_parse_error = true;
 
-- 
2.35.1




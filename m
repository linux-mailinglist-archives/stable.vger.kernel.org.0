Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18B15941FC
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343499AbiHOU5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347162AbiHOU4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:56:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4325018A;
        Mon, 15 Aug 2022 12:12:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5B91B81117;
        Mon, 15 Aug 2022 19:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD09C433C1;
        Mon, 15 Aug 2022 19:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590736;
        bh=hWJfRmigzXjjlg325CHFkYdC+YR8IOWJqgSXsWNhN+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p32zk5WUS7vpL50hCEM8mx7+QeyJfQ2P7ilVDtuGfLJeO023dGbZbpMeqwHC4YLuE
         sKzwFbjSV37L357dhAHjEIe3pViUTUT3hCr2UzI+lgGgGSZEuqmA+3dZOsq52n5Wqt
         UxqWx7p5Xbb1QZey2zf+fV/5pkYzuizrK2YT9kbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Mirela Rabulea <mirela.rabulea@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0354/1095] media: imx-jpeg: Refactor function mxc_jpeg_parse
Date:   Mon, 15 Aug 2022 19:55:53 +0200
Message-Id: <20220815180444.382625860@linuxfoundation.org>
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

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 8dd504a3a0a5f73b4c137ce3afc35936a4ecd871 ]

Refine code to support dynamic resolution change

Signed-off-by: Ming Qian <ming.qian@nxp.com>
Reviewed-by: Mirela Rabulea <mirela.rabulea@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
index b53b2317bcee..d5a4d66b3998 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -1252,8 +1252,7 @@ static void mxc_jpeg_sizeimage(struct mxc_jpeg_q_data *q)
 	}
 }
 
-static int mxc_jpeg_parse(struct mxc_jpeg_ctx *ctx,
-			  u8 *src_addr, u32 size, bool *dht_needed)
+static int mxc_jpeg_parse(struct mxc_jpeg_ctx *ctx, struct vb2_buffer *vb)
 {
 	struct device *dev = ctx->mxc_jpeg->dev;
 	struct mxc_jpeg_q_data *q_data_out, *q_data_cap;
@@ -1263,6 +1262,9 @@ static int mxc_jpeg_parse(struct mxc_jpeg_ctx *ctx,
 	struct v4l2_jpeg_header header;
 	struct mxc_jpeg_sof *psof = NULL;
 	struct mxc_jpeg_sos *psos = NULL;
+	struct mxc_jpeg_src_buf *jpeg_src_buf = vb2_to_mxc_buf(vb);
+	u8 *src_addr = (u8 *)vb2_plane_vaddr(vb, 0);
+	u32 size = vb2_get_plane_payload(vb, 0);
 	int ret;
 
 	memset(&header, 0, sizeof(header));
@@ -1273,7 +1275,7 @@ static int mxc_jpeg_parse(struct mxc_jpeg_ctx *ctx,
 	}
 
 	/* if DHT marker present, no need to inject default one */
-	*dht_needed = (header.num_dht == 0);
+	jpeg_src_buf->dht_needed = (header.num_dht == 0);
 
 	q_data_out = mxc_jpeg_get_q_data(ctx,
 					 V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
@@ -1388,10 +1390,7 @@ static void mxc_jpeg_buf_queue(struct vb2_buffer *vb)
 
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96A94F33B1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235342AbiDEIjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234304AbiDEIYn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:24:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C282B65C6;
        Tue,  5 Apr 2022 01:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EE2F60FFB;
        Tue,  5 Apr 2022 08:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3437CC385A0;
        Tue,  5 Apr 2022 08:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146811;
        bh=ADEi5SU0fkm1OasEUzfXS5XLxdWFJrLpnS+LEgj9ZRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jX/tHwZ+plIHXqp5I964WB3W3tu+0jITkfMVhxXTcVjmVCvWiB8xRQJTZUT5jWT0D
         OAx8KwQLOTV2foqocsPxxgfJ8adEYZVvTdTuSaj2Bw1TQc7BxSc1edl+Wio8YZditv
         FHoDZ7xEnO71+henpLjeNIqJenokQqTbzFwFSCbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mirela Rabulea <mirela.rabulea@oss.nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0897/1126] media: imx-jpeg: Prevent decoding NV12M jpegs into single-planar buffers
Date:   Tue,  5 Apr 2022 09:27:24 +0200
Message-Id: <20220405070433.852792904@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Mirela Rabulea <mirela.rabulea@oss.nxp.com>

[ Upstream commit 417591a766b3c040c346044541ff949c0b2bb7b2 ]

If the application queues an NV12M jpeg as output buffer, but then
queues a single planar capture buffer, the kernel will crash with
"Unable to handle kernel NULL pointer dereference" in mxc_jpeg_addrs,
prevent this by finishing the job with error.

Signed-off-by: Mirela Rabulea <mirela.rabulea@oss.nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/imx-jpeg/mxc-jpeg.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
index 4ca96cf9def7..b249c1bbfac8 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
@@ -947,6 +947,12 @@ static void mxc_jpeg_device_run(void *priv)
 	v4l2_m2m_buf_copy_metadata(src_buf, dst_buf, true);
 
 	jpeg_src_buf = vb2_to_mxc_buf(&src_buf->vb2_buf);
+	if (q_data_cap->fmt->colplanes != dst_buf->vb2_buf.num_planes) {
+		dev_err(dev, "Capture format %s has %d planes, but capture buffer has %d planes\n",
+			q_data_cap->fmt->name, q_data_cap->fmt->colplanes,
+			dst_buf->vb2_buf.num_planes);
+		jpeg_src_buf->jpeg_parse_error = true;
+	}
 	if (jpeg_src_buf->jpeg_parse_error) {
 		jpeg->slot_data[ctx->slot].used = false;
 		v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
-- 
2.34.1




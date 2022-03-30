Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8BE34EC27D
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345255AbiC3L6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345051AbiC3Lxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:53:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D32E27E868;
        Wed, 30 Mar 2022 04:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01A49B81BBA;
        Wed, 30 Mar 2022 11:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E89C36AE2;
        Wed, 30 Mar 2022 11:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641018;
        bh=vJB3hI7pFHLZ4ItKPzu559ozRQX/5iq+YVkCRMlueys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqL1exLACd760aXccth7GNFZA3YHeRnOlChbWg9EY/qoLigNJutqZvx2pp3sEarWK
         t+E4bqxkyT8Nf7q50s0V39goB2JDpPhAAQ5lNoOkG6cHVHhJEKYGHEobfRhnLK4eHm
         AIOSD3zTx7+fwwrftu6JBnUPa2OSUdP3NI0zVmVm2ad3Xs5cX0eGcK5ExZpMzjZDNS
         NkRX51k29gVvjcgkGtfiL8X/hGzJWP2W4hs3Xxc+KPNDSSbF1pbSp++UGL19Dzqcrc
         EKILHNVKYKofz2JZIMCjlk3h2i9cD8GFyeOKtCf77ojz5Ma4ne8MbS/1hECcMcGE3G
         2jflMEDlj1ZUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mirela Rabulea <mirela.rabulea@oss.nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 08/50] media: imx-jpeg: Prevent decoding NV12M jpegs into single-planar buffers
Date:   Wed, 30 Mar 2022 07:49:22 -0400
Message-Id: <20220330115005.1671090-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115005.1671090-1-sashal@kernel.org>
References: <20220330115005.1671090-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index fc905ea78b17..637d73f5f4a2 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
@@ -925,6 +925,12 @@ static void mxc_jpeg_device_run(void *priv)
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


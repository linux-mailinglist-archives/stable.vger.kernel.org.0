Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD94A4EC27A
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345206AbiC3L61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344385AbiC3LxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:53:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC69261980;
        Wed, 30 Mar 2022 04:48:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1239B81C28;
        Wed, 30 Mar 2022 11:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51E6C36AE2;
        Wed, 30 Mar 2022 11:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640926;
        bh=ADEi5SU0fkm1OasEUzfXS5XLxdWFJrLpnS+LEgj9ZRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TRqqvh47KSe9ZurI5qCNfWK8cOnhuLasFuNj+0hJcovf2xvCltj1I5f9ycsnbnJ0C
         RDjTT7hpz81icI3wKIhYLzIBbY/FyRr7W+wCLJUX8RKSfjrn0Czq6aog08KN8PZ2Cc
         s3ZywOpZUpW47KssGSWTkIRxo5/nNmLEedEnnHQF70KSwSaGag3V27kbL5zBmwgSoP
         F4LURRSYlKcapDS+qIG9RbJgNbWAG/a0kxJ6DkzWKZU2YI0l3Vrmg2K9xweER7kKK/
         jNC7Q/HB6cpyc2Q7YMeQLqZaJxwJ+nvPDChQi3vwQ22/dw6vWBNH7tyqttniiJZqGP
         GmBdAan9UPyIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mirela Rabulea <mirela.rabulea@oss.nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 09/59] media: imx-jpeg: Prevent decoding NV12M jpegs into single-planar buffers
Date:   Wed, 30 Mar 2022 07:47:41 -0400
Message-Id: <20220330114831.1670235-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114831.1670235-1-sashal@kernel.org>
References: <20220330114831.1670235-1-sashal@kernel.org>
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


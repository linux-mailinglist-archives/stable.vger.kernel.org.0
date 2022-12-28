Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A592657C0F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbiL1P2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:28:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbiL1P2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:28:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8478D140E8
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:28:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2146C61551
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34789C433D2;
        Wed, 28 Dec 2022 15:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241301;
        bh=dZDlGwO8+pvBOeRn5FaHAhKZzgWHyQ18e1ci9sbhsHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yjvRquKNMnwMM761LzXuW4a11dMkD1NeJHufaW6wmLG7aqpVRx6Xn5zRktbkd9aU/
         KWzppRGGgaw39HfZ7NyoCAAj/kuBQEmdFb9138FowZ28ml/nG45rqGpzCqwZ8eY8Wz
         FL1XXvt7yidRICqUmovb2mtUuxmBzZNwsVFSam3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0230/1146] media: coda: jpeg: Add check for kmalloc
Date:   Wed, 28 Dec 2022 15:29:29 +0100
Message-Id: <20221228144336.388509022@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit f30ce3d3760b22ee33c8d9c2e223764ad30bdc5f ]

As kmalloc can return NULL pointer, it should be better to
check the return value and return error, same as
coda_jpeg_decode_header.

Fixes: 96f6f62c4656 ("media: coda: jpeg: add CODA960 JPEG encoder support")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/chips-media/coda-jpeg.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/chips-media/coda-jpeg.c b/drivers/media/platform/chips-media/coda-jpeg.c
index 435e7030fc2a..ba8f41002917 100644
--- a/drivers/media/platform/chips-media/coda-jpeg.c
+++ b/drivers/media/platform/chips-media/coda-jpeg.c
@@ -1052,10 +1052,16 @@ static int coda9_jpeg_start_encoding(struct coda_ctx *ctx)
 		v4l2_err(&dev->v4l2_dev, "error loading Huffman tables\n");
 		return ret;
 	}
-	if (!ctx->params.jpeg_qmat_tab[0])
+	if (!ctx->params.jpeg_qmat_tab[0]) {
 		ctx->params.jpeg_qmat_tab[0] = kmalloc(64, GFP_KERNEL);
-	if (!ctx->params.jpeg_qmat_tab[1])
+		if (!ctx->params.jpeg_qmat_tab[0])
+			return -ENOMEM;
+	}
+	if (!ctx->params.jpeg_qmat_tab[1]) {
 		ctx->params.jpeg_qmat_tab[1] = kmalloc(64, GFP_KERNEL);
+		if (!ctx->params.jpeg_qmat_tab[1])
+			return -ENOMEM;
+	}
 	coda_set_jpeg_compression_quality(ctx, ctx->params.jpeg_quality);
 
 	return 0;
-- 
2.35.1




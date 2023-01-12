Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA2F6674D2
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbjALOO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235911AbjALONl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:13:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3F75AC44
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:06:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 581FFB81DCC
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35F1C433D2;
        Thu, 12 Jan 2023 14:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532376;
        bh=pe5eKJ6QFQLexdOIxDequbId2uIwFad5KU1W1iWG8Jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QdLwAfLemSRD3TERFdfVgv7qQ+E7JpaAioPOMkzgq1GByrfI+LpWYfTP01CltvTei
         uoUE7BiSbuKqOGqJbKXrFpN6mYZ9wUbl5LkVbXMAvn+nRRNhPZ6rfCYflgd9cXBbWw
         NGWFeV1Dcr0aNeWitaWV/1jViKCBfsq/9o3jQXHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/783] media: coda: jpeg: Add check for kmalloc
Date:   Thu, 12 Jan 2023 14:47:06 +0100
Message-Id: <20230112135529.298158876@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
 drivers/media/platform/coda/coda-jpeg.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-jpeg.c b/drivers/media/platform/coda/coda-jpeg.c
index a72f4655e5ad..b7bf529f18f7 100644
--- a/drivers/media/platform/coda/coda-jpeg.c
+++ b/drivers/media/platform/coda/coda-jpeg.c
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




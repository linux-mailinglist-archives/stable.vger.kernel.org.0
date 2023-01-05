Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8154F65EBDD
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbjAENDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbjAENDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:03:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4F657908
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:03:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8703961A05
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A837C433D2;
        Thu,  5 Jan 2023 13:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923787;
        bh=gJsqYvD9os//zOtVLUQqt7LBUZXMymTRywcCxpB7VNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=boQ3FWJHU2CADM92GOyjggaXGb5ND7qAds0KD/Tript5QZcZGxk4zpZPLwFD3O3yN
         6DevmlmLIfm7+dxME7LLtuYvdJ3N0V1jidXGjHczrbc16Mosjt3V8ZVmpLu4Fp0GaE
         wlOcYmJR9W/pqKWBl0/BGyMsb2w+FSFgn8+2VT8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 092/251] media: coda: Add check for kmalloc
Date:   Thu,  5 Jan 2023 13:53:49 +0100
Message-Id: <20230105125339.009624651@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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

[ Upstream commit 6e5e5defdb8b0186312c2f855ace175aee6daf9b ]

As the kmalloc may return NULL pointer,
it should be better to check the return value
in order to avoid NULL poineter dereference,
same as the others.

Fixes: cb1d3a336371 ("[media] coda: add CODA7541 JPEG support")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/coda/coda-bit.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index b62c7098fc8c..a933c0cb24de 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -821,10 +821,16 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 	}
 
 	if (dst_fourcc == V4L2_PIX_FMT_JPEG) {
-		if (!ctx->params.jpeg_qmat_tab[0])
+		if (!ctx->params.jpeg_qmat_tab[0]) {
 			ctx->params.jpeg_qmat_tab[0] = kmalloc(64, GFP_KERNEL);
-		if (!ctx->params.jpeg_qmat_tab[1])
+			if (!ctx->params.jpeg_qmat_tab[0])
+				return -ENOMEM;
+		}
+		if (!ctx->params.jpeg_qmat_tab[1]) {
 			ctx->params.jpeg_qmat_tab[1] = kmalloc(64, GFP_KERNEL);
+			if (!ctx->params.jpeg_qmat_tab[1])
+				return -ENOMEM;
+		}
 		coda_set_jpeg_compression_quality(ctx, ctx->params.jpeg_quality);
 	}
 
-- 
2.35.1




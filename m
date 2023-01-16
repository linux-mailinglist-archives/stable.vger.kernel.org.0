Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E30F66CBAB
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234490AbjAPRQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234266AbjAPRPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:15:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF7927D60
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:56:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B0B0B8105D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D2FC433D2;
        Mon, 16 Jan 2023 16:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888179;
        bh=XVGttKS9A4NCunIbTeoK+gQpvjWTgoCvhQan3ZS2N58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xv7K7ZGGg9P6VGXLNPb9iFsMH5gcTphtiM5JWSNO4VKOFEangzhCrgu1SBG8dHgsd
         bT5bvFgYcHpbxtYzBHro1dkFRzn6qFiMa6ReYw2FU29wv+S8fZYXFyNhBwwh3ot3vn
         0YbfbYZ3VtKhUUYx1V3sN4UkiRanzLvBopkVEOdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-fsd@tesla.com,
        Smitha T Murthy <smitha.t@samsung.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 423/521] media: s5p-mfc: Fix in register read and write for H264
Date:   Mon, 16 Jan 2023 16:51:25 +0100
Message-Id: <20230116154906.048327074@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Smitha T Murthy <smitha.t@samsung.com>

[ Upstream commit 06710cd5d2436135046898d7e4b9408c8bb99446 ]

Few of the H264 encoder registers written were not getting reflected
since the read values were not stored and getting overwritten.

Fixes: 6a9c6f681257 ("[media] s5p-mfc: Add variants to access mfc registers")

Cc: stable@vger.kernel.org
Cc: linux-fsd@tesla.com
Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 7c629be43205..1171b76df036 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1063,7 +1063,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	}
 
 	/* aspect ratio VUI */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 5);
 	reg |= ((p_h264->vui_sar & 0x1) << 5);
 	writel(reg, mfc_regs->e_h264_options);
@@ -1086,7 +1086,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 
 	/* intra picture period for H.264 open GOP */
 	/* control */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 4);
 	reg |= ((p_h264->open_gop & 0x1) << 4);
 	writel(reg, mfc_regs->e_h264_options);
@@ -1100,23 +1100,23 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	}
 
 	/* 'WEIGHTED_BI_PREDICTION' for B is disable */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x3 << 9);
 	writel(reg, mfc_regs->e_h264_options);
 
 	/* 'CONSTRAINED_INTRA_PRED_ENABLE' is disable */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 14);
 	writel(reg, mfc_regs->e_h264_options);
 
 	/* ASO */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 6);
 	reg |= ((p_h264->aso & 0x1) << 6);
 	writel(reg, mfc_regs->e_h264_options);
 
 	/* hier qp enable */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 8);
 	reg |= ((p_h264->open_gop & 0x1) << 8);
 	writel(reg, mfc_regs->e_h264_options);
@@ -1137,7 +1137,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	writel(reg, mfc_regs->e_h264_num_t_layer);
 
 	/* frame packing SEI generation */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 25);
 	reg |= ((p_h264->sei_frame_packing & 0x1) << 25);
 	writel(reg, mfc_regs->e_h264_options);
-- 
2.35.1




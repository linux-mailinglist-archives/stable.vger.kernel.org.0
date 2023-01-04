Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951F665D3B3
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 14:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239168AbjADNDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 08:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239295AbjADNDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 08:03:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0885186CE
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 05:03:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76666615B1
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 13:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633A1C433F1;
        Wed,  4 Jan 2023 13:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672837408;
        bh=YCDoDdiAlcE6aAPAb0G6tTYxuK05tKCggrQJ6Whl3CA=;
        h=Subject:To:Cc:From:Date:From;
        b=tHIM3lPBcI5d+tVpFp7iNetq4cW035W+8Tcx8arm/yEM3RRJc3jTk4TPryswLIqQ1
         EmSVSmd16NWZEv6IyH31smToOIw/IoEWdK0AOXBg98vAMOTblBukP5Li64IvjN/xez
         n+JrDyINb+VrPJvALob7MTX1EWerTkJa8+Fgj7LI=
Subject: FAILED: patch "[PATCH] media: s5p-mfc: Fix in register read and write for H264" failed to apply to 5.4-stable tree
To:     smitha.t@samsung.com, hverkuil-cisco@xs4all.nl
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 14:03:25 +0100
Message-ID: <167283740534239@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

06710cd5d243 ("media: s5p-mfc: Fix in register read and write for H264")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 06710cd5d2436135046898d7e4b9408c8bb99446 Mon Sep 17 00:00:00 2001
From: Smitha T Murthy <smitha.t@samsung.com>
Date: Wed, 7 Sep 2022 16:02:25 +0530
Subject: [PATCH] media: s5p-mfc: Fix in register read and write for H264

Few of the H264 encoder registers written were not getting reflected
since the read values were not stored and getting overwritten.

Fixes: 6a9c6f681257 ("[media] s5p-mfc: Add variants to access mfc registers")

Cc: stable@vger.kernel.org
Cc: linux-fsd@tesla.com
Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

diff --git a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_opr_v6.c
index 8227004f6746..c0df5ac9fcff 100644
--- a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1060,7 +1060,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	}
 
 	/* aspect ratio VUI */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 5);
 	reg |= ((p_h264->vui_sar & 0x1) << 5);
 	writel(reg, mfc_regs->e_h264_options);
@@ -1083,7 +1083,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 
 	/* intra picture period for H.264 open GOP */
 	/* control */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 4);
 	reg |= ((p_h264->open_gop & 0x1) << 4);
 	writel(reg, mfc_regs->e_h264_options);
@@ -1097,23 +1097,23 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
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
@@ -1134,7 +1134,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	writel(reg, mfc_regs->e_h264_num_t_layer);
 
 	/* frame packing SEI generation */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 25);
 	reg |= ((p_h264->sei_frame_packing & 0x1) << 25);
 	writel(reg, mfc_regs->e_h264_options);


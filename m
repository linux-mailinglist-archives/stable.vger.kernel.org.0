Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1007465D3A6
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 14:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236983AbjADNDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 08:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjADNCx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 08:02:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7B6167EF
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 05:02:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97422B81642
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 13:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD50AC433D2;
        Wed,  4 Jan 2023 13:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672837370;
        bh=JkRhGL6aGw5Jxca5g4hLKshiejgd6wjGVPpaks5BSoc=;
        h=Subject:To:Cc:From:Date:From;
        b=OxC+JQQtyiEcFTtxEtRLdPvSYnz0hfcv4Xsw6QT7Zo+FRiI0i9jF6Do2TbZqB9NyE
         QposzYMExkdWA3tDU3Jl0hYIz3MabRaE6jX0DrJjlBiVFrSFrI3EjdvRgbRMIkXZf2
         ORgpHzRy5YXX1PGHMLDknIn3eQG+y0+UbD44EOZo=
Subject: FAILED: patch "[PATCH] media: s5p-mfc: Clear workbit to handle error condition" failed to apply to 5.4-stable tree
To:     smitha.t@samsung.com, hverkuil-cisco@xs4all.nl
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 14:02:46 +0100
Message-ID: <1672837366918@kroah.com>
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

d3f3c2fe54e3 ("media: s5p-mfc: Clear workbit to handle error condition")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d3f3c2fe54e30b0636496d842ffbb5ad3a547f9b Mon Sep 17 00:00:00 2001
From: Smitha T Murthy <smitha.t@samsung.com>
Date: Wed, 7 Sep 2022 16:02:26 +0530
Subject: [PATCH] media: s5p-mfc: Clear workbit to handle error condition

During error on CLOSE_INSTANCE command, ctx_work_bits was not getting
cleared. During consequent mfc execution NULL pointer dereferencing of
this context led to kernel panic. This patch fixes this issue by making
sure to clear ctx_work_bits always.

Fixes: 818cd91ab8c6 ("[media] s5p-mfc: Extract open/close MFC instance commands")
Cc: stable@vger.kernel.org
Cc: linux-fsd@tesla.com
Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

diff --git a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_ctrl.c
index 72d70984e99a..6d3c92045c05 100644
--- a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_ctrl.c
@@ -468,8 +468,10 @@ void s5p_mfc_close_mfc_inst(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx)
 	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	/* Wait until instance is returned or timeout occurred */
 	if (s5p_mfc_wait_for_done_ctx(ctx,
-				S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET, 0))
+				S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET, 0)){
+		clear_work_bit_irqsave(ctx);
 		mfc_err("Err returning instance\n");
+	}
 
 	/* Free resources */
 	s5p_mfc_hw_call(dev->mfc_ops, release_codec_buffers, ctx);


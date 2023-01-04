Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B0F65D3AC
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 14:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239302AbjADNDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 08:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239311AbjADNDY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 08:03:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A922373B2
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 05:03:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0746D6164C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 13:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B905C433EF;
        Wed,  4 Jan 2023 13:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672837387;
        bh=1c1CToqpmGiz2kWzRfq6IuENlVgJ2STId1eJ2bJcrz0=;
        h=Subject:To:Cc:From:Date:From;
        b=N+yCalFaLt0UBvuqndUnQx8KlmqrROKkOVxY+LgXbPr597YDz1u3a1U5V/0jlw9wl
         0mRdYUgvkopxi44xcOYTJNBEH0106TIqkE6+QDZ76oVl28HN9HzPrtR9XuopAjlpJb
         rEehda/o6XnRG+cY9rdRzvIcNYwA4eLRImfNAjSQ=
Subject: FAILED: patch "[PATCH] media: s5p-mfc: Clear workbit to handle error condition" failed to apply to 4.9-stable tree
To:     smitha.t@samsung.com, hverkuil-cisco@xs4all.nl
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 14:03:04 +0100
Message-ID: <1672837384255178@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
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


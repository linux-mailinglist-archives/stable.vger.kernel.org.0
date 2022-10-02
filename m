Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9245F23AD
	for <lists+stable@lfdr.de>; Sun,  2 Oct 2022 16:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiJBOqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 10:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiJBOqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 10:46:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8ECB26573
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 07:46:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83FB560EDD
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 14:46:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC1FC433D6;
        Sun,  2 Oct 2022 14:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664721997;
        bh=VGQwBmDpBYY8edgsPjIo9PNkaN0o+J+VbOjB4grWr98=;
        h=Subject:To:Cc:From:Date:From;
        b=KULYoxiAxSMItlVnMh7mDPGyyNFTr7Y2CJvaKg2aeexDxoX28kyRdwYbpj/EUQa4T
         0mFFLcp11S3HHlsOudmngb0NdWjcBkqIIYwDGvDA1aWwnt+MyAvjIaZcxQxyuuVo2P
         c13iWfNVgTww2k1WEpgVU2BLFAUCIWAvaBN0pCKo=
Subject: FAILED: patch "[PATCH] media: dvb_vb2: fix possible out of bound access" failed to apply to 4.19-stable tree
To:     hbh25y@gmail.com, hverkuil-cisco@xs4all.nl, mchehab@kernel.org,
        senozhatsky@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 02 Oct 2022 16:47:15 +0200
Message-ID: <16647220356072@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

37238699073e ("media: dvb_vb2: fix possible out of bound access")
fd89e0bb6ebf ("media: videobuf2-core: integrate with media requests")
55028695c3bb ("media: vb2: drop VB2_BUF_STATE_PREPARED, use bool prepared/synced instead")
db6e8d57e2cd ("media: vb2: store userspace data in vb2_v4l2_buffer")
0af4e80bf24a ("media: videobuf2-v4l2: replace if by switch in __fill_vb2_buffer()")
5f89ec80f1e0 ("media: videobuf2-v4l2: move __fill_v4l2_buffer() function")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 37238699073e7e93f05517e529661151173cd458 Mon Sep 17 00:00:00 2001
From: Hangyu Hua <hbh25y@gmail.com>
Date: Thu, 19 May 2022 03:17:43 +0100
Subject: [PATCH] media: dvb_vb2: fix possible out of bound access

vb2_core_qbuf and vb2_core_querybuf don't check the range of b->index
controlled by the user.

Fix this by adding range checking code before using them.

Fixes: 57868acc369a ("media: videobuf2: Add new uAPI for DVB streaming I/O")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

diff --git a/drivers/media/dvb-core/dvb_vb2.c b/drivers/media/dvb-core/dvb_vb2.c
index a1bd6d9c9223..909df82fed33 100644
--- a/drivers/media/dvb-core/dvb_vb2.c
+++ b/drivers/media/dvb-core/dvb_vb2.c
@@ -354,6 +354,12 @@ int dvb_vb2_reqbufs(struct dvb_vb2_ctx *ctx, struct dmx_requestbuffers *req)
 
 int dvb_vb2_querybuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b)
 {
+	struct vb2_queue *q = &ctx->vb_q;
+
+	if (b->index >= q->num_buffers) {
+		dprintk(1, "[%s] buffer index out of range\n", ctx->name);
+		return -EINVAL;
+	}
 	vb2_core_querybuf(&ctx->vb_q, b->index, b);
 	dprintk(3, "[%s] index=%d\n", ctx->name, b->index);
 	return 0;
@@ -378,8 +384,13 @@ int dvb_vb2_expbuf(struct dvb_vb2_ctx *ctx, struct dmx_exportbuffer *exp)
 
 int dvb_vb2_qbuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b)
 {
+	struct vb2_queue *q = &ctx->vb_q;
 	int ret;
 
+	if (b->index >= q->num_buffers) {
+		dprintk(1, "[%s] buffer index out of range\n", ctx->name);
+		return -EINVAL;
+	}
 	ret = vb2_core_qbuf(&ctx->vb_q, b->index, b, NULL);
 	if (ret) {
 		dprintk(1, "[%s] index=%d errno=%d\n", ctx->name,


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0F85F2ACF
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbiJCHl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbiJCHlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:41:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB3E4AD45;
        Mon,  3 Oct 2022 00:24:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D6E660FA0;
        Mon,  3 Oct 2022 07:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4032FC433C1;
        Mon,  3 Oct 2022 07:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781779;
        bh=C3YAV3lrI8QAUFa6ta1NH/nFMDR6H6EJh8SGAbeV0q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uuJ5NyDGxK0XvAzdIkP04WVtM0hup/24n84H+KEkAG+zcR9uF8u4+QMDkQfI2il+E
         71YHAl/P/VDK63Y4CkW2Bo8NLNWYCSVcZO/kzRc2XDQcO5KYyF9D1zSdRDpw/C/X7Z
         M73C6t0iLsQeUPoseUdAV9K1aYpD1w4025t/6IWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.10 27/52] media: dvb_vb2: fix possible out of bound access
Date:   Mon,  3 Oct 2022 09:11:34 +0200
Message-Id: <20221003070719.537199276@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070718.687440096@linuxfoundation.org>
References: <20221003070718.687440096@linuxfoundation.org>
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

From: Hangyu Hua <hbh25y@gmail.com>

commit 37238699073e7e93f05517e529661151173cd458 upstream.

vb2_core_qbuf and vb2_core_querybuf don't check the range of b->index
controlled by the user.

Fix this by adding range checking code before using them.

Fixes: 57868acc369a ("media: videobuf2: Add new uAPI for DVB streaming I/O")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvb_vb2.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/media/dvb-core/dvb_vb2.c
+++ b/drivers/media/dvb-core/dvb_vb2.c
@@ -358,6 +358,12 @@ int dvb_vb2_reqbufs(struct dvb_vb2_ctx *
 
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
@@ -382,8 +388,13 @@ int dvb_vb2_expbuf(struct dvb_vb2_ctx *c
 
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



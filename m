Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C405F2A2D
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiJCHcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiJCHbB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:31:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8AEB39B9A;
        Mon,  3 Oct 2022 00:20:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96411B80E8F;
        Mon,  3 Oct 2022 07:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EA5C433C1;
        Mon,  3 Oct 2022 07:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781556;
        bh=C3YAV3lrI8QAUFa6ta1NH/nFMDR6H6EJh8SGAbeV0q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GkCosw6mUqs17qtqur8Gk7O5j+bitWPu/xBPKe0lSz8g8f2AhY5ZrJrVJ6rcia1R7
         JrU/GQj7D8wHJNerBaR0GiTRKfO80rgEzE1b8jWFwPNLqmDG+KVxuFdHTbCrmvW6S4
         I1EGNaw7uH31fHwUUfP0tyZFyncvKiyhQIT5470A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.15 35/83] media: dvb_vb2: fix possible out of bound access
Date:   Mon,  3 Oct 2022 09:11:00 +0200
Message-Id: <20221003070722.877315558@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
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



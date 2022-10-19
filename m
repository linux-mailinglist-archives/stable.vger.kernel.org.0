Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015A6603C80
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbiJSIsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbiJSIrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:47:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0112850076;
        Wed, 19 Oct 2022 01:45:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5609617FF;
        Wed, 19 Oct 2022 08:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D00C433C1;
        Wed, 19 Oct 2022 08:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169131;
        bh=UdFH1/iFHJDIGa6c18khrKEDVJy6r7SQUPt5r5yMBp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ablIAMPgWGg2k0RHRUCDJ0OevthxyWuzir4gJyvFxrtDVOKdTlYs39ebfZWKyKZhR
         DwUzTLec6TMbRWpEShQXvCT1JcBY5s3hQ5Qfx/5bc1m05M47I+yuP09SM3/GBFwg+D
         JYap1TuRvfGILVveYJhhIf6l4YAp68xi7EwbiPoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 6.0 169/862] media: cedrus: Fix watchdog race condition
Date:   Wed, 19 Oct 2022 10:24:16 +0200
Message-Id: <20221019083257.420769331@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

commit fe8b81fde69acfcbb5af9e85328e5b9549999fdb upstream.

The watchdog needs to be scheduled before we trigger the decode
operation, otherwise there is a risk that the decoder IRQ will be
called before we have schedule the watchdog. As a side effect, the
watchdog would never be cancelled and its function would be called
at an inappropriate time.

This was observed while running Fluster with GStreamer as a backend.
Some programming error would cause the decoder IRQ to be call very
quickly after the trigger. Later calls into the driver would deadlock
due to the unbalanced state.

Cc: stable@vger.kernel.org
Fixes: 7c38a551bda1 ("media: cedrus: Add watchdog for job completion")
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
@@ -106,11 +106,11 @@ void cedrus_device_run(void *priv)
 
 	/* Trigger decoding if setup went well, bail out otherwise. */
 	if (!error) {
-		dev->dec_ops[ctx->current_codec]->trigger(ctx);
-
 		/* Start the watchdog timer. */
 		schedule_delayed_work(&dev->watchdog_work,
 				      msecs_to_jiffies(2000));
+
+		dev->dec_ops[ctx->current_codec]->trigger(ctx);
 	} else {
 		v4l2_m2m_buf_done_and_job_finish(ctx->dev->m2m_dev,
 						 ctx->fh.m2m_ctx,



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50166000D0
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 17:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJPPn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 11:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiJPPnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 11:43:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D18E31EC5
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 08:43:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D476660C05
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E62C433D7;
        Sun, 16 Oct 2022 15:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665935033;
        bh=n9D4r/cZG2iIDRRH5equLcTL+0QE4GzjhotQ1UtU4fQ=;
        h=Subject:To:Cc:From:Date:From;
        b=eZ2UyJrC67P7euJIynJPduygvd72jmXfO1GgxOepOpOokjUIa5Fs8Y6keBSFmdw19
         Hj84BbBUYkCCevY8+AHWdgvQtovPGbe3+/X9CyqempJBTKlyGguL12UrbnXp5+jNYa
         S1lq2pkyEvMPw0mobn/Smm36SqLOUudO3ApzR9oQ=
Subject: FAILED: patch "[PATCH] media: cedrus: Fix watchdog race condition" failed to apply to 5.19-stable tree
To:     nicolas.dufresne@collabora.com, hverkuil-cisco@xs4all.nl,
        mchehab@kernel.org, paul.kocialkowski@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 17:44:39 +0200
Message-ID: <1665935079229102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

fe8b81fde69a ("media: cedrus: Fix watchdog race condition")
4af46bcc4915 ("media: cedrus: Add error handling for failed setup")
f1a413902aa7 ("media: cedrus: h265: Fix logic for not low delay flag")
104a70e1d0bc ("media: cedrus: h265: Fix flag name")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fe8b81fde69acfcbb5af9e85328e5b9549999fdb Mon Sep 17 00:00:00 2001
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Date: Thu, 18 Aug 2022 22:33:06 +0200
Subject: [PATCH] media: cedrus: Fix watchdog race condition

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

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
index 3b6aa78a2985..e7f7602a5ab4 100644
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


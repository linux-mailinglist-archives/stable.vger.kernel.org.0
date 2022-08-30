Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8045A657D
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 15:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiH3NuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 09:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiH3NtS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 09:49:18 -0400
Received: from www.linuxtv.org (www.linuxtv.org [130.149.80.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E836175AC
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 06:47:15 -0700 (PDT)
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1oT1Io-005Tok-HI; Tue, 30 Aug 2022 13:29:14 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Tue, 30 Aug 2022 12:45:10 +0000
Subject: [git:media_stage/master] media: cedrus: Fix watchdog race condition
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1oT1Io-005Tok-HI@www.linuxtv.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: cedrus: Fix watchdog race condition
Author:  Nicolas Dufresne <nicolas.dufresne@collabora.com>
Date:    Thu Aug 18 22:33:06 2022 +0200

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

 drivers/staging/media/sunxi/cedrus/cedrus_dec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

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

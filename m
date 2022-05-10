Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF0F521864
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243222AbiEJNfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243456AbiEJNeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:34:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57657238D75;
        Tue, 10 May 2022 06:24:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C3D761768;
        Tue, 10 May 2022 13:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724FEC385C2;
        Tue, 10 May 2022 13:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189062;
        bh=dwo1c1VqB1TjhnB+lmO0evpTKYjAmpjBUdoni3XMw14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uG5P7bC38VJFI5zBaFd5K6kf30OwVzI3+J1FKTrNBYrNbeC3aktHoP0r92ey6A23y
         RZ9RflW6axqvC2Et0BiLIITkkzvZWmcmLqQZJNygytgFmfsgBiCRt2akiL1n2dBQp6
         Of5rmVAr6490CjLZtFAna+ADjJUekCF3y+DdmEEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 43/52] ALSA: pcm: Fix races among concurrent read/write and buffer changes
Date:   Tue, 10 May 2022 15:08:12 +0200
Message-Id: <20220510130731.112125943@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.852544477@linuxfoundation.org>
References: <20220510130729.852544477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit dca947d4d26dbf925a64a6cfb2ddbc035e831a3d upstream.

In the current PCM design, the read/write syscalls (as well as the
equivalent ioctls) are allowed before the PCM stream is running, that
is, at PCM PREPARED state.  Meanwhile, we also allow to re-issue
hw_params and hw_free ioctl calls at the PREPARED state that may
change or free the buffers, too.  The problem is that there is no
protection against those mix-ups.

This patch applies the previously introduced runtime->buffer_mutex to
the read/write operations so that the concurrent hw_params or hw_free
call can no longer interfere during the operation.  The mutex is
unlocked before scheduling, so we don't take it too long.

Cc: <stable@vger.kernel.org>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20220322170720.3529-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_lib.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1861,9 +1861,11 @@ static int wait_for_avail(struct snd_pcm
 		if (avail >= runtime->twake)
 			break;
 		snd_pcm_stream_unlock_irq(substream);
+		mutex_unlock(&runtime->buffer_mutex);
 
 		tout = schedule_timeout(wait_time);
 
+		mutex_lock(&runtime->buffer_mutex);
 		snd_pcm_stream_lock_irq(substream);
 		set_current_state(TASK_INTERRUPTIBLE);
 		switch (runtime->status->state) {
@@ -2157,6 +2159,7 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(str
 
 	nonblock = !!(substream->f_flags & O_NONBLOCK);
 
+	mutex_lock(&runtime->buffer_mutex);
 	snd_pcm_stream_lock_irq(substream);
 	err = pcm_accessible_state(runtime);
 	if (err < 0)
@@ -2244,6 +2247,7 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(str
 	if (xfer > 0 && err >= 0)
 		snd_pcm_update_state(substream, runtime);
 	snd_pcm_stream_unlock_irq(substream);
+	mutex_unlock(&runtime->buffer_mutex);
 	return xfer > 0 ? (snd_pcm_sframes_t)xfer : err;
 }
 EXPORT_SYMBOL(__snd_pcm_lib_xfer);



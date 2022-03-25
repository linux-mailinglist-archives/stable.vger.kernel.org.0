Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11F84E76C8
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353951AbiCYPT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376378AbiCYPTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:19:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9CCDFD72;
        Fri, 25 Mar 2022 08:15:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 51351CE2A52;
        Fri, 25 Mar 2022 15:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA2EC340E9;
        Fri, 25 Mar 2022 15:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221301;
        bh=NHAaKMt9HrxNA462vkEI8qLSD2LtZZgfaKLsxWUH5UA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWGQqZZ8dMvbXBrtuE5332sWbFvinIs1jY4gIaqaMnRPQqYlz9vnCCvOXoSPD6cTw
         SvzWwxdaJfLCTKK+dny2hl3nbKRIJN9B4+lrAQE8zs00dpJMMRxpzUuRBAvA1RKa33
         iXC73ynFpdX9EyLychIc8330BnHFkTv3dEfV6280=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 14/37] ALSA: pcm: Fix races among concurrent read/write and buffer changes
Date:   Fri, 25 Mar 2022 16:14:15 +0100
Message-Id: <20220325150420.341990836@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150419.931802116@linuxfoundation.org>
References: <20220325150419.931802116@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_lib.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1905,9 +1905,11 @@ static int wait_for_avail(struct snd_pcm
 		if (avail >= runtime->twake)
 			break;
 		snd_pcm_stream_unlock_irq(substream);
+		mutex_unlock(&runtime->buffer_mutex);
 
 		tout = schedule_timeout(wait_time);
 
+		mutex_lock(&runtime->buffer_mutex);
 		snd_pcm_stream_lock_irq(substream);
 		set_current_state(TASK_INTERRUPTIBLE);
 		switch (runtime->status->state) {
@@ -2201,6 +2203,7 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(str
 
 	nonblock = !!(substream->f_flags & O_NONBLOCK);
 
+	mutex_lock(&runtime->buffer_mutex);
 	snd_pcm_stream_lock_irq(substream);
 	err = pcm_accessible_state(runtime);
 	if (err < 0)
@@ -2288,6 +2291,7 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(str
 	if (xfer > 0 && err >= 0)
 		snd_pcm_update_state(substream, runtime);
 	snd_pcm_stream_unlock_irq(substream);
+	mutex_unlock(&runtime->buffer_mutex);
 	return xfer > 0 ? (snd_pcm_sframes_t)xfer : err;
 }
 EXPORT_SYMBOL(__snd_pcm_lib_xfer);



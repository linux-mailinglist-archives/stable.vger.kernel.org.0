Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B4F526420
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380816AbiEMO1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381085AbiEMO0b (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:26:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0244850B24;
        Fri, 13 May 2022 07:26:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3C14B83068;
        Fri, 13 May 2022 14:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2767C34100;
        Fri, 13 May 2022 14:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652451976;
        bh=3gwdWpVVxSY2RAbkBx16m29vhyxddLubsNCdmoGDlqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MDSyw7EU8tbTpgUnKuMQuajHU6EkNHMcSVrmKXGjte4BH29hrnHM39J3aqqigw3z2
         hg3/yWjxrGB+jvj5aDUztfAi2Ai7O7+ypniOHyti4mG3WqBNVqkingIrJ3BVZ2AF0I
         UtDN2qDbdte0nQ3PyNjF/Y7+ykstMXRkGKuSrdto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 09/15] ALSA: pcm: Fix races among concurrent read/write and buffer changes
Date:   Fri, 13 May 2022 16:23:31 +0200
Message-Id: <20220513142228.170275746@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142227.897535454@linuxfoundation.org>
References: <20220513142227.897535454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_lib.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1876,9 +1876,11 @@ static int wait_for_avail(struct snd_pcm
 		if (avail >= runtime->twake)
 			break;
 		snd_pcm_stream_unlock_irq(substream);
+		mutex_unlock(&runtime->buffer_mutex);
 
 		tout = schedule_timeout(wait_time);
 
+		mutex_lock(&runtime->buffer_mutex);
 		snd_pcm_stream_lock_irq(substream);
 		set_current_state(TASK_INTERRUPTIBLE);
 		switch (runtime->status->state) {
@@ -2172,6 +2174,7 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(str
 
 	nonblock = !!(substream->f_flags & O_NONBLOCK);
 
+	mutex_lock(&runtime->buffer_mutex);
 	snd_pcm_stream_lock_irq(substream);
 	err = pcm_accessible_state(runtime);
 	if (err < 0)
@@ -2254,6 +2257,7 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(str
 	if (xfer > 0 && err >= 0)
 		snd_pcm_update_state(substream, runtime);
 	snd_pcm_stream_unlock_irq(substream);
+	mutex_unlock(&runtime->buffer_mutex);
 	return xfer > 0 ? (snd_pcm_sframes_t)xfer : err;
 }
 EXPORT_SYMBOL(__snd_pcm_lib_xfer);



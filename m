Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760B03D5558
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 10:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbhGZHiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 03:38:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232438AbhGZHiM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 03:38:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 721E860BD3;
        Mon, 26 Jul 2021 08:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627287520;
        bh=cu81W/NHOsOmM5ZsMrtYiV8WQ8TLT6d5i3yODITwWag=;
        h=Subject:To:Cc:From:Date:From;
        b=Xko1fqUPfYz3401DwWz3OceHK15HZn6teMOSJCAMqI+JuGab5ilgJizI2by7LiDba
         2Z8KrHjOiuadj4r5samAwbvz2PfGauogSlbxUAcfhmC+p3LJ3nYLGXk72+VNrrQuLP
         t/Q0ONGBJLUpVSY6a/48hONJ5qBa6T36KoW56u9E=
Subject: FAILED: patch "[PATCH] ALSA: pcm: Call substream ack() method upon compat mmap" failed to apply to 5.4-stable tree
To:     consult.awy@gmail.com, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 26 Jul 2021 10:09:30 +0200
Message-ID: <162728697013399@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2e2832562c877e6530b8480982d99a4ff90c6777 Mon Sep 17 00:00:00 2001
From: Alan Young <consult.awy@gmail.com>
Date: Fri, 9 Jul 2021 09:48:54 +0100
Subject: [PATCH] ALSA: pcm: Call substream ack() method upon compat mmap
 commit

If a 32-bit application is being used with a 64-bit kernel and is using
the mmap mechanism to write data, then the SNDRV_PCM_IOCTL_SYNC_PTR
ioctl results in calling snd_pcm_ioctl_sync_ptr_compat(). Make this use
pcm_lib_apply_appl_ptr() so that the substream's ack() method, if
defined, is called.

The snd_pcm_sync_ptr() function, used in the 64-bit ioctl case, already
uses snd_pcm_ioctl_sync_ptr_compat().

Fixes: 9027c4639ef1 ("ALSA: pcm: Call ack() whenever appl_ptr is updated")
Signed-off-by: Alan Young <consult.awy@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/c441f18c-eb2a-3bdd-299a-696ccca2de9c@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 14e32825c339..c88c4316c417 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3063,9 +3063,14 @@ static int snd_pcm_ioctl_sync_ptr_compat(struct snd_pcm_substream *substream,
 		boundary = 0x7fffffff;
 	snd_pcm_stream_lock_irq(substream);
 	/* FIXME: we should consider the boundary for the sync from app */
-	if (!(sflags & SNDRV_PCM_SYNC_PTR_APPL))
-		control->appl_ptr = scontrol.appl_ptr;
-	else
+	if (!(sflags & SNDRV_PCM_SYNC_PTR_APPL)) {
+		err = pcm_lib_apply_appl_ptr(substream,
+				scontrol.appl_ptr);
+		if (err < 0) {
+			snd_pcm_stream_unlock_irq(substream);
+			return err;
+		}
+	} else
 		scontrol.appl_ptr = control->appl_ptr % boundary;
 	if (!(sflags & SNDRV_PCM_SYNC_PTR_AVAIL_MIN))
 		control->avail_min = scontrol.avail_min;


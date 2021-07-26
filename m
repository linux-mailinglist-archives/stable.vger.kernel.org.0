Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4793C3D610F
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbhGZP2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:28:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237803AbhGZPZq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:25:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 706D260F5A;
        Mon, 26 Jul 2021 16:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315573;
        bh=Ms46Wuh3lvtd0oUH+Yk/TH1tPXCIs0k2QhqSzkN3W8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mu2oJAdGEoWV0ng3Geuuvwav/ov0hy4GEKH3wPv6gDDgfdhBIrkgRF2JdS5iCEvTP
         8UZ2S0zxNpDtanhVMRMJMvmPFF1s1pfmlVtfVeFnRVY+FgsNnLeDrYwC2sNCp9NUAf
         SRaVGUyz42s+3twh4cWYhivwzRAofLbhR942FLaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Young <consult.awy@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 114/167] ALSA: pcm: Call substream ack() method upon compat mmap commit
Date:   Mon, 26 Jul 2021 17:39:07 +0200
Message-Id: <20210726153843.232828350@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Young <consult.awy@gmail.com>

commit 2e2832562c877e6530b8480982d99a4ff90c6777 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_native.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3062,9 +3062,14 @@ static int snd_pcm_ioctl_sync_ptr_compat
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



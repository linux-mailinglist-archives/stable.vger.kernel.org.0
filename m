Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B6133B99C
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234901AbhCOOGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233467AbhCOOBo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA04664F2E;
        Mon, 15 Mar 2021 14:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816896;
        bh=HB43tIWA/SDJJ+Ad8NreII/d3eY5xm7qwiFNHDfBMVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HzuYyCrVTcpmQWq/MlTp/m/p8NJtCifW29LgZe9zUzNGu4/apvBTrurMB6KfkHGYR
         +TNpQ9TQJ+CL5GWb5mYnZqnyJlXt1jR3dPHAI1SUdNTO4bbyBfHKdjh4RevWKX6K3P
         EFQjtdZ+Yc243CyNGCPdtwFIkfk2Oe4FdU5uuxeY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 175/290] ALSA: hda: Drop the BATCH workaround for AMD controllers
Date:   Mon, 15 Mar 2021 14:54:28 +0100
Message-Id: <20210315135547.824783899@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Takashi Iwai <tiwai@suse.de>

commit 28e96c1693ec1cdc963807611f8b5ad400431e82 upstream.

The commit c02f77d32d2c ("ALSA: hda - Workaround for crackled sound on
AMD controller (1022:1457)") introduced a few workarounds for the
recent AMD HD-audio controller, and one of them is the forced BATCH
PCM mode so that PulseAudio avoids the timer-based scheduling.  This
was thought to cover for some badly working applications, but this
actually worsens for more others.  In total, this wasn't a good idea
to enforce it.

This is a partial revert of the commit above for dropping the PCM
BATCH enforcement part to recover from the regression again.

Fixes: c02f77d32d2c ("ALSA: hda - Workaround for crackled sound on AMD controller (1022:1457)")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=195303
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210308160726.22930-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_controller.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -609,13 +609,6 @@ static int azx_pcm_open(struct snd_pcm_s
 				     20,
 				     178000000);
 
-	/* by some reason, the playback stream stalls on PulseAudio with
-	 * tsched=1 when a capture stream triggers.  Until we figure out the
-	 * real cause, disable tsched mode by telling the PCM info flag.
-	 */
-	if (chip->driver_caps & AZX_DCAPS_AMD_WORKAROUND)
-		runtime->hw.info |= SNDRV_PCM_INFO_BATCH;
-
 	if (chip->align_buffer_size)
 		/* constrain buffer sizes to be multiple of 128
 		   bytes. This is more efficient in terms of memory



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB7933B7AB
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhCOOBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230270AbhCON7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 728F164F4F;
        Mon, 15 Mar 2021 13:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816759;
        bh=Cx7Z6Teu877+PcieRFJ0pOYWFpG8cXlCbz19Qlmfev0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lprL3i00Nv3F4Ms1cyrKq0fdGONOw1mHTRqNw7B5spr7nhy0Y2qx+2HwwtONC6eSp
         FyOFNcmZZzFleXsBhnJnV2riUhCn1eOhZ3BAzvz7OTdEFWOcAOGGVgeOuHDV2g9g4C
         PVlwnEGtpJb4rVvo2/rj2jVvCwn7D96nVa+lxDTk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 42/95] ALSA: hda: Drop the BATCH workaround for AMD controllers
Date:   Mon, 15 Mar 2021 14:57:12 +0100
Message-Id: <20210315135741.651429790@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
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
@@ -624,13 +624,6 @@ static int azx_pcm_open(struct snd_pcm_s
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



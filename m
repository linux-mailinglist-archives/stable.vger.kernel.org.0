Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26165329141
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243173AbhCAUXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:23:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237956AbhCAUQK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:16:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C9D5653D6;
        Mon,  1 Mar 2021 18:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621739;
        bh=StUN6qv2fDakXp7d1EgfmAGFiqggaDwaCbenc3GI2vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OMw/E/viIRH300jBfkFeA9bPejC5wabqO+R9NdGu7ulQFrJttV4Gz9N2ob0lnyThz
         4Hh+hIB7WI2Yhsb7csyCvGuPHrctP1sAHFpULINpvew+PJhhDa3/6CFzrBb3k5Tp+2
         YI1CyC9c40iSpod4fDU00u2kMhrAlstO+zStuNfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 596/775] ALSA: usb-audio: Dont avoid stopping the stream at disconnection
Date:   Mon,  1 Mar 2021 17:12:44 +0100
Message-Id: <20210301161230.873822491@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 257d2d7e9e798305d65825cb82b0a7d1c0511e89 upstream.

In the later patch, we're going to issue the PCM sync_stop calls at
disconnection.  But currently the USB-audio driver can't handle it
because it has a check of shutdown flag for stopping the URBs.  This
is basically superfluous (the stopping URBs are safe at disconnection
state), so let's drop the check.

Fixes: dc5eafe7787c ("ALSA: usb-audio: Support PCM sync_stop")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210206203052.15606-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |    3 ---
 sound/usb/pcm.c      |    5 +----
 2 files changed, 1 insertion(+), 7 deletions(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -890,9 +890,6 @@ static int stop_urbs(struct snd_usb_endp
 {
 	unsigned int i;
 
-	if (!force && atomic_read(&ep->chip->shutdown)) /* to be sure... */
-		return -EBADFD;
-
 	if (!force && atomic_read(&ep->running))
 		return -EBUSY;
 
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -270,10 +270,7 @@ static int snd_usb_pcm_sync_stop(struct
 {
 	struct snd_usb_substream *subs = substream->runtime->private_data;
 
-	if (!snd_usb_lock_shutdown(subs->stream->chip)) {
-		sync_pending_stops(subs);
-		snd_usb_unlock_shutdown(subs->stream->chip);
-	}
+	sync_pending_stops(subs);
 	return 0;
 }
 



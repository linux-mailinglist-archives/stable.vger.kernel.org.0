Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F3D341C50
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhCSMUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:20:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230453AbhCSMT7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:19:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1880764F75;
        Fri, 19 Mar 2021 12:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156399;
        bh=KYDgQbS3tlwEfUBobQ6Qwxw3RMAUnDVO4mu0lFbu1VQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LduzkEVkQeo5H6flYB/cReRYWHlGGXg2RoL02BM+uNVcAOuKF8Ao5INo+KWcqd1sq
         0I/WCuJ+pLT7WoMMVvxWIs82xOWXSpRuJBZR3V5u/Cd539+rlOzhtMBi4hzUxNLzvS
         r9HjuSb3U2nA9378bTV23X5gY9xWdhEky+ruVJa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.10 12/13] ALSA: usb-audio: Dont avoid stopping the stream at disconnection
Date:   Fri, 19 Mar 2021 13:19:09 +0100
Message-Id: <20210319121745.503824062@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121745.112612545@linuxfoundation.org>
References: <20210319121745.112612545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 257d2d7e9e798305d65825cb82b0a7d1c0511e89 upstream

In the later patch, we're going to issue the PCM sync_stop calls at
disconnection.  But currently the USB-audio driver can't handle it
because it has a check of shutdown flag for stopping the URBs.  This
is basically superfluous (the stopping URBs are safe at disconnection
state), so let's drop the check.

Fixes: dc5eafe7787c ("ALSA: usb-audio: Support PCM sync_stop")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210206203052.15606-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |    3 ---
 sound/usb/pcm.c      |    5 +----
 2 files changed, 1 insertion(+), 7 deletions(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -576,9 +576,6 @@ static int deactivate_urbs(struct snd_us
 {
 	unsigned int i;
 
-	if (!force && atomic_read(&ep->chip->shutdown)) /* to be sure... */
-		return -EBADFD;
-
 	clear_bit(EP_FLAG_RUNNING, &ep->flags);
 
 	INIT_LIST_HEAD(&ep->ready_playback_urbs);
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -280,10 +280,7 @@ static int snd_usb_pcm_sync_stop(struct
 {
 	struct snd_usb_substream *subs = substream->runtime->private_data;
 
-	if (!snd_usb_lock_shutdown(subs->stream->chip)) {
-		sync_pending_stops(subs);
-		snd_usb_unlock_shutdown(subs->stream->chip);
-	}
+	sync_pending_stops(subs);
 	return 0;
 }
 



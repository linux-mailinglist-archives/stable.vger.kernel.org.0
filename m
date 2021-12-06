Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38367469D3D
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349485AbhLFP2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:28:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40652 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358396AbhLFPYY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:24:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 055E16131B;
        Mon,  6 Dec 2021 15:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13F9C341C1;
        Mon,  6 Dec 2021 15:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804052;
        bh=xK7leu6dHAMktzkNzqRf+5HU2isjzX2K5dKG/Xc3DgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRAcVVcDqTGxhrJU92ZZ528XnqGK6wL7yJwLCzq6Z/cM3Nb/41vXlxj2lXFEVDQl7
         qy3wpeynzh+qmGU07tAjOmhIlLM9jyo1Movxxb4/FulcVZs+JC8ypnDPKMV4gVB9tX
         KIenwGFbEofAE0Whctw2FTcXhOFi3z1VLceD2HaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 010/207] ALSA: usb-audio: Less restriction for low-latency playback mode
Date:   Mon,  6 Dec 2021 15:54:24 +0100
Message-Id: <20211206145610.541848445@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 53451b6da8271905941eb1eb369db152c4bd92f2 upstream.

The recent support for the improved low-latency playback mode applied
the SNDRV_PCM_INFO_EXPLICIT_SYNC flag for the target streams, but this
was a slight overkill.  The use of the flag above disables effectively
both PCM status and control mmaps, while basically what we want to
track is only about the appl_ptr update.

For less restriction, use a more proper flag,
SNDRV_PCM_INFO_SYNC_APPLPTR instead, which disables only the control
mmap.

Fixes: d5f871f89e21 ("ALSA: usb-audio: Improved lowlatency playback support")
Link: https://lore.kernel.org/r/20211011103650.10182-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/pcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1095,7 +1095,7 @@ static int snd_usb_pcm_open(struct snd_p
 	/* need an explicit sync to catch applptr update in low-latency mode */
 	if (direction == SNDRV_PCM_STREAM_PLAYBACK &&
 	    as->chip->lowlatency)
-		runtime->hw.info |= SNDRV_PCM_INFO_EXPLICIT_SYNC;
+		runtime->hw.info |= SNDRV_PCM_INFO_SYNC_APPLPTR;
 	runtime->private_data = subs;
 	subs->pcm_substream = substream;
 	/* runtime PM is also done there */



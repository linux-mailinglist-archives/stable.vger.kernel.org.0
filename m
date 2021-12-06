Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DE2469D3F
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358080AbhLFP2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:28:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42492 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377254AbhLFPYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:24:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 994766132E;
        Mon,  6 Dec 2021 15:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82651C341C1;
        Mon,  6 Dec 2021 15:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804058;
        bh=AfjDW6raq0l3h/y8hprG5rwy+CEBocYRTp3L2VXs6/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQ5h8f+kfuX2Kz/IoEwWFKvHC3F+K2q8vifKrS+R6OtAHwFHofRyaBqwifuPntLKH
         //QPYNjJzgJdeFQpY8gCUhq3ZjZATaiBHR1HscQQZCEgsmAO7pGvQS0hGhmPxqBC6U
         20fy19GKwf3UbfP4l+0+Nf2Vfv/ih1Jo7Z9KS7II=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 012/207] ALSA: usb-audio: Dont start stream for capture at prepare
Date:   Mon,  6 Dec 2021 15:54:26 +0100
Message-Id: <20211206145610.617373155@linuxfoundation.org>
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

commit 83de8f83816e8e15227dac985163e3d433a2bf9d upstream.

The recent change made mistakenly the stream for capture started at
prepare stage.  Add the stream direction check to avoid it.

Fixes: 9c9a3b9da891 ("ALSA: usb-audio: Rename early_playback_start flag with lowlatency_playback")
Link: https://lore.kernel.org/r/20211119102629.7476-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/pcm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -640,7 +640,8 @@ static int snd_usb_pcm_prepare(struct sn
 	runtime->delay = 0;
 
 	subs->lowlatency_playback = lowlatency_playback_available(runtime, subs);
-	if (!subs->lowlatency_playback)
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK &&
+	    !subs->lowlatency_playback)
 		ret = start_endpoints(subs);
 
  unlock:



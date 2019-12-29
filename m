Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 932CF12C60F
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730384AbfL2Rmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:42:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:49692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729136AbfL2Rmz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:42:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B1F620718;
        Sun, 29 Dec 2019 17:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641375;
        bh=J011jsk8+8CVo/CuBSlInnxf+uzT+GCmNPqICo3oCT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NwG7/hEPlb3DAiDNiboaPAISkhEcYImA1VnDaWJceOAABKXIGbmVEGNmSlKeVTo1w
         q4enMdgruwaIS7U86wS6AD6KL2DL7KD1+RPy85zyV+OzWr2NRkG1CUKMBS5mFQ/f7p
         jae581v9qTPaC9Aj3T1kMBIWHlAFPL4x45ULLs18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lionel Koenig <lionel.koenig@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 039/434] ALSA: pcm: Avoid possible info leaks from PCM stream buffers
Date:   Sun, 29 Dec 2019 18:21:32 +0100
Message-Id: <20191229172704.633648787@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit add9d56d7b3781532208afbff5509d7382fb6efe upstream.

The current PCM code doesn't initialize explicitly the buffers
allocated for PCM streams, hence it might leak some uninitialized
kernel data or previous stream contents by mmapping or reading the
buffer before actually starting the stream.

Since this is a common problem, this patch simply adds the clearance
of the buffer data at hw_params callback.  Although this does only
zero-clear no matter which format is used, which doesn't mean the
silence for some formats, but it should be OK because the intention is
just to clear the previous data on the buffer.

Reported-by: Lionel Koenig <lionel.koenig@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191211155742.3213-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/pcm_native.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -705,6 +705,10 @@ static int snd_pcm_hw_params(struct snd_
 	while (runtime->boundary * 2 <= LONG_MAX - runtime->buffer_size)
 		runtime->boundary *= 2;
 
+	/* clear the buffer for avoiding possible kernel info leaks */
+	if (runtime->dma_area && !substream->ops->copy_user)
+		memset(runtime->dma_area, 0, runtime->dma_bytes);
+
 	snd_pcm_timer_resolution_change(substream);
 	snd_pcm_set_state(substream, SNDRV_PCM_STATE_SETUP);
 



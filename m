Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461C120E646
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404089AbgF2Vps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:45:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbgF2Sfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E454924198;
        Mon, 29 Jun 2020 15:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443954;
        bh=W6nYFsliarw/sXQfZhZfO2ar4K+Ic32NaYMRTcGs9/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kC7l/r7fEkKo3wAvbPYU9ktyP/0MhF/aEBhL25lzlp5toW+jLdj1Mmqxiun4Yt3OT
         VE/m+SLzXPLS67oC9nTVf95/Q7hJrXz5tprrmErGUHtjR3xyCeBg9dvTIcpFTOcI2q
         o/N1BdXVrT9YsqQtfpUVw/kp5skgPww/mj1Ea9UY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 056/265] ALSA: usb-audio: Fix potential use-after-free of streams
Date:   Mon, 29 Jun 2020 11:14:49 -0400
Message-Id: <20200629151818.2493727-57-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit ff58bbc7b9704a5869204176f804eff57307fef0 ]

With the recent full-duplex support of implicit feedback streams, an
endpoint can be still running after closing the capture stream as long
as the playback stream with the sync-endpoint is running.  In such a
state, the URBs are still be handled and they may call retire_data_urb
callback, which tries to transfer the data from the PCM buffer.  Since
the PCM stream gets closed, this may lead to use-after-free.

This patch adds the proper clearance of the callback at stopping the
capture stream for addressing the possible UAF above.

Fixes: 10ce77e4817f ("ALSA: usb-audio: Add duplex sound support for USB devices using implicit feedback")
Link: https://lore.kernel.org/r/20200616120921.12249-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/pcm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index d61c2f1095b5c..3411e27eb64bb 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1782,6 +1782,7 @@ static int snd_usb_substream_capture_trigger(struct snd_pcm_substream *substream
 		return 0;
 	case SNDRV_PCM_TRIGGER_STOP:
 		stop_endpoints(subs);
+		subs->data_endpoint->retire_data_urb = NULL;
 		subs->running = 0;
 		return 0;
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-- 
2.25.1


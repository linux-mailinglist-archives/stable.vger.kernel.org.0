Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 587501F1FE
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbfEOL7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:59:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730305AbfEOLPb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:15:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FB4D20843;
        Wed, 15 May 2019 11:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918930;
        bh=J3RLMfzo+nRwLHRwAtAg0VMgCVR+ronI7cHNuzp2X3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QzhvsGYRrTzfsbyu3EzvBWaENiQvZxjxXMWa31uIq9ln9Q3z9YuO5PrscAerqGA1m
         0lU847v2fwaEPXS9Li0RzIYrxscFa3u0mtjLkDwzAReHnxiD+LRhUp0iasOoJtBTeJ
         vBaUISYucol3Hz1mERHOxzzSguam6RM8DpaQvnmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.9 31/51] ALSA: pcm: remove SNDRV_PCM_IOCTL1_INFO internal command
Date:   Wed, 15 May 2019 12:56:06 +0200
Message-Id: <20190515090626.104628544@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090616.669619870@linuxfoundation.org>
References: <20190515090616.669619870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit e11f0f90a626f93899687b1cc909ee37dd6c5809 upstream.

Drivers can implement 'struct snd_pcm_ops.ioctl' to handle some requests
from ALSA PCM core. These requests are internal purpose in kernel land.
Usually common set of operations are used for it.

SNDRV_PCM_IOCTL1_INFO is one of the requests. According to code comment,
it has been obsoleted in the old days.

We can see old releases in ftp.alsa-project.org. The command was firstly
introduced in v0.5.0 release as SND_PCM_IOCTL1_INFO, to allow drivers to
fill data of 'struct snd_pcm_channel_info' type. In v0.9.0 release,
this was obsoleted by the other commands for ioctl(2) such as
SNDRV_PCM_IOCTL_CHANNEL_INFO.

This commit removes the long-abandoned command, bye.

Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/sound/pcm.h     |    2 +-
 sound/core/pcm_lib.c    |    2 --
 sound/core/pcm_native.c |    6 +-----
 3 files changed, 2 insertions(+), 8 deletions(-)

--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -100,7 +100,7 @@ struct snd_pcm_ops {
 #endif
 
 #define SNDRV_PCM_IOCTL1_RESET		0
-#define SNDRV_PCM_IOCTL1_INFO		1
+/* 1 is absent slot. */
 #define SNDRV_PCM_IOCTL1_CHANNEL_INFO	2
 #define SNDRV_PCM_IOCTL1_GSTATE		3
 #define SNDRV_PCM_IOCTL1_FIFO_SIZE	4
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1849,8 +1849,6 @@ int snd_pcm_lib_ioctl(struct snd_pcm_sub
 		      unsigned int cmd, void *arg)
 {
 	switch (cmd) {
-	case SNDRV_PCM_IOCTL1_INFO:
-		return 0;
 	case SNDRV_PCM_IOCTL1_RESET:
 		return snd_pcm_lib_ioctl_reset(substream, arg);
 	case SNDRV_PCM_IOCTL1_CHANNEL_INFO:
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -214,11 +214,7 @@ int snd_pcm_info(struct snd_pcm_substrea
 	info->subdevices_avail = pstr->substream_count - pstr->substream_opened;
 	strlcpy(info->subname, substream->name, sizeof(info->subname));
 	runtime = substream->runtime;
-	/* AB: FIXME!!! This is definitely nonsense */
-	if (runtime) {
-		info->sync = runtime->sync;
-		substream->ops->ioctl(substream, SNDRV_PCM_IOCTL1_INFO, info);
-	}
+
 	return 0;
 }
 



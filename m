Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C723289C0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238526AbhCASE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:04:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:54092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239216AbhCAR67 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:58:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B255C650A3;
        Mon,  1 Mar 2021 17:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620068;
        bh=M9y9HyCBuuj9Y4V4+6kz6oq+YyIJCQPMbKFEPLEqsXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9cJA6+vNpehxKJ824c9y+2AZJ0dKGSoxtbHl/jLERqIVjOZlSznylRf0hJnkQ1g0
         DTikkJFEHXJrF3jAjRWaCYKyNuqJxM2meweq061RccxZmlXaMIE277X+bgSSbZXFJa
         0Jgq0MMQCEd5m6XgEj/b8xweM9cbvFGtRHEss9VA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 019/775] ALSA: pcm: Call sync_stop at disconnection
Date:   Mon,  1 Mar 2021 17:03:07 +0100
Message-Id: <20210301161202.665328301@linuxfoundation.org>
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

commit 29bb274e94974669acb5186a75538f20df1508b6 upstream.

The PCM core should perform the sync for the pending stop operations
at disconnection.  Otherwise it may lead to unexpected access.

Currently the old user of sync_stop, USB-audio driver, has its own
sync, so this isn't needed, but it's better to guarantee the sync in
the PCM core level.

This patch adds the missing sync_stop call at PCM disconnection
callback.  It also assures the IRQ sync if it's specified in the
card.  snd_pcm_sync_stop() is slightly modified to be called also for
any PCM substream object now.

Fixes: 1e850beea278 ("ALSA: pcm: Add the support for sync-stop operation")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210206203656.15959-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/init.c       |    4 ++++
 sound/core/pcm.c        |    4 ++++
 sound/core/pcm_local.h  |    1 +
 sound/core/pcm_native.c |   16 ++++++++--------
 4 files changed, 17 insertions(+), 8 deletions(-)

--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -14,6 +14,7 @@
 #include <linux/ctype.h>
 #include <linux/pm.h>
 #include <linux/completion.h>
+#include <linux/interrupt.h>
 
 #include <sound/core.h>
 #include <sound/control.h>
@@ -416,6 +417,9 @@ int snd_card_disconnect(struct snd_card
 	/* notify all devices that we are disconnected */
 	snd_device_disconnect_all(card);
 
+	if (card->sync_irq > 0)
+		synchronize_irq(card->sync_irq);
+
 	snd_info_card_disconnect(card);
 	if (card->registered) {
 		device_del(&card->card_dev);
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -1111,6 +1111,10 @@ static int snd_pcm_dev_disconnect(struct
 		}
 	}
 
+	for (cidx = 0; cidx < 2; cidx++)
+		for (substream = pcm->streams[cidx].substream; substream; substream = substream->next)
+			snd_pcm_sync_stop(substream, false);
+
 	pcm_call_notify(pcm, n_disconnect);
 	for (cidx = 0; cidx < 2; cidx++) {
 		snd_unregister_device(&pcm->streams[cidx].dev);
--- a/sound/core/pcm_local.h
+++ b/sound/core/pcm_local.h
@@ -63,6 +63,7 @@ static inline void snd_pcm_timer_done(st
 
 void __snd_pcm_xrun(struct snd_pcm_substream *substream);
 void snd_pcm_group_init(struct snd_pcm_group *group);
+void snd_pcm_sync_stop(struct snd_pcm_substream *substream, bool sync_irq);
 
 #ifdef CONFIG_SND_DMA_SGBUF
 struct page *snd_pcm_sgbuf_ops_page(struct snd_pcm_substream *substream,
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -583,13 +583,13 @@ static inline void snd_pcm_timer_notify(
 #endif
 }
 
-static void snd_pcm_sync_stop(struct snd_pcm_substream *substream)
+void snd_pcm_sync_stop(struct snd_pcm_substream *substream, bool sync_irq)
 {
-	if (substream->runtime->stop_operating) {
+	if (substream->runtime && substream->runtime->stop_operating) {
 		substream->runtime->stop_operating = false;
-		if (substream->ops->sync_stop)
+		if (substream->ops && substream->ops->sync_stop)
 			substream->ops->sync_stop(substream);
-		else if (substream->pcm->card->sync_irq > 0)
+		else if (sync_irq && substream->pcm->card->sync_irq > 0)
 			synchronize_irq(substream->pcm->card->sync_irq);
 	}
 }
@@ -686,7 +686,7 @@ static int snd_pcm_hw_params(struct snd_
 		if (atomic_read(&substream->mmap_count))
 			return -EBADFD;
 
-	snd_pcm_sync_stop(substream);
+	snd_pcm_sync_stop(substream, true);
 
 	params->rmask = ~0U;
 	err = snd_pcm_hw_refine(substream, params);
@@ -809,7 +809,7 @@ static int do_hw_free(struct snd_pcm_sub
 {
 	int result = 0;
 
-	snd_pcm_sync_stop(substream);
+	snd_pcm_sync_stop(substream, true);
 	if (substream->ops->hw_free)
 		result = substream->ops->hw_free(substream);
 	if (substream->managed_buffer_alloc)
@@ -1736,7 +1736,7 @@ static void snd_pcm_post_resume(struct s
 	snd_pcm_trigger_tstamp(substream);
 	runtime->status->state = runtime->status->suspended_state;
 	snd_pcm_timer_notify(substream, SNDRV_TIMER_EVENT_MRESUME);
-	snd_pcm_sync_stop(substream);
+	snd_pcm_sync_stop(substream, true);
 }
 
 static const struct action_ops snd_pcm_action_resume = {
@@ -1866,7 +1866,7 @@ static int snd_pcm_do_prepare(struct snd
 			      snd_pcm_state_t state)
 {
 	int err;
-	snd_pcm_sync_stop(substream);
+	snd_pcm_sync_stop(substream, true);
 	err = substream->ops->prepare(substream);
 	if (err < 0)
 		return err;



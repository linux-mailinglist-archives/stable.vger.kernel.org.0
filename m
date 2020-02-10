Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5399157542
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbgBJMjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:39:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:38356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728940AbgBJMjq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:46 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8572E2051A;
        Mon, 10 Feb 2020 12:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338386;
        bh=dQft7Jsp+PifajobanTiCRRBQKL883ifoUu3o6aGT+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eh93tTZrC3FAckTwswLuDrmnFKhOekDShYRQex/AiUMQ9kQZtm2YoqUdIauv+ps9z
         IOHTKP3HMqftbvAd+wrSBf6kKTcSw27YOeDTeiMEO34bjMo9Gb5sxvWrRjlijVXOsa
         Zv5ay5np1HMWdVN+DAx9j54HSTD2hGI0a5TRWw9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+30edd0f34bfcdc548ac4@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.5 030/367] ALSA: pcm: Fix memory leak at closing a stream without hw_free
Date:   Mon, 10 Feb 2020 04:29:03 -0800
Message-Id: <20200210122426.682758235@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 66f2d19f8116e16898f8d82e28573a384ddc430d upstream.

ALSA PCM core recently introduced a new managed PCM buffer allocation
mode that does allocate / free automatically at hw_params and
hw_free.  However, it overlooked the code path directly calling
hw_free PCM ops at releasing the PCM substream, and it may result in a
memory leak as spotted by syzkaller when no buffer preallocation is
used (e.g. vmalloc buffer).

This patch papers over it with a slight refactoring.  The hw_free ops
call and relevant tasks are unified in a new helper function, and call
it from both places.

Fixes: 0dba808eae26 ("ALSA: pcm: Introduce managed buffer allocation mode")
Reported-by: syzbot+30edd0f34bfcdc548ac4@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200129195907.12197-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/pcm_native.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -785,10 +785,22 @@ end:
 	return err;
 }
 
+static int do_hw_free(struct snd_pcm_substream *substream)
+{
+	int result = 0;
+
+	snd_pcm_sync_stop(substream);
+	if (substream->ops->hw_free)
+		result = substream->ops->hw_free(substream);
+	if (substream->managed_buffer_alloc)
+		snd_pcm_lib_free_pages(substream);
+	return result;
+}
+
 static int snd_pcm_hw_free(struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime;
-	int result = 0;
+	int result;
 
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
@@ -805,11 +817,7 @@ static int snd_pcm_hw_free(struct snd_pc
 	snd_pcm_stream_unlock_irq(substream);
 	if (atomic_read(&substream->mmap_count))
 		return -EBADFD;
-	snd_pcm_sync_stop(substream);
-	if (substream->ops->hw_free)
-		result = substream->ops->hw_free(substream);
-	if (substream->managed_buffer_alloc)
-		snd_pcm_lib_free_pages(substream);
+	result = do_hw_free(substream);
 	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
 	pm_qos_remove_request(&substream->latency_pm_qos_req);
 	return result;
@@ -2466,9 +2474,7 @@ void snd_pcm_release_substream(struct sn
 
 	snd_pcm_drop(substream);
 	if (substream->hw_opened) {
-		if (substream->ops->hw_free &&
-		    substream->runtime->status->state != SNDRV_PCM_STATE_OPEN)
-			substream->ops->hw_free(substream);
+		do_hw_free(substream);
 		substream->ops->close(substream);
 		substream->hw_opened = 0;
 	}



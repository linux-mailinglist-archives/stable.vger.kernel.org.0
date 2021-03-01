Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E52328A90
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239473AbhCASS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:18:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:34036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239249AbhCASN5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:13:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79E51650A4;
        Mon,  1 Mar 2021 17:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620071;
        bh=P1jLZCoPLPAe2kTFYk2rZLhFjJdpb0WXqLVHhY3KMXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RL1zl9RtIQuC2OoAqyTgVhyycb4mUUH3VVW30d7ywUo+lzB6wyKXcgYiuz803j3WR
         7ubHf7onDED9ie3DrK6otnhXupsWqJhjifvCeociGad6OJ4kHgieWsAVfHlH6VyijW
         8I9MO2c5lz8nT0kCdsVhAdDaYb4T2PM4XjgNu2XA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 020/775] ALSA: pcm: Assure sync with the pending stop operation at suspend
Date:   Mon,  1 Mar 2021 17:03:08 +0100
Message-Id: <20210301161202.712697625@linuxfoundation.org>
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

commit 2c87c1a49c9d113a9f3e8e951d7d64be5ff50ac1 upstream.

The current PCM code calls the sync_stop at the resume action due to
the analogy to the PCM prepare call pattern.  But, it makes little
sense, as the sync should have been done rather at the suspend time,
not at the resume time.

This patch corrects the sync_stop call at suspend/resume to assure the
sync before finishing the suspend.

Fixes: 1e850beea278 ("ALSA: pcm: Add the support for sync-stop operation")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210206203656.15959-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_native.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1615,6 +1615,7 @@ static int snd_pcm_do_suspend(struct snd
 	if (! snd_pcm_running(substream))
 		return 0;
 	substream->ops->trigger(substream, SNDRV_PCM_TRIGGER_SUSPEND);
+	runtime->stop_operating = true;
 	return 0; /* suspend unconditionally */
 }
 
@@ -1691,6 +1692,12 @@ int snd_pcm_suspend_all(struct snd_pcm *
 				return err;
 		}
 	}
+
+	for (stream = 0; stream < 2; stream++)
+		for (substream = pcm->streams[stream].substream;
+		     substream; substream = substream->next)
+			snd_pcm_sync_stop(substream, false);
+
 	return 0;
 }
 EXPORT_SYMBOL(snd_pcm_suspend_all);
@@ -1736,7 +1743,6 @@ static void snd_pcm_post_resume(struct s
 	snd_pcm_trigger_tstamp(substream);
 	runtime->status->state = runtime->status->suspended_state;
 	snd_pcm_timer_notify(substream, SNDRV_TIMER_EVENT_MRESUME);
-	snd_pcm_sync_stop(substream, true);
 }
 
 static const struct action_ops snd_pcm_action_resume = {



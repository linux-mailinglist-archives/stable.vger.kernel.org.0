Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E3588E23
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfHJUwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:52:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54144 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726584AbfHJUnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:52 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDM-00053a-Q8; Sat, 10 Aug 2019 21:43:48 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-0003bG-VE; Sat, 10 Aug 2019 21:43:45 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Takashi Iwai" <tiwai@suse.de>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.28313327@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 048/157] ALSA: pcm: Don't suspend stream in
 unrecoverable PCM state
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 113ce08109f8e3b091399e7cc32486df1cff48e7 upstream.

Currently PCM core sets each opened stream forcibly to SUSPENDED state
via snd_pcm_suspend_all() call, and the user-space is responsible for
re-triggering the resume manually either via snd_pcm_resume() or
prepare call.  The scheme works fine usually, but there are corner
cases where the stream can't be resumed by that call: the streams
still in OPEN state before finishing hw_params.  When they are
suspended, user-space cannot perform resume or prepare because they
haven't been set up yet.  The only possible recovery is to re-open the
device, which isn't nice at all.  Similarly, when a stream is in
DISCONNECTED state, it makes no sense to change it to SUSPENDED
state.  Ditto for in SETUP state; which you can re-prepare directly.

So, this patch addresses these issues by filtering the PCM streams to
be suspended by checking the PCM state.  When a stream is in either
OPEN, SETUP or DISCONNECTED as well as already SUSPENDED, the suspend
action is skipped.

To be noted, this problem was originally reported for the PCM runtime
PM on HD-audio.  And, the runtime PM problem itself was already
addressed (although not intended) by the code refactoring commits
3d21ef0b49f8 ("ALSA: pcm: Suspend streams globally via device type PM
ops") and 17bc4815de58 ("ALSA: pci: Remove superfluous
snd_pcm_suspend*() calls").  These commits eliminated the
snd_pcm_suspend*() calls from the runtime PM suspend callback code
path, hence the racy OPEN state won't appear while runtime PM.
(FWIW, the race window is between snd_pcm_open_substream() and the
first power up in azx_pcm_open().)

Although the runtime PM issue was already "fixed", the same problem is
still present for the system PM, hence this patch is still needed.
And for stable trees, this patch alone should suffice for fixing the
runtime PM problem, too.

Reported-and-tested-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/core/pcm_native.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1063,8 +1063,15 @@ static int snd_pcm_pause(struct snd_pcm_
 static int snd_pcm_pre_suspend(struct snd_pcm_substream *substream, int state)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	if (runtime->status->state == SNDRV_PCM_STATE_SUSPENDED)
+	switch (runtime->status->state) {
+	case SNDRV_PCM_STATE_SUSPENDED:
 		return -EBUSY;
+	/* unresumable PCM state; return -EBUSY for skipping suspend */
+	case SNDRV_PCM_STATE_OPEN:
+	case SNDRV_PCM_STATE_SETUP:
+	case SNDRV_PCM_STATE_DISCONNECTED:
+		return -EBUSY;
+	}
 	runtime->trigger_master = substream;
 	return 0;
 }


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2868E88E35
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfHJUwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:52:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54106 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726565AbfHJUnv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:51 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDM-00053L-Gx; Sat, 10 Aug 2019 21:43:48 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-0003ae-KQ; Sat, 10 Aug 2019 21:43:45 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Takashi Iwai" <tiwai@suse.de>,
        syzbot+d4503ae45b65c5bc1194@syzkaller.appspotmail.com
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.88518302@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 040/157] ALSA: pcm: Fix possible OOB access in PCM
 oss plugins
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

commit ca0214ee2802dd47239a4e39fb21c5b00ef61b22 upstream.

The PCM OSS emulation converts and transfers the data on the fly via
"plugins".  The data is converted over the dynamically allocated
buffer for each plugin, and recently syzkaller caught OOB in this
flow.

Although the bisection by syzbot pointed out to the commit
65766ee0bf7f ("ALSA: oss: Use kvzalloc() for local buffer
allocations"), this is merely a commit to replace vmalloc() with
kvmalloc(), hence it can't be the cause.  The further debug action
revealed that this happens in the case where a slave PCM doesn't
support only the stereo channels while the OSS stream is set up for a
mono channel.  Below is a brief explanation:

At each OSS parameter change, the driver sets up the PCM hw_params
again in snd_pcm_oss_change_params_lock().  This is also the place
where plugins are created and local buffers are allocated.  The
problem is that the plugins are created before the final hw_params is
determined.  Namely, two snd_pcm_hw_param_near() calls for setting the
period size and periods may influence on the final result of channels,
rates, etc, too, while the current code has already created plugins
beforehand with the premature values.  So, the plugin believes that
channels=1, while the actual I/O is with channels=2, which makes the
driver reading/writing over the allocated buffer size.

The fix is simply to move the plugin allocation code after the final
hw_params call.

Reported-by: syzbot+d4503ae45b65c5bc1194@syzkaller.appspotmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/core/oss/pcm_oss.c | 43 ++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -951,6 +951,28 @@ static int snd_pcm_oss_change_params_loc
 	oss_frame_size = snd_pcm_format_physical_width(params_format(params)) *
 			 params_channels(params) / 8;
 
+	err = snd_pcm_oss_period_size(substream, params, sparams);
+	if (err < 0)
+		goto failure;
+
+	n = snd_pcm_plug_slave_size(substream, runtime->oss.period_bytes / oss_frame_size);
+	err = snd_pcm_hw_param_near(substream, sparams, SNDRV_PCM_HW_PARAM_PERIOD_SIZE, n, NULL);
+	if (err < 0)
+		goto failure;
+
+	err = snd_pcm_hw_param_near(substream, sparams, SNDRV_PCM_HW_PARAM_PERIODS,
+				     runtime->oss.periods, NULL);
+	if (err < 0)
+		goto failure;
+
+	snd_pcm_kernel_ioctl(substream, SNDRV_PCM_IOCTL_DROP, NULL);
+
+	err = snd_pcm_kernel_ioctl(substream, SNDRV_PCM_IOCTL_HW_PARAMS, sparams);
+	if (err < 0) {
+		pcm_dbg(substream->pcm, "HW_PARAMS failed: %i\n", err);
+		goto failure;
+	}
+
 #ifdef CONFIG_SND_PCM_OSS_PLUGINS
 	snd_pcm_oss_plugin_clear(substream);
 	if (!direct) {
@@ -985,27 +1007,6 @@ static int snd_pcm_oss_change_params_loc
 	}
 #endif
 
-	err = snd_pcm_oss_period_size(substream, params, sparams);
-	if (err < 0)
-		goto failure;
-
-	n = snd_pcm_plug_slave_size(substream, runtime->oss.period_bytes / oss_frame_size);
-	err = snd_pcm_hw_param_near(substream, sparams, SNDRV_PCM_HW_PARAM_PERIOD_SIZE, n, NULL);
-	if (err < 0)
-		goto failure;
-
-	err = snd_pcm_hw_param_near(substream, sparams, SNDRV_PCM_HW_PARAM_PERIODS,
-				     runtime->oss.periods, NULL);
-	if (err < 0)
-		goto failure;
-
-	snd_pcm_kernel_ioctl(substream, SNDRV_PCM_IOCTL_DROP, NULL);
-
-	if ((err = snd_pcm_kernel_ioctl(substream, SNDRV_PCM_IOCTL_HW_PARAMS, sparams)) < 0) {
-		pcm_dbg(substream->pcm, "HW_PARAMS failed: %i\n", err);
-		goto failure;
-	}
-
 	memset(sw_params, 0, sizeof(*sw_params));
 	if (runtime->oss.trigger) {
 		sw_params->start_threshold = 1;


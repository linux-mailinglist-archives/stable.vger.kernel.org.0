Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 979FB156726
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbgBHSj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:39:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33398 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727471AbgBHS3b (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:31 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrB-0003Zn-QI; Sat, 08 Feb 2020 18:29:29 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrB-000CIS-73; Sat, 08 Feb 2020 18:29:29 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Takashi Iwai" <tiwai@suse.de>, "Chris Rorvick" <chris@rorvick.com>
Date:   Sat, 08 Feb 2020 18:19:00 +0000
Message-ID: <lsq.1581185940.345545851@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 001/148] ALSA: line6: Drop superfluous snd_device for PCM
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b45a7c565473d29bd7e02ac8ca86232a24ca247f upstream.

Instead of handling the card-specific resource in snd_device, attach
it into pcm->private_data and release it directly in private_free.
This simplifies the code and structure.

Tested-by: Chris Rorvick <chris@rorvick.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.16 as dependency of commit 1bc8d18c75fe
 "ALSA: line6: Fix memory leak at line6_init_pcm() error path"]
 - Adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/line6/pcm.c | 53 ++++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 34 deletions(-)

--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -345,24 +345,21 @@ static void line6_cleanup_pcm(struct snd
 			usb_free_urb(line6pcm->urb_audio_in[i]);
 		}
 	}
+	kfree(line6pcm);
 }
 
 /* create a PCM device */
-static int snd_line6_new_pcm(struct snd_line6_pcm *line6pcm)
+static int snd_line6_new_pcm(struct usb_line6 *line6, struct snd_pcm **pcm_ret)
 {
 	struct snd_pcm *pcm;
 	int err;
 
-	err = snd_pcm_new(line6pcm->line6->card,
-			  (char *)line6pcm->line6->properties->name,
-			  0, 1, 1, &pcm);
+	err = snd_pcm_new(line6->card, (char *)line6->properties->name,
+			  0, 1, 1, pcm_ret);
 	if (err < 0)
 		return err;
-
-	pcm->private_data = line6pcm;
-	pcm->private_free = line6_cleanup_pcm;
-	line6pcm->pcm = pcm;
-	strcpy(pcm->name, line6pcm->line6->properties->name);
+	pcm = *pcm_ret;
+	strcpy(pcm->name, line6->properties->name);
 
 	/* set operators */
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK,
@@ -374,13 +371,6 @@ static int snd_line6_new_pcm(struct snd_
 					      snd_dma_continuous_data
 					      (GFP_KERNEL), 64 * 1024,
 					      128 * 1024);
-
-	return 0;
-}
-
-/* PCM device destructor */
-static int snd_line6_pcm_free(struct snd_device *device)
-{
 	return 0;
 }
 
@@ -416,12 +406,9 @@ void line6_pcm_disconnect(struct snd_lin
 int line6_init_pcm(struct usb_line6 *line6,
 		   struct line6_pcm_properties *properties)
 {
-	static struct snd_device_ops pcm_ops = {
-		.dev_free = snd_line6_pcm_free,
-	};
-
 	int err;
 	int ep_read = 0, ep_write = 0;
+	struct snd_pcm *pcm;
 	struct snd_line6_pcm *line6pcm;
 
 	if (!(line6->properties->capabilities & LINE6_BIT_PCM))
@@ -475,11 +462,16 @@ int line6_init_pcm(struct usb_line6 *lin
 		MISSING_CASE;
 	}
 
-	line6pcm = kzalloc(sizeof(*line6pcm), GFP_KERNEL);
+	err = snd_line6_new_pcm(line6, &pcm);
+	if (err < 0)
+		return err;
 
-	if (line6pcm == NULL)
+	line6pcm = kzalloc(sizeof(*line6pcm), GFP_KERNEL);
+	if (!line6pcm)
 		return -ENOMEM;
 
+	line6pcm->pcm = pcm;
+	line6pcm->properties = properties;
 	line6pcm->volume_playback[0] = line6pcm->volume_playback[1] = 255;
 	line6pcm->volume_monitor = 255;
 	line6pcm->line6 = line6;
@@ -498,22 +490,15 @@ int line6_init_pcm(struct usb_line6 *lin
 		return -EINVAL;
 	}
 
-	line6pcm->properties = properties;
-	line6->line6pcm = line6pcm;
-
-	/* PCM device: */
-	err = snd_device_new(line6->card, SNDRV_DEV_PCM, line6, &pcm_ops);
-	if (err < 0)
-		return err;
-
-	err = snd_line6_new_pcm(line6pcm);
-	if (err < 0)
-		return err;
-
 	spin_lock_init(&line6pcm->lock_audio_out);
 	spin_lock_init(&line6pcm->lock_audio_in);
 	spin_lock_init(&line6pcm->lock_trigger);
 
+	line6->line6pcm = line6pcm;
+
+	pcm->private_data = line6pcm;
+	pcm->private_free = line6_cleanup_pcm;
+
 	err = line6_create_audio_out_urbs(line6pcm);
 	if (err < 0)
 		return err;


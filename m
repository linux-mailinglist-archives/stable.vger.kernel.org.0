Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59490411DAF
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349306AbhITRWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:22:40 -0400
Received: from mail1.perex.cz ([77.48.224.245]:59446 "EHLO mail1.perex.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346962AbhITRUi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:20:38 -0400
Received: from mail1.perex.cz (localhost [127.0.0.1])
        by smtp1.perex.cz (Perex's E-mail Delivery System) with ESMTP id A0D26A003F;
        Mon, 20 Sep 2021 19:19:09 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp1.perex.cz A0D26A003F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=perex.cz; s=default;
        t=1632158349; bh=XmUVQPaOBC1QAFDDKkeAwE2fGcNGPc+yCSGpokeuGsM=;
        h=From:To:Cc:Subject:Date:From;
        b=3VMBBkBUGZqH2aMKVTdfpyVYR25V7/furf0ZyOqvbIb3Y3Or4E0f6ck6FdoZI9SF2
         DD9VAu0S2pMhi8aJB6Q96OtzBXb4VY6r1K4mSWUaPiqJ8l16lcL0Om+yJyL+eKV1C0
         vG6+m2O3HLofUcsdznLOp8+Zj3vfjCX98lv7S7Ic=
Received: from p1gen2.perex-int.cz (unknown [192.168.100.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: perex)
        by mail1.perex.cz (Perex's E-mail Delivery System) with ESMTPSA;
        Mon, 20 Sep 2021 19:19:04 +0200 (CEST)
From:   Jaroslav Kysela <perex@perex.cz>
To:     ALSA development <alsa-devel@alsa-project.org>
Cc:     Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        David Henningsson <coding@diwic.se>, stable@vger.kernel.org
Subject: [PATCH v2] ALSA: rawmidi: introduce SNDRV_RAWMIDI_IOCTL_USER_PVERSION
Date:   Mon, 20 Sep 2021 19:18:50 +0200
Message-Id: <20210920171850.154186-1-perex@perex.cz>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The new framing mode causes the user space regression, because
the alsa-lib code does not initialize the reserved space in
the params structure when the device is opened.

This change adds SNDRV_RAWMIDI_IOCTL_USER_PVERSION like we
do for the PCM interface for the protocol acknowledgment.

Cc: David Henningsson <coding@diwic.se>
Cc: <stable@vger.kernel.org>
Fixes: 08fdced60ca0 ("ALSA: rawmidi: Add framing mode")
BugLink: https://github.com/alsa-project/alsa-lib/issues/178
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
---
 include/sound/rawmidi.h     | 1 +
 include/uapi/sound/asound.h | 1 +
 sound/core/rawmidi.c        | 9 +++++++++
 3 files changed, 11 insertions(+)

diff --git a/include/sound/rawmidi.h b/include/sound/rawmidi.h
index 989e1517332d..7a08ed2acd60 100644
--- a/include/sound/rawmidi.h
+++ b/include/sound/rawmidi.h
@@ -98,6 +98,7 @@ struct snd_rawmidi_file {
 	struct snd_rawmidi *rmidi;
 	struct snd_rawmidi_substream *input;
 	struct snd_rawmidi_substream *output;
+	unsigned int user_pversion;	/* supported protocol version */
 };
 
 struct snd_rawmidi_str {
diff --git a/include/uapi/sound/asound.h b/include/uapi/sound/asound.h
index 1d84ec9db93b..5859ca0a1439 100644
--- a/include/uapi/sound/asound.h
+++ b/include/uapi/sound/asound.h
@@ -784,6 +784,7 @@ struct snd_rawmidi_status {
 
 #define SNDRV_RAWMIDI_IOCTL_PVERSION	_IOR('W', 0x00, int)
 #define SNDRV_RAWMIDI_IOCTL_INFO	_IOR('W', 0x01, struct snd_rawmidi_info)
+#define SNDRV_RAWMIDI_IOCTL_USER_PVERSION _IOW('W', 0x02, int)
 #define SNDRV_RAWMIDI_IOCTL_PARAMS	_IOWR('W', 0x10, struct snd_rawmidi_params)
 #define SNDRV_RAWMIDI_IOCTL_STATUS	_IOWR('W', 0x20, struct snd_rawmidi_status)
 #define SNDRV_RAWMIDI_IOCTL_DROP	_IOW('W', 0x30, int)
diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index 6c0a4a67ad2e..6f30231bdb88 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -873,12 +873,21 @@ static long snd_rawmidi_ioctl(struct file *file, unsigned int cmd, unsigned long
 			return -EINVAL;
 		}
 	}
+	case SNDRV_RAWMIDI_IOCTL_USER_PVERSION:
+		if (get_user(rfile->user_pversion, (unsigned int __user *)arg))
+			return -EFAULT;
+		return 0;
+
 	case SNDRV_RAWMIDI_IOCTL_PARAMS:
 	{
 		struct snd_rawmidi_params params;
 
 		if (copy_from_user(&params, argp, sizeof(struct snd_rawmidi_params)))
 			return -EFAULT;
+		if (rfile->user_pversion < SNDRV_PROTOCOL_VERSION(2, 0, 2)) {
+			params.mode = 0;
+			memset(params.reserved, 0, sizeof(params.reserved));
+		}
 		switch (params.stream) {
 		case SNDRV_RAWMIDI_STREAM_OUTPUT:
 			if (rfile->output == NULL)
-- 
2.31.1

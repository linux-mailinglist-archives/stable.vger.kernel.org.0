Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164FA420F24
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236377AbhJDNbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:31:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237075AbhJDN3y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:29:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A317F63217;
        Mon,  4 Oct 2021 13:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353200;
        bh=rpLhAIABTnDAQ3XCCglWj+vsyjstCqUg+9CzjH/sCG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UbdPgt5GR7HsHNRZGEeGwicr9rQOER2ScDRy31QrD5TwPErmG0c4c3Aef377ou1xN
         GkjVtM8y94izh6YJU8YOXBnsnXVMR0VA6Y/CJBzpn7eqMIa0A/7O/b9M06jPP4PW1j
         UsSZfJW+2g+gAFoo4KJ5luAum4VvH5ZovXt/FKDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Henningsson <coding@diwic.se>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 035/172] ALSA: rawmidi: introduce SNDRV_RAWMIDI_IOCTL_USER_PVERSION
Date:   Mon,  4 Oct 2021 14:51:25 +0200
Message-Id: <20211004125046.106750937@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslav Kysela <perex@perex.cz>

commit 09d23174402da0f10e98da2c61bb5ac8e7d79fdd upstream.

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
Link: https://lore.kernel.org/r/20210920171850.154186-1-perex@perex.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/sound/rawmidi.h     |    1 +
 include/uapi/sound/asound.h |    1 +
 sound/core/rawmidi.c        |    9 +++++++++
 3 files changed, 11 insertions(+)

--- a/include/sound/rawmidi.h
+++ b/include/sound/rawmidi.h
@@ -98,6 +98,7 @@ struct snd_rawmidi_file {
 	struct snd_rawmidi *rmidi;
 	struct snd_rawmidi_substream *input;
 	struct snd_rawmidi_substream *output;
+	unsigned int user_pversion;	/* supported protocol version */
 };
 
 struct snd_rawmidi_str {
--- a/include/uapi/sound/asound.h
+++ b/include/uapi/sound/asound.h
@@ -783,6 +783,7 @@ struct snd_rawmidi_status {
 
 #define SNDRV_RAWMIDI_IOCTL_PVERSION	_IOR('W', 0x00, int)
 #define SNDRV_RAWMIDI_IOCTL_INFO	_IOR('W', 0x01, struct snd_rawmidi_info)
+#define SNDRV_RAWMIDI_IOCTL_USER_PVERSION _IOW('W', 0x02, int)
 #define SNDRV_RAWMIDI_IOCTL_PARAMS	_IOWR('W', 0x10, struct snd_rawmidi_params)
 #define SNDRV_RAWMIDI_IOCTL_STATUS	_IOWR('W', 0x20, struct snd_rawmidi_status)
 #define SNDRV_RAWMIDI_IOCTL_DROP	_IOW('W', 0x30, int)
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -873,12 +873,21 @@ static long snd_rawmidi_ioctl(struct fil
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



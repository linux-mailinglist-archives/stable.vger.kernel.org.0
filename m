Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902501B417D
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbgDVKJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:09:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728901AbgDVKJp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:09:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64B952070B;
        Wed, 22 Apr 2020 10:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550184;
        bh=A+JHGKZKUO6n8kcbFBZ2WcxbjAzvhMT8qPdf+AdXM+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SdyAkNUqs4vNWg2LMYyFFE0Or1asTGgGoZX2aFzQqJjLNM0BnmWy/NygrZ1rnNivZ
         eBEotYMCGqVCQTd7oe8MfheSGB2DCk2mBz/7tuCyLxGkA9CSrXZe03evrn+a3ebA+W
         tl+T6/isOSrKxsf59hqSlHskMRSV8f8RHH2fdOrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Jari Ruusu <jari.ruusu@gmail.com>
Subject: [PATCH 4.14 042/199] ALSA: pcm: oss: Fix regression by buffer overflow fix
Date:   Wed, 22 Apr 2020 11:56:08 +0200
Message-Id: <20200422095102.174647171@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit ae769d3556644888c964635179ef192995f40793 upstream.

The recent fix for the OOB access in PCM OSS plugins (commit
f2ecf903ef06: "ALSA: pcm: oss: Avoid plugin buffer overflow") caused a
regression on OSS applications.  The patch introduced the size check
in client and slave size calculations to limit to each plugin's buffer
size, but I overlooked that some code paths call those without
allocating the buffer but just for estimation.

This patch fixes the bug by skipping the size check for those code
paths while keeping checking in the actual transfer calls.

Fixes: f2ecf903ef06 ("ALSA: pcm: oss: Avoid plugin buffer overflow")
Tested-and-reported-by: Jari Ruusu <jari.ruusu@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200403072515.25539-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/oss/pcm_plugin.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

--- a/sound/core/oss/pcm_plugin.c
+++ b/sound/core/oss/pcm_plugin.c
@@ -196,7 +196,9 @@ int snd_pcm_plugin_free(struct snd_pcm_p
 	return 0;
 }
 
-snd_pcm_sframes_t snd_pcm_plug_client_size(struct snd_pcm_substream *plug, snd_pcm_uframes_t drv_frames)
+static snd_pcm_sframes_t plug_client_size(struct snd_pcm_substream *plug,
+					  snd_pcm_uframes_t drv_frames,
+					  bool check_size)
 {
 	struct snd_pcm_plugin *plugin, *plugin_prev, *plugin_next;
 	int stream;
@@ -209,7 +211,7 @@ snd_pcm_sframes_t snd_pcm_plug_client_si
 	if (stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		plugin = snd_pcm_plug_last(plug);
 		while (plugin && drv_frames > 0) {
-			if (drv_frames > plugin->buf_frames)
+			if (check_size && drv_frames > plugin->buf_frames)
 				drv_frames = plugin->buf_frames;
 			plugin_prev = plugin->prev;
 			if (plugin->src_frames)
@@ -222,7 +224,7 @@ snd_pcm_sframes_t snd_pcm_plug_client_si
 			plugin_next = plugin->next;
 			if (plugin->dst_frames)
 				drv_frames = plugin->dst_frames(plugin, drv_frames);
-			if (drv_frames > plugin->buf_frames)
+			if (check_size && drv_frames > plugin->buf_frames)
 				drv_frames = plugin->buf_frames;
 			plugin = plugin_next;
 		}
@@ -231,7 +233,9 @@ snd_pcm_sframes_t snd_pcm_plug_client_si
 	return drv_frames;
 }
 
-snd_pcm_sframes_t snd_pcm_plug_slave_size(struct snd_pcm_substream *plug, snd_pcm_uframes_t clt_frames)
+static snd_pcm_sframes_t plug_slave_size(struct snd_pcm_substream *plug,
+					 snd_pcm_uframes_t clt_frames,
+					 bool check_size)
 {
 	struct snd_pcm_plugin *plugin, *plugin_prev, *plugin_next;
 	snd_pcm_sframes_t frames;
@@ -252,14 +256,14 @@ snd_pcm_sframes_t snd_pcm_plug_slave_siz
 				if (frames < 0)
 					return frames;
 			}
-			if (frames > plugin->buf_frames)
+			if (check_size && frames > plugin->buf_frames)
 				frames = plugin->buf_frames;
 			plugin = plugin_next;
 		}
 	} else if (stream == SNDRV_PCM_STREAM_CAPTURE) {
 		plugin = snd_pcm_plug_last(plug);
 		while (plugin) {
-			if (frames > plugin->buf_frames)
+			if (check_size && frames > plugin->buf_frames)
 				frames = plugin->buf_frames;
 			plugin_prev = plugin->prev;
 			if (plugin->src_frames) {
@@ -274,6 +278,18 @@ snd_pcm_sframes_t snd_pcm_plug_slave_siz
 	return frames;
 }
 
+snd_pcm_sframes_t snd_pcm_plug_client_size(struct snd_pcm_substream *plug,
+					   snd_pcm_uframes_t drv_frames)
+{
+	return plug_client_size(plug, drv_frames, false);
+}
+
+snd_pcm_sframes_t snd_pcm_plug_slave_size(struct snd_pcm_substream *plug,
+					  snd_pcm_uframes_t clt_frames)
+{
+	return plug_slave_size(plug, clt_frames, false);
+}
+
 static int snd_pcm_plug_formats(const struct snd_mask *mask,
 				snd_pcm_format_t format)
 {
@@ -629,7 +645,7 @@ snd_pcm_sframes_t snd_pcm_plug_write_tra
 		src_channels = dst_channels;
 		plugin = next;
 	}
-	return snd_pcm_plug_client_size(plug, frames);
+	return plug_client_size(plug, frames, true);
 }
 
 snd_pcm_sframes_t snd_pcm_plug_read_transfer(struct snd_pcm_substream *plug, struct snd_pcm_plugin_channel *dst_channels_final, snd_pcm_uframes_t size)
@@ -639,7 +655,7 @@ snd_pcm_sframes_t snd_pcm_plug_read_tran
 	snd_pcm_sframes_t frames = size;
 	int err;
 
-	frames = snd_pcm_plug_slave_size(plug, frames);
+	frames = plug_slave_size(plug, frames, true);
 	if (frames < 0)
 		return frames;
 



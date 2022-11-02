Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E6E61597C
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiKBDMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbiKBDM3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:12:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8756A248E2
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:11:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E578616DB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B685CC433C1;
        Wed,  2 Nov 2022 03:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358713;
        bh=KyMZwOIYhe98p+MCyT8nUpI1RQxnvesrBwb6wKW3jmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uP1Q4irZQDGS7vIFHxNSQjN2UWM4L0cRdt3+6+y5hiimEo0xc8q2/qWhfrceUA5F4
         oqMtbb9q5BzScwL7iqU0ohjq0t+f1tbcKorSkj5oxEQkCjYiDY4ASOY+QDxZWu7VjY
         ZzgOOzBOuB88tomPkwyHNfLCUotIp5QOjtWRsbWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 05/91] ALSA: rme9652: use explicitly signed char
Date:   Wed,  2 Nov 2022 03:32:48 +0100
Message-Id: <20221102022055.190033695@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 50895a55bcfde8ac6f22a37c6bc8cff506b3c7c6 upstream.

With char becoming unsigned by default, and with `char` alone being
ambiguous and based on architecture, signed chars need to be marked
explicitly as such. This fixes warnings like:

sound/pci/rme9652/hdsp.c:3953 hdsp_channel_buffer_location() warn: 'hdsp->channel_map[channel]' is unsigned
sound/pci/rme9652/hdsp.c:4153 snd_hdsp_channel_info() warn: impossible condition '(hdsp->channel_map[channel] < 0) => (0-255 < 0)'
sound/pci/rme9652/rme9652.c:1833 rme9652_channel_buffer_location() warn: 'rme9652->channel_map[channel]' is unsigned

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221025000313.546261-1-Jason@zx2c4.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/rme9652/hdsp.c    |   26 +++++++++++++-------------
 sound/pci/rme9652/rme9652.c |   22 +++++++++++-----------
 2 files changed, 24 insertions(+), 24 deletions(-)

--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -436,7 +436,7 @@ struct hdsp_midi {
     struct snd_rawmidi           *rmidi;
     struct snd_rawmidi_substream *input;
     struct snd_rawmidi_substream *output;
-    char                     istimer; /* timer in use */
+    signed char		     istimer; /* timer in use */
     struct timer_list	     timer;
     spinlock_t               lock;
     int			     pending;
@@ -479,7 +479,7 @@ struct hdsp {
 	pid_t                 playback_pid;
 	int                   running;
 	int                   system_sample_rate;
-	const char           *channel_map;
+	const signed char    *channel_map;
 	int                   dev;
 	int                   irq;
 	unsigned long         port;
@@ -501,7 +501,7 @@ struct hdsp {
    where the data for that channel can be read/written from/to.
 */
 
-static const char channel_map_df_ss[HDSP_MAX_CHANNELS] = {
+static const signed char channel_map_df_ss[HDSP_MAX_CHANNELS] = {
 	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
 	18, 19, 20, 21, 22, 23, 24, 25
 };
@@ -516,7 +516,7 @@ static const char channel_map_mf_ss[HDSP
 	-1, -1, -1, -1, -1, -1, -1, -1
 };
 
-static const char channel_map_ds[HDSP_MAX_CHANNELS] = {
+static const signed char channel_map_ds[HDSP_MAX_CHANNELS] = {
 	/* ADAT channels are remapped */
 	1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23,
 	/* channels 12 and 13 are S/PDIF */
@@ -525,7 +525,7 @@ static const char channel_map_ds[HDSP_MA
 	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
 };
 
-static const char channel_map_H9632_ss[HDSP_MAX_CHANNELS] = {
+static const signed char channel_map_H9632_ss[HDSP_MAX_CHANNELS] = {
 	/* ADAT channels */
 	0, 1, 2, 3, 4, 5, 6, 7,
 	/* SPDIF */
@@ -539,7 +539,7 @@ static const char channel_map_H9632_ss[H
 	-1, -1
 };
 
-static const char channel_map_H9632_ds[HDSP_MAX_CHANNELS] = {
+static const signed char channel_map_H9632_ds[HDSP_MAX_CHANNELS] = {
 	/* ADAT */
 	1, 3, 5, 7,
 	/* SPDIF */
@@ -553,7 +553,7 @@ static const char channel_map_H9632_ds[H
 	-1, -1, -1, -1, -1, -1
 };
 
-static const char channel_map_H9632_qs[HDSP_MAX_CHANNELS] = {
+static const signed char channel_map_H9632_qs[HDSP_MAX_CHANNELS] = {
 	/* ADAT is disabled in this mode */
 	/* SPDIF */
 	8, 9,
@@ -3869,7 +3869,7 @@ static snd_pcm_uframes_t snd_hdsp_hw_poi
 	return hdsp_hw_pointer(hdsp);
 }
 
-static char *hdsp_channel_buffer_location(struct hdsp *hdsp,
+static signed char *hdsp_channel_buffer_location(struct hdsp *hdsp,
 					     int stream,
 					     int channel)
 
@@ -3893,7 +3893,7 @@ static int snd_hdsp_playback_copy(struct
 				  void __user *src, unsigned long count)
 {
 	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	if (snd_BUG_ON(pos + count > HDSP_CHANNEL_BUFFER_BYTES))
 		return -EINVAL;
@@ -3911,7 +3911,7 @@ static int snd_hdsp_playback_copy_kernel
 					 void *src, unsigned long count)
 {
 	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	channel_buf = hdsp_channel_buffer_location(hdsp, substream->pstr->stream, channel);
 	if (snd_BUG_ON(!channel_buf))
@@ -3925,7 +3925,7 @@ static int snd_hdsp_capture_copy(struct
 				 void __user *dst, unsigned long count)
 {
 	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	if (snd_BUG_ON(pos + count > HDSP_CHANNEL_BUFFER_BYTES))
 		return -EINVAL;
@@ -3943,7 +3943,7 @@ static int snd_hdsp_capture_copy_kernel(
 					void *dst, unsigned long count)
 {
 	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	channel_buf = hdsp_channel_buffer_location(hdsp, substream->pstr->stream, channel);
 	if (snd_BUG_ON(!channel_buf))
@@ -3957,7 +3957,7 @@ static int snd_hdsp_hw_silence(struct sn
 			       unsigned long count)
 {
 	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	channel_buf = hdsp_channel_buffer_location (hdsp, substream->pstr->stream, channel);
 	if (snd_BUG_ON(!channel_buf))
--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -229,7 +229,7 @@ struct snd_rme9652 {
 	int last_spdif_sample_rate;	/* so that we can catch externally ... */
 	int last_adat_sample_rate;	/* ... induced rate changes            */
 
-	const char *channel_map;
+	const signed char *channel_map;
 
 	struct snd_card *card;
 	struct snd_pcm *pcm;
@@ -246,12 +246,12 @@ struct snd_rme9652 {
    where the data for that channel can be read/written from/to.
 */
 
-static const char channel_map_9652_ss[26] = {
+static const signed char channel_map_9652_ss[26] = {
 	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
 	18, 19, 20, 21, 22, 23, 24, 25
 };
 
-static const char channel_map_9636_ss[26] = {
+static const signed char channel_map_9636_ss[26] = {
 	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 
 	/* channels 16 and 17 are S/PDIF */
 	24, 25,
@@ -259,7 +259,7 @@ static const char channel_map_9636_ss[26
 	-1, -1, -1, -1, -1, -1, -1, -1
 };
 
-static const char channel_map_9652_ds[26] = {
+static const signed char channel_map_9652_ds[26] = {
 	/* ADAT channels are remapped */
 	1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23,
 	/* channels 12 and 13 are S/PDIF */
@@ -268,7 +268,7 @@ static const char channel_map_9652_ds[26
 	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
 };
 
-static const char channel_map_9636_ds[26] = {
+static const signed char channel_map_9636_ds[26] = {
 	/* ADAT channels are remapped */
 	1, 3, 5, 7, 9, 11, 13, 15,
 	/* channels 8 and 9 are S/PDIF */
@@ -1841,7 +1841,7 @@ static snd_pcm_uframes_t snd_rme9652_hw_
 	return rme9652_hw_pointer(rme9652);
 }
 
-static char *rme9652_channel_buffer_location(struct snd_rme9652 *rme9652,
+static signed char *rme9652_channel_buffer_location(struct snd_rme9652 *rme9652,
 					     int stream,
 					     int channel)
 
@@ -1869,7 +1869,7 @@ static int snd_rme9652_playback_copy(str
 				     void __user *src, unsigned long count)
 {
 	struct snd_rme9652 *rme9652 = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	if (snd_BUG_ON(pos + count > RME9652_CHANNEL_BUFFER_BYTES))
 		return -EINVAL;
@@ -1889,7 +1889,7 @@ static int snd_rme9652_playback_copy_ker
 					    void *src, unsigned long count)
 {
 	struct snd_rme9652 *rme9652 = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	channel_buf = rme9652_channel_buffer_location(rme9652,
 						      substream->pstr->stream,
@@ -1905,7 +1905,7 @@ static int snd_rme9652_capture_copy(stru
 				    void __user *dst, unsigned long count)
 {
 	struct snd_rme9652 *rme9652 = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	if (snd_BUG_ON(pos + count > RME9652_CHANNEL_BUFFER_BYTES))
 		return -EINVAL;
@@ -1925,7 +1925,7 @@ static int snd_rme9652_capture_copy_kern
 					   void *dst, unsigned long count)
 {
 	struct snd_rme9652 *rme9652 = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	channel_buf = rme9652_channel_buffer_location(rme9652,
 						      substream->pstr->stream,
@@ -1941,7 +1941,7 @@ static int snd_rme9652_hw_silence(struct
 				  unsigned long count)
 {
 	struct snd_rme9652 *rme9652 = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	channel_buf = rme9652_channel_buffer_location (rme9652,
 						       substream->pstr->stream,



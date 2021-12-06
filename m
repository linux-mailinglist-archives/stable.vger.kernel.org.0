Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63BB3469E6C
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385583AbhLFPiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:38:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378673AbhLFPgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:36:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0988C09CE47;
        Mon,  6 Dec 2021 07:21:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C480B8111D;
        Mon,  6 Dec 2021 15:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42EDC341C1;
        Mon,  6 Dec 2021 15:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804111;
        bh=UtV9L2j80McXabyILMCllLJyejamau41L+YIDDXnLX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jeq4/V6dj7HjM8I5T7rC+tTdoRZII0wG2JMFKIf5TTnk4Sh3NP28IH0u0DQ7I98/B
         QVpoIANgvnjwLXx2vYr9UTdIVaneJDl5sSJMAqtTdXsHG70HKO+3l7E5x9YOU7tCdb
         YkpFpilrzw8CpodbcML+8M5FPaPyHVg85n4N5hkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 003/207] ALSA: usb-audio: Disable low-latency playback for free-wheel mode
Date:   Mon,  6 Dec 2021 15:54:17 +0100
Message-Id: <20211206145610.297918781@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit e581f1cec4f899f788f6c9477f805b1d5fef25e2 upstream.

The free-wheel stream operation like dmix may not update the appl_ptr
appropriately, and it doesn't fit with the low-latency playback mode.
Disable the low-latency playback operation when the stream is set up
in such a mode.

Link: https://lore.kernel.org/r/20210929080844.11583-5-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/pcm.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -582,7 +582,8 @@ static int snd_usb_hw_free(struct snd_pc
 }
 
 /* check whether early start is needed for playback stream */
-static int lowlatency_playback_available(struct snd_usb_substream *subs)
+static int lowlatency_playback_available(struct snd_pcm_runtime *runtime,
+					 struct snd_usb_substream *subs)
 {
 	struct snd_usb_audio *chip = subs->stream->chip;
 
@@ -591,6 +592,9 @@ static int lowlatency_playback_available
 	/* disabled via module option? */
 	if (!chip->lowlatency)
 		return false;
+	/* free-wheeling mode? (e.g. dmix) */
+	if (runtime->stop_threshold > runtime->buffer_size)
+		return false;
 	/* too short periods? */
 	if (subs->data_endpoint->nominal_queue_size >= subs->buffer_bytes)
 		return false;
@@ -630,7 +634,7 @@ static int snd_usb_pcm_prepare(struct sn
 	subs->period_elapsed_pending = 0;
 	runtime->delay = 0;
 
-	subs->lowlatency_playback = lowlatency_playback_available(subs);
+	subs->lowlatency_playback = lowlatency_playback_available(runtime, subs);
 	if (!subs->lowlatency_playback)
 		ret = start_endpoints(subs);
 



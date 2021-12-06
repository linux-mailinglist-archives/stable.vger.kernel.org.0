Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A862F469E5A
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356753AbhLFPiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:38:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389217AbhLFPfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:35:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5921C08EA3F;
        Mon,  6 Dec 2021 07:20:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F5A2B8111E;
        Mon,  6 Dec 2021 15:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7856C341C2;
        Mon,  6 Dec 2021 15:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804055;
        bh=/Sbowx0mAiWIoQTstUbAKneiRbodDlnMsju38rGnDUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JhmFnc8zY3NCnhRZhVY7ofqyXSoDInRnXEgLLQzMa8wqjQifiQ9ev56CN/5aduLue
         zQt9Nw/pBKdZRJKMR2A9DE7O5xI0uY3H+z//ZWJFil8t8KwzAD6fPpz02cpYSG016+
         tDQ+eAZ98HDwT9WYmVTFLx1lk1TosYMqxCiaCwuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 5.15 011/207] ALSA: usb-audio: Switch back to non-latency mode at a later point
Date:   Mon,  6 Dec 2021 15:54:25 +0100
Message-Id: <20211206145610.575373835@linuxfoundation.org>
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

commit eee5d6f1356a016105a974fb176b491288439efa upstream.

The recent regression report revealed that the judgment of the
low-latency playback mode based on the runtime->stop_threshold cannot
work reliably at the prepare stage, as sw_params call may happen at
any time, and PCM dmix actually sets it up after the prepare call.
This ended up with the stall of the stream as PCM ack won't be issued
at all.

For addressing this, check the free-wheeling mode again at the PCM
trigger right before starting the stream again, and allow switching to
the non-LL mode at a late stage.

Fixes: d5f871f89e21 ("ALSA: usb-audio: Improved lowlatency playback support")
Reported-and-tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Link: https://lore.kernel.org/r/20211117161855.m45mxcqszkfcetai@box.shutemov.name
Link: https://lore.kernel.org/r/20211119102459.7055-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/pcm.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -581,6 +581,12 @@ static int snd_usb_hw_free(struct snd_pc
 	return 0;
 }
 
+/* free-wheeling mode? (e.g. dmix) */
+static int in_free_wheeling_mode(struct snd_pcm_runtime *runtime)
+{
+	return runtime->stop_threshold > runtime->buffer_size;
+}
+
 /* check whether early start is needed for playback stream */
 static int lowlatency_playback_available(struct snd_pcm_runtime *runtime,
 					 struct snd_usb_substream *subs)
@@ -592,8 +598,7 @@ static int lowlatency_playback_available
 	/* disabled via module option? */
 	if (!chip->lowlatency)
 		return false;
-	/* free-wheeling mode? (e.g. dmix) */
-	if (runtime->stop_threshold > runtime->buffer_size)
+	if (in_free_wheeling_mode(runtime))
 		return false;
 	/* implicit feedback mode has own operation mode */
 	if (snd_usb_endpoint_implicit_feedback_sink(subs->data_endpoint))
@@ -1545,6 +1550,8 @@ static int snd_usb_substream_playback_tr
 					      subs);
 		if (subs->lowlatency_playback &&
 		    cmd == SNDRV_PCM_TRIGGER_START) {
+			if (in_free_wheeling_mode(substream->runtime))
+				subs->lowlatency_playback = false;
 			err = start_endpoints(subs);
 			if (err < 0) {
 				snd_usb_endpoint_set_callback(subs->data_endpoint,



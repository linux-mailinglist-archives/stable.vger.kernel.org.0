Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2625B6D4971
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbjDCOiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbjDCOiA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:38:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EF216F30
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:37:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 556F0CE12E5
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60429C433D2;
        Mon,  3 Apr 2023 14:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532672;
        bh=id1f1gd3gxTk0QcLh0AzTqvVCOc9NMLlm+IvnAlrbXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDahcHcUUkm1nkn8kt6JXZfKRn5p5z5Z4j+xdEhAmIgLlqbEyLpdIbGWHZs08dH6w
         lWhoeCWv6soOlcRVA+ljiXelk7TCQ19+0IGahVRgAVN/3fZnSmHmTu4VI8y8FfIXxI
         huptU/FxPKRgCytSYcApZmWzBUt+4jjrtwhlBkLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        John Keeping <john@metanate.com>
Subject: [PATCH 6.1 072/181] ALSA: usb-audio: Fix recursive locking at XRUN during syncing
Date:   Mon,  3 Apr 2023 16:08:27 +0200
Message-Id: <20230403140417.477850702@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 8c721c53dda512fdd48eb24d6d99e56deee57898 ]

The recent support of low latency playback in USB-audio driver made
the snd_usb_queue_pending_output_urbs() function to be called via PCM
ack ops.  In the new code path, the function is performed already in
the PCM stream lock.  The problem is that, when an XRUN is detected,
the function calls snd_pcm_xrun() to notify, but snd_pcm_xrun() is
supposed to be called only outside the stream lock.  As a result, it
leads to a deadlock of PCM stream locking.

For avoiding such a recursive locking, this patch adds an additional
check to the code paths in PCM core that call the ack callback; now it
checks the error code from the callback, and if it's -EPIPE, the XRUN
is handled in the PCM core side gracefully.  Along with it, the
USB-audio driver code is changed to follow that, i.e. -EPIPE is
returned instead of the explicit snd_pcm_xrun() call when the function
is performed already in the stream lock.

Fixes: d5f871f89e21 ("ALSA: usb-audio: Improved lowlatency playback support")
Reported-and-tested-by: John Keeping <john@metanate.com>
Link: https://lore.kernel.org/r/20230317195128.3911155-1-john@metanate.com
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Reviewed-by; Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20230320142838.494-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_lib.c |  2 ++
 sound/usb/endpoint.c | 22 ++++++++++++++--------
 sound/usb/endpoint.h |  4 ++--
 sound/usb/pcm.c      |  2 +-
 4 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 8b6aeb8a78f7d..02fd65993e7e5 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -2155,6 +2155,8 @@ int pcm_lib_apply_appl_ptr(struct snd_pcm_substream *substream,
 		ret = substream->ops->ack(substream);
 		if (ret < 0) {
 			runtime->control->appl_ptr = old_appl_ptr;
+			if (ret == -EPIPE)
+				__snd_pcm_xrun(substream);
 			return ret;
 		}
 	}
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 419302e2057e8..647fa054d8b1d 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -455,8 +455,8 @@ static void push_back_to_ready_list(struct snd_usb_endpoint *ep,
  * This function is used both for implicit feedback endpoints and in low-
  * latency playback mode.
  */
-void snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
-				       bool in_stream_lock)
+int snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
+				      bool in_stream_lock)
 {
 	bool implicit_fb = snd_usb_endpoint_implicit_feedback_sink(ep);
 
@@ -480,7 +480,7 @@ void snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
 		spin_unlock_irqrestore(&ep->lock, flags);
 
 		if (ctx == NULL)
-			return;
+			break;
 
 		/* copy over the length information */
 		if (implicit_fb) {
@@ -495,11 +495,14 @@ void snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
 			break;
 		if (err < 0) {
 			/* push back to ready list again for -EAGAIN */
-			if (err == -EAGAIN)
+			if (err == -EAGAIN) {
 				push_back_to_ready_list(ep, ctx);
-			else
+				break;
+			}
+
+			if (!in_stream_lock)
 				notify_xrun(ep);
-			return;
+			return -EPIPE;
 		}
 
 		err = usb_submit_urb(ctx->urb, GFP_ATOMIC);
@@ -507,13 +510,16 @@ void snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
 			usb_audio_err(ep->chip,
 				      "Unable to submit urb #%d: %d at %s\n",
 				      ctx->index, err, __func__);
-			notify_xrun(ep);
-			return;
+			if (!in_stream_lock)
+				notify_xrun(ep);
+			return -EPIPE;
 		}
 
 		set_bit(ctx->index, &ep->active_mask);
 		atomic_inc(&ep->submitted_urbs);
 	}
+
+	return 0;
 }
 
 /*
diff --git a/sound/usb/endpoint.h b/sound/usb/endpoint.h
index 924f4351588ce..c09f68ce08b18 100644
--- a/sound/usb/endpoint.h
+++ b/sound/usb/endpoint.h
@@ -52,7 +52,7 @@ int snd_usb_endpoint_implicit_feedback_sink(struct snd_usb_endpoint *ep);
 int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep,
 				      struct snd_urb_ctx *ctx, int idx,
 				      unsigned int avail);
-void snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
-				       bool in_stream_lock);
+int snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
+				      bool in_stream_lock);
 
 #endif /* __USBAUDIO_ENDPOINT_H */
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 2c5765cbed2d6..1e1d7458bce10 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1595,7 +1595,7 @@ static int snd_usb_pcm_playback_ack(struct snd_pcm_substream *substream)
 	 * outputs here
 	 */
 	if (!ep->active_mask)
-		snd_usb_queue_pending_output_urbs(ep, true);
+		return snd_usb_queue_pending_output_urbs(ep, true);
 	return 0;
 }
 
-- 
2.39.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C536D48C0
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbjDCObj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233490AbjDCObg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:31:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F78D4FAD
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:31:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65BF7B81C64
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DF0C433D2;
        Mon,  3 Apr 2023 14:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532289;
        bh=86ECuVXBSEl6Sy4ZHD9jFKG/QjnOIrx8XWmd8VxPbwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g33+ii7/ULABTyFkWLha1yi5Ha0Up5pGf4QmdMprNRmarExtU5LgdU50yeDWEJC7A
         8jGNj0PzQWIulmD/FGEHht5nGN26+IwPHQJndcsqvyE8ALF67/BTcs5Z67veei+Dn+
         V47BUthSNSyiRb9WNB3wQ3Sa+bthEhw9xSjSBM0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        John Keeping <john@metanate.com>
Subject: [PATCH 5.15 26/99] ALSA: usb-audio: Fix recursive locking at XRUN during syncing
Date:   Mon,  3 Apr 2023 16:08:49 +0200
Message-Id: <20230403140403.806020237@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
index 491064f55515b..8947c988b6d34 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -2137,6 +2137,8 @@ int pcm_lib_apply_appl_ptr(struct snd_pcm_substream *substream,
 		ret = substream->ops->ack(substream);
 		if (ret < 0) {
 			runtime->control->appl_ptr = old_appl_ptr;
+			if (ret == -EPIPE)
+				__snd_pcm_xrun(substream);
 			return ret;
 		}
 	}
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 092350eb5f4e3..6c7d842d04965 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -444,8 +444,8 @@ static void push_back_to_ready_list(struct snd_usb_endpoint *ep,
  * This function is used both for implicit feedback endpoints and in low-
  * latency playback mode.
  */
-void snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
-				       bool in_stream_lock)
+int snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
+				      bool in_stream_lock)
 {
 	bool implicit_fb = snd_usb_endpoint_implicit_feedback_sink(ep);
 
@@ -469,7 +469,7 @@ void snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
 		spin_unlock_irqrestore(&ep->lock, flags);
 
 		if (ctx == NULL)
-			return;
+			break;
 
 		/* copy over the length information */
 		if (implicit_fb) {
@@ -484,11 +484,14 @@ void snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
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
@@ -496,13 +499,16 @@ void snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
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
index 6a9af04cf175a..daa7ba063d858 100644
--- a/sound/usb/endpoint.h
+++ b/sound/usb/endpoint.h
@@ -49,7 +49,7 @@ int snd_usb_endpoint_implicit_feedback_sink(struct snd_usb_endpoint *ep);
 int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep,
 				      struct snd_urb_ctx *ctx, int idx,
 				      unsigned int avail);
-void snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
-				       bool in_stream_lock);
+int snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
+				      bool in_stream_lock);
 
 #endif /* __USBAUDIO_ENDPOINT_H */
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 87a30be643242..de0964dbf7a91 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1557,7 +1557,7 @@ static int snd_usb_pcm_playback_ack(struct snd_pcm_substream *substream)
 	 * outputs here
 	 */
 	if (!ep->active_mask)
-		snd_usb_queue_pending_output_urbs(ep, true);
+		return snd_usb_queue_pending_output_urbs(ep, true);
 	return 0;
 }
 
-- 
2.39.2




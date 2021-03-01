Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D6332912F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236609AbhCAUVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:21:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:42278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236772AbhCAUNw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:13:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C4336534D;
        Mon,  1 Mar 2021 18:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621698;
        bh=IqqsAOlPscPnjM0fJeuj2JrvFiDaZuEg5BGdC0HLpkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F8GvhrVCYOGPo7Lwu3y/ZDsD+8aHyJ+9HYLaskJZtz8sZjlL5r3OXsV7xB0FicgR6
         2lHOyo8PX4PdCNWhbVbUc/04Tc7R10e0XZwX4Sa66FQyBt2e0YpugS6yIFQxtKFvDh
         NTjv2qXVSo9Rn1LUpPDyVSA3wXy/hb0CsI71MoqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 594/775] ALSA: usb-audio: Handle invalid running state at releasing EP
Date:   Mon,  1 Mar 2021 17:12:42 +0100
Message-Id: <20210301161230.779987301@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit d6cda4655e2a7612a1e48c49795a5330abc01c5a upstream.

When we stop an endpoint in release_urbs(), it ignores the
inconsistent endpoint state and tries to release the resources.
This shouldn't happen in theory, but it's still safer to abort the
release and let the caller proper error handling.

Also, stop_and_unlink_urbs() called from release_urbs() does two step
works, and it's more straightforward to split this to two functions
again, so that the call from the PCM trigger won't take the path with
sleeping.

This patch modifies the EP management code to adapt two points above.

Fixes: d0f09d1e4a88 ("ALSA: usb-audio: Refactoring endpoint URB deactivation")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210206203052.15606-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |   40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -868,24 +868,22 @@ void snd_usb_endpoint_sync_pending_stop(
 }
 
 /*
- * Stop and unlink active urbs.
+ * Stop active urbs
  *
- * This function checks and clears EP_FLAG_RUNNING state.
- * When @wait_sync is set, it waits until all pending URBs are killed.
+ * This function moves the EP to STOPPING state if it's being RUNNING.
  */
-static int stop_and_unlink_urbs(struct snd_usb_endpoint *ep, bool force,
-				bool wait_sync)
+static int stop_urbs(struct snd_usb_endpoint *ep, bool force)
 {
 	unsigned int i;
 
 	if (!force && atomic_read(&ep->chip->shutdown)) /* to be sure... */
 		return -EBADFD;
 
-	if (atomic_read(&ep->running))
+	if (!force && atomic_read(&ep->running))
 		return -EBUSY;
 
 	if (!test_and_clear_bit(EP_FLAG_RUNNING, &ep->flags))
-		goto out;
+		return 0;
 
 	set_bit(EP_FLAG_STOPPING, &ep->flags);
 	INIT_LIST_HEAD(&ep->ready_playback_urbs);
@@ -901,24 +899,25 @@ static int stop_and_unlink_urbs(struct s
 		}
 	}
 
- out:
-	if (wait_sync)
-		return wait_clear_urbs(ep);
 	return 0;
 }
 
 /*
  * release an endpoint's urbs
  */
-static void release_urbs(struct snd_usb_endpoint *ep, int force)
+static int release_urbs(struct snd_usb_endpoint *ep, bool force)
 {
-	int i;
+	int i, err;
 
 	/* route incoming urbs to nirvana */
 	snd_usb_endpoint_set_callback(ep, NULL, NULL, NULL);
 
-	/* stop urbs */
-	stop_and_unlink_urbs(ep, force, true);
+	/* stop and unlink urbs */
+	err = stop_urbs(ep, force);
+	if (err)
+		return err;
+
+	wait_clear_urbs(ep);
 
 	for (i = 0; i < ep->nurbs; i++)
 		release_urb_ctx(&ep->urb[i]);
@@ -928,6 +927,7 @@ static void release_urbs(struct snd_usb_
 
 	ep->syncbuf = NULL;
 	ep->nurbs = 0;
+	return 0;
 }
 
 /*
@@ -1118,7 +1118,7 @@ static int data_ep_set_params(struct snd
 	return 0;
 
 out_of_memory:
-	release_urbs(ep, 0);
+	release_urbs(ep, false);
 	return -ENOMEM;
 }
 
@@ -1162,7 +1162,7 @@ static int sync_ep_set_params(struct snd
 	return 0;
 
 out_of_memory:
-	release_urbs(ep, 0);
+	release_urbs(ep, false);
 	return -ENOMEM;
 }
 
@@ -1180,7 +1180,9 @@ static int snd_usb_endpoint_set_params(s
 	int err;
 
 	/* release old buffers, if any */
-	release_urbs(ep, 0);
+	err = release_urbs(ep, false);
+	if (err < 0)
+		return err;
 
 	ep->datainterval = fmt->datainterval;
 	ep->maxpacksize = fmt->maxpacksize;
@@ -1433,7 +1435,7 @@ void snd_usb_endpoint_stop(struct snd_us
 		WRITE_ONCE(ep->sync_source->sync_sink, NULL);
 
 	if (!atomic_dec_return(&ep->running))
-		stop_and_unlink_urbs(ep, false, false);
+		stop_urbs(ep, false);
 }
 
 /**
@@ -1446,7 +1448,7 @@ void snd_usb_endpoint_stop(struct snd_us
  */
 void snd_usb_endpoint_release(struct snd_usb_endpoint *ep)
 {
-	release_urbs(ep, 1);
+	release_urbs(ep, true);
 }
 
 /**



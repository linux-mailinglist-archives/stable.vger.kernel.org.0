Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B05E45142E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238200AbhKOUCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:02:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344310AbhKOTYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 555006365C;
        Mon, 15 Nov 2021 18:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002535;
        bh=TojhX51gRm5TdXwuyg+Qsw3e/Vyy071o6zMEREfMUHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nNiTtrBFb3GfMG6CEkIpOoecs8xiRfK8zxE6iukh4iFD3gGQruBHuHDvtYSIEht2l
         DGflzqRnHVvhvQHCKt0bFNU29yvfa8LtmHsnRXfvSoK58JlOQzMzqLPk+ObcADjTdX
         EFl09YyiJUI0ybpORK5v0JrW7Ju0x8On4+rNnLEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 605/917] ALSA: usb-audio: Fix possible race at sync of urb completions
Date:   Mon, 15 Nov 2021 18:01:40 +0100
Message-Id: <20211115165449.283935107@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 86a42ad07905110f82648853c0ea3434b4eab173 ]

USB-audio driver tries to sync with the clear of all pending URBs in
wait_clear_urbs(), and it waits for all bits in active_mask getting
cleared.  This works fine for the normal operations, but when a stream
is managed in the implicit feedback mode, there is still a very thin
race window: namely, in snd_complete_usb(), the active_mask bit for
the current URB is once cleared before re-submitted in
queue_pending_output_urbs().  If wait_clear_urbs() is called during
that period, it may pass the test and go forward even though there may
be a still pending URB.

For covering it, this patch adds a new counter to each endpoint to
keep the number of in-flight URBs, and changes wait_clear_urbs()
checking this number instead.  The counter is decremented at the end
of URB complete, hence the reference is kept as long as the URB
complete is in process.

Link: https://lore.kernel.org/r/20210929080844.11583-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/card.h     | 1 +
 sound/usb/endpoint.c | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/usb/card.h b/sound/usb/card.h
index 5b19901f305a3..860faaf249ea6 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -97,6 +97,7 @@ struct snd_usb_endpoint {
 	unsigned int nominal_queue_size; /* total buffer sizes in URBs */
 	unsigned long active_mask;	/* bitmask of active urbs */
 	unsigned long unlink_mask;	/* bitmask of unlinked urbs */
+	atomic_t submitted_urbs;	/* currently submitted urbs */
 	char *syncbuf;			/* sync buffer for all sync URBs */
 	dma_addr_t sync_dma;		/* DMA address of syncbuf */
 
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 533919a28856f..ba2d7e6884207 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -451,6 +451,7 @@ static void queue_pending_output_urbs(struct snd_usb_endpoint *ep)
 		}
 
 		set_bit(ctx->index, &ep->active_mask);
+		atomic_inc(&ep->submitted_urbs);
 	}
 }
 
@@ -488,6 +489,7 @@ static void snd_complete_urb(struct urb *urb)
 			clear_bit(ctx->index, &ep->active_mask);
 			spin_unlock_irqrestore(&ep->lock, flags);
 			queue_pending_output_urbs(ep);
+			atomic_dec(&ep->submitted_urbs); /* decrement at last */
 			return;
 		}
 
@@ -513,6 +515,7 @@ static void snd_complete_urb(struct urb *urb)
 
 exit_clear:
 	clear_bit(ctx->index, &ep->active_mask);
+	atomic_dec(&ep->submitted_urbs);
 }
 
 /*
@@ -596,6 +599,7 @@ int snd_usb_add_endpoint(struct snd_usb_audio *chip, int ep_num, int type)
 	ep->type = type;
 	ep->ep_num = ep_num;
 	INIT_LIST_HEAD(&ep->ready_playback_urbs);
+	atomic_set(&ep->submitted_urbs, 0);
 
 	is_playback = ((ep_num & USB_ENDPOINT_DIR_MASK) == USB_DIR_OUT);
 	ep_num &= USB_ENDPOINT_NUMBER_MASK;
@@ -859,7 +863,7 @@ static int wait_clear_urbs(struct snd_usb_endpoint *ep)
 		return 0;
 
 	do {
-		alive = bitmap_weight(&ep->active_mask, ep->nurbs);
+		alive = atomic_read(&ep->submitted_urbs);
 		if (!alive)
 			break;
 
@@ -1420,6 +1424,7 @@ int snd_usb_endpoint_start(struct snd_usb_endpoint *ep)
 			goto __error;
 		}
 		set_bit(i, &ep->active_mask);
+		atomic_inc(&ep->submitted_urbs);
 	}
 
 	usb_audio_dbg(ep->chip, "%d URBs submitted for EP 0x%x\n",
-- 
2.33.0




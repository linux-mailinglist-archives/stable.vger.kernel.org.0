Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CE3329132
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237895AbhCAUVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:21:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:40430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239450AbhCAUN4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:13:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39BFD653D0;
        Mon,  1 Mar 2021 18:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621728;
        bh=ejZUUgpZt9DDiGA8wAkW+2cKTF08jqetHTGBFSpK0Nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wJIr+XPAdDopV4OkvwEPEYhAnpEyciIOrqSffb0Td1W0VM1pRvvwmb/nu15uIdE1d
         Udo2Gx4bS1XNHp1j2vC0Ic4OJ6i94htLzGxofF8YJ4c+q6lfEQdK/kKwotmX70IcXN
         2XInFGbEOBz4/Uqjc4vkn8FqKcbIAoBb9Pm/MHKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 595/775] ALSA: usb-audio: More strict state change in EP
Date:   Mon,  1 Mar 2021 17:12:43 +0100
Message-Id: <20210301161230.824722623@linuxfoundation.org>
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

commit 5c2b301476ec493be15546f05e23414e2aa9d472 upstream.

The endpoint management has bit flags to indicate the current state,
and we're dealing two things: the running bit and the stopping bit.
There is a thin window in transition from the running to the stopping
in stop_urbs(), and as long as the bit flags are used, it's difficult
to plug.

This patch modifies the state management code to use the atomic int
and follow the explicit three states, STOPPED, RUNNING and STOPPING.
The state change is done via atomic_cmpxhg() for avoiding possible
races, and check the state change more strictly.  The unexpected state
change is now handled as an error.

Fixes: d0f09d1e4a88 ("ALSA: usb-audio: Refactoring endpoint URB deactivation")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210206203052.15606-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/card.h     |    2 +-
 sound/usb/endpoint.c |   42 ++++++++++++++++++++++++++++--------------
 2 files changed, 29 insertions(+), 15 deletions(-)

--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -71,7 +71,7 @@ struct snd_usb_endpoint {
 	unsigned char altsetting;	/* corresponding alternate setting */
 	unsigned char ep_idx;		/* endpoint array index */
 
-	unsigned long flags;	/* running bit flags */
+	atomic_t state;		/* running state */
 
 	void (*prepare_data_urb) (struct snd_usb_substream *subs,
 				  struct urb *urb);
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -21,8 +21,11 @@
 #include "clock.h"
 #include "quirks.h"
 
-#define EP_FLAG_RUNNING		1
-#define EP_FLAG_STOPPING	2
+enum {
+	EP_STATE_STOPPED,
+	EP_STATE_RUNNING,
+	EP_STATE_STOPPING,
+};
 
 /* interface refcounting */
 struct snd_usb_iface_ref {
@@ -115,6 +118,16 @@ static const char *usb_error_string(int
 	}
 }
 
+static inline bool ep_state_running(struct snd_usb_endpoint *ep)
+{
+	return atomic_read(&ep->state) == EP_STATE_RUNNING;
+}
+
+static inline bool ep_state_update(struct snd_usb_endpoint *ep, int old, int new)
+{
+	return atomic_cmpxchg(&ep->state, old, new) == old;
+}
+
 /**
  * snd_usb_endpoint_implicit_feedback_sink: Report endpoint usage type
  *
@@ -393,7 +406,7 @@ next_packet_fifo_dequeue(struct snd_usb_
  */
 static void queue_pending_output_urbs(struct snd_usb_endpoint *ep)
 {
-	while (test_bit(EP_FLAG_RUNNING, &ep->flags)) {
+	while (ep_state_running(ep)) {
 
 		unsigned long flags;
 		struct snd_usb_packet_info *packet;
@@ -454,13 +467,13 @@ static void snd_complete_urb(struct urb
 	if (unlikely(atomic_read(&ep->chip->shutdown)))
 		goto exit_clear;
 
-	if (unlikely(!test_bit(EP_FLAG_RUNNING, &ep->flags)))
+	if (unlikely(!ep_state_running(ep)))
 		goto exit_clear;
 
 	if (usb_pipeout(ep->pipe)) {
 		retire_outbound_urb(ep, ctx);
 		/* can be stopped during retire callback */
-		if (unlikely(!test_bit(EP_FLAG_RUNNING, &ep->flags)))
+		if (unlikely(!ep_state_running(ep)))
 			goto exit_clear;
 
 		if (snd_usb_endpoint_implicit_feedback_sink(ep)) {
@@ -474,12 +487,12 @@ static void snd_complete_urb(struct urb
 
 		prepare_outbound_urb(ep, ctx);
 		/* can be stopped during prepare callback */
-		if (unlikely(!test_bit(EP_FLAG_RUNNING, &ep->flags)))
+		if (unlikely(!ep_state_running(ep)))
 			goto exit_clear;
 	} else {
 		retire_inbound_urb(ep, ctx);
 		/* can be stopped during retire callback */
-		if (unlikely(!test_bit(EP_FLAG_RUNNING, &ep->flags)))
+		if (unlikely(!ep_state_running(ep)))
 			goto exit_clear;
 
 		prepare_inbound_urb(ep, ctx);
@@ -835,7 +848,7 @@ static int wait_clear_urbs(struct snd_us
 	unsigned long end_time = jiffies + msecs_to_jiffies(1000);
 	int alive;
 
-	if (!test_bit(EP_FLAG_STOPPING, &ep->flags))
+	if (atomic_read(&ep->state) != EP_STATE_STOPPING)
 		return 0;
 
 	do {
@@ -850,10 +863,11 @@ static int wait_clear_urbs(struct snd_us
 		usb_audio_err(ep->chip,
 			"timeout: still %d active urbs on EP #%x\n",
 			alive, ep->ep_num);
-	clear_bit(EP_FLAG_STOPPING, &ep->flags);
 
-	ep->sync_sink = NULL;
-	snd_usb_endpoint_set_callback(ep, NULL, NULL, NULL);
+	if (ep_state_update(ep, EP_STATE_STOPPING, EP_STATE_STOPPED)) {
+		ep->sync_sink = NULL;
+		snd_usb_endpoint_set_callback(ep, NULL, NULL, NULL);
+	}
 
 	return 0;
 }
@@ -882,10 +896,9 @@ static int stop_urbs(struct snd_usb_endp
 	if (!force && atomic_read(&ep->running))
 		return -EBUSY;
 
-	if (!test_and_clear_bit(EP_FLAG_RUNNING, &ep->flags))
+	if (!ep_state_update(ep, EP_STATE_RUNNING, EP_STATE_STOPPING))
 		return 0;
 
-	set_bit(EP_FLAG_STOPPING, &ep->flags);
 	INIT_LIST_HEAD(&ep->ready_playback_urbs);
 	ep->next_packet_head = 0;
 	ep->next_packet_queued = 0;
@@ -1362,7 +1375,8 @@ int snd_usb_endpoint_start(struct snd_us
 	 * from that context.
 	 */
 
-	set_bit(EP_FLAG_RUNNING, &ep->flags);
+	if (!ep_state_update(ep, EP_STATE_STOPPED, EP_STATE_RUNNING))
+		goto __error;
 
 	if (snd_usb_endpoint_implicit_feedback_sink(ep)) {
 		for (i = 0; i < ep->nurbs; i++) {



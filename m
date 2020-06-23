Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94665205D00
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388632AbgFWUHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:07:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388641AbgFWUHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:07:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44069206C3;
        Tue, 23 Jun 2020 20:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942859;
        bh=7i/UUvq2ow8wHVnKokk+DClSu8XQ9EKsbnb7G8pQP90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+FdduQXxUvEi8bKuheTvpeHFgGmEcuLsflWaweWrInAbEewGiYRg33frjNg6fnFh
         SkSwpcFck0RUIbcvq3T9212qychu8RK4v9sHf9/CSrLDKLq/QWeRAeMs/5T9/ZXm5J
         hF/Cbf+//3klp/2blQt7JALnQdMO7eCpB2GW5dPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 136/477] ALSA: usb-audio: Fix racy list management in output queue
Date:   Tue, 23 Jun 2020 21:52:13 +0200
Message-Id: <20200623195414.036092773@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 5b6cc38f3f3f37109ce72b60bda215a5f6892c0b ]

The linked list entry from FIFO is peeked at
queue_pending_output_urbs() but the actual element pop-out is
performed outside the spinlock, and it's potentially racy.

Do delete the link at the right place inside the spinlock.

Fixes: 8fdff6a319e7 ("ALSA: snd-usb: implement new endpoint streaming model")
Link: https://lore.kernel.org/r/20200424074016.14301-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/endpoint.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index d8dc7cb56d43c..50104f658ed49 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -346,17 +346,17 @@ static void queue_pending_output_urbs(struct snd_usb_endpoint *ep)
 			ep->next_packet_read_pos %= MAX_URBS;
 
 			/* take URB out of FIFO */
-			if (!list_empty(&ep->ready_playback_urbs))
+			if (!list_empty(&ep->ready_playback_urbs)) {
 				ctx = list_first_entry(&ep->ready_playback_urbs,
 					       struct snd_urb_ctx, ready_list);
+				list_del_init(&ctx->ready_list);
+			}
 		}
 		spin_unlock_irqrestore(&ep->lock, flags);
 
 		if (ctx == NULL)
 			return;
 
-		list_del_init(&ctx->ready_list);
-
 		/* copy over the length information */
 		for (i = 0; i < packet->packets; i++)
 			ctx->packet_size[i] = packet->packet_size[i];
-- 
2.25.1




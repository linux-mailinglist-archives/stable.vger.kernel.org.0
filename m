Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3B5373AA3
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbhEEMMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233486AbhEEMKi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:10:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FDBF6044F;
        Wed,  5 May 2021 12:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216579;
        bh=gvTN5d7BbQ0bFTkpZ6pcrdXmWDneK6Q6FrIZjm3RX3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vl1S2VciNHW9/+K6ziG3zF9+/SBG/232EMIS/4LALAtOLq2gTOu6qRZE1t+nB1qez
         1Qa9zDlQQ9nWo6ObVeI9TbDPQeB9XehaZIyfNQ9VfuCrxx6MwF769spv6Etj0uM38b
         XEPNzdPqFEtR7Xi+XNk3fPDRH/YHzr3drak1qVWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Lucas Endres <jaffa225man@gmail.com>
Subject: [PATCH 5.11 25/31] ALSA: usb-audio: Fix implicit sync clearance at stopping stream
Date:   Wed,  5 May 2021 14:06:14 +0200
Message-Id: <20210505112327.509156262@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112326.672439569@linuxfoundation.org>
References: <20210505112326.672439569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 988cc17552606be67a956cf8cd6ff504cfc5d643 upstream.

The recent endpoint management change for implicit feedback mode added
a clearance of ep->sync_sink (formerly ep->sync_slave) pointer at
snd_usb_endpoint_stop() to assure no leftover for the feedback from
the already stopped capture stream.  This turned out to cause a
regression, however, when full-duplex streams were running and only a
capture was stopped.  Because of the above clearance of ep->sync_sink
pointer, no more feedback is done, hence the playback will stall.

This patch fixes the ep->sync_sink clearance to be done only after all
endpoints are released, for addressing the regression.

Reported-and-tested-by: Lucas Endres <jaffa225man@gmail.com>
Fixes: bf6313a0ff76 ("ALSA: usb-audio: Refactor endpoint management")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210426063349.18601-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1442,11 +1442,11 @@ void snd_usb_endpoint_stop(struct snd_us
 	if (snd_BUG_ON(!atomic_read(&ep->running)))
 		return;
 
-	if (ep->sync_source)
-		WRITE_ONCE(ep->sync_source->sync_sink, NULL);
-
-	if (!atomic_dec_return(&ep->running))
+	if (!atomic_dec_return(&ep->running)) {
+		if (ep->sync_source)
+			WRITE_ONCE(ep->sync_source->sync_sink, NULL);
 		stop_urbs(ep, false);
+	}
 }
 
 /**



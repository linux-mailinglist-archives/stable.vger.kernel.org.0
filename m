Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24D63A62D9
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbhFNLFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:05:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234748AbhFNLDJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:03:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CD8661449;
        Mon, 14 Jun 2021 10:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667458;
        bh=ypkhbd6xLWuIlpAF2/q2ak7ZXCHyjWVQj/Y5HvQwd/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eEMb2Ou6Zafj1WDc0euCO7ufkOCpKfRwPpPnNephXFIDURQ92f3BjQ9khA2DWayDj
         st1NWQUETYs5XbdypkZoFba+vG17ckAR2s74yb594QlxxFkcuH3CohXAyZ8H6cNu14
         knT1Y0sD42TPrGN+UtirbV25QaK6m+7gqXd2urzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 046/131] ALSA: firewire-lib: fix the context to call snd_pcm_stop_xrun()
Date:   Mon, 14 Jun 2021 12:26:47 +0200
Message-Id: <20210614102654.587526556@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 9981b20a5e3694f4625ab5a1ddc98ce7503f6d12 upstream.

In the workqueue to queue wake-up event, isochronous context is not
processed, thus it's useless to check context for the workqueue to switch
status of runtime for PCM substream to XRUN. On the other hand, in
software IRQ context of 1394 OHCI, it's needed.

This commit fixes the bug introduced when tasklet was replaced with
workqueue.

Cc: <stable@vger.kernel.org>
Fixes: 2b3d2987d800 ("ALSA: firewire: Replace tasklet with work")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20210605091054.68866-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/amdtp-stream.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/firewire/amdtp-stream.c
+++ b/sound/firewire/amdtp-stream.c
@@ -804,7 +804,7 @@ static void generate_pkt_descs(struct am
 static inline void cancel_stream(struct amdtp_stream *s)
 {
 	s->packet_index = -1;
-	if (current_work() == &s->period_work)
+	if (in_interrupt())
 		amdtp_stream_pcm_abort(s);
 	WRITE_ONCE(s->pcm_buffer_pointer, SNDRV_PCM_POS_XRUN);
 }



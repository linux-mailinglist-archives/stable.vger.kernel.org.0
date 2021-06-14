Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4EB73A63A3
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbhFNLPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:15:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235128AbhFNLNM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:13:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAE326141D;
        Mon, 14 Jun 2021 10:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667726;
        bh=ypkhbd6xLWuIlpAF2/q2ak7ZXCHyjWVQj/Y5HvQwd/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tCOUNaIbtDv+gMqv9g0EUJG9+xhMxo73CFmw6jxNBvQ43+755wgH4jNXrwjRa9lmi
         aTq4wJCyyI5V2L/fXTeMFMtTf6aRE/aLIiLMB7e8SzT2afum/e+kvSHauBC9odQsx9
         WeCsWgm9uQsRRQ3LXmRxvaeflP4HixefMAc0fGmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.12 050/173] ALSA: firewire-lib: fix the context to call snd_pcm_stop_xrun()
Date:   Mon, 14 Jun 2021 12:26:22 +0200
Message-Id: <20210614102659.815561634@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
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



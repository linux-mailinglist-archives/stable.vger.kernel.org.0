Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0803519B0D4
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388065AbgDAQ3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:29:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388192AbgDAQ3m (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:29:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 292822063A;
        Wed,  1 Apr 2020 16:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758581;
        bh=u0oxV+ZE30Cvfe5WC10gcHtQGNHrKMYUrIi5VvOstjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6tp4JVuJAlh267mHsiIn2kOAA/2esN18EXccHrJRo3Xh4L5wIbahZWmuZ4p5I38T
         DKzWnnn4V425cIsOcpg43FvYzTpMHpfSjscXrKgAPLzpXH9HxtIn4gu2CPBVZDlTtr
         VjYIsvip5xGZ2eSplQ+boGSjU+u1lbkgoUJjlac8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Steinmetz <ast@domdv.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 14/91] ALSA: seq: virmidi: Fix running status after receiving sysex
Date:   Wed,  1 Apr 2020 18:17:10 +0200
Message-Id: <20200401161518.052174848@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161512.917494101@linuxfoundation.org>
References: <20200401161512.917494101@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 4384f167ce5fa7241b61bb0984d651bc528ddebe upstream.

The virmidi driver handles sysex event exceptionally in a short-cut
snd_seq_dump_var_event() call, but this missed the reset of the
running status.  As a result, it may lead to an incomplete command
right after the sysex when an event with the same running status was
queued.

Fix it by clearing the running status properly via alling
snd_midi_event_reset_decode() for that code path.

Reported-by: Andreas Steinmetz <ast@domdv.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/3b4a4e0f232b7afbaf0a843f63d0e538e3029bfd.camel@domdv.de
Link: https://lore.kernel.org/r/20200316090506.23966-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/seq/seq_virmidi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/core/seq/seq_virmidi.c
+++ b/sound/core/seq/seq_virmidi.c
@@ -95,6 +95,7 @@ static int snd_virmidi_dev_receive_event
 			if ((ev->flags & SNDRV_SEQ_EVENT_LENGTH_MASK) != SNDRV_SEQ_EVENT_LENGTH_VARIABLE)
 				continue;
 			snd_seq_dump_var_event(ev, (snd_seq_dump_func_t)snd_rawmidi_receive, vmidi->substream);
+			snd_midi_event_reset_decode(vmidi->parser);
 		} else {
 			len = snd_midi_event_decode(vmidi->parser, msg, sizeof(msg), ev);
 			if (len > 0)



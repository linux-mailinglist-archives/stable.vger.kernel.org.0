Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC43C191127
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbgCXNRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:17:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728630AbgCXNRl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:17:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE8D3206F6;
        Tue, 24 Mar 2020 13:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055860;
        bh=BqmL+3H48/Gpy+GE0Om4/hRbGWxIoleCGc5DLoDiXWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ThtIPTSa0EBqcAu35vS7xZdEMo5UqQurY8OYF0nK1zF1H8PyvqqacBf/7trkR37o
         WzLgbIiuH0ox485etV+dp6gjccKbi+vqSJCkqoXvpXBLGLwbFQJkkFs/zPEyX5SePR
         AMAIEpqtYjglB10YfGlwWmeUsYs2bzCBKkLkfdM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Steinmetz <ast@domdv.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 050/102] ALSA: seq: virmidi: Fix running status after receiving sysex
Date:   Tue, 24 Mar 2020 14:10:42 +0100
Message-Id: <20200324130811.832828931@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130806.544601211@linuxfoundation.org>
References: <20200324130806.544601211@linuxfoundation.org>
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
@@ -81,6 +81,7 @@ static int snd_virmidi_dev_receive_event
 			if ((ev->flags & SNDRV_SEQ_EVENT_LENGTH_MASK) != SNDRV_SEQ_EVENT_LENGTH_VARIABLE)
 				continue;
 			snd_seq_dump_var_event(ev, (snd_seq_dump_func_t)snd_rawmidi_receive, vmidi->substream);
+			snd_midi_event_reset_decode(vmidi->parser);
 		} else {
 			len = snd_midi_event_decode(vmidi->parser, msg, sizeof(msg), ev);
 			if (len > 0)



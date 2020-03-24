Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72111190F1E
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgCXNRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:17:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728640AbgCXNRn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:17:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D10E208D5;
        Tue, 24 Mar 2020 13:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055862;
        bh=NghoYBc4zwZeQeF+mZJvDUpz7Iy6q1FiihAPCz2qp6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DUEHn5J4JwGmwGcHTGLrfYxFSPx9Vsg9wawTRbEleKB0O2vCKDxUGliIJBJFNqFO5
         zXs9x/22gm5R4yNGylRt1funF4p9UpiylIp4AfgPbeS0cKTaD0K2GDZK+rhWGiBZn1
         jQ5KJnaUkCiB5g2SGS6iC7aGn74B+KLdzIoa4b8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 051/102] ALSA: seq: oss: Fix running status after receiving sysex
Date:   Tue, 24 Mar 2020 14:10:43 +0100
Message-Id: <20200324130811.925550553@linuxfoundation.org>
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

commit 6c3171ef76a0bad892050f6959a7eac02fb16df7 upstream.

This is a similar bug like the previous case for virmidi: the invalid
running status is kept after receiving a sysex message.

Again the fix is to clear the running status after handling the sysex.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/3b4a4e0f232b7afbaf0a843f63d0e538e3029bfd.camel@domdv.de
Link: https://lore.kernel.org/r/20200316090506.23966-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/seq/oss/seq_oss_midi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/core/seq/oss/seq_oss_midi.c
+++ b/sound/core/seq/oss/seq_oss_midi.c
@@ -602,6 +602,7 @@ send_midi_event(struct seq_oss_devinfo *
 		len = snd_seq_oss_timer_start(dp->timer);
 	if (ev->type == SNDRV_SEQ_EVENT_SYSEX) {
 		snd_seq_oss_readq_sysex(dp->readq, mdev->seq_device, ev);
+		snd_midi_event_reset_decode(mdev->coder);
 	} else {
 		len = snd_midi_event_decode(mdev->coder, msg, sizeof(msg), ev);
 		if (len > 0)



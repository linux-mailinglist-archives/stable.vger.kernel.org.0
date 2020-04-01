Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC4619B16D
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732336AbgDAQe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:34:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387470AbgDAQe4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:34:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BABD206F8;
        Wed,  1 Apr 2020 16:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758895;
        bh=0vKhX8eqkC4hibNoWu6IOHcT8SXG4FHJa/n34WYhQYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tSd28sPxh166ufdM1x4KBkVAJ9r+cmxk835BLo9Hi2dl5N/ArQMiHO6+Lcb7NIhNf
         cOpyeaOG9P4ag7uQElnAE+o/Pq+klqkPXe3HWxFwnrR/hDkhUIlKPXFJ7roMA8k3ZX
         pLjiIkqOPuwkjDlJ+WTnP8vbibfCTvjPXiofVsv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 015/102] ALSA: seq: oss: Fix running status after receiving sysex
Date:   Wed,  1 Apr 2020 18:17:18 +0200
Message-Id: <20200401161534.887920857@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
References: <20200401161530.451355388@linuxfoundation.org>
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
@@ -615,6 +615,7 @@ send_midi_event(struct seq_oss_devinfo *
 		len = snd_seq_oss_timer_start(dp->timer);
 	if (ev->type == SNDRV_SEQ_EVENT_SYSEX) {
 		snd_seq_oss_readq_sysex(dp->readq, mdev->seq_device, ev);
+		snd_midi_event_reset_decode(mdev->coder);
 	} else {
 		len = snd_midi_event_decode(mdev->coder, msg, sizeof(msg), ev);
 		if (len > 0)



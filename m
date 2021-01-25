Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB56302AAE
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbhAYStV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:49:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:34028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727009AbhAYSsG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:48:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BE382075B;
        Mon, 25 Jan 2021 18:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600471;
        bh=nHqKweedei2LYxtp/IjBgHO4pOd3oRIKcYCJ268FmtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hNXu8R8E+yA6ztZpr0Mz8UImq2/uXxFmWMfmZVHoI2AJVkLbrslMKfJkSUeXK/GN4
         fenCqx45reaT8HbeOf4lrUlEZ+gVy8EIssMfNUlPwlNdPxt+c1Msu/HBJwQzDfAV60
         LgvvJl7lWpt2iqnU997Stq/uLc10hJc5amBiPF4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e42504ff21cff05a595f@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 008/199] ALSA: seq: oss: Fix missing error check in snd_seq_oss_synth_make_info()
Date:   Mon, 25 Jan 2021 19:37:10 +0100
Message-Id: <20210125183216.609983252@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 217bfbb8b0bfa24619b11ab75c135fec99b99b20 upstream.

snd_seq_oss_synth_make_info() didn't check the error code from
snd_seq_oss_midi_make_info(), and this leads to the call of strlcpy()
with the uninitialized string as the source, which may lead to the
access over the limit.

Add the proper error check for avoiding the failure.

Reported-by: syzbot+e42504ff21cff05a595f@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210115093428.15882-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/seq/oss/seq_oss_synth.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/core/seq/oss/seq_oss_synth.c
+++ b/sound/core/seq/oss/seq_oss_synth.c
@@ -611,7 +611,8 @@ snd_seq_oss_synth_make_info(struct seq_o
 
 	if (info->is_midi) {
 		struct midi_info minf;
-		snd_seq_oss_midi_make_info(dp, info->midi_mapped, &minf);
+		if (snd_seq_oss_midi_make_info(dp, info->midi_mapped, &minf))
+			return -ENXIO;
 		inf->synth_type = SYNTH_TYPE_MIDI;
 		inf->synth_subtype = 0;
 		inf->nr_voices = 16;



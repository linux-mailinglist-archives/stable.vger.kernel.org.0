Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB937156627
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbgBHScY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:32:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34586 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727940AbgBHS3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:48 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrO-0003iT-Bz; Sat, 08 Feb 2020 18:29:42 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrM-000CWx-Su; Sat, 08 Feb 2020 18:29:40 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        syzbot+f153bde47a62e0b05f83@syzkaller.appspotmail.com,
        "Takashi Iwai" <tiwai@suse.de>
Date:   Sat, 08 Feb 2020 18:21:18 +0000
Message-ID: <lsq.1581185941.27326435@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 139/148] ALSA: pcm: oss: Avoid potential buffer overflows
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 4cc8d6505ab82db3357613d36e6c58a297f57f7c upstream.

syzkaller reported an invalid access in PCM OSS read, and this seems
to be an overflow of the internal buffer allocated for a plugin.
Since the rate plugin adjusts its transfer size dynamically, the
calculation for the chained plugin might be bigger than the given
buffer size in some extreme cases, which lead to such an buffer
overflow as caught by KASAN.

Fix it by limiting the max transfer size properly by checking against
the destination size in each plugin transfer callback.

Reported-by: syzbot+f153bde47a62e0b05f83@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20191204144824.17801-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/core/oss/linear.c | 2 ++
 sound/core/oss/mulaw.c  | 2 ++
 sound/core/oss/route.c  | 2 ++
 3 files changed, 6 insertions(+)

--- a/sound/core/oss/linear.c
+++ b/sound/core/oss/linear.c
@@ -107,6 +107,8 @@ static snd_pcm_sframes_t linear_transfer
 		}
 	}
 #endif
+	if (frames > dst_channels[0].frames)
+		frames = dst_channels[0].frames;
 	convert(plugin, src_channels, dst_channels, frames);
 	return frames;
 }
--- a/sound/core/oss/mulaw.c
+++ b/sound/core/oss/mulaw.c
@@ -269,6 +269,8 @@ static snd_pcm_sframes_t mulaw_transfer(
 		}
 	}
 #endif
+	if (frames > dst_channels[0].frames)
+		frames = dst_channels[0].frames;
 	data = (struct mulaw_priv *)plugin->extra_data;
 	data->func(plugin, src_channels, dst_channels, frames);
 	return frames;
--- a/sound/core/oss/route.c
+++ b/sound/core/oss/route.c
@@ -57,6 +57,8 @@ static snd_pcm_sframes_t route_transfer(
 		return -ENXIO;
 	if (frames == 0)
 		return 0;
+	if (frames > dst_channels[0].frames)
+		frames = dst_channels[0].frames;
 
 	nsrcs = plugin->src_format.channels;
 	ndsts = plugin->dst_format.channels;


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E562F11B5FC
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731669AbfLKPOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:14:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731361AbfLKPOw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:14:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5B7224654;
        Wed, 11 Dec 2019 15:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077292;
        bh=YOOKKu7KZKalCYc9fcrbvluf+Q6hWobR9h7/kUaryYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o+3jEwiwdJ2g0AyOfNiD/Mms1tYw6G1+y8ubosNd1c0Y8fokbNVW86/7/85zfO/un
         0aO7ESl2yTE5V4F6J7D+DXOR5OwZH/+BrURFyLYhj7tScRL1AMuSXvSXzkBvv0I8Oy
         5z7nZ79by/0y53250TBXGpnnTl8KNs+RLnyeLw8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f153bde47a62e0b05f83@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.3 052/105] ALSA: pcm: oss: Avoid potential buffer overflows
Date:   Wed, 11 Dec 2019 16:05:41 +0100
Message-Id: <20191211150242.347949603@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191204144824.17801-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/oss/linear.c |    2 ++
 sound/core/oss/mulaw.c  |    2 ++
 sound/core/oss/route.c  |    2 ++
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



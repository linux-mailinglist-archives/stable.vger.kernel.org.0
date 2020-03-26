Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 860D9194CED
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgCZX1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:27:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728060AbgCZXYt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 19:24:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 797E320409;
        Thu, 26 Mar 2020 23:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585265089;
        bh=HZKph1vlL2+lbjT545LdjST3edbD4zKJanui7XS+8/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=awNVImfem1FjxMDX6/ArD9J0T/EkPE31LyCBS9kNiWvrkLzlIjCIQqdWuhXXn0IsP
         KJUEZZLuh2Jn1f1AcKnfmEFJ1NMS0d12xgo5YSuipSwNpRtvlql6itKm5qX39YvWrG
         TEWdCKYZTxRqb7XlrZtGd33jsZqimch4ZkC9Z+qk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        syzbot+e1fe9f44fb8ecf4fb5dd@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 15/19] ALSA: pcm: oss: Avoid plugin buffer overflow
Date:   Thu, 26 Mar 2020 19:24:27 -0400
Message-Id: <20200326232431.7816-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326232431.7816-1-sashal@kernel.org>
References: <20200326232431.7816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit f2ecf903ef06eb1bbbfa969db9889643d487e73a ]

Each OSS PCM plugins allocate its internal buffer per pre-calculation
of the max buffer size through the chain of plugins (calling
src_frames and dst_frames callbacks).  This works for most plugins,
but the rate plugin might behave incorrectly.  The calculation in the
rate plugin involves with the fractional position, i.e. it may vary
depending on the input position.  Since the buffer size
pre-calculation is always done with the offset zero, it may return a
shorter size than it might be; this may result in the out-of-bound
access as spotted by fuzzer.

This patch addresses those possible buffer overflow accesses by simply
setting the upper limit per the given buffer size for each plugin
before src_frames() and after dst_frames() calls.

Reported-by: syzbot+e1fe9f44fb8ecf4fb5dd@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/000000000000b25ea005a02bcf21@google.com
Link: https://lore.kernel.org/r/20200309082148.19855-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/oss/pcm_plugin.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/core/oss/pcm_plugin.c b/sound/core/oss/pcm_plugin.c
index 31cb2acf8afcc..9b588c6a6f099 100644
--- a/sound/core/oss/pcm_plugin.c
+++ b/sound/core/oss/pcm_plugin.c
@@ -209,6 +209,8 @@ snd_pcm_sframes_t snd_pcm_plug_client_size(struct snd_pcm_substream *plug, snd_p
 	if (stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		plugin = snd_pcm_plug_last(plug);
 		while (plugin && drv_frames > 0) {
+			if (drv_frames > plugin->buf_frames)
+				drv_frames = plugin->buf_frames;
 			plugin_prev = plugin->prev;
 			if (plugin->src_frames)
 				drv_frames = plugin->src_frames(plugin, drv_frames);
@@ -220,6 +222,8 @@ snd_pcm_sframes_t snd_pcm_plug_client_size(struct snd_pcm_substream *plug, snd_p
 			plugin_next = plugin->next;
 			if (plugin->dst_frames)
 				drv_frames = plugin->dst_frames(plugin, drv_frames);
+			if (drv_frames > plugin->buf_frames)
+				drv_frames = plugin->buf_frames;
 			plugin = plugin_next;
 		}
 	} else
@@ -248,11 +252,15 @@ snd_pcm_sframes_t snd_pcm_plug_slave_size(struct snd_pcm_substream *plug, snd_pc
 				if (frames < 0)
 					return frames;
 			}
+			if (frames > plugin->buf_frames)
+				frames = plugin->buf_frames;
 			plugin = plugin_next;
 		}
 	} else if (stream == SNDRV_PCM_STREAM_CAPTURE) {
 		plugin = snd_pcm_plug_last(plug);
 		while (plugin) {
+			if (frames > plugin->buf_frames)
+				frames = plugin->buf_frames;
 			plugin_prev = plugin->prev;
 			if (plugin->src_frames) {
 				frames = plugin->src_frames(plugin, frames);
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED3119B397
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388570AbgDAQfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:35:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387470AbgDAQfA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:35:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EE1820658;
        Wed,  1 Apr 2020 16:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758900;
        bh=AL7hoBSzUmkmWDlkQMwp9cp9Ui5kceVTauOdV7/oyJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0htzdNIOC+BnhGKekAPBtMOuOhF/dhlRqYRi4yCvggrTCXAK84j8CKUpXZyn6a53q
         o4P6/eIIuri3Ibv5bezINfwlFyBJ9r80T3ejRReStLoms3Z6mjlilhjronEdPj/+hn
         LZ3l+3Lif6Kdsiv7PMqUSdSlZVdzyLqX7jHqm5dU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e1fe9f44fb8ecf4fb5dd@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 016/102] ALSA: pcm: oss: Avoid plugin buffer overflow
Date:   Wed,  1 Apr 2020 18:17:19 +0200
Message-Id: <20200401161535.218243378@linuxfoundation.org>
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

commit f2ecf903ef06eb1bbbfa969db9889643d487e73a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/oss/pcm_plugin.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/core/oss/pcm_plugin.c
+++ b/sound/core/oss/pcm_plugin.c
@@ -209,6 +209,8 @@ snd_pcm_sframes_t snd_pcm_plug_client_si
 	if (stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		plugin = snd_pcm_plug_last(plug);
 		while (plugin && drv_frames > 0) {
+			if (drv_frames > plugin->buf_frames)
+				drv_frames = plugin->buf_frames;
 			plugin_prev = plugin->prev;
 			if (plugin->src_frames)
 				drv_frames = plugin->src_frames(plugin, drv_frames);
@@ -220,6 +222,8 @@ snd_pcm_sframes_t snd_pcm_plug_client_si
 			plugin_next = plugin->next;
 			if (plugin->dst_frames)
 				drv_frames = plugin->dst_frames(plugin, drv_frames);
+			if (drv_frames > plugin->buf_frames)
+				drv_frames = plugin->buf_frames;
 			plugin = plugin_next;
 		}
 	} else
@@ -248,11 +252,15 @@ snd_pcm_sframes_t snd_pcm_plug_slave_siz
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



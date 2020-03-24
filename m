Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5A8191138
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgCXNdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:33:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727742AbgCXNNA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:13:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79EF3208CA;
        Tue, 24 Mar 2020 13:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055579;
        bh=wyLKa9e4fnj7moQyCDcCfUz9jCeCcmM9gRIIhMtIa1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZYScw34hknr+WAsedL13HExQXTjE2c0Fzcide4/U0Qaomv3t1JmnDCUwkNZACpll
         m1bI0LZBZ3DPy3BK5nLoUcMix0ObMUkWYedV1MloS6jShsIQRv88ZjEphvQ+qbmrxv
         dSOXKru8KONkxdfPkk04MInElmCp69lml2geTvAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+2a59ee7a9831b264f45e@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 30/65] ALSA: pcm: oss: Remove WARNING from snd_pcm_plug_alloc() checks
Date:   Tue, 24 Mar 2020 14:10:51 +0100
Message-Id: <20200324130801.038990515@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130756.679112147@linuxfoundation.org>
References: <20200324130756.679112147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 5461e0530c222129dfc941058be114b5cbc00837 upstream.

The return value checks in snd_pcm_plug_alloc() are covered with
snd_BUG_ON() macro that may trigger a kernel WARNING depending on the
kconfig.  But since the error condition can be triggered by a weird
user space parameter passed to OSS layer, we shouldn't give the kernel
stack trace just for that.  As it's a normal error condition, let's
remove snd_BUG_ON() macro usage there.

Reported-by: syzbot+2a59ee7a9831b264f45e@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200312155730.7520-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/oss/pcm_plugin.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/core/oss/pcm_plugin.c
+++ b/sound/core/oss/pcm_plugin.c
@@ -111,7 +111,7 @@ int snd_pcm_plug_alloc(struct snd_pcm_su
 		while (plugin->next) {
 			if (plugin->dst_frames)
 				frames = plugin->dst_frames(plugin, frames);
-			if (snd_BUG_ON((snd_pcm_sframes_t)frames <= 0))
+			if ((snd_pcm_sframes_t)frames <= 0)
 				return -ENXIO;
 			plugin = plugin->next;
 			err = snd_pcm_plugin_alloc(plugin, frames);
@@ -123,7 +123,7 @@ int snd_pcm_plug_alloc(struct snd_pcm_su
 		while (plugin->prev) {
 			if (plugin->src_frames)
 				frames = plugin->src_frames(plugin, frames);
-			if (snd_BUG_ON((snd_pcm_sframes_t)frames <= 0))
+			if ((snd_pcm_sframes_t)frames <= 0)
 				return -ENXIO;
 			plugin = plugin->prev;
 			err = snd_pcm_plugin_alloc(plugin, frames);



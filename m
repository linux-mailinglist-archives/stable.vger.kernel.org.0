Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B35F9194C9A
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgCZXZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:25:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727843AbgCZXZl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 19:25:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7EFC20B1F;
        Thu, 26 Mar 2020 23:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585265140;
        bh=jmFWny21xsnTOEOG9DY83c3Jc7v1c7S56O+7EUfbz/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1V/5jJC1953o+VQoQaVn3MjJHAFgNIxbBqli3XUIex9WGqCYGuaBs5A9fV+tCH8PK
         np0DwKClVOxrt7DGQBJvmR3soe0GWmUVGa8InPuvuF6rT+N+cI+YylZ/EA3YOaIPea
         JbYP9P9oZsXcYpKrxXl2ZT8d/yfCT4b6dR2xFziA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        syzbot+2a59ee7a9831b264f45e@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.4 4/4] ALSA: pcm: oss: Remove WARNING from snd_pcm_plug_alloc() checks
Date:   Thu, 26 Mar 2020 19:25:35 -0400
Message-Id: <20200326232535.8460-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326232535.8460-1-sashal@kernel.org>
References: <20200326232535.8460-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 5461e0530c222129dfc941058be114b5cbc00837 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/oss/pcm_plugin.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/core/oss/pcm_plugin.c b/sound/core/oss/pcm_plugin.c
index b08b2d2d804bd..0e3dd6014ce55 100644
--- a/sound/core/oss/pcm_plugin.c
+++ b/sound/core/oss/pcm_plugin.c
@@ -111,7 +111,7 @@ int snd_pcm_plug_alloc(struct snd_pcm_substream *plug, snd_pcm_uframes_t frames)
 		while (plugin->next) {
 			if (plugin->dst_frames)
 				frames = plugin->dst_frames(plugin, frames);
-			if (snd_BUG_ON((snd_pcm_sframes_t)frames <= 0))
+			if ((snd_pcm_sframes_t)frames <= 0)
 				return -ENXIO;
 			plugin = plugin->next;
 			err = snd_pcm_plugin_alloc(plugin, frames);
@@ -123,7 +123,7 @@ int snd_pcm_plug_alloc(struct snd_pcm_substream *plug, snd_pcm_uframes_t frames)
 		while (plugin->prev) {
 			if (plugin->src_frames)
 				frames = plugin->src_frames(plugin, frames);
-			if (snd_BUG_ON((snd_pcm_sframes_t)frames <= 0))
+			if ((snd_pcm_sframes_t)frames <= 0)
 				return -ENXIO;
 			plugin = plugin->prev;
 			err = snd_pcm_plugin_alloc(plugin, frames);
-- 
2.20.1


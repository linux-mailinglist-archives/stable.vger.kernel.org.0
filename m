Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 233A1F479E
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390343AbfKHLr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:47:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:35922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391543AbfKHLr0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:47:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 162DB20656;
        Fri,  8 Nov 2019 11:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213645;
        bh=v6v8I+DBAADPhAi8quRgCkikJDr/4ewsDfazDomxKTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ck/MgDI9IXE9BUApBV5NH898eFutT2VY2gVTL3zBjv/w6UPU/YLUbyDh9hH1Gerfm
         DXCcf7JSo9QqM6GA/c3FEBu23te8a59YFWEUeHvu0Yu7ZLXk7+PMWoD1RS8RqoRqkI
         ohMfpm8AvRoiQajtwDOVZLVW8z4pvf7zv/lplzJE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 02/44] ALSA: pcm: signedness bug in snd_pcm_plug_alloc()
Date:   Fri,  8 Nov 2019 06:46:38 -0500
Message-Id: <20191108114721.15944-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114721.15944-1-sashal@kernel.org>
References: <20191108114721.15944-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 6f128fa41f310e1f39ebcea9621d2905549ecf52 ]

The "frames" variable is unsigned so the error handling doesn't work
properly.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/oss/pcm_plugin.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/core/oss/pcm_plugin.c b/sound/core/oss/pcm_plugin.c
index a84a1d3d23e56..c6888d76ca5e9 100644
--- a/sound/core/oss/pcm_plugin.c
+++ b/sound/core/oss/pcm_plugin.c
@@ -111,7 +111,7 @@ int snd_pcm_plug_alloc(struct snd_pcm_substream *plug, snd_pcm_uframes_t frames)
 		while (plugin->next) {
 			if (plugin->dst_frames)
 				frames = plugin->dst_frames(plugin, frames);
-			if (snd_BUG_ON(frames <= 0))
+			if (snd_BUG_ON((snd_pcm_sframes_t)frames <= 0))
 				return -ENXIO;
 			plugin = plugin->next;
 			err = snd_pcm_plugin_alloc(plugin, frames);
@@ -123,7 +123,7 @@ int snd_pcm_plug_alloc(struct snd_pcm_substream *plug, snd_pcm_uframes_t frames)
 		while (plugin->prev) {
 			if (plugin->src_frames)
 				frames = plugin->src_frames(plugin, frames);
-			if (snd_BUG_ON(frames <= 0))
+			if (snd_BUG_ON((snd_pcm_sframes_t)frames <= 0))
 				return -ENXIO;
 			plugin = plugin->prev;
 			err = snd_pcm_plugin_alloc(plugin, frames);
-- 
2.20.1


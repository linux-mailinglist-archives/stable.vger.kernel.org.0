Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAFE7F96B
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394782AbfHBN1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:27:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394692AbfHBN0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:26:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66FD521855;
        Fri,  2 Aug 2019 13:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752415;
        bh=oBD8mlOmTqr2lwydNzzevb3/qEoAgt12d1ygqhPtN/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k1TYU0XuBNnTL1Ufsh+8OsRzs5Nr6o0h6erBV13kKZUWoEjySY+Mwd40dOVvqfhWU
         eac779JBMQFOoqxKQ+tRDwQERmmoGK/IK6GX5RoNX5v+HZPIbRocJrtDQmTDpbu9nb
         YQftTz5P2LL4RrJgVuwsfrL6fliwbquPm3l1I3es=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Vinod Koul <vkoul@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 10/17] ALSA: compress: Prevent bypasses of set_params
Date:   Fri,  2 Aug 2019 09:26:27 -0400
Message-Id: <20190802132635.14885-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802132635.14885-1-sashal@kernel.org>
References: <20190802132635.14885-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 26c3f1542f5064310ad26794c09321780d00c57d ]

Currently, whilst in SNDRV_PCM_STATE_OPEN it is possible to call
snd_compr_stop, snd_compr_drain and snd_compr_partial_drain, which
allow a transition to SNDRV_PCM_STATE_SETUP. The stream should
only be able to move to the setup state once it has received a
SNDRV_COMPRESS_SET_PARAMS ioctl. Fix this issue by not allowing
those ioctls whilst in the open state.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Acked-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/compress_offload.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 16269e7ff3904..d0a21a5867673 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -688,9 +688,15 @@ static int snd_compr_stop(struct snd_compr_stream *stream)
 {
 	int retval;
 
-	if (stream->runtime->state == SNDRV_PCM_STATE_PREPARED ||
-			stream->runtime->state == SNDRV_PCM_STATE_SETUP)
+	switch (stream->runtime->state) {
+	case SNDRV_PCM_STATE_OPEN:
+	case SNDRV_PCM_STATE_SETUP:
+	case SNDRV_PCM_STATE_PREPARED:
 		return -EPERM;
+	default:
+		break;
+	}
+
 	retval = stream->ops->trigger(stream, SNDRV_PCM_TRIGGER_STOP);
 	if (!retval) {
 		snd_compr_drain_notify(stream);
@@ -739,9 +745,14 @@ static int snd_compr_drain(struct snd_compr_stream *stream)
 {
 	int retval;
 
-	if (stream->runtime->state == SNDRV_PCM_STATE_PREPARED ||
-			stream->runtime->state == SNDRV_PCM_STATE_SETUP)
+	switch (stream->runtime->state) {
+	case SNDRV_PCM_STATE_OPEN:
+	case SNDRV_PCM_STATE_SETUP:
+	case SNDRV_PCM_STATE_PREPARED:
 		return -EPERM;
+	default:
+		break;
+	}
 
 	retval = stream->ops->trigger(stream, SND_COMPR_TRIGGER_DRAIN);
 	if (retval) {
@@ -778,9 +789,16 @@ static int snd_compr_next_track(struct snd_compr_stream *stream)
 static int snd_compr_partial_drain(struct snd_compr_stream *stream)
 {
 	int retval;
-	if (stream->runtime->state == SNDRV_PCM_STATE_PREPARED ||
-			stream->runtime->state == SNDRV_PCM_STATE_SETUP)
+
+	switch (stream->runtime->state) {
+	case SNDRV_PCM_STATE_OPEN:
+	case SNDRV_PCM_STATE_SETUP:
+	case SNDRV_PCM_STATE_PREPARED:
 		return -EPERM;
+	default:
+		break;
+	}
+
 	/* stream can be drained only when next track has been signalled */
 	if (stream->next_track == false)
 		return -EPERM;
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 512D78DAD9
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbfHNRUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:20:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730465AbfHNRKV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:10:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80AF32133F;
        Wed, 14 Aug 2019 17:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802621;
        bh=794wgnbXaWkTJ0/bmNdN8SC03enKj458fY9bChFr2W4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VpPLmlvQqVeGSN6dviMvlj7Tf3xlYqy5pWhb3EgIfJ3Eqg0PfiH1e6m0aw3Kp7ddc
         ViYOqDREWi0JLeZRhIy348eBFPdOg8w9nIEeA2MXSFuEqnvB5yFB4DFOI3h7sR/MSi
         U7KiWFQZK3k5KAmYgulsBqX73z+oEqWdcT0M8TII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Vinod Koul <vkoul@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 53/91] ALSA: compress: Prevent bypasses of set_params
Date:   Wed, 14 Aug 2019 19:01:16 +0200
Message-Id: <20190814165751.843021519@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 44e81cf302401..5e74f518bd598 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -712,9 +712,15 @@ static int snd_compr_stop(struct snd_compr_stream *stream)
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
@@ -802,9 +808,14 @@ static int snd_compr_drain(struct snd_compr_stream *stream)
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
@@ -841,9 +852,16 @@ static int snd_compr_next_track(struct snd_compr_stream *stream)
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




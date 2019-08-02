Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5AD07F999
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394512AbfHBN0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:26:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394509AbfHBN0M (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:26:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E490D2182B;
        Fri,  2 Aug 2019 13:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752371;
        bh=RgQN4YF2CFXCe3Y6feEwt0FWqjUndpT+Z2gITf/3vH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GoNIn3PQrThLrPvVsYTKsA9yQOj+Paoy9ciMoaxcmTFkOb85BG5732JkYmI8hG1DA
         gjH4SqtYhv5yEKr4ziNonutI+eORIPSuWC2qVO14bLlevjLH0+1tlUUMUQ9LJFBPzW
         4hZZmjVnGUMxLucsEhVO5NmI8pFr3S2FRVYQxXKA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Vinod Koul <vkoul@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 12/22] ALSA: compress: Don't allow paritial drain operations on capture streams
Date:   Fri,  2 Aug 2019 09:25:36 -0400
Message-Id: <20190802132547.14517-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802132547.14517-1-sashal@kernel.org>
References: <20190802132547.14517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit a70ab8a8645083f3700814e757f2940a88b7ef88 ]

Partial drain and next track are intended for gapless playback and
don't really have an obvious interpretation for a capture stream, so
makes sense to not allow those operations on capture streams.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Acked-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/compress_offload.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 1538fbc7562b8..b4f1536b17cb5 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -835,6 +835,10 @@ static int snd_compr_next_track(struct snd_compr_stream *stream)
 	if (stream->runtime->state != SNDRV_PCM_STATE_RUNNING)
 		return -EPERM;
 
+	/* next track doesn't have any meaning for capture streams */
+	if (stream->direction == SND_COMPRESS_CAPTURE)
+		return -EPERM;
+
 	/* you can signal next track if this is intended to be a gapless stream
 	 * and current track metadata is set
 	 */
@@ -862,6 +866,10 @@ static int snd_compr_partial_drain(struct snd_compr_stream *stream)
 		break;
 	}
 
+	/* partial drain doesn't have any meaning for capture streams */
+	if (stream->direction == SND_COMPRESS_CAPTURE)
+		return -EPERM;
+
 	/* stream can be drained only when next track has been signalled */
 	if (stream->next_track == false)
 		return -EPERM;
-- 
2.20.1


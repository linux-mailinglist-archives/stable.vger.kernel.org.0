Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03B1E8DB45
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbfHNRHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:07:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728673AbfHNRHF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:07:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C74EC214DA;
        Wed, 14 Aug 2019 17:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802424;
        bh=CWxr3WGRiYKO8jNmPWHHP1v10oSJ3qpN97evaq9D0zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zrDSZ7KltRK30z/U/mu6A54jYPsM+imMw+IGsRiKuaTu6mAV0LVOFjWFKOfhwhYbt
         ChbhXEq4G5ZyZNM/uS0r5MY5x+BbCHFCU8R+Z5zVA8ecHOO6Ko3LSBAG3LmmMyfGO7
         ZgQDk4hGJ8FR1rg7zffhhsIrVayIlUa4e76/YnZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Vinod Koul <vkoul@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 094/144] ALSA: compress: Dont allow paritial drain operations on capture streams
Date:   Wed, 14 Aug 2019 19:00:50 +0200
Message-Id: <20190814165803.810549781@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 40dae723c59db..6cf5b8440cf30 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -834,6 +834,10 @@ static int snd_compr_next_track(struct snd_compr_stream *stream)
 	if (stream->runtime->state != SNDRV_PCM_STATE_RUNNING)
 		return -EPERM;
 
+	/* next track doesn't have any meaning for capture streams */
+	if (stream->direction == SND_COMPRESS_CAPTURE)
+		return -EPERM;
+
 	/* you can signal next track if this is intended to be a gapless stream
 	 * and current track metadata is set
 	 */
@@ -861,6 +865,10 @@ static int snd_compr_partial_drain(struct snd_compr_stream *stream)
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




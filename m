Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9EC99D9E
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391478AbfHVRXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:23:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403897AbfHVRXT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:23:19 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A24323405;
        Thu, 22 Aug 2019 17:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494599;
        bh=3cjpLCQ8fn6p6DHotHg4R+SHQOC6BSFZW4EWspyAYNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eGp6yLhRfeVxOAqTGZvyg7M+kQNoqQK+b0LHnmxKEU7PC7tmzc7niXQewt0xWL92i
         y3/uIlZ82oW+8fAj90fvqXYtbaWHMe3IPPsrbkJZLVg4Eo70BxSNfsiCdDuZVWp8VW
         gAaryLPPbiJCwSJZ9dMiEMUWWX05IbB55Xpt+gV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Vinod Koul <vkoul@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 020/103] ALSA: compress: Dont allow paritial drain operations on capture streams
Date:   Thu, 22 Aug 2019 10:18:08 -0700
Message-Id: <20190822171729.672960573@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
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




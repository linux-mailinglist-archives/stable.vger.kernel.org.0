Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C59377F968
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394683AbfHBN12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:27:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394699AbfHBN05 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:26:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A401521874;
        Fri,  2 Aug 2019 13:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752416;
        bh=212rHPD5TW5Tcjg46O69Jc4OuIMGL5L2p+xkDXR3qG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mkY0ByliTOjIAe6eYJznl6XilD/gOHp1bmb85naMFtFnyXlvNoSz6d59Th85LXoY0
         PdiJDbRT8lZe4x7CIvXzLB7Fnga/YfXyGSXp/ZtM/LKQbrjUKZlvVJZVBMzBeyIC7G
         kx1lqWz8RZ22MxJOlRyRA5kCqZ1YfmE6Seohekew=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Vinod Koul <vkoul@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 11/17] ALSA: compress: Be more restrictive about when a drain is allowed
Date:   Fri,  2 Aug 2019 09:26:28 -0400
Message-Id: <20190802132635.14885-11-sashal@kernel.org>
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

[ Upstream commit 3b8179944cb0dd53e5223996966746cdc8a60657 ]

Draining makes little sense in the situation of hardware overrun, as the
hardware will have consumed all its available samples. Additionally,
draining whilst the stream is paused would presumably get stuck as no
data is being consumed on the DSP side.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Acked-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/compress_offload.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index d0a21a5867673..771d7b334ad87 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -749,7 +749,10 @@ static int snd_compr_drain(struct snd_compr_stream *stream)
 	case SNDRV_PCM_STATE_OPEN:
 	case SNDRV_PCM_STATE_SETUP:
 	case SNDRV_PCM_STATE_PREPARED:
+	case SNDRV_PCM_STATE_PAUSED:
 		return -EPERM;
+	case SNDRV_PCM_STATE_XRUN:
+		return -EPIPE;
 	default:
 		break;
 	}
@@ -794,7 +797,10 @@ static int snd_compr_partial_drain(struct snd_compr_stream *stream)
 	case SNDRV_PCM_STATE_OPEN:
 	case SNDRV_PCM_STATE_SETUP:
 	case SNDRV_PCM_STATE_PREPARED:
+	case SNDRV_PCM_STATE_PAUSED:
 		return -EPERM;
+	case SNDRV_PCM_STATE_XRUN:
+		return -EPIPE;
 	default:
 		break;
 	}
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8E98DAC6
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbfHNRKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730485AbfHNRK3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:10:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 430B62084D;
        Wed, 14 Aug 2019 17:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802628;
        bh=thcy6Q/Hz7EBbae/VkotyQuplx0sNcmIZID/r/im+pU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mu2qXQo9vuYmary0325Vi0NCRTBuSYuMmJFkoh3UU8I9quRI1DwUgrH5yjFYcl7xF
         CrZKLG72G3tb3kK+s0HV5T8N+ES8EeAAE+5ixvJa9knNai2XNjnjFPgZYdtD5RwpQc
         NYJMvQ6s2I506sSYrxY0OLySxuQ+fWbcOCfiGtGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Vinod Koul <vkoul@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 55/91] ALSA: compress: Be more restrictive about when a drain is allowed
Date:   Wed, 14 Aug 2019 19:01:18 +0200
Message-Id: <20190814165751.931921514@linuxfoundation.org>
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
index 9c1684f01aca0..516ec35873256 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -812,7 +812,10 @@ static int snd_compr_drain(struct snd_compr_stream *stream)
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
@@ -861,7 +864,10 @@ static int snd_compr_partial_drain(struct snd_compr_stream *stream)
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




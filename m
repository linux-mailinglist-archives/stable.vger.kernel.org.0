Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0CB999B46
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403916AbfHVRXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:23:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390121AbfHVRXV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:23:21 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D88EE23406;
        Thu, 22 Aug 2019 17:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494600;
        bh=xr41tJqVxe692GCkDD5OSJBDIWj3pT8XZ1dJgTZ0/7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oqgb2MxSKUmm6rn8hjwFYXDN46xBxqq5JygPD72+ijFqxgJj/xrwdISTJoLiRUIxf
         j2Xb7UaNJoIPyQbKirtEHFYwxJ54xlKXmfrtVA4fuMdhy8+4dxdCJLhAU4KbNV+j1D
         O3nJnq8ge2yhB4BhAkupOm6MXYGgdo3+QOUE/tHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Vinod Koul <vkoul@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 021/103] ALSA: compress: Be more restrictive about when a drain is allowed
Date:   Thu, 22 Aug 2019 10:18:09 -0700
Message-Id: <20190822171729.707336221@linuxfoundation.org>
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
index b4f1536b17cb5..2e2d184684911 100644
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




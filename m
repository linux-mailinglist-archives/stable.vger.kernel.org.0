Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0E9113EC07
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405955AbgAPRor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:44:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:35920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405944AbgAPRoq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:44:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7A4E2475A;
        Thu, 16 Jan 2020 17:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196686;
        bh=+4iWLMisGGOvW8hD5jsQgaUof1QaynPWaCGEVaH88rY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zr0exkGmRtZeZ7k0l2wda/ezklgbepb0CLXEEY9UrscHvdCnBeIruaqMq75Uwz2+0
         56DEDSA0rrMfFzZhz1KPqAYD6WvzMzmfEGWD5WXf/MNPfI37WYIPRIdMchrh/ltzSk
         qkwOgkqyyXfg1C/uvsGJegdu3FQZ6Q/mz/tjUPHg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jerome Brunet <jbrunet@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.4 083/174] ASoC: fix valid stream condition
Date:   Thu, 16 Jan 2020 12:41:20 -0500
Message-Id: <20200116174251.24326-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 6a7c59c6d9f3b280e81d7a04bbe4e55e90152dce ]

A stream may specify a rate range using 'rate_min' and 'rate_max', so a
stream may be valid and not specify any rates. However, as stream cannot
be valid and not have any channel. Let's use this condition instead to
determine if a stream is valid or not.

Fixes: cde79035c6cf ("ASoC: Handle multiple codecs with split playback / capture")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 78813057167d..dbdea1975f90 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -48,8 +48,8 @@ static bool snd_soc_dai_stream_valid(struct snd_soc_dai *dai, int stream)
 	else
 		codec_stream = &dai->driver->capture;
 
-	/* If the codec specifies any rate at all, it supports the stream. */
-	return codec_stream->rates;
+	/* If the codec specifies any channels at all, it supports the stream */
+	return codec_stream->channels_min;
 }
 
 /**
-- 
2.20.1


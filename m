Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E18D2702F
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 22:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730277AbfEVTWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730236AbfEVTWE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:22:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 639192177E;
        Wed, 22 May 2019 19:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552924;
        bh=lppw/64HvmLohAJsfFdr+4OyInEgXNUiC5sG1y5G9CM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=shdWSWD1t35atpaaCAorEaH9DBCrOo/vTNVPLsbDYVX/NVli9mqvZyM9UARVGmSZs
         Jn0mkYU5a9TQkkiqudwit3GgWyn+cSfpWlg6g/775a5ugkMlNA83joDxI33NKshP4X
         NEn7rCCCHeku3U2sHgWlSqTH0d32A4cbkak78nrk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jerome Brunet <jbrunet@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 032/375] ASoC: hdmi-codec: unlock the device on startup errors
Date:   Wed, 22 May 2019 15:15:32 -0400
Message-Id: <20190522192115.22666-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 30180e8436046344b12813dc954b2e01dfdcd22d ]

If the hdmi codec startup fails, it should clear the current_substream
pointer to free the device. This is properly done for the audio_startup()
callback but for snd_pcm_hw_constraint_eld().

Make sure the pointer cleared if an error is reported.

Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdmi-codec.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/hdmi-codec.c b/sound/soc/codecs/hdmi-codec.c
index 35df73e42cbc5..fb2f0ac1f16f3 100644
--- a/sound/soc/codecs/hdmi-codec.c
+++ b/sound/soc/codecs/hdmi-codec.c
@@ -439,8 +439,12 @@ static int hdmi_codec_startup(struct snd_pcm_substream *substream,
 		if (!ret) {
 			ret = snd_pcm_hw_constraint_eld(substream->runtime,
 							hcp->eld);
-			if (ret)
+			if (ret) {
+				mutex_lock(&hcp->current_stream_lock);
+				hcp->current_stream = NULL;
+				mutex_unlock(&hcp->current_stream_lock);
 				return ret;
+			}
 		}
 		/* Select chmap supported */
 		hdmi_codec_eld_chmap(hcp);
-- 
2.20.1


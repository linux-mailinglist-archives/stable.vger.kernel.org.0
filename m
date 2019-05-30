Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 658512EE6C
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732255AbfE3DrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:47:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732249AbfE3DUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:20:34 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A901124943;
        Thu, 30 May 2019 03:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186433;
        bh=/pDqDNEd+ZchBPS5nftXJWLhONyWci4VjpyUw20lDR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jnqRSaCuc0TYY7BpLQMdatXaij8yCnwCFsZdzCEiADtTWMFFhhJT/1B0/lUv7h+Ka
         pKu9e4wryMCYWHMWJKh4bcwju+wOmdCse/uRooQ23bVue9ecxmJ+wVHCXAAkbuwCI7
         sY2Ld8cHusU1flbt6OXP8AhbEnILkhm4Stof2pNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 028/128] ASoC: hdmi-codec: unlock the device on startup errors
Date:   Wed, 29 May 2019 20:06:00 -0700
Message-Id: <20190530030439.734601548@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 90b5948e0ff36..cba5b5a29da0f 100644
--- a/sound/soc/codecs/hdmi-codec.c
+++ b/sound/soc/codecs/hdmi-codec.c
@@ -137,8 +137,12 @@ static int hdmi_codec_startup(struct snd_pcm_substream *substream,
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
 	}
 	return 0;
-- 
2.20.1




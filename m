Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67C5A101719
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730714AbfKSFrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:47:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:43888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728376AbfKSFra (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:47:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BB512071B;
        Tue, 19 Nov 2019 05:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142449;
        bh=TH9xCLF2rAa8rVklfhnNV7Qx4tBI5zCAyNdwfNZCEoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1ohZ2sN7nKo5fRyCp02VA8yGDzo8n0+cKPEgu5i72YENupWxpMVPHWT8TWBnYnFS
         4psEaMi98MdjkbD9RthX1tnA6Mh2KilRYDKnz4n1wYgv5vZR30fAfdygJljv03q258
         OPyMPsCAxP2gzEohwfRWkqJ1LrxNVJFpGF0LQiCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 045/239] ASoC: dpcm: Properly initialise hw->rate_max
Date:   Tue, 19 Nov 2019 06:17:25 +0100
Message-Id: <20191119051306.454651087@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit e33ffbd9cd39da09831ce62c11025d830bf78d9e ]

If the CPU DAI does not initialise rate_max, say if using
using KNOT or CONTINUOUS, then the rate_max field will be
initialised to 0. A value of zero in the rate_max field of
the hardware runtime will cause the sound card to support no
sample rates at all. Obviously this is not desired, just a
different mechanism is being used to apply the constraints. As
such update the setting of rate_max in dpcm_init_runtime_hw
to be consistent with the non-DPCM cases and set rate_max to
UINT_MAX if nothing is defined on the CPU DAI.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 052b6294a4283..24047375c2fbb 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1578,7 +1578,7 @@ static void dpcm_init_runtime_hw(struct snd_pcm_runtime *runtime,
 				 u64 formats)
 {
 	runtime->hw.rate_min = stream->rate_min;
-	runtime->hw.rate_max = stream->rate_max;
+	runtime->hw.rate_max = min_not_zero(stream->rate_max, UINT_MAX);
 	runtime->hw.channels_min = stream->channels_min;
 	runtime->hw.channels_max = stream->channels_max;
 	if (runtime->hw.formats)
-- 
2.20.1




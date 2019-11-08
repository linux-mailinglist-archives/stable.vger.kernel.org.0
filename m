Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66C34F4830
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387856AbfKHLzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:55:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:33514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391239AbfKHLqC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:46:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0F74222D4;
        Fri,  8 Nov 2019 11:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213561;
        bh=UcVJUPglSscPWgOYcHOUcXLNRDwLqyUnDRJRi2uan6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNQSCeeKEX6dKP5nWSQzIADxL2WA5IDNpD4DRYPKL+oBiz33ByGhVhQDWVabTNPTy
         bvP8hVYk0tpktPInpZ0wdjgv+QUEs3n9YFv/YpUgbkdm+sRF6c4Y+H5/6CJPMyTGnp
         G3Zhov5mp7nPwiTbB/hy+94NKZAFhYm9FzqkXi5s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 10/64] ASoC: dpcm: Properly initialise hw->rate_max
Date:   Fri,  8 Nov 2019 06:44:51 -0500
Message-Id: <20191108114545.15351-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114545.15351-1-sashal@kernel.org>
References: <20191108114545.15351-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 1d00f6e894ef4..d69559e458725 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1592,7 +1592,7 @@ static void dpcm_init_runtime_hw(struct snd_pcm_runtime *runtime,
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


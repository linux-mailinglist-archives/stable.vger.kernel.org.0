Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D33F62448
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388829AbfGHP02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:26:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388826AbfGHP02 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:26:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C50B2173C;
        Mon,  8 Jul 2019 15:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599587;
        bh=RXW4x+JMX0CQ0VlOOp/cWR/laxZudA1NraqDdzYXvK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U9Vcyn4C9lyA2Lfe2u9cHwH73gMDZAET7XyAMSiUQd1fmQcDwRvyItm6U9rgxEPus
         M182yOIo1PZCfFtcVKCTjLKi0kJI/SK3PgkWvq+BJIic5afUy4MM+vZ8tgg4asCDYS
         7COUNgFpIpiHb1Yv7175wsEKo7vKwle0o5VmXfek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Libin Yang <libin.yang@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/90] ASoC: soc-pcm: BE dai needs prepare when pause release after resume
Date:   Mon,  8 Jul 2019 17:12:37 +0200
Message-Id: <20190708150523.116501865@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5087a8f17df868601cd7568299e91c28086d2b45 ]

If playback/capture is paused and system enters S3, after system returns
from suspend, BE dai needs to call prepare() callback when playback/capture
is released from pause if RESUME_INFO flag is not set.

Currently, the dpcm_be_dai_prepare() function will block calling prepare()
if the pcm is in SND_SOC_DPCM_STATE_PAUSED state. This will cause the
following test case fail if the pcm uses BE:

playback -> pause -> S3 suspend -> S3 resume -> pause release

The playback may exit abnormally when pause is released because the BE dai
prepare() is not called.

This patch allows dpcm_be_dai_prepare() to call dai prepare() callback in
SND_SOC_DPCM_STATE_PAUSED state.

Signed-off-by: Libin Yang <libin.yang@intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 33060af18b5a..6566c8831a96 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -2451,7 +2451,8 @@ int dpcm_be_dai_prepare(struct snd_soc_pcm_runtime *fe, int stream)
 
 		if ((be->dpcm[stream].state != SND_SOC_DPCM_STATE_HW_PARAMS) &&
 		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_STOP) &&
-		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_SUSPEND))
+		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_SUSPEND) &&
+		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_PAUSED))
 			continue;
 
 		dev_dbg(be->dev, "ASoC: prepare BE %s\n",
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D252063B0
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390173AbgFWUb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:31:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388271AbgFWUbW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:31:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FD292064B;
        Tue, 23 Jun 2020 20:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944282;
        bh=mzXSjF9PmHePhcMtqcmwxBJma7XPfGGrCd/HZ0E53R8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iET5mRBSvSfhW0CsZnadkeGUG/EVUUwc4pIVhXNyyRqn0qnleKEk3S50bcQ0bQEB+
         YR1wB6khXQTqFDBX7YP3ZuJRcN9VrXHcHspF0VHLeU+JZ/aAfVSr5wzmR3N9ORewgf
         VZ7BTP6eSmLb6QRH5kZc6TEAevARNiQ3oRuslDtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Daniel Baluta <daniel.baluta@gmail.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 244/314] ASoC: SOF: nocodec: conditionally set dpcm_capture/dpcm_playback flags
Date:   Tue, 23 Jun 2020 21:57:19 +0200
Message-Id: <20200623195350.584956802@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit ba4e5abc6c4e173af7c941c03c067263b686665d ]

With additional checks on dailinks, we see errors such as

[ 3.000418] sof-nocodec sof-nocodec: CPU DAI DMIC01 Pin for rtd
NoCodec-6 does not support playback

It's not clear why we set the dpcm_playback and dpcm_capture flags
unconditionally, add a check on number of channels for each direction
to avoid invalid configurations.

Fixes: 8017b8fd37bf5e ('ASoC: SOF: Add Nocodec machine driver support')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Daniel Baluta <daniel.baluta@gmail.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20200608194415.4663-5-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/nocodec.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/nocodec.c b/sound/soc/sof/nocodec.c
index 3d128e5a132c0..ea0fe9a09f3f5 100644
--- a/sound/soc/sof/nocodec.c
+++ b/sound/soc/sof/nocodec.c
@@ -52,8 +52,10 @@ static int sof_nocodec_bes_setup(struct device *dev,
 		links[i].platforms->name = dev_name(dev);
 		links[i].codecs->dai_name = "snd-soc-dummy-dai";
 		links[i].codecs->name = "snd-soc-dummy";
-		links[i].dpcm_playback = 1;
-		links[i].dpcm_capture = 1;
+		if (ops->drv[i].playback.channels_min)
+			links[i].dpcm_playback = 1;
+		if (ops->drv[i].capture.channels_min)
+			links[i].dpcm_capture = 1;
 	}
 
 	card->dai_link = links;
-- 
2.25.1




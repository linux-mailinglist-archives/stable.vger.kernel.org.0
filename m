Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075D43C4F9E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243859AbhGLH0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:26:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345089AbhGLHYw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:24:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF8076112D;
        Mon, 12 Jul 2021 07:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074510;
        bh=FcoA/rpXFQqGVm2CKUVo4beaIA44KbbY/dfV7nSVcd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ftwO5leWGWLQoR6ow9tuCKnyaz/dDsJixicq6FL5wbTMLGjlth2thx4ORazNM73pH
         o0ItcNfWNW9CR7vXkfiaShQr0OMERutcBHy88aO2f8JiPaQmUyyz5kpq9haLh+UIs5
         yHdVH06bP4AXA4sKSzRnH7IiWO7kqrZPeGExGIjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 604/700] ASoC: rt5682-sdw: set regcache_cache_only false before reading RT5682_DEVICE_ID
Date:   Mon, 12 Jul 2021 08:11:27 +0200
Message-Id: <20210712061040.165551519@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit c0372bc873dd29f325ee908351e0bd5b08d4d608 ]

RT5682_DEVICE_ID is a volatile register, we can not read it in cache
only mode.

Fixes: 03f6fc6de919 ("ASoC: rt5682: Add the soundwire support")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210607222239.582139-14-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682-sdw.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/rt5682-sdw.c b/sound/soc/codecs/rt5682-sdw.c
index 2b0f02e6c977..b4649b599eaa 100644
--- a/sound/soc/codecs/rt5682-sdw.c
+++ b/sound/soc/codecs/rt5682-sdw.c
@@ -400,6 +400,11 @@ static int rt5682_io_init(struct device *dev, struct sdw_slave *slave)
 
 	pm_runtime_get_noresume(&slave->dev);
 
+	if (rt5682->first_hw_init) {
+		regcache_cache_only(rt5682->regmap, false);
+		regcache_cache_bypass(rt5682->regmap, true);
+	}
+
 	while (loop > 0) {
 		regmap_read(rt5682->regmap, RT5682_DEVICE_ID, &val);
 		if (val == DEVICE_ID)
@@ -415,11 +420,6 @@ static int rt5682_io_init(struct device *dev, struct sdw_slave *slave)
 		goto err_nodev;
 	}
 
-	if (rt5682->first_hw_init) {
-		regcache_cache_only(rt5682->regmap, false);
-		regcache_cache_bypass(rt5682->regmap, true);
-	}
-
 	rt5682_calibrate(rt5682);
 
 	if (rt5682->first_hw_init) {
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAFAB3C5568
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355675AbhGLIKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:10:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353627AbhGLICi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87E8F61CEF;
        Mon, 12 Jul 2021 07:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076564;
        bh=dFYZ40fLAP93EqZ/Dx4nY9108HnGjYbbeC1MUrT/pYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vVXB04OJLLovd2Ypsf2LvQzC5nZvWkWqCVI9aOd3bIkFpmeEIm4Bb3VwA/UNrAR1f
         xgCAEFCK7kJ/FlnMgS2Q5pR/C2Qs3UECVxDeWtogBNCTGpMlElD+JbqEFPmlZm/Ixp
         3eWYi8I6KsRwLMwqvHgsLHFN6QqZscUTYUS79Zz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 695/800] ASoC: rt5682-sdw: set regcache_cache_only false before reading RT5682_DEVICE_ID
Date:   Mon, 12 Jul 2021 08:11:58 +0200
Message-Id: <20210712061040.797755370@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 529a85fd0a00..54873730bec5 100644
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




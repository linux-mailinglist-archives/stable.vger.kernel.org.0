Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6A13C557A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhGLIKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353643AbhGLICo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3380D61CCE;
        Mon, 12 Jul 2021 07:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076568;
        bh=c75eVZSMK8ISgDmgdG7ItnyPfjjAK298Sg+4ZtEcFfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QXHMSGsf4sAt7kzaKw3c7dHPrwC3iSVp8mbW7e7SJ5sRRWxrlQgax21Wx96syKyLx
         lJjwTuWL1h0wmasryKa7b3cGaoLE9QuH47l1Xfdcm1D3Zx3Hik30STWG0b7pu7vsYQ
         G0rMHXSzq62TQ3YNF8b+GlzmZHKFy4CD1RoNNuVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 697/800] ASoC: rt711-sdca: handle mbq_regmap in rt711_sdca_io_init
Date:   Mon, 12 Jul 2021 08:12:00 +0200
Message-Id: <20210712061040.994366117@linuxfoundation.org>
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

[ Upstream commit bcc0f0c078771e983a7e602eb14efa02f811445f ]

We currently only hangle rt711->regmap in rt711_sdca_io_init(), and
rt711->mbq_regmap is missing.

Fixes: 7ad4d237e7c4a ('ASoC: rt711-sdca: Add RT711 SDCA vendor-specific driver')
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210607222239.582139-16-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711-sdca.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/codecs/rt711-sdca.c b/sound/soc/codecs/rt711-sdca.c
index 24a084e0b48a..0b0c230dcf71 100644
--- a/sound/soc/codecs/rt711-sdca.c
+++ b/sound/soc/codecs/rt711-sdca.c
@@ -1500,6 +1500,8 @@ int rt711_sdca_io_init(struct device *dev, struct sdw_slave *slave)
 	if (rt711->first_hw_init) {
 		regcache_cache_only(rt711->regmap, false);
 		regcache_cache_bypass(rt711->regmap, true);
+		regcache_cache_only(rt711->mbq_regmap, false);
+		regcache_cache_bypass(rt711->mbq_regmap, true);
 	} else {
 		/*
 		 * PM runtime is only enabled when a Slave reports as Attached
@@ -1565,6 +1567,8 @@ int rt711_sdca_io_init(struct device *dev, struct sdw_slave *slave)
 	if (rt711->first_hw_init) {
 		regcache_cache_bypass(rt711->regmap, false);
 		regcache_mark_dirty(rt711->regmap);
+		regcache_cache_bypass(rt711->mbq_regmap, false);
+		regcache_mark_dirty(rt711->mbq_regmap);
 	} else
 		rt711->first_hw_init = true;
 
-- 
2.30.2




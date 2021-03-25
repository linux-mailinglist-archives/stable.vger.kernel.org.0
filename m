Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07DA348F7A
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhCYL1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:27:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231191AbhCYL0g (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:26:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9542D61A4C;
        Thu, 25 Mar 2021 11:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671596;
        bh=hJa9rp58N7aJ9sXcF03LBQrA2SL2PMMMoOZRU6f7NBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uupFCp9iwpwXqtHsXIzvO9zAllLBsr4WOXfFtL7XsjWqZZJxaZkj4DgSmMMgCrGV4
         ghPkfs9gLHkdgWRHfYNJwzyEs/vzoIc9VM1dmpQuSyJ4lDwFa5pBcZK6rXt8UQo3MU
         BuBadmQRleyaQsgc23yA1SZeF9jRGAH8h3NspX2jjYcpynaPj0SAOY+EqpvLvwoGoC
         QMjjJIAj+2aLBmv89lxzIwz4XS5JzcSV1p0suJIkYC/oKiYLYgARQ8At7JOUApVwuQ
         9yadmrsunkixEwJn6y3N0BKA0va5nGi+i+qICBvMoTRGbQi1CvSdvsT5xyBX/tSMNJ
         +v4PXzKMZSTrQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sameer Pujar <spujar@nvidia.com>, Mark Brown <broonie@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 28/39] ASoC: rt5659: Update MCLK rate in set_sysclk()
Date:   Thu, 25 Mar 2021 07:25:47 -0400
Message-Id: <20210325112558.1927423-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112558.1927423-1-sashal@kernel.org>
References: <20210325112558.1927423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameer Pujar <spujar@nvidia.com>

[ Upstream commit dbf54a9534350d6aebbb34f5c1c606b81a4f35dd ]

Simple-card/audio-graph-card drivers do not handle MCLK clock when it
is specified in the codec device node. The expectation here is that,
the codec should actually own up the MCLK clock and do necessary setup
in the driver.

Suggested-by: Mark Brown <broonie@kernel.org>
Suggested-by: Michael Walle <michael@walle.cc>
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Link: https://lore.kernel.org/r/1615829492-8972-3-git-send-email-spujar@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5659.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/codecs/rt5659.c b/sound/soc/codecs/rt5659.c
index 41e5917b16a5..91a4ef7f620c 100644
--- a/sound/soc/codecs/rt5659.c
+++ b/sound/soc/codecs/rt5659.c
@@ -3426,12 +3426,17 @@ static int rt5659_set_component_sysclk(struct snd_soc_component *component, int
 {
 	struct rt5659_priv *rt5659 = snd_soc_component_get_drvdata(component);
 	unsigned int reg_val = 0;
+	int ret;
 
 	if (freq == rt5659->sysclk && clk_id == rt5659->sysclk_src)
 		return 0;
 
 	switch (clk_id) {
 	case RT5659_SCLK_S_MCLK:
+		ret = clk_set_rate(rt5659->mclk, freq);
+		if (ret)
+			return ret;
+
 		reg_val |= RT5659_SCLK_SRC_MCLK;
 		break;
 	case RT5659_SCLK_S_PLL1:
-- 
2.30.1


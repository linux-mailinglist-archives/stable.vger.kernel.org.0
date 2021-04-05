Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC825353F94
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239358AbhDEJNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:13:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239349AbhDEJNC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:13:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F55E6139D;
        Mon,  5 Apr 2021 09:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613971;
        bh=hJa9rp58N7aJ9sXcF03LBQrA2SL2PMMMoOZRU6f7NBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uv5Jdu5dbaQlsctiLI88ESbrnzvnH7TC/exRo/8YEoKrsqIaHoPSMM43OyJWXyg3l
         Vn/4aq4yWZ4MLjm+GNTMz91sKg9X8osqFYrg1mlCGdkzn4dHHxoqP5nXxEi9wD22Do
         BHCPILxBiPF8igbCIkJYOIXISJ7RFhJGoYXalYds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Sameer Pujar <spujar@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 028/152] ASoC: rt5659: Update MCLK rate in set_sysclk()
Date:   Mon,  5 Apr 2021 10:52:57 +0200
Message-Id: <20210405085035.163011257@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




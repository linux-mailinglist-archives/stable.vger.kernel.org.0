Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38136119D26
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbfLJWeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:34:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:55756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730258AbfLJWeX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:34:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 040EB208C3;
        Tue, 10 Dec 2019 22:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017262;
        bh=OogEJvpxW3riCL+s3n2+MjLSanOC0jBMKeUmyIoWezg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VLEV48KzEYeg/0zGoqgk1xWmJfo03tsJaPwuIzGzCpAhlFka5v+fcwVaC6PkAELDH
         6N7jc+D4Z8P5Lmfa9BCeelzDSnp3NJs9SJz4IpSZpRRwBekOubZ3lf6/hXYZuyNsjp
         EWFIIG5spPxp4BcSpi7q/+EUvb0T1afcJAz/skCo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Zhang <benzh@chromium.org>,
        Curtis Malainey <cujomalainey@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.4 56/71] ASoC: rt5677: Mark reg RT5677_PWR_ANLG2 as volatile
Date:   Tue, 10 Dec 2019 17:33:01 -0500
Message-Id: <20191210223316.14988-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210223316.14988-1-sashal@kernel.org>
References: <20191210223316.14988-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Zhang <benzh@chromium.org>

[ Upstream commit eabf424f7b60246c76dcb0ea6f1e83ef9abbeaa6 ]

The codec dies when RT5677_PWR_ANLG2(MX-64h) is set to 0xACE1
while it's streaming audio over SPI. The DSP firmware turns
on PLL2 (MX-64 bit 8) when SPI streaming starts.  However regmap
does not believe that register can change by itself. When
BST1 (bit 15) is turned on with regmap_update_bits(), it doesn't
read the register first before write, so PLL2 power bit is
cleared by accident.

Marking MX-64h as volatile in regmap solved the issue.

Signed-off-by: Ben Zhang <benzh@chromium.org>
Signed-off-by: Curtis Malainey <cujomalainey@chromium.org>
Link: https://lore.kernel.org/r/20191106011335.223061-6-cujomalainey@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5677.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/rt5677.c b/sound/soc/codecs/rt5677.c
index 69d987a9935c9..90f8173123f6c 100644
--- a/sound/soc/codecs/rt5677.c
+++ b/sound/soc/codecs/rt5677.c
@@ -295,6 +295,7 @@ static bool rt5677_volatile_register(struct device *dev, unsigned int reg)
 	case RT5677_I2C_MASTER_CTRL7:
 	case RT5677_I2C_MASTER_CTRL8:
 	case RT5677_HAP_GENE_CTRL2:
+	case RT5677_PWR_ANLG2: /* Modified by DSP firmware */
 	case RT5677_PWR_DSP_ST:
 	case RT5677_PRIV_DATA:
 	case RT5677_PLL1_CTRL2:
-- 
2.20.1


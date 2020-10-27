Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D302729B4B8
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1766449AbgJ0PA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1788707AbgJ0PAc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:00:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50BD622264;
        Tue, 27 Oct 2020 15:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810831;
        bh=XI/PGtV0g0DQ1gOTZuh8r193FjOwkN/55NTCqAc7kB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NCC55EjwxSu1qiGK2DWGAp4OQCUO8D9eZLkvZGDJiWbljc7mGSwrY18owKqntPeYf
         7fSF1zcsd7VTEPqVO9PImKK5VJkpyTW7o5/BUtYSvwlSBo0U7gulSuiKJvPNusJpQf
         AZte+qUmwIUcYlYXDcHADUB3IuCLLhABWXIseBVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 247/633] ASoC: tas2770: Add missing bias level power states
Date:   Tue, 27 Oct 2020 14:49:50 +0100
Message-Id: <20201027135534.265361809@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>

[ Upstream commit 4272caf34aa4699eca8e6e7f4a8e5ea2bde275c9 ]

Add the BIAS_STANDBY and BIAS_PREPARE to the set_bias_level or else the
driver will return -EINVAL which is not correct as they are valid
states.

Fixes: 1a476abc723e6 ("tas2770: add tas2770 smart PA kernel driver")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
Link: https://lore.kernel.org/r/20200918190548.12598-2-dmurphy@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2770.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index 9f759c51ca435..4d67b1c160380 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -57,7 +57,12 @@ static int tas2770_set_bias_level(struct snd_soc_component *component,
 			TAS2770_PWR_CTRL_MASK,
 			TAS2770_PWR_CTRL_ACTIVE);
 		break;
-
+	case SND_SOC_BIAS_STANDBY:
+	case SND_SOC_BIAS_PREPARE:
+		snd_soc_component_update_bits(component,
+			TAS2770_PWR_CTRL,
+			TAS2770_PWR_CTRL_MASK, TAS2770_PWR_CTRL_MUTE);
+		break;
 	case SND_SOC_BIAS_OFF:
 		snd_soc_component_update_bits(component,
 			TAS2770_PWR_CTRL,
-- 
2.25.1




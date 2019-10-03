Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0F8BCA4A6
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391139AbfJCQ0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:26:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391162AbfJCQ0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:26:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 549F32133F;
        Thu,  3 Oct 2019 16:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120014;
        bh=csEuR0I3jvQUqVfdCrUe0yTO9jh+m3SBF9finvCv31s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HmYrFFXUuLhsIv1PRX0H4EGnUQk/8CR4KeBLc/mFECXEqEn6YYDtab/W2Iiiki5hW
         22Egt40nM85ePItcY/MjyA+J35kyNbFLrAOiKlcwFbO3mhLdpruvDRel1FlOyEd6hn
         NvZQ82J0GCsuoIILYbmV3WaWakpGHi9nvhnH76Is=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        "Andrew F. Davis" <afd@ti.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 038/313] ASoC: tlv320aic31xx: suppress error message for EPROBE_DEFER
Date:   Thu,  3 Oct 2019 17:50:16 +0200
Message-Id: <20191003154536.990503538@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit b7e814deae33eb30f8f8c6528e8e69b107978d88 ]

Both the supplies and reset GPIO might need a probe deferral for the
resource to be available. Don't print a error message in that case, as
it is a normal operating condition.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Acked-by: Andrew F. Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20190719143637.2018-1-l.stach@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320aic31xx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic31xx.c b/sound/soc/codecs/tlv320aic31xx.c
index 9b37e98da0db1..26a4f6cd32883 100644
--- a/sound/soc/codecs/tlv320aic31xx.c
+++ b/sound/soc/codecs/tlv320aic31xx.c
@@ -1553,7 +1553,8 @@ static int aic31xx_i2c_probe(struct i2c_client *i2c,
 	aic31xx->gpio_reset = devm_gpiod_get_optional(aic31xx->dev, "reset",
 						      GPIOD_OUT_LOW);
 	if (IS_ERR(aic31xx->gpio_reset)) {
-		dev_err(aic31xx->dev, "not able to acquire gpio\n");
+		if (PTR_ERR(aic31xx->gpio_reset) != -EPROBE_DEFER)
+			dev_err(aic31xx->dev, "not able to acquire gpio\n");
 		return PTR_ERR(aic31xx->gpio_reset);
 	}
 
@@ -1564,7 +1565,9 @@ static int aic31xx_i2c_probe(struct i2c_client *i2c,
 				      ARRAY_SIZE(aic31xx->supplies),
 				      aic31xx->supplies);
 	if (ret) {
-		dev_err(aic31xx->dev, "Failed to request supplies: %d\n", ret);
+		if (ret != -EPROBE_DEFER)
+			dev_err(aic31xx->dev,
+				"Failed to request supplies: %d\n", ret);
 		return ret;
 	}
 
-- 
2.20.1




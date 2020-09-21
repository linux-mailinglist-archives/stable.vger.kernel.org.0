Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343DB272F58
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbgIUQ4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:56:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729691AbgIUQoi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:44:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79FC923976;
        Mon, 21 Sep 2020 16:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706676;
        bh=uKhtbAHetKRl79hoPb4Phr9dqJLxsmRtCUHaohCZe5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/k+nixubTxpKMXXLBRSE/+BM8VtfkQ01jl05zYV7MajfLhJR7umK3UpuoyEGpCB7
         pRkisHNKKFaZSnAqImrkKOX22aOiINXdJWTyDnm+Xforga6h2Wqe119ho6wD9/5n+p
         UNcX84397D+BrgC9TDq7Y4tqoyhDqgjNwlyOnaNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Camel Guo <camel.guo@axis.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 049/118] ASoC: tlv320adcx140: Fix accessing uninitialized adcx140->dev
Date:   Mon, 21 Sep 2020 18:27:41 +0200
Message-Id: <20200921162038.597995010@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Camel Guo <camelg@axis.com>

[ Upstream commit 2569231d71dff82cfd6e82ab3871776f72ec53b6 ]

In adcx140_i2c_probe, adcx140->dev is accessed before its
initialization. This commit fixes this bug.

Fixes: 689c7655b50c ("ASoC: tlv320adcx140: Add the tlv320adcx140 codec driver family")
Acked-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Camel Guo <camel.guo@axis.com>
Link: https://lore.kernel.org/r/20200901135736.32036-1-camel.guo@axis.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320adcx140.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tlv320adcx140.c b/sound/soc/codecs/tlv320adcx140.c
index 35fe8ee5bce9f..03fb50175d876 100644
--- a/sound/soc/codecs/tlv320adcx140.c
+++ b/sound/soc/codecs/tlv320adcx140.c
@@ -930,6 +930,8 @@ static int adcx140_i2c_probe(struct i2c_client *i2c,
 	if (!adcx140)
 		return -ENOMEM;
 
+	adcx140->dev = &i2c->dev;
+
 	adcx140->gpio_reset = devm_gpiod_get_optional(adcx140->dev,
 						      "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(adcx140->gpio_reset))
@@ -957,7 +959,7 @@ static int adcx140_i2c_probe(struct i2c_client *i2c,
 			ret);
 		return ret;
 	}
-	adcx140->dev = &i2c->dev;
+
 	i2c_set_clientdata(i2c, adcx140);
 
 	return devm_snd_soc_register_component(&i2c->dev,
-- 
2.25.1




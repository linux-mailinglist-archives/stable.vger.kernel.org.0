Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF8729B816
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799422AbgJ0PbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:31:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799415AbgJ0PbX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:31:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BA9822265;
        Tue, 27 Oct 2020 15:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812683;
        bh=bmxus4vzJIiSBTz5zyWHaTrQV4eQ4CEr7Xdeg8N/Y4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6zuxFPMYVT1MugIxb81m9bhW9xvkRJwB2m5tbnXLAIX6tZJtQigPMHZuvYm1AoFU
         8IB5NSii2jZMIcfT0VZPbCzqGLd3dz/7sEsgDaOMjyCC0jp3DaHSPmWP4x1/pQNNWJ
         hc0q26DOf0kq4KoMeh6bZkZfo/vjPxA2sEifd/so=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 294/757] ASoC: tas2770: Fix required DT properties in the code
Date:   Tue, 27 Oct 2020 14:49:04 +0100
Message-Id: <20201027135504.354469949@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>

[ Upstream commit 4b8ab8a7761fe2ba1c4e741703a848cb8f390f79 ]

The devicetree binding indicates that the ti,asi-format, ti,imon-slot-no
and ti,vmon-slot-no are not required but the driver requires them or it
fails to probe. Honor the binding and allow these entries to be optional
and set the corresponding values to the default values for each as defined
in the data sheet.

Fixes: 1a476abc723e6 ("tas2770: add tas2770 smart PA kernel driver")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
Link: https://lore.kernel.org/r/20200918190548.12598-4-dmurphy@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2770.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index 7c6f61946ab39..bdfdad5f4f644 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -708,29 +708,28 @@ static int tas2770_parse_dt(struct device *dev, struct tas2770_priv *tas2770)
 	rc = fwnode_property_read_u32(dev->fwnode, "ti,asi-format",
 					&tas2770->asi_format);
 	if (rc) {
-		dev_err(tas2770->dev, "Looking up %s property failed %d\n",
-			"ti,asi-format", rc);
-		goto end;
+		dev_info(tas2770->dev, "Property %s is missing setting default slot\n",
+			"ti,asi-format");
+		tas2770->asi_format = 0;
 	}
 
 	rc = fwnode_property_read_u32(dev->fwnode, "ti,imon-slot-no",
 			&tas2770->i_sense_slot);
 	if (rc) {
-		dev_err(tas2770->dev, "Looking up %s property failed %d\n",
-			"ti,imon-slot-no", rc);
-		goto end;
+		dev_info(tas2770->dev, "Property %s is missing setting default slot\n",
+			"ti,imon-slot-no");
+		tas2770->i_sense_slot = 0;
 	}
 
 	rc = fwnode_property_read_u32(dev->fwnode, "ti,vmon-slot-no",
 				&tas2770->v_sense_slot);
 	if (rc) {
-		dev_err(tas2770->dev, "Looking up %s property failed %d\n",
-			"ti,vmon-slot-no", rc);
-		goto end;
+		dev_info(tas2770->dev, "Property %s is missing setting default slot\n",
+			"ti,vmon-slot-no");
+		tas2770->v_sense_slot = 2;
 	}
 
-end:
-	return rc;
+	return 0;
 }
 
 static int tas2770_i2c_probe(struct i2c_client *client,
-- 
2.25.1




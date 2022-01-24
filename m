Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C5049991B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454176AbiAXVbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:31:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40852 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378406AbiAXVRZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:17:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3FFE60C60;
        Mon, 24 Jan 2022 21:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88417C340E7;
        Mon, 24 Jan 2022 21:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059042;
        bh=KELrlWHcvTQuXSNFFxUFF1tW/4V0P2KYuGkbnaXmsdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aFYXdpydSY/eMO53hRtULDDnhWxoTyBPgLEuZPFDqGzS0aNl00FLLBMddrrF57bcb
         Yj+tNzhDxa43D63CGnrLs5HGO6dbi74whOa3hWBIs3o+jfGMgc7Ktf/11sAa1e3/Db
         X4ttRuA8yMXz6CTw1SBraA/tKDD0SQ2oYAriYKEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0486/1039] ASoC: rt5663: Handle device_property_read_u32_array error codes
Date:   Mon, 24 Jan 2022 19:37:55 +0100
Message-Id: <20220124184141.608319251@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 2167c0b205960607fb136b4bb3c556a62be1569a ]

The return value of device_property_read_u32_array() is not always 0.
To catch the exception in case that devm_kzalloc failed and the
rt5663->imp_table was NULL, which caused the failure of
device_property_read_u32_array.

Fixes: 450f0f6a8fb4 ("ASoC: rt5663: Add the manual offset field to compensate the DC offset")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20211215031550.70702-1-jiasheng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5663.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt5663.c b/sound/soc/codecs/rt5663.c
index 0389b2bb360e2..2138f62e6af5d 100644
--- a/sound/soc/codecs/rt5663.c
+++ b/sound/soc/codecs/rt5663.c
@@ -3461,6 +3461,7 @@ static void rt5663_calibrate(struct rt5663_priv *rt5663)
 static int rt5663_parse_dp(struct rt5663_priv *rt5663, struct device *dev)
 {
 	int table_size;
+	int ret;
 
 	device_property_read_u32(dev, "realtek,dc_offset_l_manual",
 		&rt5663->pdata.dc_offset_l_manual);
@@ -3477,9 +3478,11 @@ static int rt5663_parse_dp(struct rt5663_priv *rt5663, struct device *dev)
 		table_size = sizeof(struct impedance_mapping_table) *
 			rt5663->pdata.impedance_sensing_num;
 		rt5663->imp_table = devm_kzalloc(dev, table_size, GFP_KERNEL);
-		device_property_read_u32_array(dev,
+		ret = device_property_read_u32_array(dev,
 			"realtek,impedance_sensing_table",
 			(u32 *)rt5663->imp_table, table_size);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
@@ -3504,8 +3507,11 @@ static int rt5663_i2c_probe(struct i2c_client *i2c,
 
 	if (pdata)
 		rt5663->pdata = *pdata;
-	else
-		rt5663_parse_dp(rt5663, &i2c->dev);
+	else {
+		ret = rt5663_parse_dp(rt5663, &i2c->dev);
+		if (ret)
+			return ret;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(rt5663->supplies); i++)
 		rt5663->supplies[i].supply = rt5663_supply_names[i];
-- 
2.34.1




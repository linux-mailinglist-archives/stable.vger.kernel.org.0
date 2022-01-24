Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7844F498C6F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345967AbiAXTW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:22:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42540 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345805AbiAXTT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:19:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87007B8123F;
        Mon, 24 Jan 2022 19:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E0EC340E5;
        Mon, 24 Jan 2022 19:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051964;
        bh=iS+y03BfRF0LeTvWUGV0QoMfW2bryzaHTzsrUFwQqKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wj/s0s3BBdivZ9XZX35DB2RmMoWXJXqnwiDSFi+mbd52AhlH9R9vI3f5ktK9eTajg
         o3dqqveVXQ38l09ymNTNxLZVNleTO7Zm3JWknJcRMPKM/7UvexD6/V+N7++Y3ez6iI
         2fhtGGOFlF378Y4tG8FHKu5Sfs4s4bBoq27YlS0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 111/239] ASoC: rt5663: Handle device_property_read_u32_array error codes
Date:   Mon, 24 Jan 2022 19:42:29 +0100
Message-Id: <20220124183946.631656385@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
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
index 9bd24ad422407..dd77f131ce6c5 100644
--- a/sound/soc/codecs/rt5663.c
+++ b/sound/soc/codecs/rt5663.c
@@ -3446,6 +3446,7 @@ static void rt5663_calibrate(struct rt5663_priv *rt5663)
 static int rt5663_parse_dp(struct rt5663_priv *rt5663, struct device *dev)
 {
 	int table_size;
+	int ret;
 
 	device_property_read_u32(dev, "realtek,dc_offset_l_manual",
 		&rt5663->pdata.dc_offset_l_manual);
@@ -3462,9 +3463,11 @@ static int rt5663_parse_dp(struct rt5663_priv *rt5663, struct device *dev)
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
@@ -3489,8 +3492,11 @@ static int rt5663_i2c_probe(struct i2c_client *i2c,
 
 	if (pdata)
 		rt5663->pdata = *pdata;
-	else
-		rt5663_parse_dp(rt5663, &i2c->dev);
+	else {
+		ret = rt5663_parse_dp(rt5663, &i2c->dev);
+		if (ret)
+			return ret;
+	}
 
 	regmap = devm_regmap_init_i2c(i2c, &temp_regmap);
 	if (IS_ERR(regmap)) {
-- 
2.34.1




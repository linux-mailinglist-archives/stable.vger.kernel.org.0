Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D842B63AFD4
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbiK1RqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbiK1Rpe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:45:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8992CE21;
        Mon, 28 Nov 2022 09:41:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DED30B80E81;
        Mon, 28 Nov 2022 17:41:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C357DC433C1;
        Mon, 28 Nov 2022 17:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657270;
        bh=bU25Nii84+2iHsLAjyvDjHvd8R4uQjmsRD9iQBkNt8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4YL6y53Ub1LWd7orWo8f2yJRZuuFvSEHnkjNIwBPZG597JT9R4kRmICS+A+WPazQ
         DeTrESBshVh3akzNHQpY8oNbSUKVozKXeSg2t0Ij+B+c5MIKwpjkzc3x/+aSYOuIni
         3CsoEiCnfnRa5VnY/5WN/NhgJ7prm95jMpFMTv/AQmNaifTQRXt6TXyTrvXcImUEKs
         HLqi6qmoCIjLkTTB2aBLjYlWN2I4j0N+ivpcWI/MgVh5YtjULQDVV9Pu3Pnkjnpfbk
         biNbHUnj3Isc37M1M6Ad8YebJeoMXSh7zf5i4B94X1+3D256zoejpNcUD2z6d2pIg+
         aHiAuIpcrwsgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Kemnade <andreas@kemnade.info>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, tony@atomide.com,
        lgirdwood@gmail.com, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 20/24] regulator: twl6030: fix get status of twl6032 regulators
Date:   Mon, 28 Nov 2022 12:40:20 -0500
Message-Id: <20221128174027.1441921-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174027.1441921-1-sashal@kernel.org>
References: <20221128174027.1441921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit 31a6297b89aabc81b274c093a308a7f5b55081a7 ]

Status is reported as always off in the 6032 case. Status
reporting now matches the logic in the setters. Once of
the differences to the 6030 is that there are no groups,
therefore the state needs to be read out in the lower bits.

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://lore.kernel.org/r/20221120221208.3093727-3-andreas@kemnade.info
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/twl6030-regulator.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/twl6030-regulator.c b/drivers/regulator/twl6030-regulator.c
index 430265c404d6..7ee05556d783 100644
--- a/drivers/regulator/twl6030-regulator.c
+++ b/drivers/regulator/twl6030-regulator.c
@@ -67,6 +67,7 @@ struct twlreg_info {
 #define TWL6030_CFG_STATE_SLEEP	0x03
 #define TWL6030_CFG_STATE_GRP_SHIFT	5
 #define TWL6030_CFG_STATE_APP_SHIFT	2
+#define TWL6030_CFG_STATE_MASK		0x03
 #define TWL6030_CFG_STATE_APP_MASK	(0x03 << TWL6030_CFG_STATE_APP_SHIFT)
 #define TWL6030_CFG_STATE_APP(v)	(((v) & TWL6030_CFG_STATE_APP_MASK) >>\
 						TWL6030_CFG_STATE_APP_SHIFT)
@@ -128,13 +129,14 @@ static int twl6030reg_is_enabled(struct regulator_dev *rdev)
 		if (grp < 0)
 			return grp;
 		grp &= P1_GRP_6030;
+		val = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_STATE);
+		val = TWL6030_CFG_STATE_APP(val);
 	} else {
+		val = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_STATE);
+		val &= TWL6030_CFG_STATE_MASK;
 		grp = 1;
 	}
 
-	val = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_STATE);
-	val = TWL6030_CFG_STATE_APP(val);
-
 	return grp && (val == TWL6030_CFG_STATE_ON);
 }
 
@@ -187,7 +189,12 @@ static int twl6030reg_get_status(struct regulator_dev *rdev)
 
 	val = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_STATE);
 
-	switch (TWL6030_CFG_STATE_APP(val)) {
+	if (info->features & TWL6032_SUBCLASS)
+		val &= TWL6030_CFG_STATE_MASK;
+	else
+		val = TWL6030_CFG_STATE_APP(val);
+
+	switch (val) {
 	case TWL6030_CFG_STATE_ON:
 		return REGULATOR_STATUS_NORMAL;
 
-- 
2.35.1


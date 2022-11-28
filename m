Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 234D463B044
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbiK1RtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233963AbiK1Rrp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:47:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB3128E03;
        Mon, 28 Nov 2022 09:42:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F2506130A;
        Mon, 28 Nov 2022 17:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B23C433D7;
        Mon, 28 Nov 2022 17:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657375;
        bh=iQpQUVK5gX+soU2jK/6FjxFPztatRaqDKoWWz//s3zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CqxYxJBtCYPtlkclMFD621+qGiE9Ktt1mHbMLz+Y49WjqzCTH6A7Oi/dkiddlsUxQ
         Qj3w7B0hH9gp8bo3UUYHWmSnOIN5WuO5tRXrjm15FoMr9uCbSm0jyZw+s/hhefGOyT
         lHTLsi44pJb/oN451Er9KIlzOsWjUR1mAWUhE8LrpK5frm7GDgUO1Z9kIVkXEc8wI+
         rcwkX0DxZYp6A0ja7FTW2JSmVuBuq3VMuwTAOwCRDodrc6rmRL5vDVQCdtvtVv+poL
         zq6CgFjPanw3swO2U78EovUuTXs2CX54IVKnOzktHTNpzE9yM8jmW42ca6ZmnbFHvQ
         swXxsEd2vRfMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Kemnade <andreas@kemnade.info>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, tony@atomide.com,
        lgirdwood@gmail.com, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 09/12] regulator: twl6030: fix get status of twl6032 regulators
Date:   Mon, 28 Nov 2022 12:42:32 -0500
Message-Id: <20221128174235.1442841-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174235.1442841-1-sashal@kernel.org>
References: <20221128174235.1442841-1-sashal@kernel.org>
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
index 219cbd910dbf..485d25f683d8 100644
--- a/drivers/regulator/twl6030-regulator.c
+++ b/drivers/regulator/twl6030-regulator.c
@@ -71,6 +71,7 @@ struct twlreg_info {
 #define TWL6030_CFG_STATE_SLEEP	0x03
 #define TWL6030_CFG_STATE_GRP_SHIFT	5
 #define TWL6030_CFG_STATE_APP_SHIFT	2
+#define TWL6030_CFG_STATE_MASK		0x03
 #define TWL6030_CFG_STATE_APP_MASK	(0x03 << TWL6030_CFG_STATE_APP_SHIFT)
 #define TWL6030_CFG_STATE_APP(v)	(((v) & TWL6030_CFG_STATE_APP_MASK) >>\
 						TWL6030_CFG_STATE_APP_SHIFT)
@@ -131,13 +132,14 @@ static int twl6030reg_is_enabled(struct regulator_dev *rdev)
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
 
@@ -190,7 +192,12 @@ static int twl6030reg_get_status(struct regulator_dev *rdev)
 
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


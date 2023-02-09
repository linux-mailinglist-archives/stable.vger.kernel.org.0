Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA2A69075F
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbjBIL2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:28:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbjBIL1K (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:27:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80EA55A93D;
        Thu,  9 Feb 2023 03:20:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FB44619F6;
        Thu,  9 Feb 2023 11:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC23C4339B;
        Thu,  9 Feb 2023 11:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941602;
        bh=sbmjl7ztF6Ua+/t9QmN41jrbGtE5gH5IK6zXP5ztTGY=;
        h=From:To:Cc:Subject:Date:From;
        b=bq2hbDiGcyi0lZleFAJ+8vw8CaYQtt0RJbWipNQzj8Ovqbgwr5KrDBQAqEY0M6TIh
         rS3eAJl0PEaMVgTN/gi9MIqeNABWiDTHOA5mJCcKi77c4Pz6ANRFl0oOUUAK2EZebn
         aAwypSL6LChJet06GmP6t3793v/ZO5pCxwibeRwHdRLzymskbkVzGkt71c0CZfwpNk
         O/yrdR3eqkkjile8ldxAraM6IvWJ7B8d+iFTBwxK2MjbpP+HJdsITB927WdSeLaceN
         fCHEBcMm6YR0IosaMBlX0QPA2R6p5VUk0ZlUC382APYy9fs+wstVnaFECHfrvpPgHu
         GgnzqIe1agnAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, james.schulman@cirrus.com,
        david.rhodes@cirrus.com, tanureal@opensource.cirrus.com,
        rf@opensource.cirrus.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org,
        patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 4.19 1/6] ASoC: cs42l56: fix DT probe
Date:   Thu,  9 Feb 2023 06:19:54 -0500
Message-Id: <20230209111959.1893269-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit e18c6da62edc780e4f4f3c9ce07bdacd69505182 ]

While looking through legacy platform data users, I noticed that
the DT probing never uses data from the DT properties, as the
platform_data structure gets overwritten directly after it
is initialized.

There have never been any boards defining the platform_data in
the mainline kernel either, so this driver so far only worked
with patched kernels or with the default values.

For the benefit of possible downstream users, fix the DT probe
by no longer overwriting the data.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20230126162203.2986339-1-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l56.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/sound/soc/codecs/cs42l56.c b/sound/soc/codecs/cs42l56.c
index deaad703a7dbf..a4826a7d0a98c 100644
--- a/sound/soc/codecs/cs42l56.c
+++ b/sound/soc/codecs/cs42l56.c
@@ -1204,18 +1204,12 @@ static int cs42l56_i2c_probe(struct i2c_client *i2c_client,
 	if (pdata) {
 		cs42l56->pdata = *pdata;
 	} else {
-		pdata = devm_kzalloc(&i2c_client->dev, sizeof(*pdata),
-				     GFP_KERNEL);
-		if (!pdata)
-			return -ENOMEM;
-
 		if (i2c_client->dev.of_node) {
 			ret = cs42l56_handle_of_data(i2c_client,
 						     &cs42l56->pdata);
 			if (ret != 0)
 				return ret;
 		}
-		cs42l56->pdata = *pdata;
 	}
 
 	if (cs42l56->pdata.gpio_nreset) {
-- 
2.39.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194095107E9
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353385AbiDZTFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351872AbiDZTFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:05:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38215199168;
        Tue, 26 Apr 2022 12:02:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B98CFB8224A;
        Tue, 26 Apr 2022 19:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64AA5C385C3;
        Tue, 26 Apr 2022 19:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999720;
        bh=fl/SlIFa21XcUiuyoHk/hrTxohmhSV+w9p9Ll/WaPjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AhVp68IdmPZMMNbrsRIyz74xyLu7820rj2nWY5EpnXBAsUky9DumGMw+C7L+RFpBs
         pgIAeHhR0XSpkaw6j3aNuZUjAiqaS/p/VHBEvSqbCW+ISuu7qKdjU/qQoRU070Jm75
         gaeJCyXQxgKzEp8WQC2hQPKCBnYpFF601luHPDbL/ASaVtntOwz3Hgd4bb43+e7XW9
         XIx0Z+aJoPVQD6IphISS5m25W+vu22oAUUEFBNuu9FHYWHVSy5/kl32pPuNxLXFrAG
         99C8wB5uGWCl2eaor9pO5kZnzURSt0FqX95URXELFD3oxdTQMo/e+wPcxV9CUJ9OXL
         z2mLa0Af50/nw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, y.oudjana@protonmail.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 07/22] Input: cypress-sf - register a callback to disable the regulators
Date:   Tue, 26 Apr 2022 15:01:30 -0400
Message-Id: <20220426190145.2351135-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190145.2351135-1-sashal@kernel.org>
References: <20220426190145.2351135-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit fd0a4b39870d49ff15f6966470185409e261f20f ]

When the driver fails to probe, we will get the following splat:

[   19.311970] ------------[ cut here ]------------
[   19.312566] WARNING: CPU: 3 PID: 375 at drivers/regulator/core.c:2257 _regulator_put+0x3ec/0x4e0
[   19.317591] RIP: 0010:_regulator_put+0x3ec/0x4e0
[   19.328831] Call Trace:
[   19.329112]  <TASK>
[   19.329369]  regulator_bulk_free+0x82/0xe0
[   19.329860]  devres_release_group+0x319/0x3d0
[   19.330357]  i2c_device_probe+0x766/0x940

Fix this by adding a callback that will deal with the disabling when the
driver fails to probe.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Link: https://lore.kernel.org/r/20220409022629.3493557-1-zheyuma97@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/cypress-sf.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/input/keyboard/cypress-sf.c b/drivers/input/keyboard/cypress-sf.c
index c28996028e80..9a23eed6a4f4 100644
--- a/drivers/input/keyboard/cypress-sf.c
+++ b/drivers/input/keyboard/cypress-sf.c
@@ -61,6 +61,14 @@ static irqreturn_t cypress_sf_irq_handler(int irq, void *devid)
 	return IRQ_HANDLED;
 }
 
+static void cypress_sf_disable_regulators(void *arg)
+{
+	struct cypress_sf_data *touchkey = arg;
+
+	regulator_bulk_disable(ARRAY_SIZE(touchkey->regulators),
+			       touchkey->regulators);
+}
+
 static int cypress_sf_probe(struct i2c_client *client)
 {
 	struct cypress_sf_data *touchkey;
@@ -121,6 +129,12 @@ static int cypress_sf_probe(struct i2c_client *client)
 		return error;
 	}
 
+	error = devm_add_action_or_reset(&client->dev,
+					 cypress_sf_disable_regulators,
+					 touchkey);
+	if (error)
+		return error;
+
 	touchkey->input_dev = devm_input_allocate_device(&client->dev);
 	if (!touchkey->input_dev) {
 		dev_err(&client->dev, "Failed to allocate input device\n");
-- 
2.35.1


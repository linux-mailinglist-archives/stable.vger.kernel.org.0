Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279C866C970
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbjAPQtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233882AbjAPQta (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:49:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3EDF30B3D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:36:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 589C261083
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F631C43398;
        Mon, 16 Jan 2023 16:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886976;
        bh=ZBgmSonHaystLGqZqpBv2/aGMLxWjNm4HbPNmNJa6Ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KA6PRsPTPV3qXSQ35EYfFX7HKG2jhIF2+B9f1k45ZZuKhuv4dm1D0EccBs1HfZf25
         2Bo9MemJmr3Jyg9oFnBBOy2C6eqbcCrVfB7GdqIQAnfuXOij30RzqOVpoaDiJRLKNI
         rs2o3RzeU09ZPh2q2etRjeefE4HK3ORG9gfMPCr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ricardo Ribalda <ribalda@chromium.org>,
        Adam Ward <DLG-Adam.Ward.opensource@dm.renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 633/658] regulator: da9211: Use irq handler when ready
Date:   Mon, 16 Jan 2023 16:52:01 +0100
Message-Id: <20230116154938.446284480@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 02228f6aa6a64d588bc31e3267d05ff184d772eb ]

If the system does not come from reset (like when it is kexec()), the
regulator might have an IRQ waiting for us.

If we enable the IRQ handler before its structures are ready, we crash.

This patch fixes:

[    1.141839] Unable to handle kernel read from unreadable memory at virtual address 0000000000000078
[    1.316096] Call trace:
[    1.316101]  blocking_notifier_call_chain+0x20/0xa8
[    1.322757] cpu cpu0: dummy supplies not allowed for exclusive requests
[    1.327823]  regulator_notifier_call_chain+0x1c/0x2c
[    1.327825]  da9211_irq_handler+0x68/0xf8
[    1.327829]  irq_thread+0x11c/0x234
[    1.327833]  kthread+0x13c/0x154

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Adam Ward <DLG-Adam.Ward.opensource@dm.renesas.com>
Link: https://lore.kernel.org/r/20221124-da9211-v2-0-1779e3c5d491@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/da9211-regulator.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/da9211-regulator.c b/drivers/regulator/da9211-regulator.c
index bf80748f1ccc..7baa6121cc66 100644
--- a/drivers/regulator/da9211-regulator.c
+++ b/drivers/regulator/da9211-regulator.c
@@ -471,6 +471,12 @@ static int da9211_i2c_probe(struct i2c_client *i2c,
 
 	chip->chip_irq = i2c->irq;
 
+	ret = da9211_regulator_init(chip);
+	if (ret < 0) {
+		dev_err(chip->dev, "Failed to initialize regulator: %d\n", ret);
+		return ret;
+	}
+
 	if (chip->chip_irq != 0) {
 		ret = devm_request_threaded_irq(chip->dev, chip->chip_irq, NULL,
 					da9211_irq_handler,
@@ -485,11 +491,6 @@ static int da9211_i2c_probe(struct i2c_client *i2c,
 		dev_warn(chip->dev, "No IRQ configured\n");
 	}
 
-	ret = da9211_regulator_init(chip);
-
-	if (ret < 0)
-		dev_err(chip->dev, "Failed to initialize regulator: %d\n", ret);
-
 	return ret;
 }
 
-- 
2.35.1




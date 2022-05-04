Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F5A51A9E8
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357868AbiEDRUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357202AbiEDROz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:14:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C2F54695;
        Wed,  4 May 2022 09:58:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03461B827A3;
        Wed,  4 May 2022 16:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACCCC385A4;
        Wed,  4 May 2022 16:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683488;
        bh=fl/SlIFa21XcUiuyoHk/hrTxohmhSV+w9p9Ll/WaPjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w+K6ksNO9lWs1rsQYL+PuR3I+s4ppijYuj4EgSzvWcRcMeFh3IE9OSMFFJRbGvIzu
         x9PekTSY4j/cyCSukWaL8fP8+G9uHr73iiqsnTmBKHuf5gv6QA44DjBWRh5hSGuYpL
         RbsGRJw2Dw1AEXY8pOEG84i900KXFIhLGaQu0Rkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 163/225] Input: cypress-sf - register a callback to disable the regulators
Date:   Wed,  4 May 2022 18:46:41 +0200
Message-Id: <20220504153124.529765225@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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




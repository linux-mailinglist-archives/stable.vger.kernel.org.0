Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6AE1541C4C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382852AbiFGV6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383292AbiFGVxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:53:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970C42432DD;
        Tue,  7 Jun 2022 12:11:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45858B8220B;
        Tue,  7 Jun 2022 19:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58F4C34115;
        Tue,  7 Jun 2022 19:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629064;
        bh=ZZWF/Lct7Kly7eSjM6A574A1ZQpS2iQCvjZmIC7gaCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FYYCU280zg82+7v6/hNupeU6AxuF2w7z1O/GpSevzR/DZ0h6cjYuHQnh6ZkJoiYAF
         IK//aMq5+kU0OT87Y7VaZntCFbqqVp+4rFR7VtQUol+3Sc5jZFV2Zxi4uCgfxGSzk7
         q0ipyWptdUxrIan5BQYiWhq8VwYWI6S7ljYHYQ6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prashant Malani <pmalani@chromium.org>,
        Tzung-Bi Shih <tzungbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 557/879] platform/chrome: cros_ec: fix error handling in cros_ec_register()
Date:   Tue,  7 Jun 2022 19:01:15 +0200
Message-Id: <20220607165019.032065158@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit 2cd01bd6b117df07b1bc2852f08694fdd29e40ed ]

Fix cros_ec_register() to unregister platform devices if
blocking_notifier_chain_register() fails.

Also use the single exit path to handle the platform device
unregistration.

Fixes: 42cd0ab476e2 ("platform/chrome: cros_ec: Query EC protocol version if EC transitions between RO/RW")
Reviewed-by: Prashant Malani <pmalani@chromium.org>
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec.c b/drivers/platform/chrome/cros_ec.c
index d49a4efe46c8..a5cc8f24299e 100644
--- a/drivers/platform/chrome/cros_ec.c
+++ b/drivers/platform/chrome/cros_ec.c
@@ -189,6 +189,8 @@ int cros_ec_register(struct cros_ec_device *ec_dev)
 	ec_dev->max_request = sizeof(struct ec_params_hello);
 	ec_dev->max_response = sizeof(struct ec_response_get_protocol_info);
 	ec_dev->max_passthru = 0;
+	ec_dev->ec = NULL;
+	ec_dev->pd = NULL;
 
 	ec_dev->din = devm_kzalloc(dev, ec_dev->din_size, GFP_KERNEL);
 	if (!ec_dev->din)
@@ -245,18 +247,16 @@ int cros_ec_register(struct cros_ec_device *ec_dev)
 		if (IS_ERR(ec_dev->pd)) {
 			dev_err(ec_dev->dev,
 				"Failed to create CrOS PD platform device\n");
-			platform_device_unregister(ec_dev->ec);
-			return PTR_ERR(ec_dev->pd);
+			err = PTR_ERR(ec_dev->pd);
+			goto exit;
 		}
 	}
 
 	if (IS_ENABLED(CONFIG_OF) && dev->of_node) {
 		err = devm_of_platform_populate(dev);
 		if (err) {
-			platform_device_unregister(ec_dev->pd);
-			platform_device_unregister(ec_dev->ec);
 			dev_err(dev, "Failed to register sub-devices\n");
-			return err;
+			goto exit;
 		}
 	}
 
@@ -278,7 +278,7 @@ int cros_ec_register(struct cros_ec_device *ec_dev)
 		err = blocking_notifier_chain_register(&ec_dev->event_notifier,
 						      &ec_dev->notifier_ready);
 		if (err)
-			return err;
+			goto exit;
 	}
 
 	dev_info(dev, "Chrome EC device registered\n");
@@ -291,6 +291,10 @@ int cros_ec_register(struct cros_ec_device *ec_dev)
 		cros_ec_irq_thread(0, ec_dev);
 
 	return 0;
+exit:
+	platform_device_unregister(ec_dev->ec);
+	platform_device_unregister(ec_dev->pd);
+	return err;
 }
 EXPORT_SYMBOL(cros_ec_register);
 
-- 
2.35.1




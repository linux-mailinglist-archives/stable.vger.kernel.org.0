Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A88095B4942
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiIJVSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiIJVRq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:17:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB844D822;
        Sat, 10 Sep 2022 14:17:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 737E460ED2;
        Sat, 10 Sep 2022 21:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE57C4314E;
        Sat, 10 Sep 2022 21:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844624;
        bh=gBqSutPfpXDWZXIZCw/OTNVRLC+utnkFgLmtlY25dus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JFL+nVQtTt/04qbVmLbMUjd4Uj/cYxSQGlfs5zVCddFSJtyQY53wOLau7S4Ixl6JG
         1suS3rR+o7ulUP6oWztyoROC9TDRfLDgRsYwhXnhK9GEahReOAlGAajL2MUEuNv2FW
         3I9nXVPRvjL6L0V057nmutHRjVOKNQgikHHkKGsJoSCms4WoD/72eH5ih3r8rmTjAC
         MQbNXw1Gp+DmMrjBYtDK3TmuFCmj0iUtS1bAv9tlJnZwWZwSZ32kSQ8X+w/pKZnGHW
         YLmlyuh2ecAgpKI5eKfc/TZBpcmHdHzfSMtTSZ/dhLGNzevpsF81Puq8Ch1sPolztn
         KmvzUhzgqTERQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>, bamv2005@gmail.com,
        linus.walleij@linaro.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 21/38] gpio: mockup: remove gpio debugfs when remove device
Date:   Sat, 10 Sep 2022 17:16:06 -0400
Message-Id: <20220910211623.69825-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211623.69825-1-sashal@kernel.org>
References: <20220910211623.69825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 303e6da99429510b1e4edf833afe90ac8542e747 ]

GPIO mockup debugfs is created in gpio_mockup_probe() but
forgot to remove when remove device. This patch add a devm
managed callback for removing them.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mockup.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-mockup.c b/drivers/gpio/gpio-mockup.c
index 8943cea927642..a2e505a7545cd 100644
--- a/drivers/gpio/gpio-mockup.c
+++ b/drivers/gpio/gpio-mockup.c
@@ -373,6 +373,13 @@ static void gpio_mockup_debugfs_setup(struct device *dev,
 	}
 }
 
+static void gpio_mockup_debugfs_cleanup(void *data)
+{
+	struct gpio_mockup_chip *chip = data;
+
+	debugfs_remove_recursive(chip->dbg_dir);
+}
+
 static void gpio_mockup_dispose_mappings(void *data)
 {
 	struct gpio_mockup_chip *chip = data;
@@ -455,7 +462,7 @@ static int gpio_mockup_probe(struct platform_device *pdev)
 
 	gpio_mockup_debugfs_setup(dev, chip);
 
-	return 0;
+	return devm_add_action_or_reset(dev, gpio_mockup_debugfs_cleanup, chip);
 }
 
 static const struct of_device_id gpio_mockup_of_match[] = {
-- 
2.35.1


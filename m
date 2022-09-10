Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125D55B49AB
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbiIJVV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiIJVVK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:21:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA274F698;
        Sat, 10 Sep 2022 14:18:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFDC7B8093B;
        Sat, 10 Sep 2022 21:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1350C433D7;
        Sat, 10 Sep 2022 21:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844695;
        bh=bUQW0Wp4SnI8PrxP3zvxYr7GetJzUvK5EMTjMqSKClw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJvTvMD6Ex57y7RsviEdyXmNLAirU4jAKED8ijnIGentOhZ5Jf+HXpYifOrt5lXAK
         zcu7p4mVQLlUJ1kmRr39C9Rzm73UMqeWaw0GnK/h14e7AZBb3qCEH4OuECxM5OJx49
         vz3DCKMruCASQ5hJRvrDyI6P4z7YqsEc5IKBLDabr+wKuDcCCCG2LViOgmf/rTTwr3
         4sdZSOzYrb2rGp8HQsQsb74q6FIhBBYveGtXd09TdTUKXjBeB/lF2w1O+NUj7xpReS
         +/Nu71nU19jzawGO2MGcRAuuP7KbiGZ0b/vFo+f9snqKHtUTm9i577xm/ImvvNecVf
         bzRhJkOIyP95w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>, bamv2005@gmail.com,
        linus.walleij@linaro.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 13/21] gpio: mockup: remove gpio debugfs when remove device
Date:   Sat, 10 Sep 2022 17:17:44 -0400
Message-Id: <20220910211752.70291-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211752.70291-1-sashal@kernel.org>
References: <20220910211752.70291-1-sashal@kernel.org>
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
index d26bff29157b5..369a832d96203 100644
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


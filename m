Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E35785BAAD6
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbiIPKZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbiIPKX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:23:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F382120AC;
        Fri, 16 Sep 2022 03:14:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A3DF62A3A;
        Fri, 16 Sep 2022 10:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE69C433D6;
        Fri, 16 Sep 2022 10:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323260;
        bh=gBqSutPfpXDWZXIZCw/OTNVRLC+utnkFgLmtlY25dus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSbLGrCLaxeaMTqgRcQOuRXc6fpGCF8sZOwtHSE0neNGvw1W9WzghT5O8k9SD3YxG
         0bjqVd1iGVF5Pm7BkhyyB1P8iTs8V3KiuOPtbMKt+Yaq/stSTirceuSuVq/GyoDYYM
         HWCrBairHzLPLsVrQTaLT+XLbkRIUWwxw0Suosf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 20/38] gpio: mockup: remove gpio debugfs when remove device
Date:   Fri, 16 Sep 2022 12:08:54 +0200
Message-Id: <20220916100449.317125633@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
References: <20220916100448.431016349@linuxfoundation.org>
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




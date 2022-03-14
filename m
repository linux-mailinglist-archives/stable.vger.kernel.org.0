Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4419C4D82CB
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240666AbiCNMLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241458AbiCNMIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:08:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31C04DF71;
        Mon, 14 Mar 2022 05:05:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8ED5B80DEC;
        Mon, 14 Mar 2022 12:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C284C36AE7;
        Mon, 14 Mar 2022 12:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259514;
        bh=uwf9dzxIwUnSO09Hn6uEZGOvmjnlWBgALoym4KdSelM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2pOQYh5PpjHOAxQ2n6H5XmyLit3xjRq56/fYTb9Au8W+C3zaC+0ptrz6ZmscT/8uR
         sMfyFTKCJiToobQ0cyX+PDTJtMqBIERN+vwEMCT2lExXzzIfM3O4EWqkCgVNaiLALd
         lpssy/VWiBdPiaGJuJK8vUorv2S+qNtI7GQ876AU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/110] gpiolib: acpi: Convert ACPI value of debounce to microseconds
Date:   Mon, 14 Mar 2022 12:53:26 +0100
Message-Id: <20220314112743.710609916@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 660c619b9d7ccd28648ee3766cdbe94ec7b27402 ]

It appears that GPIO ACPI library uses ACPI debounce values directly.
However, the GPIO library APIs expect the debounce timeout to be in
microseconds.

Convert ACPI value of debounce to microseconds.

While at it, document this detail where it is appropriate.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215664
Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Fixes: 8dcb7a15a585 ("gpiolib: acpi: Take into account debounce settings")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-acpi.c |  6 ++++--
 drivers/gpio/gpiolib.c      | 10 ++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index d040c72fea58..4c2e32c38acc 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -311,7 +311,8 @@ static struct gpio_desc *acpi_request_own_gpiod(struct gpio_chip *chip,
 	if (IS_ERR(desc))
 		return desc;
 
-	ret = gpio_set_debounce_timeout(desc, agpio->debounce_timeout);
+	/* ACPI uses hundredths of milliseconds units */
+	ret = gpio_set_debounce_timeout(desc, agpio->debounce_timeout * 10);
 	if (ret)
 		dev_warn(chip->parent,
 			 "Failed to set debounce-timeout for pin 0x%04X, err %d\n",
@@ -1052,7 +1053,8 @@ int acpi_dev_gpio_irq_get_by(struct acpi_device *adev, const char *name, int ind
 			if (ret < 0)
 				return ret;
 
-			ret = gpio_set_debounce_timeout(desc, info.debounce);
+			/* ACPI uses hundredths of milliseconds units */
+			ret = gpio_set_debounce_timeout(desc, info.debounce * 10);
 			if (ret)
 				return ret;
 
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d1b9b721218f..9e151413f51a 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2186,6 +2186,16 @@ static int gpio_set_bias(struct gpio_desc *desc)
 	return gpio_set_config_with_argument_optional(desc, bias, arg);
 }
 
+/**
+ * gpio_set_debounce_timeout() - Set debounce timeout
+ * @desc:	GPIO descriptor to set the debounce timeout
+ * @debounce:	Debounce timeout in microseconds
+ *
+ * The function calls the certain GPIO driver to set debounce timeout
+ * in the hardware.
+ *
+ * Returns 0 on success, or negative error code otherwise.
+ */
 int gpio_set_debounce_timeout(struct gpio_desc *desc, unsigned int debounce)
 {
 	return gpio_set_config_with_argument_optional(desc,
-- 
2.34.1




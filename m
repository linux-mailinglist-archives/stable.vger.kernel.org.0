Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBA341A3EF5
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 05:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgDJDqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:46:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726759AbgDJDqu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:46:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8843720936;
        Fri, 10 Apr 2020 03:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490410;
        bh=67CmsBXhGdHoYKLS1PHocYKFpEGu9O35WeIeUEMuhKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SyUv5s2KAq7pAWLPWtXnkD2lul4aEnaGGG+6mjs9Zeior6yyoBcJxSREtz27JVtB+
         gu8OgeEWy9ivuSGIYrMYg6cu+H2ECCoC4M+EM3I6Bwst2+NJSyLU2Bt/5yNvqky3g3
         6kc9rXYEsze/YxdHWJE79lOrYB85MSjGjCY1NQv4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 12/68] usb: phy: tegra: Include proper GPIO consumer header to fix compile testing
Date:   Thu,  9 Apr 2020 23:45:37 -0400
Message-Id: <20200410034634.7731-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034634.7731-1-sashal@kernel.org>
References: <20200410034634.7731-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 9cb9322a26ae84424c3e16e58617b3d8962fdbbb ]

The driver uses only GPIO Descriptor Consumer Interface so include
proper header.  This fixes compile test failures (e.g. on i386):

    drivers/usb/phy/phy-tegra-usb.c: In function ‘ulpi_phy_power_on’:
    drivers/usb/phy/phy-tegra-usb.c:695:2: error:
        implicit declaration of function ‘gpiod_set_value_cansleep’ [-Werror=implicit-function-declaration]
    drivers/usb/phy/phy-tegra-usb.c: In function ‘tegra_usb_phy_probe’:
    drivers/usb/phy/phy-tegra-usb.c:1167:11: error:
        implicit declaration of function ‘devm_gpiod_get_from_of_node’ [-Werror=implicit-function-declaration]

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/1583234960-24909-1-git-send-email-krzk@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/phy-tegra-usb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index 6153cc35aba0d..cffe2aced4884 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -12,12 +12,11 @@
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/export.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <linux/of_gpio.h>
 #include <linux/platform_device.h>
 #include <linux/resource.h>
 #include <linux/slab.h>
-- 
2.20.1


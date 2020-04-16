Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABDDF1AC7FD
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394866AbgDPPCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:02:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897246AbgDPNyC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:54:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 626862078B;
        Thu, 16 Apr 2020 13:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045241;
        bh=67CmsBXhGdHoYKLS1PHocYKFpEGu9O35WeIeUEMuhKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ssoT2ch9Ka45uHfRDDEzY7XYvf6FXz2oFN66BGrDjB411oeia2Xn+WMemqRqlAzUw
         YROIY5r+iWaQckwkIUxoTs9id+YTjVK9SIwK/BzPI820vu1kE7RQ2cmzIzh/tTu/hg
         QV50QvWY/ibqyuDPB7+v4Of7p10Id2pUa0qBvedY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 013/254] usb: phy: tegra: Include proper GPIO consumer header to fix compile testing
Date:   Thu, 16 Apr 2020 15:21:42 +0200
Message-Id: <20200416131327.481953796@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




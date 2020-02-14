Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0299115EE86
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389725AbgBNQDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:03:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389284AbgBNQDm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:03:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF3942187F;
        Fri, 14 Feb 2020 16:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696222;
        bh=l451lrYGMBWdYXnyn5Wlqaz3WUFTjstgJxeTc6xM2cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZMNA9wbwiPpMhuPSEcNjCudXTT1Y/46Ez8FXq9nIdxQTZG/dTzmDOFBTNmEWLlywD
         ysp1lTLCEou2msj2D8/GDPiBudQbniCJTPPOih5PZyNF6WeprOghNEc1xcFxmx4n9x
         aFl/LoeixocaYvTVqmBlPl7ASR7nWCOUFpeMHDlY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Paul Gazzillo <paul@pgazz.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 085/459] mfd: max77650: Select REGMAP_IRQ in Kconfig
Date:   Fri, 14 Feb 2020 10:55:35 -0500
Message-Id: <20200214160149.11681-85-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

[ Upstream commit cb7a374a5e7a5af3f8c839f74439193add6d0589 ]

MAX77650 MFD driver uses regmap_irq API but doesn't select the required
REGMAP_IRQ option in Kconfig. This can cause the following build error
if regmap irq is not enabled implicitly by someone else:

    ld: drivers/mfd/max77650.o: in function `max77650_i2c_probe':
    max77650.c:(.text+0xcb): undefined reference to `devm_regmap_add_irq_chip'
    ld: max77650.c:(.text+0xdb): undefined reference to `regmap_irq_get_domain'
    make: *** [Makefile:1079: vmlinux] Error 1

Fix it by adding the missing option.

Fixes: d0f60334500b ("mfd: Add new driver for MAX77650 PMIC")
Reported-by: Paul Gazzillo <paul@pgazz.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index ae24d3ea68ea4..43169f25da1fd 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -758,6 +758,7 @@ config MFD_MAX77650
 	depends on OF || COMPILE_TEST
 	select MFD_CORE
 	select REGMAP_I2C
+	select REGMAP_IRQ
 	help
 	  Say Y here to add support for Maxim Semiconductor MAX77650 and
 	  MAX77651 Power Management ICs. This is the core multifunction
-- 
2.20.1


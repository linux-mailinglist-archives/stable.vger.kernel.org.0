Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D10314E25F
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730861AbgA3Som (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:44:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730596AbgA3Soh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:44:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CB0321734;
        Thu, 30 Jan 2020 18:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409876;
        bh=8/lSlbMRAlSUMReWNthaK1vAVR0sim4ZvTR2usmWdtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aT5vshDCV20e3AmyTG/KA8/RY7T5hj8Jlv630+ods/CKL2yjXdGbxN2XID0fxjmO4
         2IJtZoasy61HkUFTX05hUF6bo7yASS4fux62ziR6j3DNeZTuDZxV/2PCY3hPvSEtCN
         n9wgkgTOGDHQkkMVuycLv/NWrJfLIeBXepGRKs5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/110] gpio: max77620: Add missing dependency on GPIOLIB_IRQCHIP
Date:   Thu, 30 Jan 2020 19:38:45 +0100
Message-Id: <20200130183622.734353587@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit c5706c7defc79de68a115b5536376298a8fef111 ]

Driver fails to compile in a minimized kernel's configuration because of
the missing dependency on GPIOLIB_IRQCHIP.

 error: ‘struct gpio_chip’ has no member named ‘irq’
   44 |   virq = irq_find_mapping(gpio->gpio_chip.irq.domain, offset);

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20200106015154.12040-1-digetx@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index ceb908f7dbe51..f9263426af030 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -1120,6 +1120,7 @@ config GPIO_MADERA
 config GPIO_MAX77620
 	tristate "GPIO support for PMIC MAX77620 and MAX20024"
 	depends on MFD_MAX77620
+	select GPIOLIB_IRQCHIP
 	help
 	  GPIO driver for MAX77620 and MAX20024 PMIC from Maxim Semiconductor.
 	  MAX77620 PMIC has 8 pins that can be configured as GPIOs. The
-- 
2.20.1




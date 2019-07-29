Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF41779788
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391108AbfG2UAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 16:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390436AbfG2Tw2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:52:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF0EB217D7;
        Mon, 29 Jul 2019 19:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429948;
        bh=tX+IshYVTHGNNujMt94bhRNsrEcqv6riFvKMfNSTxh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QagjrEMy8rQf8huRXDWemO/3rv2kWKUhkXjwdAbrB9lao//Bb97dTjgbSZMuADJx9
         bleVdpR991GxIrJhbouajBqwLSJyTmLVLhAJ9uymResH8wqyzxdlmI9BzfZqgz7MfC
         nqQbJok7j1MeK0FLA3l8gYLdBx/SZ6lKEJSM7AuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 146/215] platform/x86: Fix PCENGINES_APU2 Kconfig warning
Date:   Mon, 29 Jul 2019 21:22:22 +0200
Message-Id: <20190729190805.047820359@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7d67c8ac25fbc66ee254aa3e33329d1c9bc152ce ]

Fix Kconfig warning for PCENGINES_APU2 symbol:

WARNING: unmet direct dependencies detected for GPIO_AMD_FCH
  Depends on [n]: GPIOLIB [=n] && HAS_IOMEM [=y]
  Selected by [y]:
  - PCENGINES_APU2 [=y] && X86 [=y] && X86_PLATFORM_DEVICES [=y] && INPUT [=y] && INPUT_KEYBOARD [=y] && LEDS_CLASS [=y]

WARNING: unmet direct dependencies detected for KEYBOARD_GPIO_POLLED
  Depends on [n]: !UML && INPUT [=y] && INPUT_KEYBOARD [=y] && GPIOLIB [=n]
  Selected by [y]:
  - PCENGINES_APU2 [=y] && X86 [=y] && X86_PLATFORM_DEVICES [=y] && INPUT [=y] && INPUT_KEYBOARD [=y] && LEDS_CLASS [=y]

Add GPIOLIB dependency to fix it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: f8eb0235f659 ("x86: pcengines apuv2 gpio/leds/keys platform driver")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 5d5cc6111081..7c2fd1d72e18 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -1317,7 +1317,7 @@ config HUAWEI_WMI
 
 config PCENGINES_APU2
 	tristate "PC Engines APUv2/3 front button and LEDs driver"
-	depends on INPUT && INPUT_KEYBOARD
+	depends on INPUT && INPUT_KEYBOARD && GPIOLIB
 	depends on LEDS_CLASS
 	select GPIO_AMD_FCH
 	select KEYBOARD_GPIO_POLLED
-- 
2.20.1




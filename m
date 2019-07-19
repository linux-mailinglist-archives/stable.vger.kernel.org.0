Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C96636DF68
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730602AbfGSEeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:34:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729640AbfGSEBr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:01:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DA4D21852;
        Fri, 19 Jul 2019 04:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508906;
        bh=0aSZODHBkOAbvibJ9SQqfbPnqgw2bJ8FpFrXYuyK1CU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mfoj0p+DWFLHfOC3Y+wBz2qviHhnNwajcnIRHBQPUGOh/6J+ljiM5b8EeWYkiaJ0i
         gcNm/ChMRbhzOTxLNzSzgt+bvXTWJ7UdKmnQ0dSvUW5py6F4nWhLJyNS6TKO1k5T7a
         ScBS0pKMHET6GWyfvv859Z9ny2X6UvDQIg3iLexg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 151/171] platform/x86: Fix PCENGINES_APU2 Kconfig warning
Date:   Thu, 18 Jul 2019 23:56:22 -0400
Message-Id: <20190719035643.14300-151-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

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


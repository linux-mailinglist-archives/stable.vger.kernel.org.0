Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19743B6A44
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 23:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238046AbhF1VX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 17:23:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237915AbhF1VXa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 17:23:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D05E461D00;
        Mon, 28 Jun 2021 21:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624915264;
        bh=aYDKaucny87sagAC2JtISSqkoyLoQQcF0M5+HEzqVMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSA4A31VyoxyLrAV22jUdOfFX0D5Gi152dNmXBqbG2uycN6esbIrX6J9/uMTfej5w
         /63ctVWS/EG7wOJYoGAws8RVNgSOmrOBLhsALw0l+dX7BLtaISYw5+2X8PBjH/xER0
         81BcTFpcAugsfDggIjryo1ex2ysi8ccNEN8vJ+j6PxFVEtaxIc0iqppHrSRH2SYKyh
         N84NphxDALK7Z9zh5MsFn9CFczo+Y6WFAoN/aepB84WG71Zg8Tko1/SpGfPYUNGFwe
         AhvwgQ1gSa/1c/fIoffw4qnHVNLPsANEUsxZp/fCSRYgViC1N8LGJ/KkpbbgFUHBsi
         yQAFxV2xilsEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        kernel test robot <lkp@intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 4/4] gpio: AMD8111 and TQMX86 require HAS_IOPORT_MAP
Date:   Mon, 28 Jun 2021 17:20:58 -0400
Message-Id: <20210628212059.43361-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628212059.43361-1-sashal@kernel.org>
References: <20210628212059.43361-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit c6414e1a2bd26b0071e2b9d6034621f705dfd4c0 ]

Both of these drivers use ioport_map(), so they need to
depend on HAS_IOPORT_MAP. Otherwise, they cannot be built
even with COMPILE_TEST on architectures without an ioport
implementation, such as ARCH=um.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 14751c7ccd1f..d1300fc003ed 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -1337,6 +1337,7 @@ config GPIO_TPS68470
 config GPIO_TQMX86
 	tristate "TQ-Systems QTMX86 GPIO"
 	depends on MFD_TQMX86 || COMPILE_TEST
+	depends on HAS_IOPORT_MAP
 	select GPIOLIB_IRQCHIP
 	help
 	  This driver supports GPIO on the TQMX86 IO controller.
@@ -1404,6 +1405,7 @@ menu "PCI GPIO expanders"
 config GPIO_AMD8111
 	tristate "AMD 8111 GPIO driver"
 	depends on X86 || COMPILE_TEST
+	depends on HAS_IOPORT_MAP
 	help
 	  The AMD 8111 south bridge contains 32 GPIO pins which can be used.
 
-- 
2.30.2


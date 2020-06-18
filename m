Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC981FE03F
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732026AbgFRBqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732095AbgFRB2a (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:28:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77DEC221FC;
        Thu, 18 Jun 2020 01:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443710;
        bh=5d3vNDNuQvODzfrN0SzSBAhnNYtyMFSiHtXdBNldzrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hHSPhEzRjzXQOHUyz7TiToRdSaOGobj8qTXgBZyJODCvGaUbpCqLTnF5PAKHxVuzB
         gGdqhh7+q2X+sohXt4oaX+GLC/lFmMm4T+8qt1uCfLhCc5WVo1dDvadiorDWkKsO5K
         STdC+3Wfddx0VXkLzYoyKGz3e1wWZCAgSphso5TA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 08/80] ARM: integrator: Add some Kconfig selections
Date:   Wed, 17 Jun 2020 21:27:07 -0400
Message-Id: <20200618012819.609778-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012819.609778-1-sashal@kernel.org>
References: <20200618012819.609778-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit d2854bbe5f5c4b4bec8061caf4f2e603d8819446 ]

The CMA and DMA_CMA Kconfig options need to be selected
by the Integrator in order to produce boot console on some
Integrator systems.

The REGULATOR and REGULATOR_FIXED_VOLTAGE need to be
selected in order to boot the system from an external
MMC card when using MMCI/PL181 from the device tree
probe path.

Select these things directly from the Kconfig so we are
sure to be able to bring the systems up with console
from any device tree.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-integrator/Kconfig | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-integrator/Kconfig b/arch/arm/mach-integrator/Kconfig
index cefe44f6889b..ba124f8704fa 100644
--- a/arch/arm/mach-integrator/Kconfig
+++ b/arch/arm/mach-integrator/Kconfig
@@ -3,6 +3,8 @@ menuconfig ARCH_INTEGRATOR
 	depends on ARCH_MULTI_V4T || ARCH_MULTI_V5 || ARCH_MULTI_V6
 	select ARM_AMBA
 	select COMMON_CLK_VERSATILE
+	select CMA
+	select DMA_CMA
 	select HAVE_TCM
 	select ICST
 	select MFD_SYSCON
@@ -34,14 +36,13 @@ config INTEGRATOR_IMPD1
 	select ARM_VIC
 	select GPIO_PL061
 	select GPIOLIB
+	select REGULATOR
+	select REGULATOR_FIXED_VOLTAGE
 	help
 	  The IM-PD1 is an add-on logic module for the Integrator which
 	  allows ARM(R) Ltd PrimeCells to be developed and evaluated.
 	  The IM-PD1 can be found on the Integrator/PP2 platform.
 
-	  To compile this driver as a module, choose M here: the
-	  module will be called impd1.
-
 config INTEGRATOR_CM7TDMI
 	bool "Integrator/CM7TDMI core module"
 	depends on ARCH_INTEGRATOR_AP
-- 
2.25.1


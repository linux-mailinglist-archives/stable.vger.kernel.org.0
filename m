Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEC72A54CB
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388865AbgKCVOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:14:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:55930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389092AbgKCVNK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:13:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22EF7205ED;
        Tue,  3 Nov 2020 21:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437989;
        bh=MzQblIlLxg3h3xxgE3Uf01tjIDi39O9jXtVbrNnZDdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QkeAiCvD0zIDIl/Hq7gMEqV7pL/R+XbUVg6rKZGerkQ3cepigAU+VZtaq+9pTrOMP
         zCjdkTOkbHGcbszuRKbv7z0JngCJK27Jq1uaMPJ3E5ksLV6QRRbAWMfN1CLfWoZEpL
         3w7lBiQ8/Tb25ETOzlB/XPYLtirOZ83YgCpwosm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 4.14 118/125] ARM: samsung: fix PM debug build with DEBUG_LL but !MMU
Date:   Tue,  3 Nov 2020 21:38:15 +0100
Message-Id: <20201103203214.545926093@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

commit 7be0d19c751b02db778ca95e3274d5ea7f31891c upstream.

Selecting CONFIG_SAMSUNG_PM_DEBUG (depending on CONFIG_DEBUG_LL) but
without CONFIG_MMU leads to build errors:

  arch/arm/plat-samsung/pm-debug.c: In function ‘s3c_pm_uart_base’:
  arch/arm/plat-samsung/pm-debug.c:57:2: error:
    implicit declaration of function ‘debug_ll_addr’ [-Werror=implicit-function-declaration]

Fixes: 99b2fc2b8b40 ("ARM: SAMSUNG: Use debug_ll_addr() to get UART base address")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200910154150.3318-1-krzk@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/plat-samsung/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -242,6 +242,7 @@ config SAMSUNG_PM_DEBUG
 	bool "Samsung PM Suspend debug"
 	depends on PM && DEBUG_KERNEL
 	depends on DEBUG_EXYNOS_UART || DEBUG_S3C24XX_UART || DEBUG_S3C2410_UART
+	depends on DEBUG_LL && MMU
 	help
 	  Say Y here if you want verbose debugging from the PM Suspend and
 	  Resume code. See <file:Documentation/arm/Samsung-S3C24XX/Suspend.txt>



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F1E264F44
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 21:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgIJTjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 15:39:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731263AbgIJPmJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Sep 2020 11:42:09 -0400
Received: from localhost.localdomain (unknown [194.230.155.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3E0F2087C;
        Thu, 10 Sep 2020 15:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599752519;
        bh=P91+gTcFqZsVXHGB3OESB5O/+DN+aXhnKMJXknOiXEE=;
        h=From:To:Cc:Subject:Date:From;
        b=gK7UKUQXnZfxgXKXiWYA2RFHQC2GxckJQpn1qPSGEYxp1QBGvdF86cm775y+PARHW
         sNWZ2Se3EXiwgExLq5sEnNY5gwNWE76BeeYDIoiBxv+SL13Air3hHqqwasg+jEzrPk
         ZcHVtgevAPLG5EQBScqj/fz5CdHEW/tsbft/1RlI=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org
Subject: [PATCH 1/2] ARM: samsung: fix PM debug build with DEBUG_LL but !MMU
Date:   Thu, 10 Sep 2020 17:41:49 +0200
Message-Id: <20200910154150.3318-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Selecting CONFIG_SAMSUNG_PM_DEBUG (depending on CONFIG_DEBUG_LL) but
without CONFIG_MMU leads to build errors:

  arch/arm/plat-samsung/pm-debug.c: In function ‘s3c_pm_uart_base’:
  arch/arm/plat-samsung/pm-debug.c:57:2: error:
    implicit declaration of function ‘debug_ll_addr’ [-Werror=implicit-function-declaration]

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 99b2fc2b8b40 ("ARM: SAMSUNG: Use debug_ll_addr() to get UART base address")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

Patchset is rebased on v5.9-rc1.
---
 arch/arm/plat-samsung/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index 301e572651c0..790c87ee7271 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -241,6 +241,7 @@ config SAMSUNG_PM_DEBUG
 	depends on PM && DEBUG_KERNEL
 	depends on PLAT_S3C24XX || ARCH_S3C64XX || ARCH_S5PV210
 	depends on DEBUG_EXYNOS_UART || DEBUG_S3C24XX_UART || DEBUG_S3C2410_UART
+	depends on DEBUG_LL && MMU
 	help
 	  Say Y here if you want verbose debugging from the PM Suspend and
 	  Resume code. See <file:Documentation/arm/samsung-s3c24xx/suspend.rst>
-- 
2.17.1


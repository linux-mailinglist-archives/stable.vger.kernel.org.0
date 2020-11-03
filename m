Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345D72A5559
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388419AbgKCVJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:09:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:47556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388516AbgKCVIJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:08:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A307205ED;
        Tue,  3 Nov 2020 21:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437689;
        bh=m4g9q+Mue7xJeKG2I/ft/AffLGKRBJrMhbhgOqcRyQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TuiL4nDPTTu4XJkVBzRzuCpavrHVPaCwWfbsP9eRIkgk1hTI7+LGx5iWPW3Rzkguc
         HbegLBaiQGVcfhZUf4i7bOKIDsDVr02RAiMptrSjBBTPJDhrfRkVewdefwlmkSzIcS
         HUKNzwGwtVHfvsputkVeE7FLm7KCpS/CGLEwIJcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 4.19 184/191] ARM: samsung: fix PM debug build with DEBUG_LL but !MMU
Date:   Tue,  3 Nov 2020 21:37:56 +0100
Message-Id: <20201103203249.978323384@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
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
@@ -240,6 +240,7 @@ config SAMSUNG_PM_DEBUG
 	bool "Samsung PM Suspend debug"
 	depends on PM && DEBUG_KERNEL
 	depends on DEBUG_EXYNOS_UART || DEBUG_S3C24XX_UART || DEBUG_S3C2410_UART
+	depends on DEBUG_LL && MMU
 	help
 	  Say Y here if you want verbose debugging from the PM Suspend and
 	  Resume code. See <file:Documentation/arm/Samsung-S3C24XX/Suspend.txt>



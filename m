Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40BCF2A57E1
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732031AbgKCVqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:46:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732003AbgKCUvx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:51:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61E752071E;
        Tue,  3 Nov 2020 20:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436712;
        bh=sPcDn3pCFsVf/hXUP2umMlz2D70RkKKsF+8Rs+E/f/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zavex8GFYnHMZENXJiZFWSyvXXK590JgR3Aj7V9kyX6NQ5lb9iTBgn5+r7tYbNINN
         cHhF/PMSVBQqQQSXp0f/FHDn/kinVWroz3+hXNIsIAtF346TTGNGr/8esxRrXhow5o
         ezOzCz1/43Fg899UvioPbdLP6PEnsyrH/hhGQ2N8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.9 370/391] ARM: samsung: fix PM debug build with DEBUG_LL but !MMU
Date:   Tue,  3 Nov 2020 21:37:01 +0100
Message-Id: <20201103203412.114859901@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
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
@@ -241,6 +241,7 @@ config SAMSUNG_PM_DEBUG
 	depends on PM && DEBUG_KERNEL
 	depends on PLAT_S3C24XX || ARCH_S3C64XX || ARCH_S5PV210
 	depends on DEBUG_EXYNOS_UART || DEBUG_S3C24XX_UART || DEBUG_S3C2410_UART
+	depends on DEBUG_LL && MMU
 	help
 	  Say Y here if you want verbose debugging from the PM Suspend and
 	  Resume code. See <file:Documentation/arm/samsung-s3c24xx/suspend.rst>



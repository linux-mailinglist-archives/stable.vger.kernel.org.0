Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CC638A75D
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237361AbhETKhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:37:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237805AbhETKfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:35:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6853861400;
        Thu, 20 May 2021 09:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504426;
        bh=t2SDdH4ejF2+umXZYksPCXnl5nME/ht8BNAB3lEBcgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YEssUkb8g/HW7ev70AAQ+Ufwv1BNTqHyGB5Ka9a/6nNz0hWTcWo631rFLtccAHhTG
         YiA4NGrHkQLm9/C2Br3arkoHBPkuuT1FduWso8DmHuF0+KxASd2a3jJ5yC1jMiVQ48
         /u75o2i8yYC7NuDeXdkOR4JjEn9MAElgruXJbVlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 206/323] powerpc: iommu: fix build when neither PCI or IBMVIO is set
Date:   Thu, 20 May 2021 11:21:38 +0200
Message-Id: <20210520092127.185508204@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit b27dadecdf9102838331b9a0b41ffc1cfe288154 ]

When neither CONFIG_PCI nor CONFIG_IBMVIO is set/enabled, iommu.c has a
build error. The fault injection code is not useful in that kernel config,
so make the FAIL_IOMMU option depend on PCI || IBMVIO.

Prevents this build error (warning escalated to error):
../arch/powerpc/kernel/iommu.c:178:30: error: 'fail_iommu_bus_notifier' defined but not used [-Werror=unused-variable]
  178 | static struct notifier_block fail_iommu_bus_notifier = {

Fixes: d6b9a81b2a45 ("powerpc: IOMMU fault injection")
Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210404192623.10697-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Kconfig.debug | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/Kconfig.debug b/arch/powerpc/Kconfig.debug
index be1c8c5beb61..762bb08b0f59 100644
--- a/arch/powerpc/Kconfig.debug
+++ b/arch/powerpc/Kconfig.debug
@@ -349,6 +349,7 @@ config PPC_EARLY_DEBUG_CPM_ADDR
 config FAIL_IOMMU
 	bool "Fault-injection capability for IOMMU"
 	depends on FAULT_INJECTION
+	depends on PCI || IBMVIO
 	help
 	  Provide fault-injection capability for IOMMU. Each device can
 	  be selectively enabled via the fail_iommu property.
-- 
2.30.2




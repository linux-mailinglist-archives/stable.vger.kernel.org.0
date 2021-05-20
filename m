Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027E238AB51
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239834AbhETLXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:23:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239958AbhETLU7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:20:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8D1261D88;
        Thu, 20 May 2021 10:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505474;
        bh=VudqAjCm7cNo/92nDgScdUdyls3M86uh7MZYVapLyto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aIi55RnoA07i0y4Mx7jh8Thc/88Z9To95XHRW4FHClR+4akurbdvoZB8tDuoWAPOg
         jSkAeb3iLsye+ATXXwR3/vf2RSAGfOPZ8m1mydpWeDD6IV03L9ceT+oy/ypOPIU+C5
         MxusS+6uaWU+Wc3fIN8lPQO5OEAKKKvv+f9y3Xb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 117/190] powerpc: iommu: fix build when neither PCI or IBMVIO is set
Date:   Thu, 20 May 2021 11:23:01 +0200
Message-Id: <20210520092106.076711154@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
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
index 3a510f4a6b68..7e62572215ce 100644
--- a/arch/powerpc/Kconfig.debug
+++ b/arch/powerpc/Kconfig.debug
@@ -350,6 +350,7 @@ config STRICT_DEVMEM
 config FAIL_IOMMU
 	bool "Fault-injection capability for IOMMU"
 	depends on FAULT_INJECTION
+	depends on PCI || IBMVIO
 	help
 	  Provide fault-injection capability for IOMMU. Each device can
 	  be selectively enabled via the fail_iommu property.
-- 
2.30.2




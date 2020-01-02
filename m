Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 577C712EC2F
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbgABWQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:16:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727528AbgABWQD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:16:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E26F72253D;
        Thu,  2 Jan 2020 22:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003363;
        bh=kxFz/ZBpzvwU5N3uVVg+4xNcT/Td854SHiUieOo7OK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QfXD031gdlsvADsc6I6zQCqcej/lj3rt9rMu7oGTZX95a2mNClUVyndGpBEjqxAuB
         By38tW9yPN6sxLJyZwWRO1PaoIK0VyXWgFo96Iv/JzLI2ihxqe4e3yQ0OBdmMN2MRw
         c1pLWSEBp+L9+13dysnAeMU0Gtu6G5tc8Gy658FI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Parth Shah <parth@linux.ibm.com>,
        Ihor Pasichnyk <Ihor.Pasichnyk@ibm.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Waiman Long <longman@redhat.com>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Phil Auld <pauld@redhat.com>,
        Vaidyanathan Srinivasan <svaidy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 130/191] Revert "powerpc/vcpu: Assume dedicated processors as non-preempt"
Date:   Thu,  2 Jan 2020 23:06:52 +0100
Message-Id: <20200102215843.634744563@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 8332dbe5157a0056d8ab409957dfa89930066d87 which is
commit 14c73bd344da60abaf7da3ea2e7733ddda35bbac upstream.

It breaks the build.

Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Parth Shah <parth@linux.ibm.com>
Cc: Ihor Pasichnyk <Ihor.Pasichnyk@ibm.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Phil Auld <pauld@redhat.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.ibm.com>
Cc: Parth Shah <parth@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/spinlock.h    |    4 +---
 arch/powerpc/platforms/pseries/setup.c |    7 -------
 2 files changed, 1 insertion(+), 10 deletions(-)

--- a/arch/powerpc/include/asm/spinlock.h
+++ b/arch/powerpc/include/asm/spinlock.h
@@ -36,12 +36,10 @@
 #endif
 
 #ifdef CONFIG_PPC_PSERIES
-DECLARE_STATIC_KEY_FALSE(shared_processor);
-
 #define vcpu_is_preempted vcpu_is_preempted
 static inline bool vcpu_is_preempted(int cpu)
 {
-	if (!static_branch_unlikely(&shared_processor))
+	if (!firmware_has_feature(FW_FEATURE_SPLPAR))
 		return false;
 	return !!(be32_to_cpu(lppaca_of(cpu).yield_count) & 1);
 }
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -74,9 +74,6 @@
 #include "pseries.h"
 #include "../../../../drivers/pci/pci.h"
 
-DEFINE_STATIC_KEY_FALSE(shared_processor);
-EXPORT_SYMBOL_GPL(shared_processor);
-
 int CMO_PrPSP = -1;
 int CMO_SecPSP = -1;
 unsigned long CMO_PageSize = (ASM_CONST(1) << IOMMU_PAGE_SHIFT_4K);
@@ -761,10 +758,6 @@ static void __init pSeries_setup_arch(vo
 
 	if (firmware_has_feature(FW_FEATURE_LPAR)) {
 		vpa_init(boot_cpuid);
-
-		if (lppaca_shared_proc(get_lppaca()))
-			static_branch_enable(&shared_processor);
-
 		ppc_md.power_save = pseries_lpar_idle;
 		ppc_md.enable_pmcs = pseries_lpar_enable_pmcs;
 #ifdef CONFIG_PCI_IOV



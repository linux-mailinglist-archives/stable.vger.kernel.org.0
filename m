Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B5C2A1622
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgJaLmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:42:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727823AbgJaLmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:42:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C95DF205F4;
        Sat, 31 Oct 2020 11:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144530;
        bh=ETpU0BXfRtZxD2EQRg6oathVavk99g4z1nxhq8Anb7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tiQpTTN2Vgi1ssiLUUl3fEqAN7bVx4Rg+Jto3tWZD7WfEVHHQsPOx6HSYb54UknsT
         jDoH3xD/z/goOOhcluI5kBvXlcM95NinMg0wFn4UUMaoMY/6nC/uLMBwmODSq152bY
         zUG72CF8NrVnHDslvphUVkb1eONp9lpuuYXXAuSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jesse Barnes <jsbarnes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Len Brown <lenb@kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 5.8 23/70] x86/PCI: Fix intel_mid_pci.c build error when ACPI is not enabled
Date:   Sat, 31 Oct 2020 12:35:55 +0100
Message-Id: <20201031113500.614049175@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit 035fff1f7aab43e420e0098f0854470a5286fb83 upstream.

Fix build error when CONFIG_ACPI is not set/enabled by adding the header
file <asm/acpi.h> which contains a stub for the function in the build
error.

    ../arch/x86/pci/intel_mid_pci.c: In function ‘intel_mid_pci_init’:
    ../arch/x86/pci/intel_mid_pci.c:303:2: error: implicit declaration of function ‘acpi_noirq_set’; did you mean ‘acpi_irq_get’? [-Werror=implicit-function-declaration]
      acpi_noirq_set();

Fixes: a912a7584ec3 ("x86/platform/intel-mid: Move PCI initialization to arch_init()")
Link: https://lore.kernel.org/r/ea903917-e51b-4cc9-2680-bc1e36efa026@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Jesse Barnes <jsbarnes@google.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org	# v4.16+
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Jesse Barnes <jsbarnes@google.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/pci/intel_mid_pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/pci/intel_mid_pci.c
+++ b/arch/x86/pci/intel_mid_pci.c
@@ -33,6 +33,7 @@
 #include <asm/hw_irq.h>
 #include <asm/io_apic.h>
 #include <asm/intel-mid.h>
+#include <asm/acpi.h>
 
 #define PCIE_CAP_OFFSET	0x100
 



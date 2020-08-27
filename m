Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC34254DF8
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 21:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgH0TFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 15:05:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgH0TFT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Aug 2020 15:05:19 -0400
Received: from localhost (104.sub-72-107-126.myvzw.com [72.107.126.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6524E20786;
        Thu, 27 Aug 2020 19:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598555118;
        bh=6wi7BZ7sjbl1BjeinCwOI2PqM7WQLe/7Md+KmWzCljw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=l1e8/Pmn8ngF+p3T9et0To6f49k4Ql3c2Z74uxj3xtH00LxLMAu5rqZK5lwfRW+63
         a2oxGdG2gcwUcCa7OKsDv0Sr9kCeSbyeEIuhTR+zmHFvr3YFh8HlUlxsJB+STprPT0
         uMjl4QF+58ofygnmmXDpFUoANW4vhWh+RNq8ZbG8=
Date:   Thu, 27 Aug 2020 14:05:17 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        stable <stable@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Len Brown <lenb@kernel.org>,
        Jesse Barnes <jsbarnes@google.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Adam Borowski <kilobyte@angband.pl>
Subject: Re: [PATCH v2] x86/pci: fix intel_mid_pci.c build error when ACPI is
 not enabled
Message-ID: <20200827190517.GA2097725@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ea903917-e51b-4cc9-2680-bc1e36efa026@infradead.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 05:10:27PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix build error when CONFIG_ACPI is not set/enabled by adding
> the header file <asm/acpi.h> which contains a stub for the function
> in the build error.
> 
> ../arch/x86/pci/intel_mid_pci.c: In function ‘intel_mid_pci_init’:
> ../arch/x86/pci/intel_mid_pci.c:303:2: error: implicit declaration of function ‘acpi_noirq_set’; did you mean ‘acpi_irq_get’? [-Werror=implicit-function-declaration]
>   acpi_noirq_set();
> 
> Fixes: a912a7584ec3 ("x86/platform/intel-mid: Move PCI initialization to arch_init()")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: stable@vger.kernel.org	# v4.16+
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Len Brown <lenb@kernel.org>
> To: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Jesse Barnes <jsbarnes@google.com>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: linux-pci@vger.kernel.org
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Reviewed-by: Jesse Barnes <jsbarnes@google.com>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>

Applied to pci/misc for v5.10, thanks!

We could put it in v5.9, but a912a7584ec3 was merged for v4.16, so
apparently this has been broken for a long time.

> ---
> Found in linux-next, but applies to/exists in mainline also.
> 
> v2:
> - add Reviewed-by: and Acked-by: tags
> - drop alternatives
> 
>  arch/x86/pci/intel_mid_pci.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20200813.orig/arch/x86/pci/intel_mid_pci.c
> +++ linux-next-20200813/arch/x86/pci/intel_mid_pci.c
> @@ -33,6 +33,7 @@
>  #include <asm/hw_irq.h>
>  #include <asm/io_apic.h>
>  #include <asm/intel-mid.h>
> +#include <asm/acpi.h>
>  
>  #define PCIE_CAP_OFFSET	0x100
>  
> 

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C191B259C4F
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgIARN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:13:59 -0400
Received: from mga07.intel.com ([134.134.136.100]:2209 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729563AbgIARNE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 13:13:04 -0400
IronPort-SDR: 88nGYQL07Hd1sx4NtXJDw60T2FomUt8SFBAqQ5Outng1DYs6VDXJFSwYHJcD1DP8nmCYjvTJ4a
 AMHjMEA4+/YA==
X-IronPort-AV: E=McAfee;i="6000,8403,9731"; a="221439686"
X-IronPort-AV: E=Sophos;i="5.76,379,1592895600"; 
   d="scan'208";a="221439686"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2020 10:13:02 -0700
IronPort-SDR: IPJiBrBum7jSbBMjjnUnRTLc3uregRJqv4MEVLmYVVfOppTr0opOuRhR1Rggi52AQGhVbjTY48
 m7ntPozknbkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,379,1592895600"; 
   d="scan'208";a="477278477"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.209.2.157]) ([10.209.2.157])
  by orsmga005.jf.intel.com with ESMTP; 01 Sep 2020 10:13:01 -0700
Subject: Re: [PATCH 5.8 070/255] dmaengine: idxd: fix PCI_MSI build errors
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        dmaengine@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20200901151000.800754757@linuxfoundation.org>
 <20200901151004.086401987@linuxfoundation.org>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <3ed5a847-981a-6520-add9-dc1e3792e703@intel.com>
Date:   Tue, 1 Sep 2020 10:13:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200901151004.086401987@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/1/2020 8:08 AM, Greg Kroah-Hartman wrote:
> [ Upstream commit d6a7bb869dd8a516901591136a9a895fd829d6c6 ]
> 
> Fix build errors when CONFIG_PCI_MSI is not enabled by making the
> driver depend on PCI_MSI:
> 
> ld: drivers/dma/idxd/device.o: in function `idxd_mask_msix_vector':
> device.c:(.text+0x26f): undefined reference to `pci_msi_mask_irq'
> ld: drivers/dma/idxd/device.o: in function `idxd_unmask_msix_vector':
> device.c:(.text+0x2af): undefined reference to `pci_msi_unmask_irq'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: dmaengine@vger.kernel.org
> Cc: Vinod Koul <vkoul@kernel.org>
> Link: https://lore.kernel.org/r/9dee3f46-70d9-ea75-10cb-5527ab297d1d@infradead.org
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Acked-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   drivers/dma/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index de41d7928bff2..984354ca877de 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -285,6 +285,7 @@ config INTEL_IDMA64
>   config INTEL_IDXD
>   	tristate "Intel Data Accelerators support"
>   	depends on PCI && X86_64
> +	depends on PCI_MSI
>   	select DMA_ENGINE
>   	select SBITMAP
>   	help
> 

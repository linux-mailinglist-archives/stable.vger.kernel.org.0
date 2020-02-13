Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC8415C932
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 18:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgBMRKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 12:10:30 -0500
Received: from mga12.intel.com ([192.55.52.136]:7922 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728102AbgBMRKa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 12:10:30 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Feb 2020 09:10:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,437,1574150400"; 
   d="scan'208";a="227296677"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga008.jf.intel.com with ESMTP; 13 Feb 2020 09:10:27 -0800
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1j2I0T-001AuL-SD; Thu, 13 Feb 2020 19:10:29 +0200
Date:   Thu, 13 Feb 2020 19:10:29 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc:     linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] i2c: designware-pci: Fix BUG_ON during device removal
Message-ID: <20200213171029.GB10400@smile.fi.intel.com>
References: <20200213151503.545269-1-jarkko.nikula@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213151503.545269-1-jarkko.nikula@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 05:15:03PM +0200, Jarkko Nikula wrote:
> Function i2c_dw_pci_remove() -> pci_free_irq_vectors() ->
> pci_disable_msi() -> free_msi_irqs() will throw a BUG_ON() for MSI
> enabled device since the driver has not released the requested IRQ before
> calling the pci_free_irq_vectors().
> 
> Here driver requests an IRQ using devm_request_irq() but automatic
> release happens only after remove callback. Fix this by explicitly
> freeing the IRQ before calling pci_free_irq_vectors().
> 

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Fixes: 21aa3983d619 ("i2c: designware-pci: Switch over to MSI interrupts")
> Cc: stable@vger.kernel.org # v5.4+
> Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
> ---
>  drivers/i2c/busses/i2c-designware-pcidrv.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
> index 050adda7c1bd..05b35ac33ce3 100644
> --- a/drivers/i2c/busses/i2c-designware-pcidrv.c
> +++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
> @@ -313,6 +313,7 @@ static void i2c_dw_pci_remove(struct pci_dev *pdev)
>  	pm_runtime_get_noresume(&pdev->dev);
>  
>  	i2c_del_adapter(&dev->adapter);
> +	devm_free_irq(&pdev->dev, dev->irq, dev);
>  	pci_free_irq_vectors(pdev);
>  }
>  
> -- 
> 2.25.0
> 

-- 
With Best Regards,
Andy Shevchenko



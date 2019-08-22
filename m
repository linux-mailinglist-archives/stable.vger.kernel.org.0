Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE4798EB0
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 11:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732136AbfHVJFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 05:05:14 -0400
Received: from mga05.intel.com ([192.55.52.43]:6194 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732115AbfHVJFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 05:05:14 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 02:05:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,416,1559545200"; 
   d="scan'208";a="190504668"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.145])
  by orsmga002.jf.intel.com with ESMTP; 22 Aug 2019 02:05:11 -0700
Received: from andy by smile with local (Exim 4.92.1)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1i0j1p-0006Vi-8G; Thu, 22 Aug 2019 12:05:09 +0300
Date:   Thu, 22 Aug 2019 12:05:09 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc:     linux-acpi@vger.kernel.org,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Curtis Malainey <cujomalainey@chromium.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] ACPI / LPSS: Save/restore LPSS private registers also on
 Lynxpoint
Message-ID: <20190822090509.GK30120@smile.fi.intel.com>
References: <20190822083200.18150-1-jarkko.nikula@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822083200.18150-1-jarkko.nikula@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 22, 2019 at 11:32:00AM +0300, Jarkko Nikula wrote:
> My assumption in the commit b53548f9d9e4 ("spi: pxa2xx: Remove LPSS private
> register restoring during resume") that Intel Lynxpoint and compatible
> based chipsets may not need LPSS private registers saving and restoring
> over suspend/resume cycle turned out to be false on Intel Broadwell.
> 
> Curtis Malainey sent a patch bringing above change back and reported the
> LPSS SPI Chip Select control was lost over suspend/resume cycle on
> Broadwell machine.
> 
> Instead of reverting above commit lets add LPSS private register
> saving/restoring also for all LPSS SPI, I2C and UART controllers on
> Lynxpoint and compatible chipset to make sure context is not lost in
> case nothing else preserves it like firmware or if LPSS is always on.
> 

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Fixes: b53548f9d9e4 ("spi: pxa2xx: Remove LPSS private register restoring during resume")
> Reported-by: Curtis Malainey <cujomalainey@chromium.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
> ---
>  drivers/acpi/acpi_lpss.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index d696f165a50e..60bbc5090abe 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -219,12 +219,13 @@ static void bsw_pwm_setup(struct lpss_private_data *pdata)
>  }
>  
>  static const struct lpss_device_desc lpt_dev_desc = {
> -	.flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | LPSS_LTR,
> +	.flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | LPSS_LTR
> +			| LPSS_SAVE_CTX,
>  	.prv_offset = 0x800,
>  };
>  
>  static const struct lpss_device_desc lpt_i2c_dev_desc = {
> -	.flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_LTR,
> +	.flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_LTR | LPSS_SAVE_CTX,
>  	.prv_offset = 0x800,
>  };
>  
> @@ -236,7 +237,8 @@ static struct property_entry uart_properties[] = {
>  };
>  
>  static const struct lpss_device_desc lpt_uart_dev_desc = {
> -	.flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | LPSS_LTR,
> +	.flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | LPSS_LTR
> +			| LPSS_SAVE_CTX,
>  	.clk_con_id = "baudclk",
>  	.prv_offset = 0x800,
>  	.setup = lpss_uart_setup,
> -- 
> 2.23.0.rc1
> 

-- 
With Best Regards,
Andy Shevchenko



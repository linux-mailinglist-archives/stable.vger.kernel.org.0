Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33549DC0C7
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 11:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392050AbfJRJXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 05:23:04 -0400
Received: from mga03.intel.com ([134.134.136.65]:45040 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbfJRJXD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 05:23:03 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Oct 2019 02:23:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,311,1566889200"; 
   d="scan'208";a="190312549"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga008.jf.intel.com with ESMTP; 18 Oct 2019 02:23:00 -0700
Received: from andy by smile with local (Exim 4.92.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1iLOTM-0000TP-45; Fri, 18 Oct 2019 12:23:00 +0300
Date:   Fri, 18 Oct 2019 12:23:00 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] pinctrl: cherryview: Fix irq_valid_mask calculation
Message-ID: <20191018092300.GV32742@smile.fi.intel.com>
References: <20191018090842.11189-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018090842.11189-1-hdegoede@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 18, 2019 at 11:08:42AM +0200, Hans de Goede wrote:
> Commit 03c4749dd6c7 ("gpio / ACPI: Drop unnecessary ACPI GPIO to Linux
> GPIO translation") has made the cherryview gpio numbers sparse, to get
> a 1:1 mapping between ACPI pin numbers and gpio numbers in Linux.
> 
> This has greatly simplified things, but the code setting the
> irq_valid_mask was not updated for this, so the valid mask is still in
> the old "compressed" numbering with the gaps in the pin numbers skipped,
> which is wrong as irq_valid_mask needs to be expressed in gpio numbers.
> 
> This results in the following error on devices using pin 24 (0x0018) on
> the north GPIO controller as an ACPI event source:
> 
> [    0.422452] cherryview-pinctrl INT33FF:01: Failed to translate GPIO to IRQ
> 
> This has been reported (by email) to be happening on a Caterpillar CAT T20
> tablet and I've reproduced this myself on a Medion Akoya e2215t 2-in-1.
> 
> This commit uses the pin number instead of the compressed index into
> community->pins to clear the correct bits in irq_valid_mask for GPIOs
> using GPEs for interrupts, fixing these errors and in case of the
> Medion Akoya e2215t also fixing the LID switch not working.

Thanks!
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> 
> Cc: stable@vger.kernel.org
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> Fixes: 03c4749dd6c7 ("gpio / ACPI: Drop unnecessary ACPI GPIO to Linux GPIO translation")
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/pinctrl/intel/pinctrl-cherryview.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pinctrl/intel/pinctrl-cherryview.c b/drivers/pinctrl/intel/pinctrl-cherryview.c
> index aae51c507f59..02ff5e8b0510 100644
> --- a/drivers/pinctrl/intel/pinctrl-cherryview.c
> +++ b/drivers/pinctrl/intel/pinctrl-cherryview.c
> @@ -1563,7 +1563,7 @@ static void chv_init_irq_valid_mask(struct gpio_chip *chip,
>  		intsel >>= CHV_PADCTRL0_INTSEL_SHIFT;
>  
>  		if (intsel >= community->nirqs)
> -			clear_bit(i, valid_mask);
> +			clear_bit(desc->number, valid_mask);
>  	}
>  }
>  
> -- 
> 2.23.0
> 

-- 
With Best Regards,
Andy Shevchenko



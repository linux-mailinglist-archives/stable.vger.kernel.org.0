Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBA3D922C3
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 13:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbfHSLwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 07:52:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:53745 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbfHSLwX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 07:52:23 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 04:52:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,403,1559545200"; 
   d="scan'208";a="177859322"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.145])
  by fmsmga008.fm.intel.com with ESMTP; 19 Aug 2019 04:52:20 -0700
Received: from andy by smile with local (Exim 4.92.1)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1hzgCw-00055k-CD; Mon, 19 Aug 2019 14:52:18 +0300
Date:   Mon, 19 Aug 2019 14:52:18 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Ian W MORRISON <ianwmorrison@gmail.com>
Cc:     benjamin.tissoires@redhat.com, hdegoede@redhat.com,
        mika.westerberg@linux.intel.com, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com, linux-gpio@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] Skip deferred request irqs for devices known to fail
Message-ID: <20190819115218.GY30120@smile.fi.intel.com>
References: <20190819112637.29943-1-ianwmorrison@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819112637.29943-1-ianwmorrison@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 19, 2019 at 09:26:37PM +1000, Ian W MORRISON wrote:
> Patch ca876c7483b6 "gpiolib-acpi: make sure we trigger edge events at
> least once on boot" causes the MINIX family of mini PCs to fail to boot
> resulting in a "black screen".
> 
> This patch excludes MINIX devices from executing this trigger in order
> to successfully boot.

Thanks for an update.

> Cc: stable@vger.kernel.org
> Signed-off-by: Ian W MORRISON <ianwmorrison@gmail.com>
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>

> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Hmm... Did I really give the tag?
Too many stuff is going on, anyway, please consider more comments below.

First of all, the subject should start from "gpiolib: acpi: " prefix.

Then, Fixes tag seems to be missed.

> +/*
> + * Run deferred acpi_gpiochip_request_irqs()
> + * but exclude devices known to fail

Missed period.

> +*/

Missed leading space (the column of stars).

>  static int acpi_gpio_handle_deferred_request_irqs(void)
>  {
>  	struct acpi_gpio_chip *acpi_gpio, *tmp;
> +	const struct dmi_system_id *dmi_id;
>  
> -	mutex_lock(&acpi_gpio_deferred_req_irqs_lock);
> -	list_for_each_entry_safe(acpi_gpio, tmp,
> +	dmi_id = dmi_first_match(skip_deferred_request_irqs_table);
> +	if (dmi_id)
> +		return 0;

The idea of positive check is exactly for...

> +	else {

...getting rid of this redundant 'else' followed by unneeded level of indentation.

> +		mutex_lock(&acpi_gpio_deferred_req_irqs_lock);
> +		list_for_each_entry_safe(acpi_gpio, tmp,
>  				 &acpi_gpio_deferred_req_irqs_list,
>  				 deferred_req_irqs_list_entry)
> -		acpi_gpiochip_request_irqs(acpi_gpio);
> +			acpi_gpiochip_request_irqs(acpi_gpio);
>  
> -	acpi_gpio_deferred_req_irqs_done = true;
> -	mutex_unlock(&acpi_gpio_deferred_req_irqs_lock);
> +		acpi_gpio_deferred_req_irqs_done = true;
> +		mutex_unlock(&acpi_gpio_deferred_req_irqs_lock);
> +	}
>  
>  	return 0;
>  }

-- 
With Best Regards,
Andy Shevchenko



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFDFA7A69E
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 13:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbfG3LHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 07:07:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:57603 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730639AbfG3LHg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jul 2019 07:07:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jul 2019 04:07:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,326,1559545200"; 
   d="scan'208";a="371502145"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.145])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jul 2019 04:07:32 -0700
Received: from andy by smile with local (Exim 4.92)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1hsPyc-000293-LK; Tue, 30 Jul 2019 14:07:30 +0300
Date:   Tue, 30 Jul 2019 14:07:30 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org,
        Salvatore Bellizzi <salvatore.bellizzi@linux.seppia.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        egranata@chromium.org, egranata@google.com,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Gwendal Grignou <gwendal@chromium.org>,
        linux-acpi@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] driver core: platform: return -ENXIO for missing GpioInt
Message-ID: <20190730110730.GK23480@smile.fi.intel.com>
References: <20190729204954.25510-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729204954.25510-1-briannorris@chromium.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 01:49:54PM -0700, Brian Norris wrote:
> Commit daaef255dc96 ("driver: platform: Support parsing GpioInt 0 in
> platform_get_irq()") broke the Embedded Controller driver on most LPC
> Chromebooks (i.e., most x86 Chromebooks), because cros_ec_lpc expects
> platform_get_irq() to return -ENXIO for non-existent IRQs.
> Unfortunately, acpi_dev_gpio_irq_get() doesn't follow this convention
> and returns -ENOENT instead. So we get this error from cros_ec_lpc:
> 
>    couldn't retrieve IRQ number (-2)
> 
> I see a variety of drivers that treat -ENXIO specially, so rather than
> fix all of them, let's fix up the API to restore its previous behavior.
> 
> I reported this on v2 of this patch:
> 
> https://lore.kernel.org/lkml/20190220180538.GA42642@google.com/
> 
> but apparently the patch had already been merged before v3 got sent out:
> 
> https://lore.kernel.org/lkml/20190221193429.161300-1-egranata@chromium.org/
> 
> and the result is that the bug landed and remains unfixed.
> 
> I differ from the v3 patch by:
>  * allowing for ret==0, even though acpi_dev_gpio_irq_get() specifically
>    documents (and enforces) that 0 is not a valid return value (noted on
>    the v3 review)
>  * adding a small comment

Thank you for fixing this.
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> 
> Reported-by: Brian Norris <briannorris@chromium.org>
> Reported-by: Salvatore Bellizzi <salvatore.bellizzi@linux.seppia.net>
> Cc: Enrico Granata <egranata@chromium.org>
> Cc: <stable@vger.kernel.org>
> Fixes: daaef255dc96 ("driver: platform: Support parsing GpioInt 0 in platform_get_irq()")
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
> Side note: it might have helped alleviate some of this pain if there
> were email notifications to the mailing list when a patch gets applied.
> I didn't realize (and I'm not sure if Enrico did) that v2 was already
> merged by the time I noted its mistakes. If I had known, I would have
> suggested a follow-up patch, not a v3.
> 
> I know some maintainers' "tip bots" do this, but not all apparently.
> 
>  drivers/base/platform.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 506a0175a5a7..ec974ba9c0c4 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -157,8 +157,13 @@ int platform_get_irq(struct platform_device *dev, unsigned int num)
>  	 * the device will only expose one IRQ, and this fallback
>  	 * allows a common code path across either kind of resource.
>  	 */
> -	if (num == 0 && has_acpi_companion(&dev->dev))
> -		return acpi_dev_gpio_irq_get(ACPI_COMPANION(&dev->dev), num);
> +	if (num == 0 && has_acpi_companion(&dev->dev)) {
> +		int ret = acpi_dev_gpio_irq_get(ACPI_COMPANION(&dev->dev), num);
> +
> +		/* Our callers expect -ENXIO for missing IRQs. */
> +		if (ret >= 0 || ret == -EPROBE_DEFER)
> +			return ret;
> +	}
>  
>  	return -ENXIO;
>  #endif
> -- 
> 2.22.0.709.g102302147b-goog
> 

-- 
With Best Regards,
Andy Shevchenko



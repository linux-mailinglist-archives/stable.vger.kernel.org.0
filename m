Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1C1331497
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 18:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhCHRWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 12:22:17 -0500
Received: from mga03.intel.com ([134.134.136.65]:6750 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230301AbhCHRVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 12:21:49 -0500
IronPort-SDR: UbgkGT9IRSG+Lolmy8HHJ7wpugYxleHGlHxsH/dpJWgvBx0FgUatPSauclF2wb25sx95Pq2WXu
 5YeMAXQP6mgQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="188121581"
X-IronPort-AV: E=Sophos;i="5.81,232,1610438400"; 
   d="scan'208";a="188121581"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 09:21:48 -0800
IronPort-SDR: PR9cYkJIz9YxvF4N3z3Sbz3bfOm9dckVQUfzFdGIl+JspCU0hEFdbOS6e4IDfWkfutDeyeve7g
 4On0VsWMaIhw==
X-IronPort-AV: E=Sophos;i="5.81,232,1610438400"; 
   d="scan'208";a="447198966"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 09:21:46 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1lJJZg-00Arp4-2q; Mon, 08 Mar 2021 19:21:44 +0200
Date:   Mon, 8 Mar 2021 19:21:44 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>, stable@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>
Subject: Re: [PATCH v2 1/1] pinctrl: intel: Show the GPIO base calculation
 explicitly
Message-ID: <YEZdKLY2loUg66Ti@smile.fi.intel.com>
References: <20210308170842.88555-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308170842.88555-1-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 08, 2021 at 07:08:42PM +0200, Andy Shevchenko wrote:
> During the split of intel_pinctrl_add_padgroups(), the _by_size() variant
> missed the GPIO base calculations and hence made unable to retrieve proper
> GPIO number.
> 
> Assign the gpio_base explicitly in _by_size() variant.
> 
> While at it, differentiate NOMAP case with the rest in _by_gpps() variant.

Meanwhile pushed to my review and testing queue, thanks!

> Fixes: 036e126c72eb ("pinctrl: intel: Split intel_pinctrl_add_padgroups() for better maintenance")
> Reported-and-tested-by: Maximilian Luz <luzmaximilian@gmail.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
> v2: added tag and Cc'ed to stable@ (Mika)
>  drivers/pinctrl/intel/pinctrl-intel.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
> index 8085782cd8f9..7283203861ae 100644
> --- a/drivers/pinctrl/intel/pinctrl-intel.c
> +++ b/drivers/pinctrl/intel/pinctrl-intel.c
> @@ -1357,6 +1357,7 @@ static int intel_pinctrl_add_padgroups_by_gpps(struct intel_pinctrl *pctrl,
>  				gpps[i].gpio_base = 0;
>  				break;
>  			case INTEL_GPIO_BASE_NOMAP:
> +				break;
>  			default:
>  				break;
>  		}
> @@ -1393,6 +1394,7 @@ static int intel_pinctrl_add_padgroups_by_size(struct intel_pinctrl *pctrl,
>  		gpps[i].size = min(gpp_size, npins);
>  		npins -= gpps[i].size;
>  
> +		gpps[i].gpio_base = gpps[i].base;
>  		gpps[i].padown_num = padown_num;
>  
>  		/*
> -- 
> 2.30.1
> 

-- 
With Best Regards,
Andy Shevchenko



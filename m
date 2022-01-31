Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2A44A4DF9
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 19:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243942AbiAaSYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 13:24:10 -0500
Received: from mga07.intel.com ([134.134.136.100]:37369 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232361AbiAaSYJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Jan 2022 13:24:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643653449; x=1675189449;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lQzhqiT47y+P20hA+SEuOwsKyR/X5oa3XuqnTl9IAME=;
  b=RYvcL6jn8KFub9GXAPfdhNqPURVuE8o+GvRK12Y47EOUD3rYe0tVAgH9
   XcllJAOfni6KXpDrAFnbHFBWT2tLYzrD1lS6drAcjzY7LSXNfrqto9wpC
   GV7Sa50Z855WUqmnK7aikfE3TTJwRsoD+lSuT63UnjBiMzfITqPQDFxCX
   tVM0GvoINRjiQILbWFTIwsX3+rKGE4Xn0wONL4fPP3PbxXHYGN6qH1HMl
   nO5qQzviTqmpw0qSl7mVjImPfp/g5E/hTCn62IRXAtNgRWqsfxK3dosq8
   sdt7LlD2V8+alqdNAfyDEhaifchk6WQJkuigu/JdEgw471yg70lPotO6r
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="310831524"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="310831524"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 10:24:06 -0800
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="630111551"
Received: from smile.fi.intel.com ([10.237.72.61])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 10:24:01 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nEbKM-00GzDb-HB;
        Mon, 31 Jan 2022 20:22:58 +0200
Date:   Mon, 31 Jan 2022 20:22:58 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     quentin.schulz@theobroma-systems.com,
        Chris Morgan <macromorgan@hotmail.com>,
        Douglas Anderson <dianders@chromium.org>
Cc:     mturquette@baylibre.com, sboyd@kernel.org, heiko@sntech.de,
        linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Quentin Schulz <foss+kernel@0leil.net>
Subject: Re: [PATCH] clk: rockchip: re-add rational best approximation
 algorithm to the fractional divider
Message-ID: <YfgpAu2fjxMZrzxe@smile.fi.intel.com>
References: <20220131163224.708002-1-quentin.schulz@theobroma-systems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131163224.708002-1-quentin.schulz@theobroma-systems.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 05:32:24PM +0100, quentin.schulz@theobroma-systems.com wrote:
> From: Quentin Schulz <quentin.schulz@theobroma-systems.com>

Thanks for your report.

> In commit 4e7cf74fa3b2 ("clk: fractional-divider: Export approximation
> algorithm to the CCF users"), the code handling the rational best
> approximation algorithm was replaced by a call to the core
> clk_fractional_divider_general_approximation function which did the same
> thing back then.
> 
> However, in commit 82f53f9ee577 ("clk: fractional-divider: Introduce
> POWER_OF_TWO_PS flag"), this common code was made conditional on
> CLK_FRAC_DIVIDER_POWER_OF_TWO_PS flag which was not added back to the
> rockchip clock driver.
> 
> This broke the ltk050h3146w-a2 MIPI DSI display present on a PX30-based
> downstream board.
> 
> Let's add the flag to the fractional divider flags so that the original
> and intended behavior is brought back to the rockchip clock drivers.

I believe this was the result of the discussion about 1000 in DRM code.

I Cc'ed this to the people from 64ec4912c51a ("drm/rockchip: Update crtc
fixup to account for fractional clk change").

> Fixes: 82f53f9ee577 ("clk: fractional-divider: Introduce POWER_OF_TWO_PS flag")
> Cc: stable@vger.kernel.org
> Cc: Quentin Schulz <foss+kernel@0leil.net>
> Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
> ---
>  drivers/clk/rockchip/clk.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/clk/rockchip/clk.c b/drivers/clk/rockchip/clk.c
> index b7be7e11b0df..bb8a844309bf 100644
> --- a/drivers/clk/rockchip/clk.c
> +++ b/drivers/clk/rockchip/clk.c
> @@ -180,6 +180,7 @@ static void rockchip_fractional_approximation(struct clk_hw *hw,
>  		unsigned long rate, unsigned long *parent_rate,
>  		unsigned long *m, unsigned long *n)
>  {
> +	struct clk_fractional_divider *fd = to_clk_fd(hw);
>  	unsigned long p_rate, p_parent_rate;
>  	struct clk_hw *p_parent;
>  
> @@ -190,6 +191,8 @@ static void rockchip_fractional_approximation(struct clk_hw *hw,
>  		*parent_rate = p_parent_rate;
>  	}
>  
> +	fd->flags |= CLK_FRAC_DIVIDER_POWER_OF_TWO_PS;
> +
>  	clk_fractional_divider_general_approximation(hw, rate, parent_rate, m, n);
>  }

-- 
With Best Regards,
Andy Shevchenko



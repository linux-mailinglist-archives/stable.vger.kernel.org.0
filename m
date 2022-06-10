Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E332D546792
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 15:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbiFJNqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 09:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiFJNqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 09:46:33 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9AE22B35;
        Fri, 10 Jun 2022 06:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654868792; x=1686404792;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ravTgUnKG4C+bKIq95tFE0q0c60bszYzURjmYJ4owCY=;
  b=K7AyFHdPnXsk0KEWuJAxX7QZT133eEFKuejLuhSP4XcKmarPFG2JzYHx
   sLO8v4Dve6m07IAY2r4OUBjsgGLgC5n4FGaHB4U7pWlfMvY1HsI80G7YL
   Yi5cB2vTAMPycmSQyaerOQe+y/gEeUCTrqKQjZBekkYnlS3cvy3h5p/gT
   Qj4GfnBjhjKsrVGSXh/UfyJZZdH8R4mc/PmhqEB8Q7QF0CuzKYuscx6Ly
   t5jLOSQDb4y/Um+aZo9Fkd3JaMhn0NahioElwSXtoSmSfl389lcVYIOSn
   NHuS/7CZhZX3GCNrmb+9RO/9pdDWLZt8Thk+ybxU7fFCAqqFpB/HFEcmD
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="275165390"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="275165390"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 06:46:32 -0700
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="649839598"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 06:46:26 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nzexy-000YpF-0z;
        Fri, 10 Jun 2022 16:46:22 +0300
Date:   Fri, 10 Jun 2022 16:46:21 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Yury Norov <yury.norov@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Matt Turner <mattst88@gmail.com>,
        Brian Cain <bcain@quicinc.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Marco Elver <elver@google.com>, Borislav Petkov <bp@suse.de>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-alpha@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 1/6] ia64, processor: fix -Wincompatible-pointer-types
 in ia64_get_irr()
Message-ID: <YqNLLTAY0t62Jxq4@smile.fi.intel.com>
References: <20220610113427.908751-1-alexandr.lobakin@intel.com>
 <20220610113427.908751-2-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610113427.908751-2-alexandr.lobakin@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 10, 2022 at 01:34:22PM +0200, Alexander Lobakin wrote:
> test_bit(), as any other bitmap op, takes `unsigned long *` as a
> second argument (pointer to the actual bitmap), as any bitmap
> itself is an array of unsigned longs. However, the ia64_get_irr()
> code passes a ref to `u64` as a second argument.
> This works with the ia64 bitops implementation due to that they
> have `void *` as the second argument and then cast it later on.
> This works with the bitmap API itself due to that `unsigned long`
> has the same size on ia64 as `u64` (`unsigned long long`), but
> from the compiler PoV those two are different.
> Define @irr as `unsigned long` to fix that. That implies no
> functional changes. Has been hidden for 16 years!

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Fixes: a58786917ce2 ("[IA64] avoid broken SAL_CACHE_FLUSH implementations")
> Cc: stable@vger.kernel.org # 2.6.16+
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
>  arch/ia64/include/asm/processor.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/ia64/include/asm/processor.h b/arch/ia64/include/asm/processor.h
> index 7cbce290f4e5..757c2f6d8d4b 100644
> --- a/arch/ia64/include/asm/processor.h
> +++ b/arch/ia64/include/asm/processor.h
> @@ -538,7 +538,7 @@ ia64_get_irr(unsigned int vector)
>  {
>  	unsigned int reg = vector / 64;
>  	unsigned int bit = vector % 64;
> -	u64 irr;
> +	unsigned long irr;
>  
>  	switch (reg) {
>  	case 0: irr = ia64_getreg(_IA64_REG_CR_IRR0); break;
> -- 
> 2.36.1
> 

-- 
With Best Regards,
Andy Shevchenko



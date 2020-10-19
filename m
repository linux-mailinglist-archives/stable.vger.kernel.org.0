Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB0C29229F
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 08:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgJSGnX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 19 Oct 2020 02:43:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:42737 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbgJSGnX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Oct 2020 02:43:23 -0400
IronPort-SDR: MRMdegYoTZld922ofMxr8J/N1Jsm+effKO+gZuKJ34BZ3/myAZwbbUJ8HLLEuCiqUsHHR6A5rk
 QjqzbX1WR1yA==
X-IronPort-AV: E=McAfee;i="6000,8403,9778"; a="154768937"
X-IronPort-AV: E=Sophos;i="5.77,393,1596524400"; 
   d="scan'208";a="154768937"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2020 23:43:20 -0700
IronPort-SDR: fr80jlmgluxsrlngIvwH9H4IS2y9c7Z9lyMr4lkqG6er7vrl2/MWQHSQg3nzfOm9DLUZf/L3Bg
 z9DJnPLeF4GA==
X-IronPort-AV: E=Sophos;i="5.77,393,1596524400"; 
   d="scan'208";a="523000067"
Received: from gmanojku-mobl.ger.corp.intel.com (HELO localhost) ([10.252.4.169])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2020 23:43:17 -0700
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20201016152340.15906-1-sf@sfritsch.de>
References: <20201016152340.15906-1-sf@sfritsch.de>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Stefan Fritsch <sf@sfritsch.de>, stable@vger.kernel.org
To:     Stefan Fritsch <sf@sfritsch.de>, intel-gfx@lists.freedesktop.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [PATCH] drm/i915: Rate limit 'Fault errors' message
From:   Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Message-ID: <160308979457.4267.13628612734509793218@jlahtine-mobl.ger.corp.intel.com>
User-Agent: alot/0.8.1
Date:   Mon, 19 Oct 2020 09:43:15 +0300
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ Zhenyu & Zhi,

Should not we instead fix the reason why the errors happen instead of
rate-limiting them?

Regards, Joonas

Quoting Stefan Fritsch (2020-10-16 18:23:40)
> If linux is running as a guest and the host is doing igd pass-through
> with VT-d enabled, this message is logged dozens of times per second.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Stefan Fritsch <sf@sfritsch.de>
> ---
> 
> The i915 driver should also detect VT-d in this case, but that is a
> different issue.  I have sent a separate mail with subject 'Detecting
> Vt-d when running as guest os'.
> 
> 
>  drivers/gpu/drm/i915/i915_irq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
> index 759f523c6a6b..29096634e697 100644
> --- a/drivers/gpu/drm/i915/i915_irq.c
> +++ b/drivers/gpu/drm/i915/i915_irq.c
> @@ -2337,7 +2337,7 @@ gen8_de_irq_handler(struct drm_i915_private *dev_priv, u32 master_ctl)
>  
>                 fault_errors = iir & gen8_de_pipe_fault_mask(dev_priv);
>                 if (fault_errors)
> -                       drm_err(&dev_priv->drm,
> +                       drm_err_ratelimited(&dev_priv->drm,
>                                 "Fault errors on pipe %c: 0x%08x\n",
>                                 pipe_name(pipe),
>                                 fault_errors);
> -- 
> 2.28.0
> 

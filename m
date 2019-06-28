Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D58625916F
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 04:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfF1Cpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 22:45:39 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:35018 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbfF1Cpi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 22:45:38 -0400
Received: by mail-oi1-f193.google.com with SMTP id a127so3173235oii.2
        for <stable@vger.kernel.org>; Thu, 27 Jun 2019 19:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PMKZ8BEHKvEYdxNcG4BmGK541+ZJ0zqQanPAbjMM/80=;
        b=d+NvPoVQLAcSwFaypnYtbksDd4NeutRV0QFkGivUk8+1RIoDVBfvXTKXHMnKX5ACMg
         SSABdjUbVVqcIy6QgYQVE3BHBhp4WJCoQecMvjaDW7+JWDS+678zjU0FkbRvKhh0xuZj
         WiQ/BOirHtW4sj7HZC+prOsT7vZDKsadxBxH5Hq/sT55KWk1iHYw30yE9FWM5sAJquR4
         HUBVK1PANQGGAYjUyHa4NXq/fIY9b4UeJG5MhkYkJV9SJ7gTfqZDCU4WNWhuteXUtDwY
         XLEBsXPF75cYOSvRDGkLEE7qYAerv1M5CNiA4l0U7lf0Z+gmqKB9FwgP2BEiPS9i605o
         WXEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PMKZ8BEHKvEYdxNcG4BmGK541+ZJ0zqQanPAbjMM/80=;
        b=nux6P3/u10/JRMuOYCO+rS/nUe6t8DsL0V6KnlJ/i7MfvbAov/1wRfZoA9OVDvJ3K2
         LlzUd5/eSdiXvGDiCS6VrZFAFRI/cqHDEGoLQDk/2evGzWvFvFg5w7Sq+v1rExBn1oA4
         S5j8W7+urRZVz8VJH38z1lcBwu5ZL1rwjuMV80ndjmLeOuXbF2XDRBnQvDdrXzoOlTNi
         GklTS3IM9LTXAVOLuPy/MD8Gmryi210R1IKbD/sQTMmNkAhPPKHVGkLb2UmcrM2WK7qm
         OuWxbmzO5zClaiHt1zH4Luqx879ifpjtZ19x+SUIIzCnTrEbxxSw3UvN2DElNBKg3g9c
         VfEw==
X-Gm-Message-State: APjAAAV0P45sPq143rkTIfTfC6mr343QABRXewPiDsCpNmmxvyg9Ya2J
        3efxzQyreQuBiAZwKdeuQjdBmA==
X-Google-Smtp-Source: APXvYqyaI8LbpjqN2Z+o/n9LADwl2AElxmchikVcZ7H9wSMGZMuKlk0AhN20VWhwhEutViRPfwDLQA==
X-Received: by 2002:aca:a896:: with SMTP id r144mr367546oie.105.1561689937963;
        Thu, 27 Jun 2019 19:45:37 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (li964-79.members.linode.com. [45.33.10.79])
        by smtp.gmail.com with ESMTPSA id f39sm432863otb.57.2019.06.27.19.45.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Jun 2019 19:45:36 -0700 (PDT)
Date:   Fri, 28 Jun 2019 10:45:29 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Andrew Murray <andrew.murray@arm.com>
Cc:     Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        coresight@lists.linaro.org, Sudeep Holla <sudeep.holla@arm.com>,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Leach <mike.leach@linaro.org>
Subject: Re: [PATCH v2 2/5] coresight: etm4x: use explicit barriers on
 enable/disable
Message-ID: <20190628024529.GC20296@leoy-ThinkPad-X240s>
References: <20190627083525.37463-1-andrew.murray@arm.com>
 <20190627083525.37463-3-andrew.murray@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627083525.37463-3-andrew.murray@arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrew,

On Thu, Jun 27, 2019 at 09:35:22AM +0100, Andrew Murray wrote:
> Synchronization is recommended before disabling the trace registers
> to prevent any start or stop points being speculative at the point
> of disabling the unit (section 7.3.77 of ARM IHI 0064D).
> 
> Synchronization is also recommended after programming the trace
> registers to ensure all updates are committed prior to normal code
> resuming (section 4.3.7 of ARM IHI 0064D).
> 
> Let's ensure these syncronization points are present in the code
> and clearly commented.
> 
> Note that we could rely on the barriers in CS_LOCK and
> coresight_disclaim_device_unlocked or the context switch to user
> space - however coresight may be of use in the kernel.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> CC: stable@vger.kernel.org
> ---
>  drivers/hwtracing/coresight/coresight-etm4x.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
> index c89190d464ab..68e8e3954cef 100644
> --- a/drivers/hwtracing/coresight/coresight-etm4x.c
> +++ b/drivers/hwtracing/coresight/coresight-etm4x.c
> @@ -188,6 +188,10 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
>  		dev_err(etm_dev,
>  			"timeout while waiting for Idle Trace Status\n");
>  
> +	/* As recommended by 4.3.7 of ARM IHI 0064D */
> +	dsb(sy);
> +	isb();
> +

I read the spec, it recommends to use dsb/isb after accessing trace
unit, so here I think dsb(sy) is the most safe way.

arm64 defines barrier in arch/arm64/include/asm/barrier.h:

  #define mb()            dsb(sy)

so here I suggest to use barriers:

  mb();
  isb();

I wrongly assumed that mb() is for dmb operations, but actually it's
defined for dsb operation.  So we should use it and this is a common
function between arm64 and arm.

>  done:
>  	CS_LOCK(drvdata->base);
>  
> @@ -454,7 +458,8 @@ static void etm4_disable_hw(void *info)
>  	control &= ~0x1;
>  
>  	/* make sure everything completes before disabling */
> -	mb();
> +	/* As recommended by 7.3.77 of ARM IHI 0064D */
> +	dsb(sy);

Here the old code should be right, mb() is the same thing with
dsb(sy).

So we don't need to change at here?

Thanks,
Leo Yan

>  	isb();
>  	writel_relaxed(control, drvdata->base + TRCPRGCTLR);
>  
> -- 
> 2.21.0
> 
> _______________________________________________
> CoreSight mailing list
> CoreSight@lists.linaro.org
> https://lists.linaro.org/mailman/listinfo/coresight

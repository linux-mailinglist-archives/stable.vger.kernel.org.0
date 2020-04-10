Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 254C61A47BD
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 17:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgDJPE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 11:04:57 -0400
Received: from 9.mo178.mail-out.ovh.net ([46.105.75.45]:39734 "EHLO
        9.mo178.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbgDJPE4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Apr 2020 11:04:56 -0400
X-Greylist: delayed 4197 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Apr 2020 11:04:55 EDT
Received: from player716.ha.ovh.net (unknown [10.110.171.131])
        by mo178.mail-out.ovh.net (Postfix) with ESMTP id D69349A618
        for <stable@vger.kernel.org>; Fri, 10 Apr 2020 15:47:11 +0200 (CEST)
Received: from etezian.org (213-243-141-64.bb.dnainternet.fi [213.243.141.64])
        (Authenticated sender: andi@etezian.org)
        by player716.ha.ovh.net (Postfix) with ESMTPSA id 634EA113C45CA;
        Fri, 10 Apr 2020 13:47:08 +0000 (UTC)
Date:   Fri, 10 Apr 2020 16:47:02 +0300
From:   Andi Shyti <andi@etezian.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] agp/intel: Reinforce the barrier after GTT
 updates
Message-ID: <20200410134702.GA264232@jack.zhora.eu>
References: <20200410083347.25128-1-chris@chris-wilson.co.uk>
 <20200410083535.25464-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200410083535.25464-1-chris@chris-wilson.co.uk>
X-Ovh-Tracer-Id: 8709680207301296649
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrvddvgdejtdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughiucfuhhihthhiuceorghnughisegvthgviihirghnrdhorhhgqeenucfkpheptddrtddrtddrtddpvddufedrvdegfedrudeguddrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrjeduiedrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegrnhguihesvghtvgiiihgrnhdrohhrghdprhgtphhtthhopehsthgrsghlvgesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Chris,

> After changing the timing between GTT updates and execution on the GPU,
> we started seeing sporadic failures on Ironlake. These were narrowed
> down to being an insufficiently strong enough barrier/delay after
> updating the GTT and scheduling execution on the GPU. By forcing the
> uncached read, and adding the missing barrier for the singular
> insert_page (relocation paths), the sporadic failures go away.
> 
> Fixes: 983d308cb8f6 ("agp/intel: Serialise after GTT updates")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: stable@vger.kernel.org # v4.0+

Acked-by: Andi Shyti <andi.shyti@intel.com>

Andi

> ---
>  drivers/char/agp/intel-gtt.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
> index 66a62d17a3f5..3d42fc4290bc 100644
> --- a/drivers/char/agp/intel-gtt.c
> +++ b/drivers/char/agp/intel-gtt.c
> @@ -846,6 +846,7 @@ void intel_gtt_insert_page(dma_addr_t addr,
>  			   unsigned int flags)
>  {
>  	intel_private.driver->write_entry(addr, pg, flags);
> +	readl(intel_private.gtt + pg);
>  	if (intel_private.driver->chipset_flush)
>  		intel_private.driver->chipset_flush();
>  }
> @@ -871,7 +872,7 @@ void intel_gtt_insert_sg_entries(struct sg_table *st,
>  			j++;
>  		}
>  	}
> -	wmb();
> +	readl(intel_private.gtt + j - 1);
>  	if (intel_private.driver->chipset_flush)
>  		intel_private.driver->chipset_flush();
>  }
> @@ -1105,6 +1106,7 @@ static void i9xx_cleanup(void)
>  
>  static void i9xx_chipset_flush(void)
>  {
> +	wmb();
>  	if (intel_private.i9xx_flush_page)
>  		writel(1, intel_private.i9xx_flush_page);
>  }

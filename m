Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6585124FC01
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 12:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgHXKyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 06:54:07 -0400
Received: from mga14.intel.com ([192.55.52.115]:5643 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726632AbgHXKyD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 06:54:03 -0400
IronPort-SDR: dD5T2zKr8qWhsemCroLdlAO6zpE6hiyHrD3gITFpw+cr9duHj1XoeFWPR38v7ku4A7rmF5kJwi
 BJPZNhmncr5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9722"; a="155133236"
X-IronPort-AV: E=Sophos;i="5.76,348,1592895600"; 
   d="scan'208";a="155133236"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 03:54:02 -0700
IronPort-SDR: q/FUI6k4PalzOzZOZ64YwEVu+gSnV1+yhqRPLUns7XMsRRX0hbowqXMC/EpxPpHrUxe6AT4lub
 H3HHQr7PayOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,348,1592895600"; 
   d="scan'208";a="372643675"
Received: from gaia.fi.intel.com ([10.237.72.192])
  by orsmga001.jf.intel.com with ESMTP; 24 Aug 2020 03:54:01 -0700
Received: by gaia.fi.intel.com (Postfix, from userid 1000)
        id 13B585C276C; Mon, 24 Aug 2020 13:53:08 +0300 (EEST)
From:   Mika Kuoppala <mika.kuoppala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Break up error capture compression loops with cond_resched()
In-Reply-To: <20200820141546.21194-1-chris@chris-wilson.co.uk>
References: <20200820141546.21194-1-chris@chris-wilson.co.uk>
Date:   Mon, 24 Aug 2020 13:53:08 +0300
Message-ID: <877dto1fjf.fsf@gaia.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chris Wilson <chris@chris-wilson.co.uk> writes:

> As the error capture will compress user buffers as directed to by the
> user, it can take an arbitrary amount of time and space. Break up the
> compression loops with a call to cond_resched(), that will allow other
> processes to schedule (avoiding the soft lockups) and also serve as a
> warning should we try to make this loop atomic in the future.
>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>

> ---
>  drivers/gpu/drm/i915/i915_gpu_error.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/i915_gpu_error.c b/drivers/gpu/drm/i915/i915_gpu_error.c
> index 6a3a2ce0b394..6551ff04d5a6 100644
> --- a/drivers/gpu/drm/i915/i915_gpu_error.c
> +++ b/drivers/gpu/drm/i915/i915_gpu_error.c
> @@ -311,6 +311,8 @@ static int compress_page(struct i915_vma_compress *c,
>  
>  		if (zlib_deflate(zstream, Z_NO_FLUSH) != Z_OK)
>  			return -EIO;
> +
> +		cond_resched();
>  	} while (zstream->avail_in);
>  
>  	/* Fallback to uncompressed if we increase size? */
> @@ -397,6 +399,7 @@ static int compress_page(struct i915_vma_compress *c,
>  	if (!(wc && i915_memcpy_from_wc(ptr, src, PAGE_SIZE)))
>  		memcpy(ptr, src, PAGE_SIZE);
>  	dst->pages[dst->page_count++] = ptr;
> +	cond_resched();
>  
>  	return 0;
>  }
> -- 
> 2.20.1

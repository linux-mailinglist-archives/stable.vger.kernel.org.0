Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FC9327C28
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234446AbhCAKaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234251AbhCAKaD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:30:03 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E02C06178B
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 02:28:32 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <l.stach@pengutronix.de>)
        id 1lGfmw-00045g-S2; Mon, 01 Mar 2021 11:28:30 +0100
Message-ID: <f0e85747e101a9078f1e1d158f1eea29a9f31684.camel@pengutronix.de>
Subject: Re: [PATCH 1/2] drm/etnaviv: Use FOLL_FORCE for userptr
From:   Lucas Stach <l.stach@pengutronix.de>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>
Cc:     stable@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        etnaviv@lists.freedesktop.org
Date:   Mon, 01 Mar 2021 11:28:30 +0100
In-Reply-To: <20210301095254.1946084-1-daniel.vetter@ffwll.ch>
References: <20210301095254.1946084-1-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Montag, dem 01.03.2021 um 10:52 +0100 schrieb Daniel Vetter:
> Nothing checks userptr.ro except this call to pup_fast, which means
> there's nothing actually preventing userspace from writing to this.
> Which means you can just read-only mmap any file you want, userptr it
> and then write to it with the gpu. Not good.

I agree about the "not good" part.

> The right way to handle this is FOLL_WRITE | FOLL_FORCE, which will
> break any COW mappings and update tracking for MAY_WRITE mappings so
> there's no exploit and the vm isn't confused about what's going on.
> For any legit use case there's no difference from what userspace can
> observe and do.

This however seems pretty heavy handed. Does this mean we do a full COW
cycle of the userpages on BO creation? This most likely kills a lot of
the performance benefits that one might seek by using userptr. If
that's the case I might still take this patch for stable, but then we
should rather just disallow writable GPU mappings to this BO.

Regards,
Lucas

> 
> Cc: stable@vger.kernel.org
> Cc: John Hubbard <jhubbard@nvidia.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Lucas Stach <l.stach@pengutronix.de>
> Cc: Russell King <linux+etnaviv@armlinux.org.uk>
> Cc: Christian Gmeiner <christian.gmeiner@gmail.com>
> Cc: etnaviv@lists.freedesktop.org
> ---
>  drivers/gpu/drm/etnaviv/etnaviv_gem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem.c b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
> index 6d38c5c17f23..a9e696d05b33 100644
> --- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
> +++ b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
> @@ -689,7 +689,7 @@ static int etnaviv_gem_userptr_get_pages(struct etnaviv_gem_object *etnaviv_obj)
>  		struct page **pages = pvec + pinned;
>  
> 
> 
> 
> 
> 
> 
> 
>  		ret = pin_user_pages_fast(ptr, num_pages,
> -					  !userptr->ro ? FOLL_WRITE : 0, pages);
> +					  FOLL_WRITE | FOLL_FORCE, pages);
>  		if (ret < 0) {
>  			unpin_user_pages(pvec, pinned);
>  			kvfree(pvec);



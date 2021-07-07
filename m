Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECECE3BE6AC
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 12:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbhGGKzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 06:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbhGGKzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Jul 2021 06:55:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A969AC061574
        for <stable@vger.kernel.org>; Wed,  7 Jul 2021 03:52:31 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <l.stach@pengutronix.de>)
        id 1m15AK-0007KA-CP; Wed, 07 Jul 2021 12:52:28 +0200
Message-ID: <099ef9f1cd1b865afd9cb8849d5485776ad1b868.camel@pengutronix.de>
Subject: Re: [PATCH AUTOSEL 5.13 001/189] drm/etnaviv: fix NULL check before
 some freeing functions is not needed
From:   Lucas Stach <l.stach@pengutronix.de>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Tian Tao <tiantao6@hisilicon.com>,
        Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Date:   Wed, 07 Jul 2021 12:52:25 +0200
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Dienstag, dem 06.07.2021 um 07:11 -0400 schrieb Sasha Levin:
> From: Tian Tao <tiantao6@hisilicon.com>
> 
> [ Upstream commit 7d614ab2f20503ed8766363d41f8607337571adf ]
> 
> fixed the below warning:
> drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c:84:2-8: WARNING: NULL check
> before some freeing functions is not needed.

While the subject contains "fix" this only removes a duplicated NULL
check, so the code is correct before and after this change.
Is this really stable material? Doesn't this just add commit noise to
the stable kernels?

Regards,
Lucas

> 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> Acked-by: Christian König <christian.koenig@amd.com>
> Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c b/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
> index b390dd4d60b7..d741b1d735f7 100644
> --- a/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
> +++ b/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
> @@ -80,8 +80,7 @@ static void etnaviv_gem_prime_release(struct etnaviv_gem_object *etnaviv_obj)
>  	/* Don't drop the pages for imported dmabuf, as they are not
>  	 * ours, just free the array we allocated:
>  	 */
> -	if (etnaviv_obj->pages)
> -		kvfree(etnaviv_obj->pages);
> +	kvfree(etnaviv_obj->pages);
>  
>  	drm_prime_gem_destroy(&etnaviv_obj->base, etnaviv_obj->sgt);
>  }



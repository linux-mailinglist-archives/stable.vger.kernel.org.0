Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F2D1D94B3
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 12:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728738AbgESKsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 06:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbgESKsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 06:48:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72630C061A0C
        for <stable@vger.kernel.org>; Tue, 19 May 2020 03:48:40 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=localhost)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <l.stach@pengutronix.de>)
        id 1jaznZ-00060D-Ht; Tue, 19 May 2020 12:48:37 +0200
Message-ID: <074a3a7c83c87f5265eec69c150f8f993bd787da.camel@pengutronix.de>
Subject: Re: [PATCH v2] drm/etnaviv: fix perfmon domain interation
From:   Lucas Stach <l.stach@pengutronix.de>
To:     Christian Gmeiner <christian.gmeiner@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, etnaviv@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Date:   Tue, 19 May 2020 12:48:35 +0200
In-Reply-To: <20200519053019.48376-1-christian.gmeiner@gmail.com>
References: <20200519053019.48376-1-christian.gmeiner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Dienstag, den 19.05.2020, 07:30 +0200 schrieb Christian Gmeiner:
> The GC860 has one GPU device which has a 2d and 3d core. In this case
> we want to expose perfmon information for both cores.
> 
> The driver has one array which contains all possible perfmon domains
> with some meta data - doms_meta. Here we can see that for the GC860
> two elements of that array are relevant:
> 
>   doms_3d: is at index 0 in the doms_meta array with 8 perfmon domains
>   doms_2d: is at index 1 in the doms_meta array with 1 perfmon domain
> 
> The userspace driver wants to get a list of all perfmon domains and
> their perfmon signals. This is done by iterating over all domains and
> their signals. If the userspace driver wants to access the domain with
> id 8 the kernel driver fails and returns invalid data from doms_3d with
> and invalid offset.
> 
> This results in:
>   Unable to handle kernel paging request at virtual address 00000000
> 
> On such a device it is not possible to use the userspace driver at all.
> 
> The fix for this off-by-one error is quite simple.
> 
> Reported-by: Paul Cercueil <paul@crapouillou.net>
> Tested-by: Paul Cercueil <paul@crapouillou.net>
> Fixes: ed1dd899baa3 ("drm/etnaviv: rework perfmon query infrastructure")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>

Thanks, applied to etnaviv/fixes.

Regards,
Lucas

> ---
>  drivers/gpu/drm/etnaviv/etnaviv_perfmon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> index e6795bafcbb9..75f9db8f7bec 100644
> --- a/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> +++ b/drivers/gpu/drm/etnaviv/etnaviv_perfmon.c
> @@ -453,7 +453,7 @@ static const struct etnaviv_pm_domain *pm_domain(const struct etnaviv_gpu *gpu,
>  		if (!(gpu->identity.features & meta->feature))
>  			continue;
>  
> -		if (meta->nr_domains < (index - offset)) {
> +		if (index - offset >= meta->nr_domains) {
>  			offset += meta->nr_domains;
>  			continue;
>  		}


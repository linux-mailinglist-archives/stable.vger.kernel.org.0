Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9EC28D1DD
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 18:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729707AbgJMQKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 12:10:37 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:51318 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726482AbgJMQKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 12:10:36 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Oct 2020 12:10:36 EDT
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 13 Oct 2020 08:55:31 -0700
Received: from [0.0.0.0] (oddjob.vmware.com [10.253.4.32])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 4DC1320925;
        Tue, 13 Oct 2020 08:55:32 -0700 (PDT)
Subject: Re: [PATCH 5.8 050/124] drm/vmwgfx: Fix error handling in get_node
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Zack Rusin <zackr@vmware.com>,
        Martin Krastev <krastevm@vmware.com>,
        Sasha Levin <sashal@kernel.org>
References: <20201012133146.834528783@linuxfoundation.org>
 <20201012133149.276124624@linuxfoundation.org>
From:   Roland Scheidegger <sroland@vmware.com>
Message-ID: <703ec8e7-f036-948d-f155-73f0c946aeba@vmware.com>
Date:   Tue, 13 Oct 2020 17:55:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201012133149.276124624@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Received-SPF: None (EX13-EDG-OU-002.vmware.com: sroland@vmware.com does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

this commit should NOT be applied to 5.8.
It fixes a regression introduced by
58e4d686d456c3e356439ae160ff4a0728940b8e (drm/ttm: cleanup
ttm_mem_type_manager_func.get_node interface v3) which is part of 5.9
but not 5.8.
Applying this to 5.8 will very likely break things. I don't know why it
ended up as a candidate for 5.8.

Roland

Am 12.10.20 um 15:30 schrieb Greg Kroah-Hartman:
> From: Zack Rusin <zackr@vmware.com>
> 
> [ Upstream commit f54c4442893b8dfbd3aff8e903c54dfff1aef990 ]
> 
> ttm_mem_type_manager_func.get_node was changed to return -ENOSPC
> instead of setting the node pointer to NULL. Unfortunately
> vmwgfx still had two places where it was explicitly converting
> -ENOSPC to 0 causing regressions. This fixes those spots by
> allowing -ENOSPC to be returned. That seems to fix recent
> regressions with vmwgfx.
> 
> Signed-off-by: Zack Rusin <zackr@vmware.com>
> Reviewed-by: Roland Scheidegger <sroland@vmware.com>
> Reviewed-by: Martin Krastev <krastevm@vmware.com>
> Sigend-off-by: Roland Scheidegger <sroland@vmware.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c | 2 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_thp.c           | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c b/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
> index 7da752ca1c34b..b93c558dd86e0 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
> @@ -57,7 +57,7 @@ static int vmw_gmrid_man_get_node(struct ttm_mem_type_manager *man,
>  
>  	id = ida_alloc_max(&gman->gmr_ida, gman->max_gmr_ids - 1, GFP_KERNEL);
>  	if (id < 0)
> -		return (id != -ENOMEM ? 0 : id);
> +		return id;
>  
>  	spin_lock(&gman->lock);
>  
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_thp.c b/drivers/gpu/drm/vmwgfx/vmwgfx_thp.c
> index b7c816ba71663..c8b9335bccd8d 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_thp.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_thp.c
> @@ -95,7 +95,7 @@ found_unlock:
>  		mem->start = node->start;
>  	}
>  
> -	return 0;
> +	return ret;
>  }
>  
>  
> 


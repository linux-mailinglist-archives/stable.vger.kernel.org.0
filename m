Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A77321CA04
	for <lists+stable@lfdr.de>; Sun, 12 Jul 2020 17:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbgGLPe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jul 2020 11:34:57 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:36910 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728840AbgGLPe5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jul 2020 11:34:57 -0400
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 3AC83514;
        Sun, 12 Jul 2020 17:34:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1594568095;
        bh=iaw7tkJBmoWtYDNarq2CsG9BuZ73n7i1IlTNN+2hqTo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lYXQlARBLpxQ1ri9ctH2+r0Pdzroh6m4p1ODUy4SXLyF53aUv0LUQRn19E9urWwUS
         EQcuZjNtVqP3U8Eo2h8d14m1oMAApi4V5euj8Qdd/RrzLLgnCst31B7RVwCo46lHsI
         0iMl0Y1bxciU+iBNvFjRiSyw0VVzKdPWKEg2qfMc=
Date:   Sun, 12 Jul 2020 18:34:49 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     trix@redhat.com
Cc:     a.hajda@samsung.com, narmstrong@baylibre.com, jonas@kwiboo.se,
        jernej.skrabec@siol.net, airlied@linux.ie, daniel@ffwll.ch,
        architt@codeaurora.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] drm/bridge: sil_sii8620: initialize return of
 sii8620_readb
Message-ID: <20200712153449.GA6642@pendragon.ideasonboard.com>
References: <20200712152453.27510-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200712152453.27510-1-trix@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tom,

Thank you for the patch.

On Sun, Jul 12, 2020 at 08:24:53AM -0700, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> clang static analysis flags this error
> 
> sil-sii8620.c:184:2: warning: Undefined or garbage value
>   returned to caller [core.uninitialized.UndefReturn]
>         return ret;
>         ^~~~~~~~~~
> 
> sii8620_readb calls sii8620_read_buf.
> sii8620_read_buf can return without setting its output
> pararmeter 'ret'.
> 
> So initialize ret.
> 
> Fixes: ce6e153f414a ("drm/bridge: add Silicon Image SiI8620 driver")
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/gpu/drm/bridge/sil-sii8620.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/bridge/sil-sii8620.c b/drivers/gpu/drm/bridge/sil-sii8620.c
> index 3540e4931383..da933d477e5f 100644
> --- a/drivers/gpu/drm/bridge/sil-sii8620.c
> +++ b/drivers/gpu/drm/bridge/sil-sii8620.c
> @@ -178,7 +178,7 @@ static void sii8620_read_buf(struct sii8620 *ctx, u16 addr, u8 *buf, int len)
>  
>  static u8 sii8620_readb(struct sii8620 *ctx, u16 addr)
>  {
> -	u8 ret;
> +	u8 ret = 0;
>  
>  	sii8620_read_buf(ctx, addr, &ret, 1);
>  	return ret;

-- 
Regards,

Laurent Pinchart

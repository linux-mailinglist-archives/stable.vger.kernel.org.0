Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587A421DB0B
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 18:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbgGMQAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 12:00:17 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:49570 "EHLO
        asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729782AbgGMQAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jul 2020 12:00:17 -0400
Received: from ravnborg.org (unknown [188.228.123.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asavdk4.altibox.net (Postfix) with ESMTPS id 9E7538048A;
        Mon, 13 Jul 2020 18:00:11 +0200 (CEST)
Date:   Mon, 13 Jul 2020 18:00:10 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     trix@redhat.com
Cc:     a.hajda@samsung.com, narmstrong@baylibre.com,
        Laurent.pinchart@ideasonboard.com, jonas@kwiboo.se,
        jernej.skrabec@siol.net, airlied@linux.ie, daniel@ffwll.ch,
        architt@codeaurora.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/bridge: sil_sii8620: initialize return of
 sii8620_readb
Message-ID: <20200713160010.GA1223330@ravnborg.org>
References: <20200712152453.27510-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200712152453.27510-1-trix@redhat.com>
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=aP3eV41m c=1 sm=1 tr=0
        a=S6zTFyMACwkrwXSdXUNehg==:117 a=S6zTFyMACwkrwXSdXUNehg==:17
        a=kj9zAlcOel0A:10 a=20KFwNOVAAAA:8 a=e5mUnYsNAAAA:8
        a=O_S-2KurR925GvWnQ7MA:9 a=CjuIK1q_8ugA:10 a=Vxmtnl_E_bksehYqCbjh:22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tom.

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

Thnaks, applied to drm-misc-next as the fix is not urgent.

	Sam

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
> -- 
> 2.18.1
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D353D214DDF
	for <lists+stable@lfdr.de>; Sun,  5 Jul 2020 17:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgGEP6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jul 2020 11:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727843AbgGEP6Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jul 2020 11:58:25 -0400
Received: from smtp.domeneshop.no (smtp.domeneshop.no [IPv6:2a01:5b40:0:3005::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5931CC061794
        for <stable@vger.kernel.org>; Sun,  5 Jul 2020 08:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tronnes.org
        ; s=ds201912; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:References:Cc:To:Subject:From:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NHevZJPUkjg54LOPyXWTmOALzTwaDHaAfPBRFrHmVf0=; b=Y03bGvTD32hKlEebGxu9pVvp6F
        iQoIsYXOXAZSnnVj4UC9eAfVZQ26XN1QU5cVgOioREGDSq/yf9i4ZzYBufEK/s4JC27DI0ECfy0zA
        ms7+t+aMqa49Q6rJmfuvbe7CAf31WyZstwJHY3l7zaoVhD3lpZhQaEhQwwP1EtZgesWzA8SG+vdll
        sksnG7f8NKyqqidBc0v9svMibBJ9G3MUg3l+MbDDe7d9o6VIqfVzKAsRlQKbCz1qyvolt5e/omWEU
        U2YuvN9PBA+6RQsZJrOuFfX+OSrlz8uhJoHmz11ORT5u2joutANDReIJl8xR0PNQDSC33g45Wx5rv
        OAdfSMVA==;
Received: from 211.81-166-168.customer.lyse.net ([81.166.168.211]:55281 helo=[192.168.10.61])
        by smtp.domeneshop.no with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <noralf@tronnes.org>)
        id 1js724-0003uP-St; Sun, 05 Jul 2020 17:58:20 +0200
From:   =?UTF-8?Q?Noralf_Tr=c3=b8nnes?= <noralf@tronnes.org>
Subject: Re: [PATCH] drm/dbi: Fix SPI Type 1 (9-bit) transfer
To:     Paul Cercueil <paul@crapouillou.net>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>
Cc:     dri-devel@lists.freedesktop.org, Sam Ravnborg <sam@ravnborg.org>,
        stable@vger.kernel.org
References: <20200703141341.1266263-1-paul@crapouillou.net>
Message-ID: <0dda6b3f-ea8c-6a7e-5c7c-f26874b825c8@tronnes.org>
Date:   Sun, 5 Jul 2020 17:58:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200703141341.1266263-1-paul@crapouillou.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Den 03.07.2020 16.13, skrev Paul Cercueil:
> The function mipi_dbi_spi1_transfer() will transfer its payload as 9-bit
> data, the 9th (MSB) bit being the data/command bit. In order to do that,
> it unpacks the 8-bit values into 16-bit values, then sets the 9th bit if
> the byte corresponds to data, clears it otherwise. The 7 MSB are
> padding. The array of now 16-bit values is then passed to the SPI core
> for transfer.
> 
> This function was broken since its introduction, as the length of the
> SPI transfer was set to the payload size before its conversion, but the
> payload doubled in size due to the 8-bit -> 16-bit conversion.
> 
> Fixes: 02dd95fe3169 ("drm/tinydrm: Add MIPI DBI support")
> Cc: <stable@vger.kernel.org> # 4.10

The code was moved to drm_mipi_dbi.c in 5.4 so this patch won't apply
before that.

> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---

Thanks for fixing this, clearly I didn't test this. Probably because the
aux spi ip block on the Raspberry Pi that can do 9 bit didn't have a
driver at the time. Did you actually test this or was it spotted reading
the code?

Reviewed-by: Noralf Trønnes <noralf@tronnes.org>

>  drivers/gpu/drm/drm_mipi_dbi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_mipi_dbi.c b/drivers/gpu/drm/drm_mipi_dbi.c
> index bb27c82757f1..bf7888ad9ad4 100644
> --- a/drivers/gpu/drm/drm_mipi_dbi.c
> +++ b/drivers/gpu/drm/drm_mipi_dbi.c
> @@ -923,7 +923,7 @@ static int mipi_dbi_spi1_transfer(struct mipi_dbi *dbi, int dc,
>  			}
>  		}
>  
> -		tr.len = chunk;
> +		tr.len = chunk * 2;
>  		len -= chunk;
>  
>  		ret = spi_sync(spi, &m);
> 

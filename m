Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810C1218226
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 10:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgGHIYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 04:24:16 -0400
Received: from kernel.crashing.org ([76.164.61.194]:60620 "EHLO
        kernel.crashing.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgGHIYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 04:24:15 -0400
Received: from localhost (gate.crashing.org [63.228.1.57])
        (authenticated bits=0)
        by kernel.crashing.org (8.14.7/8.14.7) with ESMTP id 0688NCdH001794
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 8 Jul 2020 03:23:18 -0500
Message-ID: <39fe1480891453839e257cd85e1070cde05866f0.camel@kernel.crashing.org>
Subject: Re: [PATCH 5/6] drm/ast: Initialize DRAM type before posting GPU
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Thomas Zimmermann <tzimmermann@suse.de>, airlied@redhat.com,
        daniel@ffwll.ch, sam@ravnborg.org, noralf@tronnes.org,
        emil.l.velikov@gmail.com, yc_chen@aspeedtech.com
Cc:     dri-devel@lists.freedesktop.org, Joel Stanley <joel@jms.id.au>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org
Date:   Wed, 08 Jul 2020 18:23:11 +1000
In-Reply-To: <20200708074912.25422-6-tzimmermann@suse.de>
References: <20200708074912.25422-1-tzimmermann@suse.de>
         <20200708074912.25422-6-tzimmermann@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2020-07-08 at 09:49 +0200, Thomas Zimmermann wrote:
> Posting the GPU requires the correct DRAM type to be stored in
> struct ast_private. Therefore first initialize the DRAM info and
> then post the GPU. This restores the original order of instructions
> in this function.

I no longer have access to the relevant test POWER systems,
however the patch looks good to me.

> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Fixes: bad09da6deab ("drm/ast: Fixed vram size incorrect issue on
> POWER")
> Cc: Joel Stanley <joel@jms.id.au>
> Cc: Y.C. Chen <yc_chen@aspeedtech.com>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Gerd Hoffmann <kraxel@redhat.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Emil Velikov <emil.l.velikov@gmail.com>
> Cc: "Y.C. Chen" <yc_chen@aspeedtech.com>
> Cc: <stable@vger.kernel.org> # v4.11+
> ---
>  drivers/gpu/drm/ast/ast_main.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/ast/ast_main.c
> b/drivers/gpu/drm/ast/ast_main.c
> index b162cc82204d..87e5baded2a7 100644
> --- a/drivers/gpu/drm/ast/ast_main.c
> +++ b/drivers/gpu/drm/ast/ast_main.c
> @@ -418,15 +418,15 @@ int ast_driver_load(struct drm_device *dev,
> unsigned long flags)
>  
>  	ast_detect_chip(dev, &need_post);
>  
> -	if (need_post)
> -		ast_post_gpu(dev);
> -
>  	ret = ast_get_dram_info(dev);
>  	if (ret)
>  		goto out_free;
>  	drm_info(dev, "dram MCLK=%u Mhz type=%d bus_width=%d\n",
>  		 ast->mclk, ast->dram_type, ast->dram_bus_width);
>  
> +	if (need_post)
> +		ast_post_gpu(dev);
> +
>  	ret = ast_mm_init(ast);
>  	if (ret)
>  		goto out_free;


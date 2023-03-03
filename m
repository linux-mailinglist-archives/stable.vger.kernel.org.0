Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287D16AA13F
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbjCCVc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbjCCVc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:32:29 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E08C62333;
        Fri,  3 Mar 2023 13:32:27 -0800 (PST)
Received: from [192.168.2.210] (109-252-117-89.nat.spd-mgts.ru [109.252.117.89])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: dmitry.osipenko)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id E7F056602FB0;
        Fri,  3 Mar 2023 21:32:24 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1677879146;
        bh=W2cOR76iMa3R1zLoQBgLLAGdE8QG5+ShTj9yleCtx6k=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=R25ZheYYXxqI6YzdSFtWvzWuaXqBKmxsV567k8TNb6d9aC7+G/+12kDENpxNdEW1r
         wVQMbAiA9YLa8y42+po2qL3TvXYId6DZzPfx2pn3VdGmKzacx3v0vGUvLZPP47ufsA
         M8pI2q6kIzwzELq8vUf2syvUj39DOmuRknygyVKzWtOWGS1m/AYs78KK3AbqiZ5FFO
         TZkyWk5aXoDW92WxPA1BLAZd8ztJM7C2upntbJRne9RQKg3pRNaCIqnE+D3FSsS3Nb
         k3alYmji/ePdGuQgZcPGzv9HeSof6VhhcQqSh5240vaJH7jwW7umFupijjeXrfwhBv
         A5QFZGwtCaNQw==
Message-ID: <d2cf9564-3b0c-b9e4-6066-8e8e6eb854f0@collabora.com>
Date:   Sat, 4 Mar 2023 00:32:22 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.15.y] drm/virtio: Fix error code in
 virtio_gpu_object_shmem_init()
Content-Language: en-US
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        stable@vger.kernel.org
Cc:     kraxel@redhat.com, linux-kernel@vger.kernel.org,
        emil.l.velikov@gmail.com, airlied@linux.ie, error27@gmail.com,
        darren.kenny@oracle.com, vegard.nossum@oracle.com
References: <20230302172538.3508747-1-harshit.m.mogalapalli@oracle.com>
From:   Dmitry Osipenko <dmitry.osipenko@collabora.com>
In-Reply-To: <20230302172538.3508747-1-harshit.m.mogalapalli@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/2/23 20:25, Harshit Mogalapalli wrote:
> In virtio_gpu_object_shmem_init() we are passing NULL to PTR_ERR, which
> is returning 0/success.
> 
> Fix this by storing error value in 'ret' variable before assigning
> shmem->pages to NULL.
> 
> Found using static analysis with Smatch.
> 
> Fixes: 64b88afbd92f ("drm/virtio: Correct drm_gem_shmem_get_sg_table() error handling")
> Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> ---
> Only compile tested.
> 
> Upstream commit b5c9ed70d1a9 ("drm/virtio: Improve DMA API usage for shmem BOs")
> deleted this code, so this patch is not necessary in linux-6.1.y and
> linux-6.2.y.
> ---
>  drivers/gpu/drm/virtio/virtgpu_object.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/virtio/virtgpu_object.c b/drivers/gpu/drm/virtio/virtgpu_object.c
> index 7e75fb0fc7bd..25d399b00404 100644
> --- a/drivers/gpu/drm/virtio/virtgpu_object.c
> +++ b/drivers/gpu/drm/virtio/virtgpu_object.c
> @@ -169,8 +169,9 @@ static int virtio_gpu_object_shmem_init(struct virtio_gpu_device *vgdev,
>  	shmem->pages = drm_gem_shmem_get_sg_table(&bo->base);
>  	if (IS_ERR(shmem->pages)) {
>  		drm_gem_shmem_unpin(&bo->base);
> +		ret = PTR_ERR(shmem->pages);
>  		shmem->pages = NULL;
> -		return PTR_ERR(shmem->pages);
> +		return ret;
>  	}
>  
>  	if (use_dma_api) {

Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>

-- 
Best regards,
Dmitry


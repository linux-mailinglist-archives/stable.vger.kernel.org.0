Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E9E6D44EF
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 14:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbjDCMxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 08:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbjDCMxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 08:53:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4967612BF6
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 05:53:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1C1761AA9
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 12:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF55AC4339E;
        Mon,  3 Apr 2023 12:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680526400;
        bh=mJ0UkEOWeDbmSNK9o8VQ81Oo3JiAQKdkhbjyEBotw8I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dzMLMBCMpSOxW9cXVBXgX3VKKlHA6PkK46uuWyqyMlYhsOhFyV8011mcfWtjgVuJF
         zjwo6Tp/q9WPGHCPN1sUeRuyItk+T5ENNceQQTN+Czv9XWYSa3WTTFVkTUeBHpPMf0
         KDZpqq0pYRQiRy8k7cme7ojk/C4udavLyuN5H71U=
Date:   Mon, 3 Apr 2023 14:53:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     stable@vger.kernel.org, bparrot@ti.com, mchehab@kernel.org,
        sashal@kernel.org, laurent.pinchart@ideasonboard.com,
        patches@lists.linux.dev
Subject: Re: [PATCH 5.10] media: ti: cal: revert "media: ti: cal: fix
 possible memory leak in cal_ctx_create()"
Message-ID: <2023040303-corporate-unearth-8b5b@gregkh>
References: <20230403121704.3017781-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403121704.3017781-1-cuigaosheng1@huawei.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 03, 2023 at 08:17:04PM +0800, Gaosheng Cui wrote:
> This reverts commit c7a218cbf67fffcd99b76ae3b5e9c2e8bef17c8c.
> 
> The memory of ctx is allocated by devm_kzalloc in cal_ctx_create,
> it should not be freed by kfree when cal_ctx_v4l2_init() fails,
> otherwise kfree() will cause double free, so revert this patch.
> 
> Fixes: c7a218cbf67f ("media: ti: cal: fix possible memory leak in cal_ctx_create()")
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> ---
>  drivers/media/platform/ti-vpe/cal.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
> index 93121c90d76a..2eef245c31a1 100644
> --- a/drivers/media/platform/ti-vpe/cal.c
> +++ b/drivers/media/platform/ti-vpe/cal.c
> @@ -624,10 +624,8 @@ static struct cal_ctx *cal_ctx_create(struct cal_dev *cal, int inst)
>  	ctx->cport = inst;
>  
>  	ret = cal_ctx_v4l2_init(ctx);
> -	if (ret) {
> -		kfree(ctx);
> +	if (ret)
>  		return NULL;
> -	}
>  
>  	return ctx;
>  }
> -- 
> 2.25.1
> 

Why is this not needed to be reverted in Linus's tree first?

thanks,

greg k-h

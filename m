Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6BE6D45E9
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 15:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbjDCNgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 09:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDCNgA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 09:36:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CC74488
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 06:35:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61E35B80762
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 13:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E61C433EF;
        Mon,  3 Apr 2023 13:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680528957;
        bh=qeZpISFwCJmRMfwTmzmQKVEuhrCuQ0NX8Q6VX57v1zQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GoMhiwu+A7lTKutOVLbFCTUXT+NvPKJI2XijIam1cNEMR8QPOE6dxEMBqx9BBI+wW
         LUmVlztDQ0yW8h5/e46noVLFKduCrtimRnzf86VlVlm833731TiYHKBJ42i+fyVwKY
         P1nE/wRszbX5iw5HN2PR11wbZ0tmUyHgoSoua83g=
Date:   Mon, 3 Apr 2023 15:35:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     cuigaosheng <cuigaosheng1@huawei.com>
Cc:     stable@vger.kernel.org, bparrot@ti.com, mchehab@kernel.org,
        sashal@kernel.org, laurent.pinchart@ideasonboard.com,
        patches@lists.linux.dev
Subject: Re: [PATCH 5.10] media: ti: cal: revert "media: ti: cal: fix
 possible memory leak in cal_ctx_create()"
Message-ID: <2023040333-untimely-salami-5e44@gregkh>
References: <20230403121704.3017781-1-cuigaosheng1@huawei.com>
 <2023040303-corporate-unearth-8b5b@gregkh>
 <beac5f8a-d96e-1e1f-1e3c-18f3f9d7519c@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <beac5f8a-d96e-1e1f-1e3c-18f3f9d7519c@huawei.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 03, 2023 at 09:11:43PM +0800, cuigaosheng wrote:
> On 2023/4/3 20:53, Greg KH wrote:
> > On Mon, Apr 03, 2023 at 08:17:04PM +0800, Gaosheng Cui wrote:
> > > This reverts commit c7a218cbf67fffcd99b76ae3b5e9c2e8bef17c8c.
> > > 
> > > The memory of ctx is allocated by devm_kzalloc in cal_ctx_create,
> > > it should not be freed by kfree when cal_ctx_v4l2_init() fails,
> > > otherwise kfree() will cause double free, so revert this patch.
> > > 
> > > Fixes: c7a218cbf67f ("media: ti: cal: fix possible memory leak in cal_ctx_create()")
> > > Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> > > ---
> > >   drivers/media/platform/ti-vpe/cal.c | 4 +---
> > >   1 file changed, 1 insertion(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
> > > index 93121c90d76a..2eef245c31a1 100644
> > > --- a/drivers/media/platform/ti-vpe/cal.c
> > > +++ b/drivers/media/platform/ti-vpe/cal.c
> > > @@ -624,10 +624,8 @@ static struct cal_ctx *cal_ctx_create(struct cal_dev *cal, int inst)
> > >   	ctx->cport = inst;
> > >   	ret = cal_ctx_v4l2_init(ctx);
> > > -	if (ret) {
> > > -		kfree(ctx);
> > > +	if (ret)
> > >   		return NULL;
> > > -	}
> > >   	return ctx;
> > >   }
> > > -- 
> > > 2.25.1
> > > 
> > Why is this not needed to be reverted in Linus's tree first?
> > 
> > thanks,
> > 
> > greg k-h
> > .
> 
> Thanks for taking time to review this patch.
> 
> The memory of ctx is allocated by kzalloc since commit 9e67f24e4d90
> ("media: ti-vpe: cal: fix ctx uninitialization"), so the fixes tag
> of patch c7a218cbf67fis not entirely accurate, mainline should merge this
> patch, but it should not be merged into 5.10, my apologies  for
> notdiscovering this bug earlier. Gaosheng.
> 

Great, can you please put all of this information in the changelog
explaining why this is only needed for this one branch and resend it?

thanks,

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7BE6D3D52
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 08:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbjDCG20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 02:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbjDCG2Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 02:28:24 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21713106
        for <stable@vger.kernel.org>; Sun,  2 Apr 2023 23:28:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 4E85F6601F13;
        Mon,  3 Apr 2023 07:28:21 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1680503301;
        bh=3cCU26BeElxI1SYG7ZzjCqv3azvdrsk7odwOKt1GgKM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f1bNOiDRafxwJwMOjlKyKSgFzn6LTOq8DL5Psqb03SUE/9wn1O9UJOM7riWvUbDJh
         dgYT0RBky4HhU0VoCoqw5Y+KM12zR6E9VsA8/bSnKQE2HHGjtRHtRRrzKJwznElVr9
         Jh4JHC0a1uWpthXmZ+pgUbfEbfSboeZcIHbf9/y8mSxmymIIPBU4FAwwfRUoWc6DF+
         UTNXd5MvIOKPnXBKG0GjLnKtJTCan8DoGdURaMDYMlBGOv8qxCfZTYMaIvV+DQBY8d
         R8qsfBR02ZhUu14N8v5tdl31VHwVhJpB1o3FddG5R8GuqaxXoYaSrwAu9BiexQdP3+
         WruiQUBjJ8S9Q==
Date:   Mon, 3 Apr 2023 08:28:18 +0200
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Steven Price <steven.price@arm.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Robin Murphy <robin.murphy@arm.com>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        david.heidelberg@collabora.com
Subject: Re: [PATCH] drm/panfrost: Fix the panfrost_mmu_map_fault_addr()
 error path
Message-ID: <20230403082707.11ec0a07@collabora.com>
In-Reply-To: <6749e0dd-bc07-b399-9718-0972993034cd@arm.com>
References: <20210521093811.1018992-1-boris.brezillon@collabora.com>
        <6749e0dd-bc07-b399-9718-0972993034cd@arm.com>
Organization: Collabora
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+David

On Fri, 21 May 2021 11:42:04 +0100
Steven Price <steven.price@arm.com> wrote:

> On 21/05/2021 10:38, Boris Brezillon wrote:
> > Make sure all bo->base.pages entries are either NULL or pointing to a
> > valid page before calling drm_gem_shmem_put_pages().
> > 
> > Reported-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> > Cc: <stable@vger.kernel.org>
> > Fixes: 187d2929206e ("drm/panfrost: Add support for GPU heap allocations")
> > Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>  
> 
> Reviewed-by: Steven Price <steven.price@arm.com>

Queued to drm-misc-fixes.

> 
> > ---
> >  drivers/gpu/drm/panfrost/panfrost_mmu.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
> > index 569509c2ba27..d76dff201ea6 100644
> > --- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
> > +++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
> > @@ -460,6 +460,7 @@ static int panfrost_mmu_map_fault_addr(struct panfrost_device *pfdev, int as,
> >  		if (IS_ERR(pages[i])) {
> >  			mutex_unlock(&bo->base.pages_lock);
> >  			ret = PTR_ERR(pages[i]);
> > +			pages[i] = NULL;
> >  			goto err_pages;
> >  		}
> >  	}
> >   
> 


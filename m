Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E17FA667C72
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 18:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbjALRWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 12:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbjALRVg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 12:21:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EA014D28;
        Thu, 12 Jan 2023 08:51:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC05FB81EE4;
        Thu, 12 Jan 2023 16:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55DAC433EF;
        Thu, 12 Jan 2023 16:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673541945;
        bh=oLyzs7BrkGWrZjSzv965hq1U/ogrEev6fsNywyDh/lU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qGKOr22K15obpuPJ2CduJ03kjMfQsEsBg+IopFp8651muUYVjOz3wPA0Adark/TSt
         P7H+ZB/lKXM6Qb4ztgkLjiHRHMMO6EfuGuusauu4hLJvKNWOPeTAoE/GIxkAUVFhCw
         SxQCaub5ZANAeRoCXsiGnWAOihOOVdrqBPp0t91k=
Date:   Thu, 12 Jan 2023 17:45:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Dragos-Marian Panait <dragos.panait@windriver.com>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Kent Russell <kent.russell@amd.com>,
        Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.10 1/1] drm/amdkfd: Check for null pointer after
 calling kmemdup
Message-ID: <Y8A5NgtGLDJv4sON@kroah.com>
References: <20230104175633.1420151-1-dragos.panait@windriver.com>
 <20230104175633.1420151-2-dragos.panait@windriver.com>
 <Y8ABeXQLzWdoaGAY@kroah.com>
 <CAKMK7uEgzJU8ukgR3sQtSUB5+wrD9VyMwCHOA-SReFWd0tKzzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uEgzJU8ukgR3sQtSUB5+wrD9VyMwCHOA-SReFWd0tKzzw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 04:26:45PM +0100, Daniel Vetter wrote:
> On Thu, 12 Jan 2023 at 13:47, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Wed, Jan 04, 2023 at 07:56:33PM +0200, Dragos-Marian Panait wrote:
> > > From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> > >
> > > [ Upstream commit abfaf0eee97925905e742aa3b0b72e04a918fa9e ]
> > >
> > > As the possible failure of the allocation, kmemdup() may return NULL
> > > pointer.
> > > Therefore, it should be better to check the 'props2' in order to prevent
> > > the dereference of NULL pointer.
> > >
> > > Fixes: 3a87177eb141 ("drm/amdkfd: Add topology support for dGPUs")
> > > Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> > > Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
> > > Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
> > > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > > Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
> > > ---
> > >  drivers/gpu/drm/amd/amdkfd/kfd_crat.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
> > > index 86b4dadf772e..02e3c650ed1c 100644
> > > --- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
> > > +++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
> > > @@ -408,6 +408,9 @@ static int kfd_parse_subtype_iolink(struct crat_subtype_iolink *iolink,
> > >                       return -ENODEV;
> > >               /* same everything but the other direction */
> > >               props2 = kmemdup(props, sizeof(*props2), GFP_KERNEL);
> > > +             if (!props2)
> > > +                     return -ENOMEM;
> >
> > Not going to queue this up as this is a bogus CVE.
> 
> Are we at the point where CVE presence actually contraindicates
> backporting?

Some would say that that point passed a long time ago :)

> At least I'm getting a bit the feeling there's a surge of
> automated (security) fixes that just don't hold up to any scrutiny.

That has been happening a lot more in the past 6-8 months than in years
past with the introduction of more automated tools being present.

> Last week I had to toss out an fbdev locking patch due to static
> checker that has no clue at all how refcounting works, and so
> complained that things need more locking ... (that was -fixes, but
> would probably have gone to stable too if I didn't catch it).
> 
> Simple bugfixes from random people was nice when it was checkpatch
> stuff and I was fairly happy to take these aggressively in drm. But my
> gut feeling says things seem to be shifting towards more advanced
> tooling, but without more advanced understanding by submitters. Does
> that holder in other areas too?

Again, yes, I have seen that a lot recently, especially with regards to
patches that purport to fix bugs yet obviously were never tested.

That being said, there are a few developers who are doing great things
with fault-injection testing and providing good patches for that.  So we
can't just say that everyone using these tools has no clue.

thanks,

greg k-h

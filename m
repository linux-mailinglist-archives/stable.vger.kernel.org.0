Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01B55A9492
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 12:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbiIAK0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 06:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234259AbiIAK0T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 06:26:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F34108538;
        Thu,  1 Sep 2022 03:26:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B3C761CDF;
        Thu,  1 Sep 2022 10:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B340AC433C1;
        Thu,  1 Sep 2022 10:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662027967;
        bh=K2HZoQF7A8JO2OtNi6cb6Lq3BAyRtkajUMPvXcXtvLs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kgBz1KQIzMiOqY93N7FxyB3AwdIlcFIIybSxIo3LJhXjYHSuHox1DMyjf3mVx0SoC
         o26f+wRZAPlMkuQ99MTYyNqpK8SzgKjPiyguTXBDhCUm5N5xa4GLHj8LZXUsjHi96a
         ebX6d594IJSaQXZJrfKVKdE4vNAyAu2CqHGO/1Ks=
Date:   Thu, 1 Sep 2022 12:26:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Frank Hofmann <fhofmann@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5.10 v2 6/7] xfs: reorder iunlink remove operation in
 xfs_ifree
Message-ID: <YxCIvDAMzWdQrpEh@kroah.com>
References: <20220901054854.2449416-1-amir73il@gmail.com>
 <20220901054854.2449416-7-amir73il@gmail.com>
 <CABEBQikqj+Uwae0XMHSbU7FVcrTR7cMb6zgbiRHC0PwFfB7+qw@mail.gmail.com>
 <CAOQ4uxhNV=-nVO_ezP=Lc42+Q+A+wxdiCBqhVQz8qVkBJba1iA@mail.gmail.com>
 <YxB+QmIwCgMtj1r+@kroah.com>
 <CAOQ4uxjxq346_dwEhrTm7_WW8nDqaQxNUCfVqDwOYAJGtmtpQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjxq346_dwEhrTm7_WW8nDqaQxNUCfVqDwOYAJGtmtpQQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 01, 2022 at 01:16:33PM +0300, Amir Goldstein wrote:
> On Thu, Sep 1, 2022 at 12:41 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Sep 01, 2022 at 12:30:13PM +0300, Amir Goldstein wrote:
> > > On Thu, Sep 1, 2022 at 12:04 PM Frank Hofmann <fhofmann@cloudflare.com> wrote:
> > > >
> > > > On Thu, Sep 1, 2022 at 6:49 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > >
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > >
> > > > > commit 9a5280b312e2e7898b6397b2ca3cfd03f67d7be1 upstream.
> > > > >
> > > > > [backport for 5.10.y]
> > > >
> > > > Hi Amir, hi Dave,
> > > >
> > > > I've got no objections to backporting this change at all. We've been
> > > > using the patch on our internal 5.15 tracker branch happily for
> > > > several months now.
> > > >
> > > > Would like to highlight though that it's currently not yet merged in
> > > > linux-stable 5.15 branch either (it's in 5.19 and mainline alright).
> > > > If this gets queued for 5.10 then maybe it also should be for 5.15 ?
> > > >
> > >
> > > Hi Frank,
> > >
> > > Quoting from my cover letter:
> > >
> > > Patches 6-7 in this 5.10.y update have not been applied to 5.15.y yet.
> > > I pointed Leah's attention to these patches and she said she will
> > > include them in a following 5.15.y update.
> >
> > And as you know, this means I can't take this series at all until that
> > series is ready, so to help us out, in the future, just don't even send
> > them until they are all ready together.
> >
> 
> What?
> 
> You cannot take backports to 5.10.y before they are applied to 5.15.y?
> Since when?

Since always.

Why would you ever want someone to upgrade from an older tree (like
5.10.y) to a newer one (5.15.y) and have a regression?

So we always try to make sure patches are always applied to newer trees
first.  Yes, sometimes we miss this and make mistakes, but it's always
been this way and we fix that whenever it happens accidentally.

I'll drop this series from my review queue for now until the 5.15.y
series shows up.

thanks,

greg k-h

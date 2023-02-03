Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAC2689361
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 10:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbjBCJTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 04:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbjBCJTT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 04:19:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22EFB449F;
        Fri,  3 Feb 2023 01:18:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 66193CE2F51;
        Fri,  3 Feb 2023 09:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BAEC433D2;
        Fri,  3 Feb 2023 09:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675415871;
        bh=qXg9nkVrLq+tSzHiuxr6prwSi15LJI7uYBFEuN7cU7s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X0FXIXNsxgEE573lxDtYRDIMCVflI5UVNtHtiFFOuPmzwXT5y3dQooGfEAxkd14Br
         CeqCNb7gb3dX8UFzmB4FgRwIka+/89E4tohQSr8b93ZVLPTnoGkbJSSqJ8JqMdIQuA
         yvj8wSUcxbncnjPH+OAKSaJAn+PhhczjK79zLd9s=
Date:   Fri, 3 Feb 2023 10:17:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linux regressions mailing list <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Sergey V." <truesmb@gmail.com>
Subject: Re: [regression] =?iso-8859-1?Q?Bug=A02169?=
 =?iso-8859-1?Q?32_-_io=5Furing_with_libvir?= =?iso-8859-1?Q?t?= cause kernel
 NULL pointer dereference since 6.1.5
Message-ID: <Y9zRPHyAmxhJoork@kroah.com>
References: <74347fe1-ac68-2661-500d-b87fab6994f7@leemhuis.info>
 <c5632908-1b0f-af1f-4754-bf1d0027a6dc@kernel.dk>
 <a862915b-66f3-9ad8-77d4-4b9ce7044037@kernel.dk>
 <Y8VkB6Q2xqeut5N8@kroah.com>
 <e921f92d-52ac-1dc7-7720-c270910c2a2d@kernel.dk>
 <0857ddf2-89a9-231b-89da-57cacc7342d5@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0857ddf2-89a9-231b-89da-57cacc7342d5@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 16, 2023 at 08:50:20AM -0700, Jens Axboe wrote:
> On 1/16/23 8:44 AM, Jens Axboe wrote:
> > On 1/16/23 7:49 AM, Greg Kroah-Hartman wrote:
> >> On Mon, Jan 16, 2023 at 07:13:40AM -0700, Jens Axboe wrote:
> >>> On 1/16/23 6:42 AM, Jens Axboe wrote:
> >>>> On 1/16/23 6:17?AM, Linux kernel regression tracking (Thorsten Leemhuis) wrote:
> >>>>> Hi, this is your Linux kernel regression tracker.
> >>>>>
> >>>>> I noticed a regression report in bugzilla.kernel.org. As many (most?)
> >>>>> kernel developer don't keep an eye on it, I decided to forward it by
> >>>>> mail. Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=216932 :
> >>>>
> >>>> Looks like:
> >>>>
> >>>> commit 6d47e0f6a535701134d950db65eb8fe1edf0b575
> >>>> Author: Jens Axboe <axboe@kernel.dk>
> >>>> Date:   Wed Jan 4 08:52:06 2023 -0700
> >>>>
> >>>>     block: don't allow splitting of a REQ_NOWAIT bio
> >>>>
> >>>> got picked up by stable, but not the required prep patch:
> >>>>
> >>>>
> >>>> commit 613b14884b8595e20b9fac4126bf627313827fbe
> >>>> Author: Jens Axboe <axboe@kernel.dk>
> >>>> Date:   Wed Jan 4 08:51:19 2023 -0700
> >>>>
> >>>>     block: handle bio_split_to_limits() NULL return
> >>>>
> >>>> Greg/team, can you pick the latter too? It'll pick cleanly for
> >>>> 6.1-stable, not sure how far back the other patch has gone yet.
> >>>
> >>> Looked back, and 5.15 has it too, but the cherry-pick won't work
> >>> on that kernel.
> >>>
> >>> Here's one for 5.15-stable that I verified crashes before this one,
> >>> and works with it. Haven't done an allmodconfig yet...
> >>
> >> All now queued up, thanks!
> > 
> > Thanks Greg! This one was my fault, as it was a set of 2 patches and
> > I only marked 2/2 for stable. But how is that best handled? 1/2 could've
> > been marked stable as well, but I don't think that would have prevented
> > 2/2 applying fine and 1/2 failing and hence not getting queued up until
> > I would've done a backport.
> > 
> > What's the recommended way to describe the dependency that you only
> > want 2/2 applied when 1/2 is in as well?
> 
> What I'm asking is if we have something like Depends-on or similar
> that would explain this dependency. Then patch 2/2 could have:
> 
> Depends-on: 613b14884b85 ("block: handle bio_split_to_limits() NULL return")
> 
> and then it'd be clear that either both get added, or none of them.

As per the documentation, you can put this on the cc: stable line in the
changelog text like:
  cc: stable <stable@vger.kernel.org> # 613b14884b85

thanks,

greg k-h

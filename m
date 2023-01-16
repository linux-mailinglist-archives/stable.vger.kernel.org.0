Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0139A66C318
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbjAPPAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbjAPO7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:59:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BA422DF7;
        Mon, 16 Jan 2023 06:49:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A6DE60FD7;
        Mon, 16 Jan 2023 14:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6924DC433EF;
        Mon, 16 Jan 2023 14:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673880585;
        bh=pdrPQuiDmmHjQzGsq5CHxSZmPxA94iY0FlqhGnDMkMg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pLE1itkAnZJ6raVfPf71HgORB5bnzRcVqhxTUbFmwIXShDqSXBGlKa9NUznOZylpc
         3sGn3zLCVnrUCxi6rMNn9KTLkbH6JDquzjD+vrKn36Id0FoliZoy/Jlp/KRuFGmZgW
         G+M2JOER0LImB0dLCo5wNk/hHnTnd9BvJJ7i9y0E=
Date:   Mon, 16 Jan 2023 15:49:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linux regressions mailing list <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Sergey V." <truesmb@gmail.com>
Subject: Re: [regression] =?iso-8859-1?Q?Bug=A02169?=
 =?iso-8859-1?Q?32_-_io=5Furing_with_libvir?= =?iso-8859-1?Q?t?= cause kernel
 NULL pointer dereference since 6.1.5
Message-ID: <Y8VkB6Q2xqeut5N8@kroah.com>
References: <74347fe1-ac68-2661-500d-b87fab6994f7@leemhuis.info>
 <c5632908-1b0f-af1f-4754-bf1d0027a6dc@kernel.dk>
 <a862915b-66f3-9ad8-77d4-4b9ce7044037@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a862915b-66f3-9ad8-77d4-4b9ce7044037@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 16, 2023 at 07:13:40AM -0700, Jens Axboe wrote:
> On 1/16/23 6:42 AM, Jens Axboe wrote:
> > On 1/16/23 6:17?AM, Linux kernel regression tracking (Thorsten Leemhuis) wrote:
> >> Hi, this is your Linux kernel regression tracker.
> >>
> >> I noticed a regression report in bugzilla.kernel.org. As many (most?)
> >> kernel developer don't keep an eye on it, I decided to forward it by
> >> mail. Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=216932 :
> > 
> > Looks like:
> > 
> > commit 6d47e0f6a535701134d950db65eb8fe1edf0b575
> > Author: Jens Axboe <axboe@kernel.dk>
> > Date:   Wed Jan 4 08:52:06 2023 -0700
> > 
> >     block: don't allow splitting of a REQ_NOWAIT bio
> > 
> > got picked up by stable, but not the required prep patch:
> > 
> > 
> > commit 613b14884b8595e20b9fac4126bf627313827fbe
> > Author: Jens Axboe <axboe@kernel.dk>
> > Date:   Wed Jan 4 08:51:19 2023 -0700
> > 
> >     block: handle bio_split_to_limits() NULL return
> > 
> > Greg/team, can you pick the latter too? It'll pick cleanly for
> > 6.1-stable, not sure how far back the other patch has gone yet.
> 
> Looked back, and 5.15 has it too, but the cherry-pick won't work
> on that kernel.
> 
> Here's one for 5.15-stable that I verified crashes before this one,
> and works with it. Haven't done an allmodconfig yet...

All now queued up, thanks!

greg k-h

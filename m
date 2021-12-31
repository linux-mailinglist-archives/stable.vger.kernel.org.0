Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACF0482404
	for <lists+stable@lfdr.de>; Fri, 31 Dec 2021 13:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhLaMwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Dec 2021 07:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhLaMwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Dec 2021 07:52:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3869FC061574;
        Fri, 31 Dec 2021 04:52:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B208061770;
        Fri, 31 Dec 2021 12:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C42CC36AEA;
        Fri, 31 Dec 2021 12:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640955155;
        bh=G0a9fCnRon8vGU2sZvjq27Sx8bTwd5NYHtDifqmtVM0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZJ/atFQ97KLHTNiwSJX+OAufrAw1PCTLHbwL7obC/6sRDnnwJDw4Px+6paOyOOL9a
         a3AKoQ8b+mw49ovTnGd79ZGD17qGNJCXCZzGxZdIwJIxUC8+PzNFoJL87yVBUhGKAj
         cPZmgmGlixvbM7ZHAwLMLdr6Yp0SKslNFfn63nL4=
Date:   Fri, 31 Dec 2021 13:52:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] fs/mount_setattr: always cleanup mount_kattr
Message-ID: <Yc79C0EDdSzNoQqP@kroah.com>
References: <20211230192309.115524-1-christian.brauner@ubuntu.com>
 <CAHk-=winoYrnz+KQA5Mqrw9f=PeyvKT2SsyAx=ZCUoBxm4kDpA@mail.gmail.com>
 <20211231103034.szasg7xymtfhh552@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211231103034.szasg7xymtfhh552@wittgenstein>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 31, 2021 at 11:30:34AM +0100, Christian Brauner wrote:
> On Thu, Dec 30, 2021 at 03:14:33PM -0800, Linus Torvalds wrote:
> > On Thu, Dec 30, 2021 at 11:23 AM Christian Brauner
> > <christian.brauner@ubuntu.com> wrote:
> > >
> > > Would you be ok with applying this fix directly? I
> > 
> > Done.
> > 
> > That said, I would have liked a "Fixes:" tag, or some indication of
> > how far back the stable people should take this..
> 
> Ugh, I missed to add that.
> >From a pure upstream stable perspective the only relevant and still
> supported kernel that should get this fix is 5.15.
> 
> I can make it a custom to mark all patches that should go to stable with
> the first kernel version where a given fix should be applied. In this
> case this whould've meant I'd given it:
> 
> Cc: <stable@vger.kernel.org> # v5.12+
> 
> For upstream stable maintainers it should be clear that since the only
> supported stable version within the range is v5.15.
> For downstream users/distros it should help to identify whether they
> still run/maintain a kernel that falls within the range of kernels that
> would technically be eligible for this fix.
> 
> I haven't seen whether we prefer the Cc: with # v*.**+ syntax to a
> simple Cc: without it nowadays.

If you do the # v.** syntax, or the Fixes: tag, then I know exactly how
far back to backport things.  If a failure occurs in backporting to a
listed place, then I will send you a FAILED email.

If there is no such marking, then I just have to guess myself and if I
start to get conflicts on older kernels, I just stop and do not send a
FAILED email if it does not look obviously relevant to me.

I'll just queue this up for 5.15, thanks.

greg k-h

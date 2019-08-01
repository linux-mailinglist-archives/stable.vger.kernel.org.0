Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D04DA7D56D
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 08:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbfHAGVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 02:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728884AbfHAGVa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Aug 2019 02:21:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E12320644;
        Thu,  1 Aug 2019 06:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564640489;
        bh=94YBJl9BSKguvjo7G9HODMAg6sYdTT6pdmMmNA8WOzA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GPFaiQMp5oEY9rU6/Ve6tU6wrP7JQPbEIkoC9ddjnOFAGYeO7dX7TgMt3tT5C9rAe
         jFS38cS3nBds7CGGGULrK3l5+7d+oYjl2GkXIC98j3zHJT2tEmiOyMGF0Y99mdKPIM
         nYB0axWEjwwkJ3SRGler7zsUwKEvVlIlZyL0M/9A=
Date:   Thu, 1 Aug 2019 08:21:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: Request vsock and hv_sock patches to be backported for
 linux-5.2.y, linux-4.19.y and linux-4.14.y
Message-ID: <20190801062126.GC4338@kroah.com>
References: <PU1P153MB0169AD4EB10548EACCED82C2BFDF0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <20190731093049.GC18269@kroah.com>
 <PU1P153MB0169EE57A6C3022A05C8DCF7BFDF0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PU1P153MB0169EE57A6C3022A05C8DCF7BFDF0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 31, 2019 at 08:13:24PM +0000, Dexuan Cui wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Wednesday, July 31, 2019 2:31 AM
> > On Wed, Jul 31, 2019 at 06:41:10AM +0000, Dexuan Cui wrote:
> > > For linux-4.14.y (currently it's v4.14.134), 4 patches are missing.
> > > The mainline commit IDs are:
> > >         cb359b604167 ("hvsock: fix epollout hang from race condition")
> > >         3b4477d2dcf2 ("VSOCK: use TCP state constants for sk_state")
> > >         a9eeb998c28d ("hv_sock: Add support for delayed close")
> > >         d5afa82c977e ("vsock: correct removal of socket from the list")
> > > The third patch (a9eeb998c28d) needs small manual adjustments, and please
> > > use the attached backported patch for it; the other 3 patches can be cleanly
> > > cherry-picked from the mainline, in the listed order here.
> > > Note: it looks the first commit (cb359b604167) has been queued.
> > 
> > I have not taken 3b4477d2dcf2 ("VSOCK: use TCP state constants for
> > sk_state") for 4.14.y as it doesn't look like you really needed it.  Are
> > you sure you did?
> 
> For linux-4.14.y:
>   Without 3b4477d2dcf2, there would be a conflict when we apply a9eeb998c28d.

Didn't happen, look at the tree for proof of that :)

>   And, without 3b4477d2dcf2, I think actually we should not apply:
>   c9d3fe9da094 ("VSOCK: fix outdated sk_state value in hvs_release()"), 
>   but c9d3fe9da094 was already applied into linux-4.14.y on Feb 25, 2018.
> 
>   I just checked 4.14.136-rc1 and found 3b4477d2dcf2 is queued. This is great! :-)
> 
>   So the only missing thing is: we need to cherry pick 
>     a9eeb998c28d ("hv_sock: Add support for delayed close")
>   onto 4.14.136-rc1.

Now queued up.

Can you test all of these to verify I got it right?

thanks,

greg k-h

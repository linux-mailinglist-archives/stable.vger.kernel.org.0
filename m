Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA212D5E21
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 15:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390838AbgLJOlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:41:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:48064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390577AbgLJOk4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:40:56 -0500
Date:   Thu, 10 Dec 2020 15:40:40 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607611216;
        bh=NgzJ+mRf7fLTuA5ix8xAU4kKnS7qzg2AXJsyY5uMGjY=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=BvUB0AVYbrpW8BW49tuy9uC6bcKe88KXKhKFeAPf0vNe9Kc3fJueXyYOOu5CPG1fa
         ucuO71CGn9CQKdQHxz84m4sh212DXtz2TSYOCx5OIe3pJO9dYLx0gMtgnW6U9s1cQP
         5MpMM3z8Wv5R2Wq8faFocn5XhRKXZBUyKT0eGTIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 4.4 15/39] geneve: pull IP header before ECN decapsulation
Message-ID: <X9IzaHjsIjcn3XNX@kroah.com>
References: <20201210142600.887734129@linuxfoundation.org>
 <20201210142601.652963609@linuxfoundation.org>
 <CANn89iK=kMSkT771iL0dybnWisXr9FWW-bffa5KB+McBYrxx4g@mail.gmail.com>
 <X9Iy9EDh2gZgth+R@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9Iy9EDh2gZgth+R@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 03:38:44PM +0100, Greg Kroah-Hartman wrote:
> On Thu, Dec 10, 2020 at 03:32:12PM +0100, Eric Dumazet wrote:
> > On Thu, Dec 10, 2020 at 3:26 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > From: Eric Dumazet <edumazet@google.com>
> > >
> > > IP_ECN_decapsulate() and IP6_ECN_decapsulate() assume
> > > IP header is already pulled.
> > >
> > > geneve does not ensure this yet.
> > >
> > > Fixing this generically in IP_ECN_decapsulate() and
> > > IP6_ECN_decapsulate() is not possible, since callers
> > > pass a pointer that might be freed by pskb_may_pull()
> > >
> > > syzbot reported :
> > >
> > 
> > Note that we had to revert this patch, so you can either scratp this
> > backport, or make sure to backport the revert.
> 
> I'll drop it thanks.  Odd I lost the upstream git id on this patch, let
> me check what went wrong...

What is the git id of the revert?  This ended up already in 4.19.y,
5.4.y, and 5.9.y so needs to be reverted there.

thanks,

greg k-h

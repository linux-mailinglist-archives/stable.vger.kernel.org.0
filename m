Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4902D6005
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391385AbgLJPgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 10:36:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:48408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389899AbgLJPgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 10:36:10 -0500
Date:   Thu, 10 Dec 2020 16:36:43 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607614529;
        bh=Xwyc46kb9Zf+lrvn7bafHBDuobBRZsoyjP/r5kwNAgY=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oyf4Lqt33B34eWf4Bh3GYyr66HdcYWvukSqFS15oh20JhF1728JtyGmJs/Zj9VHaO
         hCHwKTWCO7/xmLs1VgGBVDmST8JZVjlqodUwY/d+3BdorPL5r5fYc9pi5om8uNUxDD
         Rnb6g9k/U2ZmctuY2T8PYN1egZiTSODSFgjWFy0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 4.4 15/39] geneve: pull IP header before ECN decapsulation
Message-ID: <X9JAi9wFusAi1VxC@kroah.com>
References: <20201210142600.887734129@linuxfoundation.org>
 <20201210142601.652963609@linuxfoundation.org>
 <CANn89iK=kMSkT771iL0dybnWisXr9FWW-bffa5KB+McBYrxx4g@mail.gmail.com>
 <X9Iy9EDh2gZgth+R@kroah.com>
 <X9IzaHjsIjcn3XNX@kroah.com>
 <CANn89iLFCBVOzPhwSxmAnT6dx8fnRD4TYRSJaX2ni7AxvXKEGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iLFCBVOzPhwSxmAnT6dx8fnRD4TYRSJaX2ni7AxvXKEGg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 03:53:09PM +0100, Eric Dumazet wrote:
> On Thu, Dec 10, 2020 at 3:40 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Dec 10, 2020 at 03:38:44PM +0100, Greg Kroah-Hartman wrote:
> > > On Thu, Dec 10, 2020 at 03:32:12PM +0100, Eric Dumazet wrote:
> > > > On Thu, Dec 10, 2020 at 3:26 PM Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > From: Eric Dumazet <edumazet@google.com>
> > > > >
> > > > > IP_ECN_decapsulate() and IP6_ECN_decapsulate() assume
> > > > > IP header is already pulled.
> > > > >
> > > > > geneve does not ensure this yet.
> > > > >
> > > > > Fixing this generically in IP_ECN_decapsulate() and
> > > > > IP6_ECN_decapsulate() is not possible, since callers
> > > > > pass a pointer that might be freed by pskb_may_pull()
> > > > >
> > > > > syzbot reported :
> > > > >
> > > >
> > > > Note that we had to revert this patch, so you can either scratp this
> > > > backport, or make sure to backport the revert.
> > >
> > > I'll drop it thanks.  Odd I lost the upstream git id on this patch, let
> > > me check what went wrong...
> >
> > What is the git id of the revert?  This ended up already in 4.19.y,
> > 5.4.y, and 5.9.y so needs to be reverted there.
> >
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=c02bd115b1d25931159f89c7d9bf47a30f5d4b41

Thanks, I'll drop the patch from 4.4, 4.9, and 4.14, and queue up this
revert for the other trees now.

greg k-h

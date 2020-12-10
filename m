Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30352D6010
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391446AbgLJPk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 10:40:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391311AbgLJOka (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:40:30 -0500
Date:   Thu, 10 Dec 2020 15:38:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607611213;
        bh=zsIJN6z8FTmy73+DOegLXEWt+5izYHdwXL7OlzZ6Ykg=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=ns2Bkr0xFfOXEVbBHWZZkdl+LpBFo5CilV+23ufJ9hUv0gD5KyYkO6CnGKZ7R9EQu
         UXV2bZZ8Gd5qvubQQ9hOxxO0zP2OCPbvQr8Ru4Bkz+HGGdQhVR1xGaiSz5rhj6eB5g
         3a5ljOKQJ+oqiNQvCJ7E92Z5Sm8X878QMeA4tXAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 4.4 15/39] geneve: pull IP header before ECN decapsulation
Message-ID: <X9Iy9EDh2gZgth+R@kroah.com>
References: <20201210142600.887734129@linuxfoundation.org>
 <20201210142601.652963609@linuxfoundation.org>
 <CANn89iK=kMSkT771iL0dybnWisXr9FWW-bffa5KB+McBYrxx4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iK=kMSkT771iL0dybnWisXr9FWW-bffa5KB+McBYrxx4g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 03:32:12PM +0100, Eric Dumazet wrote:
> On Thu, Dec 10, 2020 at 3:26 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Eric Dumazet <edumazet@google.com>
> >
> > IP_ECN_decapsulate() and IP6_ECN_decapsulate() assume
> > IP header is already pulled.
> >
> > geneve does not ensure this yet.
> >
> > Fixing this generically in IP_ECN_decapsulate() and
> > IP6_ECN_decapsulate() is not possible, since callers
> > pass a pointer that might be freed by pskb_may_pull()
> >
> > syzbot reported :
> >
> 
> Note that we had to revert this patch, so you can either scratp this
> backport, or make sure to backport the revert.

I'll drop it thanks.  Odd I lost the upstream git id on this patch, let
me check what went wrong...

greg k-h

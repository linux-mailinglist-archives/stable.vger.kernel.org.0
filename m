Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01840362F6
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 19:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfFERtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 13:49:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbfFERtI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Jun 2019 13:49:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9E5E20866;
        Wed,  5 Jun 2019 17:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559756947;
        bh=b7nDVwO98Q0vYnNmnAp8NQsKYaTd7xFH8bcBeyCedvY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K8W1k1KNhRmhYVf0rnu+EonoJ5XvIJKAXJnE+kbwf6IICfkuNcRkq51gE3Ocoe4j7
         x8e1mqQ4ol8/yvPUFh3LV8tCW56jxcZr7+1EKyi4L/D32Zli7Rt0oTdWCdFiZ3GHCy
         0Yzw5vuzyoc28WpfG8cpS835b9zDxjOw9UpVz5W8=
Date:   Wed, 5 Jun 2019 19:49:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Todd Kjos <tkjos@google.com>
Cc:     Todd Kjos <tkjos@android.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [stable] binder: fix race between munmap() and direct reclaim
Message-ID: <20190605174904.GG27700@kroah.com>
References: <1558991372.2631.10.camel@codethink.co.uk>
 <20190528065131.GA2623@kroah.com>
 <CAHRSSEzopAbeAv4ap9xTrC1nCbpw1ZPrEYEMZOc5W_EcLZaktQ@mail.gmail.com>
 <CAHRSSEw=z4hyHMZV=WYAs_hy6Wp2qRk2mWGRSiXUO49d1SDVfQ@mail.gmail.com>
 <20190604145037.GB5824@kroah.com>
 <CAHRSSEwxB0YRZd5+JAMUew3w2MKEDcf-t4ReRq-b=zTFEYgW1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHRSSEwxB0YRZd5+JAMUew3w2MKEDcf-t4ReRq-b=zTFEYgW1A@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 05, 2019 at 09:43:53AM -0700, Todd Kjos wrote:
> On Tue, Jun 4, 2019 at 7:50 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, May 31, 2019 at 01:09:53PM -0700, Todd Kjos wrote:
> > > Greg,
> > >
> > > I'm really confused. [1] was my submittal to stable for "binder: fix
> > > race between munmap() and direct reclaim" which I think looks correct.
> > >
> > > For "binder: fix handling of misaligned binder object", I only
> > > submitted to LKML [2]. But then I see [3] for 4.14 (that looks
> > > incorrect as Ben pointed out).
> > >
> > > So the result is that fix is present in the LTS trees where it is
> > > needed, but it has the wrong commit message and headline.
> > >
> > > I agree with Ben that the cleanest approach is to revert and apply the
> > > correct version (to 4.14, 4.19, 5.0). I think the correct version is
> > > the one I sent [1], but please let me know if you see something I
> > > screwed up or if you need me to do something.
> > >
> > > [1] https://www.spinics.net/lists/stable/msg299033.html
> > > [2] https://lkml.org/lkml/2019/2/14/1235
> > > [3] https://lkml.org/lkml/2019/4/30/650
> >
> > Can you send me a patch series that fixes things up properly?  I really
> > don't know exactly what to do here, sorry.
> 
> Sent. 2 patches for each of 4.14, 4.19, 5.0 (1/2=revert of bad patch,
> 2/2 apply good patch). Code ends up the same.

Thanks for that, I'll queue them up soon.

greg k-h

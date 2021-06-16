Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331A43A9CCB
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 15:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbhFPOAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 10:00:25 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:56155 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232791AbhFPOAZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 10:00:25 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 15GDw6dP002036;
        Wed, 16 Jun 2021 15:58:06 +0200
Date:   Wed, 16 Jun 2021 15:58:06 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     "'Amit Klein'" <aksecurity@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 175/244] inet: use bigger hash table for IP ID
 generation
Message-ID: <20210616135806.GD1670@1wt.eu>
References: <20210512144743.039977287@linuxfoundation.org>
 <20210512144748.600206118@linuxfoundation.org>
 <CANEQ_++O0XVVdvynGtf37YCHSBT8CYHnUkK+VsFkOTqeqwOUtA@mail.gmail.com>
 <YMmlPHMn/+EPdbvm@kroah.com>
 <CANEQ_++gbwU2Rvcqg5KtngZC1UX1XcjOKfPKRr3Pvxi+VyQX+Q@mail.gmail.com>
 <a388a8018b09429d93a4a6b6852c70b2@AcuMS.aculab.com>
 <CANEQ_++RSG=cOa-hWcHefqVa5_=FRo+PdwuJbE2A-NHA_RNXXQ@mail.gmail.com>
 <a9956d07dfe64e5db829dbe1a8910bdd@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9956d07dfe64e5db829dbe1a8910bdd@AcuMS.aculab.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021 at 01:42:17PM +0000, David Laight wrote:
> > This patch mitigates some techniques that leak internal state due to
> > table hash collisions.
> 
> As you say below it isn't really effective...

Actually it's Amit's attack which is really effective against anything
that is not 100% random. And as you mentioned yourself in another thread,
full randomness is not desirable as it can result in big trouble with ID
collisions, especially when limited to 16 bits only. The only remaining
factor to act on is thus the number of buckets to reduce the effectiveness
of the attack.

> > > Why should my desktop system 'waste' 2MB of memory on a massive
> > > hash table that I don't need.
> > 
> > In the patch's defense, it only consumes 2MB when the physical RAM is >= 16GB.
> 
> Right, but I've 16GB of memory because I run some very large
> applications that need all the memory they can get (and more).

Then by all means if your system is so tightly sized, buy this extra
2 MB DRAM stick you're missing, and install it next to your existing
16GB one.

> > Security-wise, this approach is not effective. The table size was
> > increased to reduce the likelihood of hash collisions. These start
> > happening when you have ~N^(1/2) elements (for table size N), so
> > you'll need to resize pretty quickly anyway.
> 
> You really have to live with some hash collisions.

Absolutely, and that's the principle, that at some point it costs
enough to the attacker for the attack to not be affordable or at
least be easily detectable. All this for 1/8192 of your total RAM
in the worst case, you will not notice more than when some fields
are added to certain important structures and probably much less
than when you simply upgrade whatever lib or binary. And probably
that you forgot to reduce the amount of RAM dedicated to the video
in your BIOS and can salvage no less than 32MB there!

Willy

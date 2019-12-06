Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E06A1150BD
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 14:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfLFNDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 08:03:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbfLFNDD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Dec 2019 08:03:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 903EF2464E;
        Fri,  6 Dec 2019 13:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575637383;
        bh=nu9QCTqM5WXOIT+G9aiycC+1A31iUFHQjDd4ZczZSCQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A7/Uc0ULYMTnDP7XBhIKeKkTGXW5DcmM/GjnT7fPd2vQ+hHIhe/OnDNUPtE9ymA3U
         PeN53l7aGoU9A7T5xoWwlklJ+HezOHBgdlbyJFaOU81xt2s4GEDbkVJ/7nDZOX0D4A
         l8V1IZiPOox7WXZobykU4ElqZHgFHTGHEI1DNq3o=
Date:   Fri, 6 Dec 2019 14:03:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?utf-8?B?546L5paH5rab?= <witallwang@gmail.com>
Cc:     Mike Rapoport <rppt@linux.ibm.com>, Pavel Machek <pavel@denx.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 200/321] mm/page_alloc.c: deduplicate
 __memblock_free_early() and memblock_free()
Message-ID: <20191206130300.GB1399220@kroah.com>
References: <20191203223427.103571230@linuxfoundation.org>
 <20191203223437.527630884@linuxfoundation.org>
 <20191205115043.GA25107@duo.ucw.cz>
 <20191205131128.GA25566@linux.ibm.com>
 <CACzRS4cYJkJAhOdm+qf55H7O4S5HiQEe_fguJGx-mZYJzz62ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACzRS4cYJkJAhOdm+qf55H7O4S5HiQEe_fguJGx-mZYJzz62ug@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 06, 2019 at 10:34:19AM +0800, 王文涛 wrote:
> Yes, Mike's follow up fix should be picked too with this change.
> 
> On Thu, Dec 5, 2019 at 9:11 PM Mike Rapoport <rppt@linux.ibm.com> wrote:
> 
> > On Thu, Dec 05, 2019 at 12:50:43PM +0100, Pavel Machek wrote:
> > > Hi!
> > > On Tue 2019-12-03 23:34:26, Greg Kroah-Hartman wrote:
> > > > From: Wentao Wang <witallwang@gmail.com>
> > > >
> > > > [ Upstream commit d31cfe7bff9109476da92c245b56083e9b48d60a ]
> > >
> > >
> > > > @@ -1537,12 +1537,7 @@ void * __init memblock_virt_alloc_try_nid(
> > > >   */
> > > >  void __init __memblock_free_early(phys_addr_t base, phys_addr_t size)
> > > >  {
> > > > -   phys_addr_t end = base + size - 1;
> > > > -
> > > > -   memblock_dbg("%s: [%pa-%pa] %pF\n",
> > > > -                __func__, &base, &end, (void *)_RET_IP_);
> > > > -   kmemleak_free_part_phys(base, size);
> > > > -   memblock_remove_range(&memblock.reserved, base, size);
> > > > +   memblock_free(base, size);
> > > >  }
> > >
> > > This makes the memblock_dbg() less useful: _RET_IP_ will now be one of
> > > __memblock_free_early(), not of the original caller.
> > >
> > > That may be okay, but I guess it should be mentioned in changelog, and
> > > I don't really see why it is queued for -stable.
> >
> > Not sure why this one was picked for -stable, but in upstream there is a
> > followup commit 4d72868c8f7c ("memblock: replace usage of
> > __memblock_free_early() with memblock_free()") that completely eliminates
> > __memblock_free_early(). IMHO it would make sense to either to take both or
> > to drop both.


This commit does not apply to the 4.19.y tree :(


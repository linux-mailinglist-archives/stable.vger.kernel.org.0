Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36C6E156AC0
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbgBINpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:45:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:57980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727707AbgBINpS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 08:45:18 -0500
Received: from localhost (unknown [38.98.37.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 063CD20715;
        Sun,  9 Feb 2020 13:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581255916;
        bh=C5ZnmNinn7r93jfXQQ4TfyDFAbimGfnEEt98N+V1Ha0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X+u2XVMDfgfX6w+wlTW17cd22Cfj3m9/RZsEFAfnC++Obmj6K5wqxDZLjmv42onQX
         ri8uKC68GxM6pypoY9fPDLVZiNlJulSZYi6C3ZlrDzj920rwvn17VVrVr/l+vhLBil
         AzTsN5T6/83vPtRJEVcgJHUG8vjlzUFd6qhhlxnw=
Date:   Sun, 9 Feb 2020 13:41:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Wentao Wang <witallwang@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 200/321] mm/page_alloc.c: deduplicate
 __memblock_free_early() and memblock_free()
Message-ID: <20200209124120.GA1622852@kroah.com>
References: <20191203223427.103571230@linuxfoundation.org>
 <20191203223437.527630884@linuxfoundation.org>
 <20191205115043.GA25107@duo.ucw.cz>
 <20191205131128.GA25566@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205131128.GA25566@linux.ibm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 05, 2019 at 03:11:28PM +0200, Mike Rapoport wrote:
> On Thu, Dec 05, 2019 at 12:50:43PM +0100, Pavel Machek wrote:
> > Hi!
> > On Tue 2019-12-03 23:34:26, Greg Kroah-Hartman wrote:
> > > From: Wentao Wang <witallwang@gmail.com>
> > > 
> > > [ Upstream commit d31cfe7bff9109476da92c245b56083e9b48d60a ]
> > 
> > 
> > > @@ -1537,12 +1537,7 @@ void * __init memblock_virt_alloc_try_nid(
> > >   */
> > >  void __init __memblock_free_early(phys_addr_t base, phys_addr_t size)
> > >  {
> > > -	phys_addr_t end = base + size - 1;
> > > -
> > > -	memblock_dbg("%s: [%pa-%pa] %pF\n",
> > > -		     __func__, &base, &end, (void *)_RET_IP_);
> > > -	kmemleak_free_part_phys(base, size);
> > > -	memblock_remove_range(&memblock.reserved, base, size);
> > > +	memblock_free(base, size);
> > >  }
> > 
> > This makes the memblock_dbg() less useful: _RET_IP_ will now be one of
> > __memblock_free_early(), not of the original caller.
> > 
> > That may be okay, but I guess it should be mentioned in changelog, and
> > I don't really see why it is queued for -stable.
> 
> Not sure why this one was picked for -stable, but in upstream there is a
> followup commit 4d72868c8f7c ("memblock: replace usage of
> __memblock_free_early() with memblock_free()") that completely eliminates
> __memblock_free_early(). IMHO it would make sense to either to take both or
> to drop both.

Ok, I'll try, but that commit does not apply cleanly to 5.0, so it might
take a bit of time...

thanks,

greg k-h

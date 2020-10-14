Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA2A28E81D
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 22:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgJNUyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 16:54:03 -0400
Received: from [157.25.102.26] ([157.25.102.26]:39198 "EHLO orcam.me.uk"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726028AbgJNUyD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 16:54:03 -0400
X-Greylist: delayed 35030 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Oct 2020 16:54:02 EDT
Received: from bugs.linux-mips.org (eddie.linux-mips.org [IPv6:2a01:4f8:201:92aa::3])
        by orcam.me.uk (Postfix) with ESMTPS id 6BC052BE086;
        Wed, 14 Oct 2020 21:53:59 +0100 (BST)
Date:   Wed, 14 Oct 2020 21:53:55 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@linux-mips.org>
To:     Serge Semin <fancer.lancer@gmail.com>
cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: DEC: Restore bootmem reservation for firmware
 working memory area
In-Reply-To: <20201014180114.fnz5ewt2tzkgxin4@mobilestation>
Message-ID: <alpine.LFD.2.21.2010142146110.866917@eddie.linux-mips.org>
References: <alpine.LFD.2.21.2010141123010.866917@eddie.linux-mips.org> <20201014180114.fnz5ewt2tzkgxin4@mobilestation>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Serge,

> > @@ -146,6 +150,9 @@ void __init plat_mem_setup(void)
> >  
> >  	ioport_resource.start = ~0UL;
> >  	ioport_resource.end = 0UL;
> > +
> > +	/* Stay away from the firmware working memory area for now. */
> 
> > +	memblock_reserve(PHYS_OFFSET, __pa_symbol(&_text));
> 
> Shouldn't that be:
> +	memblock_reserve(PHYS_OFFSET, __pa_symbol(&_text) - PHYS_OFFSET);
> instead?

 Good point: unlike `free_init_pages' which uses start/end this function 
uses start/size as its arguments.  For DEC effectively it does not matter 
as PHYS_OFFSET is 0 anyway, but code has to be semantically correct.  
I'll post an update.

  Maciej

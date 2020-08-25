Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8641E25116C
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 07:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgHYFT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 01:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgHYFT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 01:19:56 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FEEC061574;
        Mon, 24 Aug 2020 22:19:56 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BbHP51BCKz9sR4;
        Tue, 25 Aug 2020 15:19:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=popple.id.au;
        s=202006; t=1598332793;
        bh=MTpbfNAqvTkG6db77/xvLASym21B8CMhGSXqP1HtlLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vVvt4BaZ4udfjy1JvLdr5LEsLneBTrDH7xEb+XK7APb2XjAbB3c/sxw7XDM9pqRCB
         PKkRSiXGt+ltunZg2XsWCDZsOL0mQ4I10rvltxgYyzVPCrimigfHxhSRbSalPomE57
         f4PiBC++1UnPlyf/iyNxfa1+wjQQZENoxbWKsCislDZ287zE01dHlPq95Tmq22c+KR
         4D5MH7aMnsbiSC14g0F3rhy/erRARyVv6MVgiezViwp9QBarQ4B8Go/CjI9tAhiUr/
         KnvTIt287HS4LMzX/yhsLGwqG35AeBoWdd+xt5eUc2fMm8Z4Yr2ryznl+xUFmQbY0F
         MHJv+ae/xyu1Q==
From:   Alistair Popple <alistair@popple.id.au>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/rmap: Fixup copying of soft dirty and uffd ptes
Date:   Tue, 25 Aug 2020 15:19:50 +1000
Message-ID: <1650521.I2r5EI4MMx@cleo>
In-Reply-To: <20200824154359.GA8605@xz-x1>
References: <20200824083128.12684-1-alistair@popple.id.au> <20200824083128.12684-2-alistair@popple.id.au> <20200824154359.GA8605@xz-x1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday, 25 August 2020 1:43:59 AM AEST Peter Xu wrote:
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -2427,9 +2427,11 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
> > 
> >  			entry = make_migration_entry(page, mpfn &
> >  			
> >  						     MIGRATE_PFN_WRITE);
> >  			
> >  			swp_pte = swp_entry_to_pte(entry);
> > 
> > -			if (pte_soft_dirty(pte))
> > +			if ((is_swap_pte(pte) && pte_swp_soft_dirty(pte))
> > +				|| (!is_swap_pte(pte) && pte_soft_dirty(pte)))
> > 
> >  				swp_pte = pte_swp_mksoft_dirty(swp_pte);
> > 
> > -			if (pte_uffd_wp(pte))
> > +			if ((is_swap_pte(pte) && pte_swp_uffd_wp(pte))
> > +				|| (!is_swap_pte(pte) && pte_uffd_wp(pte)))
> > 
> >  				swp_pte = pte_swp_mkuffd_wp(swp_pte);
> >  			
> >  			set_pte_at(mm, addr, ptep, swp_pte);
> 
> The worst case is we'll call is_swap_pte() four times for each entry. Also
> considering we know it's not a pte_none() when reach here, how about:
> 
>   if (pte_present(pte)) {
>     // pte handling of both soft dirty and uffd-wp
>   } else {
>     // swap handling of both soft dirty and uffd-wp
>   }
> 
> ?

Works for me, I'd missed we knew it was not a pte_none() so will respin. 
Thanks!

 - Alistair
 
> Thanks,





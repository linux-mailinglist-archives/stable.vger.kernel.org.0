Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA3F47537A
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 08:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235862AbhLOHDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 02:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235852AbhLOHDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 02:03:43 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E528C061574;
        Tue, 14 Dec 2021 23:03:43 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id k6-20020a17090a7f0600b001ad9d73b20bso18318570pjl.3;
        Tue, 14 Dec 2021 23:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aFB3zrYvsnnfO0vx/SsksAk1QGRVLRM3ofNufeo+PJc=;
        b=YzoB6yjvezFylfMhN8lj8gq+BNBJ1JsI/Rm+zpii6DX3Ias5Xk+0QhmtIMZjCDWTE2
         wfnDntdkMKC2SLG835hKNe3ElO7yuQ1K7lmboOzGFvz8lnHm7UXnZj1TvLzFZR9w3ntR
         Hx9aJBndr4XhaxUqfbNQQ2eD8gAd6sGuwkXgEk372lmRUpPKRsb//DL8dJ1EZkhRppl/
         MJ4m4a8Pj4aVn7QwYLArAxYdeutnvmeiVaxnw47iP/y5yMeLBfx9VzS16IZ60NBKtZMn
         /TQXthNmZ9SyBB7OSgPd5cLbQ7qS8fHFnaB1mrfNT76KdfXSz59MivWYSjvssbDUF50b
         ZcaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aFB3zrYvsnnfO0vx/SsksAk1QGRVLRM3ofNufeo+PJc=;
        b=h9C+lAGGvagEsHEKSRrml52Rfq8ORPh+ox7bKB/JsSwiBVi69yzyA9cQ+mC47/IQsC
         FJex4IflznCTx/CYoH3ip3EnBGDdNxspEa+rPwtWROvYmEc0mu9C/ISfyt+hKPEWho3Y
         RxL7ldB7KI91WHBtdYpQGZMbmVz4iCZCY66o0zwhEDTfdcH7iv13DC6hRpe/8a4MBOTt
         VHXNTlJX81WTnSeD49TDc2/odSlT1nhjM8cW818PAfJxYpBziLedzTOxQYx7PO1iPGP6
         dORPcLizX5KMNJvQ9GdiBdVW0uYOMAc1mr+1E10yi8vLKvOf1uPM1uZheH6QlU57nKw/
         GJtw==
X-Gm-Message-State: AOAM530HitcaAXIM7PatfTSwCUDWXOFnh1auIU8U9gmkNh3NmPIOJqvn
        Yxni3PJANP13uDMG8veV8+A=
X-Google-Smtp-Source: ABdhPJymvszIJp5x2/rZeDDSbk1JK+ZtC9yjHhRIlBi6dDcZVrDHByKhpmjFbx2JeAs8ETva/J7kqg==
X-Received: by 2002:a17:902:6b47:b0:142:82e1:6c92 with SMTP id g7-20020a1709026b4700b0014282e16c92mr9656466plt.84.1639551822672;
        Tue, 14 Dec 2021 23:03:42 -0800 (PST)
Received: from odroid ([114.29.23.242])
        by smtp.gmail.com with ESMTPSA id m6sm1115137pgb.31.2021.12.14.23.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 23:03:42 -0800 (PST)
Date:   Wed, 15 Dec 2021 07:03:35 +0000
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org, hch@lst.de,
        cl@linux.com, John.p.donnelly@oracle.com,
        kexec@lists.infradead.org, stable@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v3 5/5] mm/slub: do not create dma-kmalloc if no managed
 pages in DMA zone
Message-ID: <20211215070335.GA1165926@odroid>
References: <20211213122712.23805-1-bhe@redhat.com>
 <20211213122712.23805-6-bhe@redhat.com>
 <20211213134319.GA997240@odroid>
 <20211214053253.GB2216@MiWiFi-R3L-srv>
 <f5ff82eb-73b6-55b5-53d7-04ab73ce5035@suse.cz>
 <20211215044818.GB1097530@odroid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215044818.GB1097530@odroid>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 15, 2021 at 04:48:26AM +0000, Hyeonggon Yoo wrote:
> 
> Hello Baoquan and Vlastimil.
> 
> I'm not sure allowing ZONE_DMA32 for kdump kernel is nice way to solve
> this problem. Devices that requires ZONE_DMA is rare but we still
> support them.
> 
> If we allow ZONE_DMA32 for ZONE_DMA in kdump kernels,
> the problem will be hard to find.
> 

Sorry, I sometimes forget validating my english writing :(

What I meant:

I'm not sure that allocating from ZONE_DMA32 instead of ZONE_DMA
for kdump kernel is nice way to solve this problem.

Devices that requires ZONE_DMA memory is rare but we still support them.

If we use ZONE_DMA32 memory instead of ZONE_DMA in kdump kernels,
It will be hard to the problem when we use devices that can use only
ZONE_DMA memory.

> What about one of those?:
> 
>     1) Do not call warn_alloc in page allocator if will always fail
>     to allocate ZONE_DMA pages.
> 
> 
>     2) let's check all callers of kmalloc with GFP_DMA
>     if they really need GFP_DMA flag and replace those by DMA API or
>     just remove GFP_DMA from kmalloc()
> 
>     3) Drop support for allocating DMA memory from slab allocator
>     (as Christoph Hellwig said) and convert them to use DMA32

	(as Christoph Hellwig said) and convert them to use *DMA API*

>     and see what happens
> 
> Thanks,
> Hyeonggon.
> 
> > >> 
> > >> Maybe the function get_capabilities() want to allocate memory
> > >> even if it's not from DMA zone, but other callers will not expect that.
> > > 
> > > Yeah, I have the same guess too for get_capabilities(), not sure about other
> > > callers. Or, as ChristophL and ChristophH said(Sorry, not sure if this is
> > > the right way to call people when the first name is the same. Correct me if
> > > it's wrong), any buffer requested from kmalloc can be used by device driver.
> > > Means device enforces getting memory inside addressing limit for those
> > > DMA transferring buffer which is usually large, Megabytes level with
> > > vmalloc() or alloc_pages(), but doesn't care about this kind of small
> > > piece buffer memory allocated with kmalloc()? Just a guess, please tell
> > > a counter example if anyone happens to know, it could be easy.
> > > 
> > > 
> > >> 
> > >> >  			kmalloc_caches[KMALLOC_DMA][i] = create_kmalloc_cache(
> > >> >  				kmalloc_info[i].name[KMALLOC_DMA],
> > >> >  				kmalloc_info[i].size,
> > >> > -- 
> > >> > 2.17.2
> > >> > 
> > >> > 
> > >> 
> > > 
> > 

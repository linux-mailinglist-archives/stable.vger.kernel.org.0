Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBE948772D
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 12:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238354AbiAGL47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 06:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238445AbiAGL4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 06:56:45 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFDAC034003;
        Fri,  7 Jan 2022 03:56:45 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id u16so4713690plg.9;
        Fri, 07 Jan 2022 03:56:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JLgB+8SwNkq1hxQ6rMptEY0LB++ryMfLvvofb8EfBbs=;
        b=gPQ3FkicBPrX+aFjP0SyJpmjRm6CLsi6+aKZJVRRcQgGb4rsuHqN7+fXtKR1haiDFw
         h1OpOSFfZ738pdrAI5qr+b7c7uKT0KNseERh1pvJkwKXNfZZyaxo9vU/Ox7ZPTMnp9IR
         YFaqA75rAJ0+i9zMQdeaXeU7pHiwc807sRl7xRc0BLddaY6u6Fldv3zDd7Wp3jBIvnr1
         D4XXpNTzRBawPzTgtkeX4qXUbgsV9PNyXhathIwnWHHHsmCrPDv205TRvhjmsCi2ZtPp
         wge7F5qu3IJwjSkQynmvaEnXPp1bUsVpm0cKkF7HKhtMf+sOgT4Sz7YeCuOvY8jK1EXk
         7qCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JLgB+8SwNkq1hxQ6rMptEY0LB++ryMfLvvofb8EfBbs=;
        b=VpAo2sbTGcX9CQpS8GPPPxmGx5Q/ImXPudpgQkk6g3xzI6+U4819lR8EvvW4c1eqs6
         wngA4j9M79vrAfnsD9usI/WpjOmHAhTlDyWsuZg/T6QZBpp0qLx4fSqQ3+xYGOtssGme
         RBi+P0HmNquNosRkoeYfIKZgfHrUgW+W4YrUVr9z+agE1LcgSbRXVFifEIYaVy/dEVXS
         P1kOf3bfF3MH/7YphrRO5UwlYbu5TQ+yyhCtoPpTBNvq9IA+Bz7Exb1zx70yePFGdv57
         MioW4oTRyPf7bD5u+sLzVXwAq4PSqijN7oADU1pKuexh5wo5SwjUmij+XPCxCAciuuZK
         c7FQ==
X-Gm-Message-State: AOAM531YGwfrRFp4adKFN+CfQZ9ZhBMXkW4+RaV+wZWOlfVwWnrunGUj
        AwGCy4RCw2dqLnE5ku3QchU=
X-Google-Smtp-Source: ABdhPJwSKz9gRS4YXXsG0cGPlKpWY+DCW8zdfng9ZRZ47ARlJnxZvYrQS9W+LrU4kVWZyNJzWcY9uw==
X-Received: by 2002:a17:902:8498:b0:149:f459:adfb with SMTP id c24-20020a170902849800b00149f459adfbmr6610921plo.85.1641556604847;
        Fri, 07 Jan 2022 03:56:44 -0800 (PST)
Received: from odroid ([114.29.23.242])
        by smtp.gmail.com with ESMTPSA id e11sm5301883pjh.14.2022.01.07.03.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 03:56:44 -0800 (PST)
Date:   Fri, 7 Jan 2022 11:56:38 +0000
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Baoquan He <bhe@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, cl@linux.com,
        John.p.donnelly@oracle.com, kexec@lists.infradead.org,
        stable@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v3 5/5] mm/slub: do not create dma-kmalloc if no managed
 pages in DMA zone
Message-ID: <20220107115638.GB2769814@odroid>
References: <20211213122712.23805-1-bhe@redhat.com>
 <20211213122712.23805-6-bhe@redhat.com>
 <20211213134319.GA997240@odroid>
 <20211214053253.GB2216@MiWiFi-R3L-srv>
 <f5ff82eb-73b6-55b5-53d7-04ab73ce5035@suse.cz>
 <20211215044818.GB1097530@odroid>
 <20211215070335.GA1165926@odroid>
 <20211215072710.GA3010@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215072710.GA3010@lst.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 15, 2021 at 08:27:10AM +0100, Christoph Hellwig wrote:
> On Wed, Dec 15, 2021 at 07:03:35AM +0000, Hyeonggon Yoo wrote:
> > I'm not sure that allocating from ZONE_DMA32 instead of ZONE_DMA
> > for kdump kernel is nice way to solve this problem.
> 
> What is the problem with zones in kdump kernels?
> 
> > Devices that requires ZONE_DMA memory is rare but we still support them.
> 
> Indeed.
> 
> > >     1) Do not call warn_alloc in page allocator if will always fail
> > >     to allocate ZONE_DMA pages.
> > > 
> > > 
> > >     2) let's check all callers of kmalloc with GFP_DMA
> > >     if they really need GFP_DMA flag and replace those by DMA API or
> > >     just remove GFP_DMA from kmalloc()
> > > 
> > >     3) Drop support for allocating DMA memory from slab allocator
> > >     (as Christoph Hellwig said) and convert them to use DMA32
> > 
> > 	(as Christoph Hellwig said) and convert them to use *DMA API*
> > 
> > >     and see what happens
> 
> This is the right thing to do, but it will take a while.  In fact
> I dont think we really need the warning in step 1, a simple grep
> already allows to go over them.  I just looked at the uses of GFP_DMA
> in drivers/scsi for example, and all but one look bogus.
> 
> > > > > Yeah, I have the same guess too for get_capabilities(), not sure about other
> > > > > callers. Or, as ChristophL and ChristophH said(Sorry, not sure if this is
> > > > > the right way to call people when the first name is the same. Correct me if
> > > > > it's wrong), any buffer requested from kmalloc can be used by device driver.
> > > > > Means device enforces getting memory inside addressing limit for those
> > > > > DMA transferring buffer which is usually large, Megabytes level with
> > > > > vmalloc() or alloc_pages(), but doesn't care about this kind of small
> > > > > piece buffer memory allocated with kmalloc()? Just a guess, please tell
> > > > > a counter example if anyone happens to know, it could be easy.
> 
> The way this works is that the dma_map* calls will bounce buffer memory
> that does to fall into the addressing limitations.  This is a performance
> overhead, but allows drivers to address all memory in a system.  If the
> driver controls memory allocation it should use one of the dma_alloc_*
> APIs that allocate addressable memory from the start.  The allocator
> will dip into ZONE_DMA and ZONE_DMA32 when needed.

Hello Christoph, Baoquan and I started this cleanup.
But we're a bit confused. I want to ask you something.

-   Did you mean dma_map_* can handle arbitrary buffer, (and dma_map_* will
    bounce buffer when necessary) Can we assume it on every architectures
    and buses?

    Reading at the DMA API documentation and code (dma_map_page_attrs(),
    dma_direct_map_page()), I'm not sure about that.

    In the documentation: (dma_map_single)
    	Further, the DMA address of the memory must be within the
	dma_mask of the device (the dma_mask is a bit mask of the
	addressable region for the device, i.e., if the DMA address of
	the memory ANDed with the dma_mask is still equal to the DMA
	address, then the device can perform DMA to the memory).  To
	ensure that the memory allocated by kmalloc is within the dma_mask,
	the driver may specify various platform-dependent flags to restrict
	the DMA address range of the allocation (e.g., on x86, GFP_DMA
	guarantees to be within the first 16MB of available DMA addresses,
	as required by ISA devices).

-   In what function does the DMA API do bounce buffering?

Thanks a lot,
Hyeonggon

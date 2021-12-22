Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85BB47D1CF
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 13:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244896AbhLVMhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 07:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbhLVMhJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 07:37:09 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAB4C061401;
        Wed, 22 Dec 2021 04:37:09 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id s1so505830pga.5;
        Wed, 22 Dec 2021 04:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UZz7xhafkkHpJkMgl/kac5c4UCSL804TVcwmmdEcK/0=;
        b=nsK2TtW3n6e1+xlg1RZyMo4ycIQFl2Xn4YC2120yajzQ6jPjoaIwA6gZz1sGETLPUL
         Rfa/LfPmrvEWU4Ei7szxx6trUEnm0qqv0dd2AiuW7yC9Q8Kmj65hZzxMmeDD3bHL/spD
         7R1e6dtfBRTi2XLI4rk8HxD+FiGZii7cJPWWjtz94MCdYnZAByH7nd70yU8pbinerVFe
         czLvEyE+RXSPw54P41GoQuj/8IBRLGfLgE/5wHW3f/xNdt8UjnFKxL/mLLdLjPFFyQdm
         00IoO5rCraGZGFjUndcF10Su7RbUd0SQh9K+J3+3MKToFMJm3/n6GSWfk3qCY+FDHmMQ
         CjxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UZz7xhafkkHpJkMgl/kac5c4UCSL804TVcwmmdEcK/0=;
        b=iovJylkErsXzynctPTQVjz+IDCGpCA6MPSZeFhoFPb7McpuqV4uaG0fe2kmPbLYLz2
         1FaSEAzOU6kP15C4YEX7A2LPDUsv+6h2Qje0wwCjMu0a3UABF0+sc1chv4nhRwyOGvXF
         BaCBy0NiRonJe/5j55dwxc1CaumAvzRkutSF6t6dg+PwzWWuGgWEyuDF/wgD/G5Titw5
         Z2pruoaiN4p13fuQlSQqx88IREIdL5cChGeKOAddFmdnD0BT2Pc3pCv1UFfY6DnRGsKS
         dBGZh874wtzXyajhx35KSjBBQ7uP/n47kXG4s1Vc8sKLQzR7rAMw3mNWfQ5wbIkGHrjd
         y2Hg==
X-Gm-Message-State: AOAM530KPiwscRhzP4APoFeRXLzqTbc0qxRXtxY3hvi8aWo3tTClewUG
        K7jRiXzyUGTQtChrj3D496Q=
X-Google-Smtp-Source: ABdhPJywzhxYDDrq26wikSanWRvBdbTroGbSbcvCsRISQViIDfeWIm5m9pfq2nL//FWIWUPg7CAIoQ==
X-Received: by 2002:a63:6dc8:: with SMTP id i191mr333146pgc.34.1640176628671;
        Wed, 22 Dec 2021 04:37:08 -0800 (PST)
Received: from ip-172-31-30-232.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id om10sm2616130pjb.13.2021.12.22.04.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 04:37:08 -0800 (PST)
Date:   Wed, 22 Dec 2021 12:37:03 +0000
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org, cl@linux.com,
        John.p.donnelly@oracle.com, kexec@lists.infradead.org,
        stable@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v3 5/5] mm/slub: do not create dma-kmalloc if no managed
 pages in DMA zone
Message-ID: <YcMb7+RESj1nEx9l@ip-172-31-30-232.ap-northeast-1.compute.internal>
References: <20211213122712.23805-1-bhe@redhat.com>
 <20211213122712.23805-6-bhe@redhat.com>
 <20211213134319.GA997240@odroid>
 <20211214053253.GB2216@MiWiFi-R3L-srv>
 <Ybx2szXEgl1tN4MD@ip-172-31-30-232.ap-northeast-1.compute.internal>
 <20211221085623.GA7733@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221085623.GA7733@lst.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Christoph.

On Tue, Dec 21, 2021 at 09:56:23AM +0100, Christoph Hellwig wrote:
> On Fri, Dec 17, 2021 at 11:38:27AM +0000, Hyeonggon Yoo wrote:
> > My understanding is any buffer requested from kmalloc (without
> > GFP_DMA/DMA32) can be used by device driver because it allocates
> > continuous physical memory. It doesn't mean that buffer allocated
> > with kmalloc is free of addressing limitation.
> 
> Yes.
> 
> > 
> > the addressing limitation comes from the capability of device, not
> > allocation size. if you allocate memory using alloc_pages() or kmalloc(),
> > the device has same limitation. and vmalloc can't be used for
> > devices because they have no MMU.
> 
> vmalloc can be used as well, it just needs to be setup as a scatterlist
> and needs a little lover for DMA challenged platforms with the
> invalidate_kernel_vmap_range and flush_kernel_vmap_range helpers.

Oh I misunderstood this. Underlying physical address of vmalloc()-allocated memory
can be mapped using DMA API, and it needs to be setup as scatterlist because
the allocated memory is not physically continuous. Right?

BTW, looking at the API I think the scsi case can be converted to use
dma_alloc_pages(). but driver requires 512 bytes of buffer and the API
supports allocating by at least page size.

It's not a big problem as it allocates a single buffer but in other
cases maybe not. Can't we use dma pool for non-coherent pages?

Thanks,
Hyeonggon.

> > But we can map memory outside DMA zone into bounce buffer (which resides
> > in DMA zone) using DMA API.
> 
> Yes, although in a few specific cases the bounce buffer could also come
> from somewhere else.

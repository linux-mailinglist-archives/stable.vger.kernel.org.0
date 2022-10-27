Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A9B60FB11
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 17:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235384AbiJ0PCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 11:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235495AbiJ0PCH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 11:02:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1575C180580
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 08:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666882921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7tuZlBsEJHoXDT8PckH4DBYM57QoO40s7XkvRbeR/28=;
        b=deo0S/LTOiu9tSn9VdJsLs//H4N1m8a77RzUeiyIm2Cq9MY61yiTcVTBqIleXeQwgLZOnz
        ilIR2a6E5RdI8QpijInNZ9QuOqHMVS6fwX+ASIJrZy5zzwMr7geXHpX2Xjp0yls8bcPDNl
        qx8IAPDTQCSu1XHhVsWmlMHzKoJCAQA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-629-EahqewzZPq6_Yu2mdnE0pA-1; Thu, 27 Oct 2022 11:01:59 -0400
X-MC-Unique: EahqewzZPq6_Yu2mdnE0pA-1
Received: by mail-qv1-f71.google.com with SMTP id h1-20020a0ceda1000000b004b899df67a4so1078507qvr.1
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 08:01:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7tuZlBsEJHoXDT8PckH4DBYM57QoO40s7XkvRbeR/28=;
        b=Ve+R+98PkD1D0oU3YAmjfnh7XZKcTthOjtK1s1S4kIWTbvtVPw0hJMje3p4C/prrsF
         OhiAvJLljkwOQ8XS8EvKqgd0grwcNRlM69rgSMr2bjPKZvzjBf3p5JD8r9yxrqpTppJg
         UAbG6zRFOiKF6s5iWZrVKjH9SElxehJVwGdo4TINi78JWj+qoYng/VypPTy+DGuzyT1J
         AYOt8lz+3hQZOfpqyZAmJKqiK9sQlBI7OOaGsV2/yG52NJyl4E9Lx2vxDJvWzAcvtYY0
         PIjK0xL3UmrMnTx5jS4i4oLz4PocuP3KvDnEvemEbRWYEeS9j8+dfHic83UCnFobaQ3a
         VNpQ==
X-Gm-Message-State: ACrzQf3kgSxvIh86CkC5rcibHwAlQlMi1Bp7NX9atclzLypZwEhAH4cc
        56b8GgK0QSX5QC9kyJ8dSTsF7UjPWOidb9+VYRBlLSpL0TBg34TfO4HhsuDM6Lstji0ccSIKzq2
        z4NfbiMwcUQphDd/L
X-Received: by 2002:a05:622a:1898:b0:39a:1184:43cc with SMTP id v24-20020a05622a189800b0039a118443ccmr41606905qtc.151.1666882917610;
        Thu, 27 Oct 2022 08:01:57 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7tDA4BdFqAk+er3D6ejMgTxpSnvM+8eLCkOssg2My81SL5V5FRU7pJlzMoYh7ViGzp/Fr/8A==
X-Received: by 2002:a05:622a:1898:b0:39a:1184:43cc with SMTP id v24-20020a05622a189800b0039a118443ccmr41606830qtc.151.1666882916926;
        Thu, 27 Oct 2022 08:01:56 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id m8-20020ac866c8000000b003a4c3c4d2d4sm980920qtp.49.2022.10.27.08.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 08:01:56 -0700 (PDT)
Date:   Thu, 27 Oct 2022 11:01:55 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Hugh Dickins <hughd@google.com>,
        Yuanzheng Song <songyuanzheng@huawei.com>
Cc:     Yuanzheng Song <songyuanzheng@huawei.com>,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        david@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH STABLE 5.10] mm/memory: add non-anonymous page check in
 the copy_present_page()
Message-ID: <Y1qdY8oUlUvWl067@x1n>
References: <20221024094911.3054769-1-songyuanzheng@huawei.com>
 <3823471f-6dda-256e-e082-718879c05449@google.com>
 <Y1nRiJ1LYB62uInn@x1n>
 <fffefe4-adce-a7d-23e0-9f8afc7ce6cf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fffefe4-adce-a7d-23e0-9f8afc7ce6cf@google.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 26, 2022 at 06:48:29PM -0700, Hugh Dickins wrote:
> On Wed, 26 Oct 2022, Peter Xu wrote:
> 
> > Hi, Yuanzheng,
> > 
> > On Wed, Oct 26, 2022 at 02:51:16PM -0700, Hugh Dickins wrote:
> > > On Mon, 24 Oct 2022, Yuanzheng Song wrote:
> > > 
> > > > The vma->anon_vma of the child process may be NULL because
> > > > the entire vma does not contain anonymous pages. In this
> > > > case, a BUG will occur when the copy_present_page() passes
> > > > a copy of a non-anonymous page of that vma to the
> > > > page_add_new_anon_rmap() to set up new anonymous rmap.
> > > > 
> > > > ------------[ cut here ]------------
> > > > kernel BUG at mm/rmap.c:1044!
> > > > Internal error: Oops - BUG: 0 [#1] SMP
> > > > Modules linked in:
> > > > CPU: 2 PID: 3617 Comm: test Not tainted 5.10.149 #1
> > > > Hardware name: linux,dummy-virt (DT)
> > > > pstate: 80000005 (Nzcv daif -PAN -UAO -TCO BTYPE=--)
> > > > pc : __page_set_anon_rmap+0xbc/0xf8
> > > > lr : __page_set_anon_rmap+0xbc/0xf8
> > > > sp : ffff800014c1b870
> > > > x29: ffff800014c1b870 x28: 0000000000000001
> > > > x27: 0000000010100073 x26: ffff1d65c517baa8
> > > > x25: ffff1d65cab0f000 x24: ffff1d65c416d800
> > > > x23: ffff1d65cab5f248 x22: 0000000020000000
> > > > x21: 0000000000000001 x20: 0000000000000000
> > > > x19: fffffe75970023c0 x18: 0000000000000000
> > > > x17: 0000000000000000 x16: 0000000000000000
> > > > x15: 0000000000000000 x14: 0000000000000000
> > > > x13: 0000000000000000 x12: 0000000000000000
> > > > x11: 0000000000000000 x10: 0000000000000000
> > > > x9 : ffffc3096d5fb858 x8 : 0000000000000000
> > > > x7 : 0000000000000011 x6 : ffff5a5c9089c000
> > > > x5 : 0000000000020000 x4 : ffff5a5c9089c000
> > > > x3 : ffffc3096d200000 x2 : ffffc3096e8d0000
> > > > x1 : ffff1d65ca3da740 x0 : 0000000000000000
> > > > Call trace:
> > > >  __page_set_anon_rmap+0xbc/0xf8
> > > >  page_add_new_anon_rmap+0x1e0/0x390
> > > >  copy_pte_range+0xd00/0x1248
> > > >  copy_page_range+0x39c/0x620
> > > >  dup_mmap+0x2e0/0x5a8
> > > >  dup_mm+0x78/0x140
> > > >  copy_process+0x918/0x1a20
> > > >  kernel_clone+0xac/0x638
> > > >  __do_sys_clone+0x78/0xb0
> > > >  __arm64_sys_clone+0x30/0x40
> > > >  el0_svc_common.constprop.0+0xb0/0x308
> > > >  do_el0_svc+0x48/0xb8
> > > >  el0_svc+0x24/0x38
> > > >  el0_sync_handler+0x160/0x168
> > > >  el0_sync+0x180/0x1c0
> > > > Code: 97f8ff85 f9400294 17ffffeb 97f8ff82 (d4210000)
> > > > ---[ end trace a972347688dc9bd4 ]---
> > > > Kernel panic - not syncing: Oops - BUG: Fatal exception
> > > > SMP: stopping secondary CPUs
> > > > Kernel Offset: 0x43095d200000 from 0xffff800010000000
> > > > PHYS_OFFSET: 0xffffe29a80000000
> > > > CPU features: 0x08200022,61806082
> > > > Memory Limit: none
> > > > ---[ end Kernel panic - not syncing: Oops - BUG: Fatal exception ]---
> > > > 
> > > > This problem has been fixed by the fb3d824d1a46
> > > > ("mm/rmap: split page_dup_rmap() into page_dup_file_rmap() and page_try_dup_anon_rmap()"),
> > > > but still exists in the linux-5.10.y branch.
> > > > 
> > > > This patch is not applicable to this version because
> > > > of the large version differences. Therefore, fix it by
> > > > adding non-anonymous page check in the copy_present_page().
> > > > 
> > > > Fixes: 70e806e4e645 ("mm: Do early cow for pinned pages during fork() for ptes")
> > > > Signed-off-by: Yuanzheng Song <songyuanzheng@huawei.com>
> > > 
> > > It's a good point, but this patch should not go into any stable release
> > > without an explicit Ack from either Peter Xu or David Hildenbrand.
> > > 
> > > To my eye, it's simply avoiding the issue, rather than fixing
> > > it properly; and even if the issue is so rare, and fixing properly
> > > too difficult or inefficent (a cached anon_vma?), that a workaround
> > > is good enough, it still looks like the wrong workaround (checking
> > > dst_vma->anon_vma instead of PageAnon seems more to the point, and
> > > less lenient).
> > 
> > Sorry to have missed this patch. I agree with Hugh that this patch may not
> > really fix the issue.
> > 
> > IIUC it's the case where the vma is privately mapping a file.  Some shared
> > pages got pinned, and here we're trying to trigger the CoW assuming it's
> > anonymous page but it's not.
> > 
> > The pin should be RO - if it was a write pin, CoW should have happened on
> > the page cache and there should be an anonymous page, and anon_vma should
> > be there, no issue should happen.  Only if with RO pin, we won't trigger
> > CoW, we won't have any anonymous page, we won't have anon_vma, hence the
> > panic.
> > 
> > The thing is if the page is RO pinned, skip copying it (as what was done in
> > this patch) is not correct either, because e.g. a follow up write after
> > fork() from the parent will trigger CoW and the dma RO page that was pinned
> > will be inconsistent to the page in pgtable anymore, I think.
> > 
> > IIUC the correct fix is what David worked on with unshare - when RO pin the
> > page cache we should have triggered CoR already before fork().  But as you
> > mentioned, that's too much change for stable.
> > 
> > So besides this workaround which seems feasible to at least not panic the
> > system (Hugh: I can't quickly tell what'll be the difference here to check
> > dst anon_vma or PageAnon, they all seem to work?  I could have missed
> 
> Thanks for all the helpful elucidation above.
> 
> My thought here, in favour of checking dst anon_vma rather than PageAnon,
> was that a common case would be that the private file vma does already
> have an anon_vma attached (from earlier CoW on some other page), and
> in that case there is no justification for taking this short cut to
> avoid the BUG in __page_set_anon_rmap() on every !PageAnon in the vma.

I see, thanks for explaining.  Definitely makes sense.

> 
> And I imagined that the correct fix (short of going forward with David's
> full changes) would be to back out to a context where one could add an
> anon_vma_prepare(), then retry after that - involves dropping pt lock,
> maybe gets nasty (tedious, anyway).

Right, that looks a larger changeset with minimum benefit - the page is
still inconsistent before fork(), and also for users don't fork() at all
after the RO pin.

It looks to me Hugh's suggestion would be the best suite here for stable.
Yuanzheng, what do you think?

For the long term I think we should wait for David's further unshare work
so gup_must_unshare() will work for page caches too while mapped private.

Thanks,

-- 
Peter Xu


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6105A58B2B2
	for <lists+stable@lfdr.de>; Sat,  6 Aug 2022 01:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241548AbiHEXN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Aug 2022 19:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240503AbiHEXNy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Aug 2022 19:13:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9197D27173
        for <stable@vger.kernel.org>; Fri,  5 Aug 2022 16:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659741231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CQ0tUUX9dSdS4JRTC1zPGHaQM3Hc6bp+ASxYzjmtUmQ=;
        b=E555HY3/Kht+Je+3fgfn9tVF44MH7avovwzM2VCN4BOZg5jU82FXTSTEXZugdZYPVj5y/3
        1obQXpjJ79DJ5XJiMKTNcaDEVFBZh6jq1QWny9UlxBUHqJfq8KzYDcOAwU4bEr3s0SM6di
        xlTj8kHW016iJpBtQRjtTyGGTAjoQno=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-i2VtkK7mNxyiUtS7WObCYQ-1; Fri, 05 Aug 2022 19:13:50 -0400
X-MC-Unique: i2VtkK7mNxyiUtS7WObCYQ-1
Received: by mail-qt1-f197.google.com with SMTP id c27-20020ac84e1b000000b00342e8e0b160so1300659qtw.9
        for <stable@vger.kernel.org>; Fri, 05 Aug 2022 16:13:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=CQ0tUUX9dSdS4JRTC1zPGHaQM3Hc6bp+ASxYzjmtUmQ=;
        b=edXcALTyhwXN0qGSMbigJK3ONONvVgaijM7iMNo2aK6r2fz0+uBRvHA5rJwOhfP6OI
         vLydDsEtd2vKjRV+XegANTp35w5wHz7VVsxcs8STrOwSGIrI7tNKO05rgXw78L6k+d/U
         PuT+8ynD9Q+Ox8mOlzZUgLZO2TidH9Z2pyZimQL3er7JOilf/vIWRPvyKPqE7w31fGT1
         NTQWoKPp3HB/gUtnNw0ujF0mHEY0HK0kn9E0b7+0h2cOjNktZM01ak2HyTi0dAWqYmZ8
         ykerNWHAQ2ziXE/mnN2a+g8OqgD1Bm6zPeFPHQypiWAFD400wmdw5JKKtHnIJPXP6IEO
         7qTg==
X-Gm-Message-State: ACgBeo263gYK0qKFKRwYI8SAECZMM1Wxqhc1MX2d4xvqB+HYSBLNuwRW
        za7o0zA4Lnwfw8LiZrmTp1yWzf0LjTc9dnAjzPfU+6XZiOtYxocsz4GkJHvz4bt+Lc8bbAu1IRy
        FkmJuRRF1pGdkpJwn
X-Received: by 2002:a05:620a:b86:b0:6b8:d74e:1e08 with SMTP id k6-20020a05620a0b8600b006b8d74e1e08mr6880997qkh.166.1659741229904;
        Fri, 05 Aug 2022 16:13:49 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7vQnU94QQncO9wXjydH0biWvfzN2On2lgdFWzew+raRRdFz5zCSICz/EgkRwetHoifGyaVTQ==
X-Received: by 2002:a05:620a:b86:b0:6b8:d74e:1e08 with SMTP id k6-20020a05620a0b8600b006b8d74e1e08mr6880984qkh.166.1659741229647;
        Fri, 05 Aug 2022 16:13:49 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id r11-20020ac87eeb000000b0031f286f868dsm3289067qtc.92.2022.08.05.16.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 16:13:49 -0700 (PDT)
Date:   Fri, 5 Aug 2022 19:13:47 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Peter Feiner <pfeiner@google.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v1 1/2] mm/hugetlb: fix hugetlb not supporting
 write-notify
Message-ID: <Yu2kK6s8m8NLDjuV@xz-m1.local>
References: <20220805110329.80540-1-david@redhat.com>
 <20220805110329.80540-2-david@redhat.com>
 <Yu1eCsMqa641zj5C@xz-m1.local>
 <Yu1gHnpKRZBhSTZB@monkey>
 <c2a3b903-099c-4b79-6923-8b288d404c51@redhat.com>
 <Yu1ie559zt8VvDc1@monkey>
 <73050e64-e40f-0c94-be96-316d1e8d5f3b@redhat.com>
 <Yu2CI4wGLHCjMSWm@monkey>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yu2CI4wGLHCjMSWm@monkey>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 05, 2022 at 01:48:35PM -0700, Mike Kravetz wrote:
> On 08/05/22 20:57, David Hildenbrand wrote:
> > On 05.08.22 20:33, Mike Kravetz wrote:
> > > On 08/05/22 20:25, David Hildenbrand wrote:
> > >> On 05.08.22 20:23, Mike Kravetz wrote:
> > >>> On 08/05/22 14:14, Peter Xu wrote:
> > >>>> On Fri, Aug 05, 2022 at 01:03:28PM +0200, David Hildenbrand wrote:
> > >>>>> diff --git a/mm/mmap.c b/mm/mmap.c
> > >>>>> index 61e6135c54ef..462a6b0344ac 100644
> > >>>>> --- a/mm/mmap.c
> > >>>>> +++ b/mm/mmap.c
> > >>>>> @@ -1683,6 +1683,13 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
> > >>>>>  	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
> > >>>>>  		return 0;
> > >>>>>  
> > >>>>> +	/*
> > >>>>> +	 * Hugetlb does not require/support writenotify; especially, it does not
> > >>>>> +	 * support softdirty tracking.
> > >>>>> +	 */
> > >>>>> +	if (is_vm_hugetlb_page(vma))
> > >>>>> +		return 0;
> > >>>>
> > >>>> I'm kind of confused here..  you seems to be fixing up soft-dirty for
> > >>>> hugetlb but here it's explicitly forbidden.
> > >>>>
> > >>>> Could you explain a bit more on why this patch is needed if (assume
> > >>>> there'll be a working) patch 2 being provided?
> > >>>>
> > >>>
> > >>> No comments on the patch, but ...
> > >>>
> > >>> Since it required little thought, I ran the test program on next-20220802 and
> > >>> was surprised that the issue did not recreate.  Even added a simple printk
> > >>> to make sure we were getting into vma_wants_writenotify with a hugetlb vma.
> > >>> We were.
> > >>
> > >>
> > >> ... does your config have CONFIG_MEM_SOFT_DIRTY enabled?
> > >>
> > > 
> > > No, Duh!
> > > 
> > > FYI - Some time back, I started looking at adding soft dirty support for
> > > hugetlb mappings.  I did not finish that work.  But, I seem to recall
> > > places where code was operating on hugetlb mappings when perhaps it should
> > > not.
> > > 
> > > Perhaps, it would also be good to just disable soft dirty for hugetlb at
> > > the source?
> > 
> > I thought about that as well. But I came to the conclusion that without
> > patch #2, hugetlb VMAs cannot possibly support write-notify, so there is
> > no need to bother in vma_wants_writenotify() at all.
> > 
> > The "root" would be places where we clear VM_SOFTDIRTY. That should only
> > be fs/proc/task_mmu.c:clear_refs_write() IIRC.
> > 
> > So I don't particularly care, I consider this patch a bit cleaner and
> > more generic, but I can adjust clear_refs_write() instead of there is a
> > preference.
> > 
> 
> After a closer look, I agree that this may be the simplest/cleanest way to
> proceed.  I was going to suggest that you note hugetlb does not support
> softdirty, but see you did in the comment.
> 
> Acked-by: Mike Kravetz <mike.kravetz@oracle.com>

Filtering out hugetlbfs in vma_wants_writenotify() is still a bit hard to
follow to me, since it's not clear why hugetlbfs never wants writenotify.

If it's only about soft-dirty, we could have added the hugetlbfs check into
vma_soft_dirty_enabled(), then I think it'll achieve the same thing and
much clearer - with the soft-dirty check constantly returning false for it,
hugetlbfs shared vmas should have vma_wants_writenotify() naturally return
0 already.

For the long term - shouldn't we just enable soft-dirty for hugetlbfs?  I
remember Mike used to have that in todo.  Since we've got patch 2 already,
I feel like that's really much close (is the only missing piece the clear
refs write part? or maybe some more that I didn't notice).

Then patch 1 (or IMHO equivalant check in vma_soft_dirty_enabled(), but
maybe in stable trees we don't have vma_soft_dirty_enabled then it's
exactly patch 1) can be a stable-only backport just to avoid the bug from
triggering.

Thanks,

-- 
Peter Xu


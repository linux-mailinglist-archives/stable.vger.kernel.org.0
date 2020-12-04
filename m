Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A3E2CF52E
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 20:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388129AbgLDTyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 14:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730681AbgLDTyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 14:54:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26374C0613D1
        for <stable@vger.kernel.org>; Fri,  4 Dec 2020 11:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tM/EF1zobTNDLoJZIcx9y7SBvpWLPM3jHAoQD68psVI=; b=YtvMInOrdKGP7IEuDjxROBxqvG
        Qo/9aZd2M5zXOJwEGHYt3O4JxtqvsdzJeMAcecLY8UPwhJlw5a6ipWqovnu0w7TxxySp7e9xS+NHL
        BND9m8Lqwm8VPsYY4lv1V4B0H8j7cPWc5joVBEhPC6+OaESofuQXI6LQLMuw5wV2jCvwnnvNutSbE
        zHNCipJHwlwJm4gClmGltUSOP9x6OcBNVYUIryD5bgaIpJxQZl7E0fR07a+1i3lOG/uNDZDIhN1ei
        HrzC8qcilLc+gPwDgSbFPjFQO99Gq9BVAvsusw0vGOcYF5GxFCfH/Fu4LfZbdbxM/cP+2IGrdbMhb
        yZgxm0Hg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1klH8s-0003nW-1w; Fri, 04 Dec 2020 19:53:22 +0000
Date:   Fri, 4 Dec 2020 19:53:21 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     David Hildenbrand <david@redhat.com>,
        Liu Zixian <liuzixian4@huawei.com>, akpm@linux-foundation.org,
        linmiaohe@huawei.com, louhongxiang@huawei.com, linux-mm@kvack.org,
        hushiyuan@huawei.com, stable@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2] fix mmap return value when vma is merged after
 call_mmap()
Message-ID: <20201204195321.GQ11935@casper.infradead.org>
References: <20201203085350.22624-1-liuzixian4@huawei.com>
 <d59e9e5a-1d6e-e7dc-21ec-17777fe9f7a2@redhat.com>
 <20201204151028.GZ5487@ziepe.ca>
 <20201204152535.GP11935@casper.infradead.org>
 <20201204160451.GC5487@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204160451.GC5487@ziepe.ca>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 04, 2020 at 12:04:51PM -0400, Jason Gunthorpe wrote:
> On Fri, Dec 04, 2020 at 03:25:35PM +0000, Matthew Wilcox wrote:
> 
> > This commit makes no sense.  I know it's eight years old, so maybe the
> > device driver which did this has long been removed from the tree, but
> > davem's comment was (iirc) related to a device driver for a graphics
> > card that would 256MB-align the user address.  Another possibility is
> > that userspace always asks for a 256MB-aligned address these days.
> 
> Presumably the latter, otherwise people would be complaining about the
> WARN_ON.
> 
> With some grep I could only find this:
> 
> static int mc68x328fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
> {
> #ifndef MMU
>         /* this is uClinux (no MMU) specific code */
> 
>         vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
>         vma->vm_start = videomemory;
> 
>         return 0;
> #else
>         return -EINVAL;
> #endif
> }
> 
> So it does seem gone

I found some buggy, uncompilable code in binder that used to modify it:

-#ifdef CONFIG_CPU_CACHE_VIPT
-       if (cache_is_vipt_aliasing()) {
-               while (CACHE_COLOUR(
-                       pr_info("%s: %d %lx-%lx maps %pK bad alignment\n",
-                               __func__,
-                               alloc->pid, vma->vm_start, vma->vm_end,
-                               alloc->buffer);
-                       vma->vm_start += PAGE_SIZE;
-               }
-       }
-#endif

pretty sure that even if the syntax error were fixed, it would have
done something awful and wrong.

It seems like it used to be quite popular to do it for nommu-fb-mmap,
but it fell out of favour.  If there was a sparc fb driver that did it,
it got deleted before 2.6.12-rc2, so I don't really care.

So yes, let's turn this into a BUG_ON.


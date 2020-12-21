Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3902E02D4
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 00:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgLUXNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 18:13:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgLUXNH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 18:13:07 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3A5C0613D6
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 15:12:27 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id q137so10341623iod.9
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 15:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+Y8ZZnXUThIraa3kqic3ZC5rSXsBos2RLv0vNdKIdp8=;
        b=DxVK5T7xYuc3JN8wgvZmILR7izqYuIuOuZP8y9YDH+UGCLq1U5ffM+vkNZbFyoyFfY
         QjYsdKEH4NUBglLU6ZfspgzE2jYzSZms3pYlhjcTdJn9SjgMvNWaFrpdpf2+NwYffk5Y
         VDfiSGmiABKqKfOouHbwEBvyuwGer/TmjR0q2AcU7C+G7TZzNug02zhc7TYu4A1TEvOb
         tV9OmyCeuLeeM5d7FNX4qEcVjsHxvCmsGjLVKs/PABt6O0pe9orzgp5di2aZrq96wVTY
         3rAWaegB1d30JCP0tyjrQ5p61WdzS6iZF2DEwaK+yokbaAXymj2kq8FtCS2EPSlGfS/D
         CCSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+Y8ZZnXUThIraa3kqic3ZC5rSXsBos2RLv0vNdKIdp8=;
        b=iMTHTkSMQtn4XUPd0wM7x11fDI8c+nASiNfvpkZP9XWW6VDwiw/LhXj3vU0S08Bpml
         AAZ4u4RA+P4nncdhOHvG37cwfwgij/b4naABgrZ9QpLhZaQVTp67zWH0u7LmeDV0uzIr
         oeP2gV89HMbujyNDF/x3huzzsZ3uBGUVBwmeJKMzlW5+nouobNu3nf3kF15PFdZewW5H
         a+ezX78r3jetrmcvhFrZMnA0PiKl8vcNZO+h+dwFDo2UaFTQbUS/CxfFjfGPQemp7LZR
         UxzDRFMZNFBUR0CocZtspWjg0L51CKTFvfJL44oxBiv9V5WN5aCewbBJIdcTKC6L6BIO
         h8Vg==
X-Gm-Message-State: AOAM532+iaNek0uVaNbSYnYYjBBUROQZbek3YFEb0bqN7eaFqNCfBxcF
        1h7XCcoEGg8LcyiBoDsE7lA1AA==
X-Google-Smtp-Source: ABdhPJxrNJhpu7hO5zHS9Bem7JnYOOhxdWF9WY7zd5k89jhc62Lw8mKAmazIWoJLYzLC8veIw6+tLA==
X-Received: by 2002:a02:3541:: with SMTP id y1mr16433792jae.66.1608592346477;
        Mon, 21 Dec 2020 15:12:26 -0800 (PST)
Received: from google.com ([2620:15c:183:200:7220:84ff:fe09:2d90])
        by smtp.gmail.com with ESMTPSA id c15sm13515002ils.87.2020.12.21.15.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 15:12:25 -0800 (PST)
Date:   Mon, 21 Dec 2020 16:12:21 -0700
From:   Yu Zhao <yuzhao@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X+Er1Rjv1W7rzcw7@google.com>
References: <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com>
 <20201221172711.GE6640@xz-x1>
 <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
 <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201221223041.GL6640@xz-x1>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 21, 2020 at 05:30:41PM -0500, Peter Xu wrote:
> On Mon, Dec 21, 2020 at 01:49:55PM -0800, Nadav Amit wrote:
> > BTW: In general, I think that you are right, and that changing of PTEs
> > should not require taking mmap_lock for write. However, I am not sure
> > cow_user_page() is not the only one that poses a problem and whether a more
> > systematic solution is needed. If cow_user_pages() is the only problem, do
> > you think it is possible to do the copying while holding the PTL? It works
> > for normal-pages, but I am not sure whether special-pages pose special
> > problems.
> > 
> > Anyhow, this is an enhancement that we can try later.
> 
> AFAIU mprotect() is the only one who modifies the pte using the mmap write
> lock.  NUMA balancing is also using read mmap lock when changing pte
> protections,

NUMA balance doesn't clear pte_write() -- I would not call setting
pte_none() a change of protection.

> while my understanding is mprotect() used write lock only because
> it manipulates the address space itself (aka. vma layout) rather than modifying
> the ptes, so it needs to.

Yes, and personally, I would only take mmap lock for write when I
change VMAs, not PTE protections.

> At the pte level, it seems always to be the pgtable lock that serializes things.
> 
> So it's perfectly legal to me for e.g. a driver to modify ptes with the read
> lock of mmap_sem, unless I'm severely mistaken.. as long as the pgtable lock is
> taken when doing so.
> 
> If there's a driver that manipulated the ptes, changed the content of the page,
> recover the ptes to origin, and all these happen right after wp_page_copy()
> unlocked the pgtable lock but before wp_page_copy() retakes the same lock
> again, we may face the same issue finding that the page got copied contains
> corrupted data at last.  While I don't know what to blame on the driver either
> because it seems to be exactly following the rules.
> 
> I believe changing into write lock would solve the race here because tlb
> flushing would be guaranteed along the way, but I'm just a bit worried it's not
> the best way to go..

I can't say I disagree with you but the man has made the call and I
think we should just move on.

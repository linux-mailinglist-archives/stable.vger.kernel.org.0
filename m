Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B23A2E17CE
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgLWDgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:36:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727372AbgLWDgu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 22:36:50 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF50C0613D6
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 19:36:10 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id w12so13834258ilm.12
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 19:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZIOrZp4VvbHbVHD6MydQhHnSb1pJwOMWKWbLXpdZOFI=;
        b=Vhrl2m3iMIa3mMtWmRqOmKoxmGP2khypurHxy69cJjigQyZicp85E1PyetI5yR1mGU
         QmUfzICRUzgBG35f210h8TMBpFciYgz+OzdbHRXJsDFlHg/i2bTTH7RalU4NzLIjd4Qf
         NnbDl1P02SGx/vxNyx72IrFpoKUlJLnXxXoIIuuDqUidX4Uu/zQSG7C2OrEVYjVXIqpn
         g2IWiiCHQQ9KJFzkdtCJOiZhVvSVzcgU+s/d+fLabWmPGTIzBB9VMJyHJyYGFRrb9l+o
         TIZ+0ggvpr4uSrtVQ6ikNCv1K6n+8koWhp7eU5/Jyd3iGMLG6igiwIlJgE6DVNhAR2QW
         y3SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZIOrZp4VvbHbVHD6MydQhHnSb1pJwOMWKWbLXpdZOFI=;
        b=BzMDUPG8jTtlPm5jW5zrtFWbPJwN/mlx6v7gLKXc4IGM0beKFZeKs7o2aWUqZsbQqE
         1MozeWjrpEaBCpPW0ET5rUy1YfG+R47qQqroLxRV6NFZsRSEEnbe5/Q19aZ5J2PLih8a
         YTe+vG/HQAySohO0IPP//3x+mJ/yRokBAW18aOpnlNrvF4EC3dCyzEktyxH6wFFvQRkR
         aXn/Pgl5NiGSA3mgXzmKN7z9DVlsdL+nw8x+RPk5JTufC8yrlF+i1Du2+Pvknb/tngSl
         Wo2roqfdY6D93JjQSSLbG33rQYQuCoTUKFc3qGJ44nUWlZGbRCblz0pAR48UbZrBXc13
         jO6Q==
X-Gm-Message-State: AOAM532lTQXgYkTGBQEKLQbng9bNV2isxVZnpJgPCs1J99HvE5myN/5Z
        glJL8BSTTUk3CGdTsVWH3XZfvg==
X-Google-Smtp-Source: ABdhPJwmFsNaiUtYb57RZoZls9iOlEmeZLPp8r+adegWDnYyoLjPiAj7KYKM5riNKEWykKA2igcNCQ==
X-Received: by 2002:a92:1e10:: with SMTP id e16mr15481208ile.65.1608694569458;
        Tue, 22 Dec 2020 19:36:09 -0800 (PST)
Received: from google.com ([2620:15c:183:200:7220:84ff:fe09:2d90])
        by smtp.gmail.com with ESMTPSA id y12sm17546969ilk.32.2020.12.22.19.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 19:36:08 -0800 (PST)
Date:   Tue, 22 Dec 2020 20:36:04 -0700
From:   Yu Zhao <yuzhao@google.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X+K7JMrTEC9SpVIB@google.com>
References: <X+ESkna2z3WjjniN@google.com>
 <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com>
 <X+JhwVX3s5mU9ZNx@google.com>
 <X+Js/dFbC5P7C3oO@redhat.com>
 <X+KDwu1PRQ93E2LK@google.com>
 <X+Kxy3oBMSLz8Eaq@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X+Kxy3oBMSLz8Eaq@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 22, 2020 at 09:56:11PM -0500, Andrea Arcangeli wrote:
> On Tue, Dec 22, 2020 at 04:39:46PM -0700, Yu Zhao wrote:
> > We are talking about non-COW anon pages here -- they can't be mapped
> > more than once. So why not just identify them by checking
> > page_mapcount == 1 and then unconditionally reuse them? (This is
> > probably where I've missed things.)
> 
> The problem in depending on page_mapcount to decide if it's COW or
> non-COW (respectively wp_page_copy or wp_page_reuse) is that is GUP
> may elevate the count of a COW anon page that become a non-COW anon
> page.
> 
> This is Jann's idea not mine.
> 
> The problem is we have an unprivileged long term GUP like vmsplice
> that facilitates elevating the page count indefinitely, until the
> parent finally writes a secret to it. Theoretically a short term pin
> would do it too so it's not just vmpslice, but the short term pin
> would be incredibly more challenging to become a concern since it'd
> kill a phone battery and flash before it can read any data.
> 
> So what happens with your page_mapcount == 1 check is that it doesn't
> mean non-COW (we thought it did until it didn't for the long term gup
> pin in vmsplice).
> 
> Jann's testcases does fork() and set page_mapcount 2 and page_count to
> 2, vmsplice, take unprivileged infinitely long GUP pin to set
> page_count to 3, queue the page in the pipe with page_count elevated,
> munmap to drop page_count to 2 and page_mapcount to 1.
> 
> page_mapcount is 1, so you'd think the page is non-COW and owned by
> the parent, but the child can still read it so it's very much still
> wp_page_copy material if the parent tries to modify it. Otherwise the
> child can read the content.
> 
> This was supposed to be solvable by just doing the COW in gup(write=0)
> case if page_mapcount > 1 with commit 17839856fd58. I'm not exactly
> sure why that didn't fly and it had to be reverted by Peter in
> a308c71bf1e6e19cc2e4ced31853ee0fc7cb439a but at the time this was
> happening I was side tracked by urgent issues and I didn't manage to
> look back of how we ended up with the big hammer page_count == 1 check
> instead to decide if to call wp_page_reuse or wp_page_shared.
> 
> So anyway, the only thing that is clear to me is that keeping the
> child from reading the page_mapcount == 1 pages of the parent, is the
> only reason why wp_page_reuse(vmf) will only be called on
> page_count(page) == 1 and not on page_mapcount(page) == 1.
> 
> It's also the reason why your page_mapcount assumption will risk to
> reintroduce the issue, and I only wish we could put back page_mapcount
> == 1 back there.
> 
> Still even if we put back page_mapcount there, it is not ok to leave
> the page fault with stale TLB entries and to rely on the fact
> wp_page_shared won't run. It'd also avoid the problem but I think if
> you leave stale TLB entries in change_protection just like NUMA
> balancing does, it also requires a catcher just like NUMA balancing
> has, or it'd truly work by luck.
> 
> So until we can put a page_mapcount == 1 check back there, the
> page_count will be by definition unreliable because of the speculative
> lookups randomly elevating all non zero page_counts at any time in the
> background on all pages, so you will never be able to tell if a page
> is true COW or if it's just a spurious COW because of a speculative
> lookup. It is impossible to differentiate a speculative lookup from a
> vmsplice ref in a child.

Thanks for the details.

In your patch, do we need to take wrprotect_rwsem in
handle_userfault() as well? Otherwise, it seems userspace would have
to synchronize between its wrprotect ioctl and fault handler? i.e.,
the fault hander needs to be aware that the content of write-
protected pages can actually change before the iotcl returns.

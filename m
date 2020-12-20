Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FF22DF4F2
	for <lists+stable@lfdr.de>; Sun, 20 Dec 2020 10:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbgLTJzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Dec 2020 04:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbgLTJzf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Dec 2020 04:55:35 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392A7C0617B0
        for <stable@vger.kernel.org>; Sun, 20 Dec 2020 01:54:50 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id 2so6249385ilg.9
        for <stable@vger.kernel.org>; Sun, 20 Dec 2020 01:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=g1f+hTqJ01sTRRK/QRqCfkwd/KCqqcEThWLus7s2oL8=;
        b=KO0s5hkNfoe/HC+Lo6UxShdkpn5i8FtDgEZQeFoyZOnSVPubj7oYpPjvH0tqybGefX
         3ecsUHL0N6yBTXk+jSaYiDXIcqr0hpOF21yjZ77YkbVYaO4lcqfZcS1l/E/YHAiw7WJp
         CYgDTmQs3gbTipvWuc+UOZsXMCv6g3xJJJOMaqZvHoKW3qpDH2Awrg/6t/jybqU7M4m+
         86g+qtJLaID/LToDTFQT84HVzxwXys5m7LykpSMAQe/8D3wvNBsE4TFFNF32ADkBYMfK
         OiaIbVfChL+FJJ2yDOjBGwUNPjv4tHPJ8LZHeOewEkrmgi4lsPOauaFRfJNqvWCtUmWC
         XZjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=g1f+hTqJ01sTRRK/QRqCfkwd/KCqqcEThWLus7s2oL8=;
        b=jx9wTkdz2g8ViDLBuTI6N7M47ukkSvj/CCZFaGD9+mHKnxcogOxkCF7O7bCn88uR7v
         9dIluWodqXCEUHImOFIfS5qjDG3IywmwbjUziuFq5tsKjYv096k89ZqyLVWTPY28sgcB
         eSXKUshjeISHRSEi6LqzwLv9uT4CorAkv8gXMkFiQBeT2zuP6O8s6/XY3EYVWJ1E1guP
         prgp/LdwNsigJ0pgnnmsH7CZVmxUeK58OXhMJosUJpx3an0np3Ia/9krqAQ7LZR9tpSQ
         9wJDlEy2sh6rl51Ynre1DLz1FslA9KUlgBbQF+NSIW0XQrF9d2/j4hXoIREaF74K50Gj
         Qbtw==
X-Gm-Message-State: AOAM532AEaGuQgjqmFEaEEcZITcU3nliDej7m2BW9zZZ/JyFQPiXO0wB
        FWlrQpaa+e+phBpfnT9YTnqHhg==
X-Google-Smtp-Source: ABdhPJwFXRHS7o4frczZ+ABNBpZU+cZA2RhD15NOmpz8TH5RvcGdGctXc98YQroLdgxv8GyB8XuMjg==
X-Received: by 2002:a92:d0d:: with SMTP id 13mr1203977iln.209.1608458089138;
        Sun, 20 Dec 2020 01:54:49 -0800 (PST)
Received: from google.com ([2620:15c:183:200:7220:84ff:fe09:2d90])
        by smtp.gmail.com with ESMTPSA id d1sm20445472ioh.3.2020.12.20.01.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 01:54:48 -0800 (PST)
Date:   Sun, 20 Dec 2020 02:54:44 -0700
From:   Yu Zhao <yuzhao@google.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable@vger.kernel.org, minchan@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X98fZOiLNmnDQKhN@google.com>
References: <20201219043006.2206347-1-namit@vmware.com>
 <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
 <X97pprdcRXusLGnq@google.com>
 <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 20, 2020 at 12:06:38AM -0800, Nadav Amit wrote:
> > On Dec 19, 2020, at 10:05 PM, Yu Zhao <yuzhao@google.com> wrote:
> > 
> > On Sat, Dec 19, 2020 at 01:34:29PM -0800, Nadav Amit wrote:
> >> [ cc’ing some more people who have experience with similar problems ]
> >> 
> >>> On Dec 19, 2020, at 11:15 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> >>> 
> >>> Hello,
> >>> 
> >>> On Fri, Dec 18, 2020 at 08:30:06PM -0800, Nadav Amit wrote:
> >>>> Analyzing this problem indicates that there is a real bug since
> >>>> mmap_lock is only taken for read in mwriteprotect_range(). This might
> >>> 
> >>> Never having to take the mmap_sem for writing, and in turn never
> >>> blocking, in order to modify the pagetables is quite an important
> >>> feature in uffd that justifies uffd instead of mprotect. It's not the
> >>> most important reason to use uffd, but it'd be nice if that guarantee
> >>> would remain also for the UFFDIO_WRITEPROTECT API, not only for the
> >>> other pgtable manipulations.
> >>> 
> >>>> Consider the following scenario with 3 CPUs (cpu2 is not shown):
> >>>> 
> >>>> cpu0				cpu1
> >>>> ----				----
> >>>> userfaultfd_writeprotect()
> >>>> [ write-protecting ]
> >>>> mwriteprotect_range()
> >>>> mmap_read_lock()
> >>>> change_protection()
> >>>> change_protection_range()
> >>>>  ...
> >>>>  change_pte_range()
> >>>>  [ defer TLB flushes]
> >>>> 				userfaultfd_writeprotect()
> >>>> 				 mmap_read_lock()
> >>>> 				 change_protection()
> >>>> 				 [ write-unprotect ]
> >>>> 				 ...
> >>>> 				  [ unprotect PTE logically ]
> >>>> 				...
> >>>> 				[ page-fault]
> >>>> 				...
> >>>> 				wp_page_copy()
> >>>> 				[ set new writable page in PTE]
> > 
> > I don't see any problem in this example -- wp_page_copy() calls
> > ptep_clear_flush_notify(), which should take care of the stale entry
> > left by cpu0.
> > 
> > That being said, I suspect the memory corruption you observed is
> > related this example, with cpu1 running something else that flushes
> > conditionally depending on pte_write().
> > 
> > Do you know which type of pages were corrupted? file, anon, etc.
> 
> First, Yu, you are correct. My analysis is incorrect, but let me have
> another try (below). To answer your (and Andrea’s) question - this happens
> with upstream without any changes, excluding a small fix to the selftest,
> since it failed (got stuck) due to missing wake events. [1]
> 
> We are talking about anon memory.
> 
> So to correct myself, I think that what I really encountered was actually
> during MM_CP_UFFD_WP_RESOLVE (i.e., when the protection is removed). The
> problem was that in this case the “write”-bit was removed during unprotect.

Thanks. You are right about when the problem happens: UFD write-
UNprotecting. But it's not UFD write-UNprotecting that removes the
writable bit -- the bit can only be removed during COW or UFD
write-protecting. So your original example was almost correct, except
the last line describing cpu1.

The problem is how do_wp_page() handles non-COW pages. (For COW pages,
do_wp_page() works correctly by either reusing an existing page or
make a new copy out of it.) In UFD case, the existing page may not
have been properly write-protected. As you pointed out, the tlb flush
may not be done yet. Making a copy can potentially race with the
writer on cpu2.

Should we fix the problem by ensuring integrity of the copy? IMO, no,
because do_wp_page() shouldn't copy at all in this case. It seems it
was recently broken by

  be068f29034f mm: fix misplaced unlock_page in do_wp_page()
  09854ba94c6a mm: do_wp_page() simplification

I haven't study them carefully. But if you could just revert them and
run the test again, we'd know where exactly to look at next.

> Sorry for the strange formatting to fit within 80 columns:
> 
> 
> [ Start: PTE is writable ]
> 
> cpu0				cpu1			cpu2
> ----				----			----
> 							[ Writable PTE 
> 							  cached in TLB ]
> userfaultfd_writeprotect()				
> [ write-*unprotect* ]
> mwriteprotect_range()
> mmap_read_lock()
> change_protection()
> 
> change_protection_range()
>  ...
>  change_pte_range()
>  [ *clear* “write”-bit ]
>  [ defer TLB flushes]
> 				[ page-fault ]
> 				…
> 				wp_page_copy()
> 				 cow_user_page()
> 				  [ copy page ]
> 							[ write to old
> 							  page ]
> 				…
> 				 set_pte_at_notify()
> 
> [ End: cpu2 write not copied form old to new page. ]
> 
> 
> So this was actually resolved by the second part of the patch - changing
> preserve_write in change_pte_range(). I removed the acquisition of mmap_lock
> for write, left the change in change_pte_range() and the test passes.
> 
> Let me give some more thought on whether a mmap_lock is needed 
> for write. I need to rehash this TLB flushing algorithm.
> 
> Thanks,
> Nadav
> 
> [1] https://lore.kernel.org/patchwork/patch/1346386

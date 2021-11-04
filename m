Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135D644594B
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 19:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbhKDSKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 14:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbhKDSKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 14:10:00 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9C1C061714;
        Thu,  4 Nov 2021 11:07:21 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id r4so23659721edi.5;
        Thu, 04 Nov 2021 11:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0oBqiMQfPYMmT40A5DIPYcF4on4Z6w8+xYNJvWPt73g=;
        b=eeZ2XvjYsAmlKJoAShKpm61374UX1KXky42ers2ZsOYnDO+g0eGlayb66DWtgoS72f
         Tt/weU/uhv7E5UbNYszJmEqlUkSJ78bWk9CdoS1miD204aK2Zh6CLcBlIP3fI0iUP9o1
         SBJrWFtAnK6+JlZdpG0482trqMHlyE4FdwWjufahsDb/1vou3AKI9bofRV9NZi96ThI6
         3q0qmDCUMYuYeuA3His/T3eTs0I6k1JRTpTDcPZfpDX8AxEoe5xZlSDj0mKtzkfbTNAr
         RgDaKfUkqqb3MwmxNQPuuS7uqSbcGZ7r6+2x7QAijpN4AX/5icSwglyYKPC1In2dQg3l
         jICw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0oBqiMQfPYMmT40A5DIPYcF4on4Z6w8+xYNJvWPt73g=;
        b=tNgAzR2/QnyMlTZ+Npex5H7MJvtr+09V+AVBrZ3JXKEIscN75bFHT608CZUV2iw41N
         ql4KiPxZ0+bu6JzuqfsVSPn9343OjVzMPsUycBhl5pANB/7uqKbU2jCCkVUgn6EGdbu/
         9Kc5mJlAUDyrjg7q8NSRlLqyK+EZU7tj+rxgc80CRY5DEeIRIp1C2B3UAObgxyfqgMq4
         I1y6MOzyVez+n7GpeEVRqeAOHJQCPswErhU808D7L/AJ7m8yqBAmMvQwRbN7QFuxob+O
         uVOBf6vLOKeOewu1VKL9kKFiAcd69g1O/HDoNCQM9HhzwNoUk7UQnHpLVq6kgMyJL+8U
         IcgQ==
X-Gm-Message-State: AOAM530/fKnLB4ImZ8p+j3OaiKH7RtW+YXcupJ4vFzzO6NnqXV4x4GZH
        nc0zaTpKc6hr8l5APbMWZI0ukh3/x5Kuah9paNI=
X-Google-Smtp-Source: ABdhPJwL5te/AV6rDZ+HrdHQbrH0/Jfel4UqGZ5KJbNZMGRUMlkoThsNHjlm3PefqNni9Etz9NHqYrl3oelK2xRaILM=
X-Received: by 2002:a17:907:3f83:: with SMTP id hr3mr65570030ejc.555.1636049237843;
 Thu, 04 Nov 2021 11:07:17 -0700 (PDT)
MIME-Version: 1.0
References: <20211101194856.305642-1-shy828301@gmail.com> <YYJacGTst7dceD8K@kroah.com>
 <YYQQIu6Xi/iEEb7f@kroah.com> <CAHbLzkrZKkS92St-AR-jL8HJYXKOm3EjKkbsaBY58LERh3-_qA@mail.gmail.com>
In-Reply-To: <CAHbLzkrZKkS92St-AR-jL8HJYXKOm3EjKkbsaBY58LERh3-_qA@mail.gmail.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Thu, 4 Nov 2021 11:07:05 -0700
Message-ID: <CAHbLzkq6Egjv3=DYXVWC23EQH++an1QN=QtZmz88f1k9-NKODQ@mail.gmail.com>
Subject: Re: [stable 5.10 PATCH] mm: hwpoison: remove the unnecessary THP check
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     =?UTF-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPoyDnm7TkuZ8p?= 
        <naoya.horiguchi@nec.com>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 4, 2021 at 10:43 AM Yang Shi <shy828301@gmail.com> wrote:
>
> On Thu, Nov 4, 2021 at 9:53 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Nov 03, 2021 at 10:46:24AM +0100, Greg KH wrote:
> > > On Mon, Nov 01, 2021 at 12:48:56PM -0700, Yang Shi wrote:
> > > > commit c7cb42e94473aafe553c0f2a3d8ca904599399ed upstream.
> > > >
> > > > When handling THP hwpoison checked if the THP is in allocation or free
> > > > stage since hwpoison may mistreat it as hugetlb page.  After commit
> > > > 415c64c1453a ("mm/memory-failure: split thp earlier in memory error
> > > > handling") the problem has been fixed, so this check is no longer
> > > > needed.  Remove it.  The side effect of the removal is hwpoison may
> > > > report unsplit THP instead of unknown error for shmem THP.  It seems not
> > > > like a big deal.
> > > >
> > > > The following patch "mm: filemap: check if THP has hwpoisoned subpage
> > > > for PMD page fault" depends on this, which fixes shmem THP with
> > > > hwpoisoned subpage(s) are mapped PMD wrongly.  So this patch needs to be
> > > > backported to -stable as well.
> > > >
> > > > Link: https://lkml.kernel.org/r/20211020210755.23964-2-shy828301@gmail.com
> > > > Signed-off-by: Yang Shi <shy828301@gmail.com>
> > > > Suggested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
> > > > Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
> > > > Cc: Hugh Dickins <hughd@google.com>
> > > > Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > > > Cc: Matthew Wilcox <willy@infradead.org>
> > > > Cc: Oscar Salvador <osalvador@suse.de>
> > > > Cc: Peter Xu <peterx@redhat.com>
> > > > Cc: <stable@vger.kernel.org>
> > > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > > ---
> > > > mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault.patch
> > > > depends on this one.
> > >
> > > Both now queued up, thanks.
> >
> > This breaks the build, see:
> >         https://lore.kernel.org/r/acabc414-164b-cd65-6a1a-cf912d8621d7@roeck-us.net
> >
> > so I'm going to drop both of these now.  Please fix this up and resend a
> > tested series.
>
> Thanks for catching this. It is because I accidentally left the
> PAGEFLAG_* macros into CONFIG_TRANSHUGE_PAGE section, so it is:
>
> #ifdef CONFIG_TRANSHUGE_PAGE
> ...
> #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSHUGE_PAGE)
> PAGEFLAG_xxx
> #else
> PAGEFLAG_FALSE_xxx
> #endif
> ...
> #endif
>
> So when THP is disabled the PAGEFLAG_FALSE_xxx macro is actually absent.
>
> The upstream has the same issue, will send a patch to fix it soon, and
> send fixes (folded the new fix in) to -stable later. Sorry for the
> inconvenience.

Further looking shows the upstream is good. I did *NOT* add the code
in CONFIG_TRANSHUGE_PAGE section. It seems the code section was moved
around when the patch was applied to 5.10.

Could you please fold the below patch into
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault.patch?
Or I could prepare a patch for you.

 diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0db6d83f70c3..1e33ba465195 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -676,20 +676,6 @@ static inline int PageTransCompoundMap(struct page *page)
         atomic_read(compound_mapcount_ptr(head));
 }

-#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
-/*
- * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned in the
- * compound page.
- *
- * This flag is set by hwpoison handler.  Cleared by THP split or free page.
- */
-PAGEFLAG(HasHWPoisoned, has_hwpoisoned, PF_SECOND)
- TESTSCFLAG(HasHWPoisoned, has_hwpoisoned, PF_SECOND)
-#else
-PAGEFLAG_FALSE(HasHWPoisoned)
- TESTSCFLAG_FALSE(HasHWPoisoned)
-#endif
-
 /*
  * PageTransTail returns true for both transparent huge pages
  * and hugetlbfs pages, so it should only be called when it's known
@@ -724,6 +710,20 @@ PAGEFLAG_FALSE(DoubleMap)
  TESTSCFLAG_FALSE(DoubleMap)
 #endif

+#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
+/*
+ * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned in the
+ * compound page.
+ *
+ * This flag is set by hwpoison handler.  Cleared by THP split or free page.
+ */
+PAGEFLAG(HasHWPoisoned, has_hwpoisoned, PF_SECOND)
+ TESTSCFLAG(HasHWPoisoned, has_hwpoisoned, PF_SECOND)
+#else
+PAGEFLAG_FALSE(HasHWPoisoned)
+ TESTSCFLAG_FALSE(HasHWPoisoned)
+#endif
+
 /*
  * For pages that are never mapped to userspace (and aren't PageSlab),
  * page_type may be used.  Because it is initialised to -1, we invert the

>
> >
> > thanks,
> >
> > greg k-h

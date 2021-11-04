Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97A54458DC
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 18:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbhKDRqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 13:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbhKDRqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 13:46:39 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7071EC061205;
        Thu,  4 Nov 2021 10:44:01 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id f8so24382313edy.4;
        Thu, 04 Nov 2021 10:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SaoNZd94jArTmVGn/jRfCzD6DEp4wsUPuwPe5TNdHKA=;
        b=Ci5zimqbv8P1cMefPHzbCNeFUUN8LJw8Y64xtBRDBYcVGncRiKkUApmWPgiZSVOwNh
         eEcSUytkkKxJYJuWZ8JEv1/fYRI+7ml4Gd2k3Me8jItIDOCl3Jos3+LN8nDrf+rKKy0F
         aA6Hx2u1dvMUGB3jtkwWYzKO2jndLVJXDdwEetiMZ6/qPNmV7ESiRPzNsCKLEMR2yyKB
         55LRGk1WD9xJ9GHmTGsfS8mFy1kVbKipwOZSGQJdIa3AFrsuccTXIu+jlZ2yVJhskbM6
         9YCQd3w88SmPEqDRkQuXlyVF2gqf+KYAYoVVNnCn7LzDc3PDv7vjxwNYmLf5ZPoB/k00
         Mauw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SaoNZd94jArTmVGn/jRfCzD6DEp4wsUPuwPe5TNdHKA=;
        b=Rc7TsX7s7Jc1Gr+cIK3AROJfy8+ry7HQbRMCP29NkbZcMww1E+m6N697+ws4dirjEe
         V5uK4pk1Kxz8PkhirUZ0dnWtIZh2QfGNwjoUEb+4qtAMSIqLMhPpwmxaA0kULSqHZHBT
         hsG47tY10w65cccTLw9lbSYyWpyC0eYCFahCZbLGXbz7Fpopm99A4hnunLxMviQGwths
         dfv2bmtFkSqB45GauIfyPanxxBT9t0jhvAO1bw3JjIwqEy6TZaKDyJFYk/sEuZnW6X/B
         iGFUBoVS5M/WCEMs2jEpJonaT5t5bmDtNPaUVGr0h+bEDqcg0EKsRCHaJAz0tEFi2RsQ
         G8aw==
X-Gm-Message-State: AOAM533AG/uQS9IymfN1sXtnwQmfCjNkVtjm7xwu9OJ0gMd8Abt1L8fr
        QfRULn6pHzTo4/GtL4+z51v3nOdURnmJ7F4tnJU=
X-Google-Smtp-Source: ABdhPJxjJVjhCFczPSEV79xEXIH2iDBKSXc5wLai7n6k3tdNY0aTKGZTGE6HhigLRtDP94cd/1k3YlOAqioLJn3YXKo=
X-Received: by 2002:a05:6402:520b:: with SMTP id s11mr28768622edd.363.1636047840071;
 Thu, 04 Nov 2021 10:44:00 -0700 (PDT)
MIME-Version: 1.0
References: <20211101194856.305642-1-shy828301@gmail.com> <YYJacGTst7dceD8K@kroah.com>
 <YYQQIu6Xi/iEEb7f@kroah.com>
In-Reply-To: <YYQQIu6Xi/iEEb7f@kroah.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Thu, 4 Nov 2021 10:43:47 -0700
Message-ID: <CAHbLzkrZKkS92St-AR-jL8HJYXKOm3EjKkbsaBY58LERh3-_qA@mail.gmail.com>
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

On Thu, Nov 4, 2021 at 9:53 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Nov 03, 2021 at 10:46:24AM +0100, Greg KH wrote:
> > On Mon, Nov 01, 2021 at 12:48:56PM -0700, Yang Shi wrote:
> > > commit c7cb42e94473aafe553c0f2a3d8ca904599399ed upstream.
> > >
> > > When handling THP hwpoison checked if the THP is in allocation or free
> > > stage since hwpoison may mistreat it as hugetlb page.  After commit
> > > 415c64c1453a ("mm/memory-failure: split thp earlier in memory error
> > > handling") the problem has been fixed, so this check is no longer
> > > needed.  Remove it.  The side effect of the removal is hwpoison may
> > > report unsplit THP instead of unknown error for shmem THP.  It seems not
> > > like a big deal.
> > >
> > > The following patch "mm: filemap: check if THP has hwpoisoned subpage
> > > for PMD page fault" depends on this, which fixes shmem THP with
> > > hwpoisoned subpage(s) are mapped PMD wrongly.  So this patch needs to be
> > > backported to -stable as well.
> > >
> > > Link: https://lkml.kernel.org/r/20211020210755.23964-2-shy828301@gmail.com
> > > Signed-off-by: Yang Shi <shy828301@gmail.com>
> > > Suggested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
> > > Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
> > > Cc: Hugh Dickins <hughd@google.com>
> > > Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > > Cc: Matthew Wilcox <willy@infradead.org>
> > > Cc: Oscar Salvador <osalvador@suse.de>
> > > Cc: Peter Xu <peterx@redhat.com>
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > ---
> > > mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault.patch
> > > depends on this one.
> >
> > Both now queued up, thanks.
>
> This breaks the build, see:
>         https://lore.kernel.org/r/acabc414-164b-cd65-6a1a-cf912d8621d7@roeck-us.net
>
> so I'm going to drop both of these now.  Please fix this up and resend a
> tested series.

Thanks for catching this. It is because I accidentally left the
PAGEFLAG_* macros into CONFIG_TRANSHUGE_PAGE section, so it is:

#ifdef CONFIG_TRANSHUGE_PAGE
...
#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSHUGE_PAGE)
PAGEFLAG_xxx
#else
PAGEFLAG_FALSE_xxx
#endif
...
#endif

So when THP is disabled the PAGEFLAG_FALSE_xxx macro is actually absent.

The upstream has the same issue, will send a patch to fix it soon, and
send fixes (folded the new fix in) to -stable later. Sorry for the
inconvenience.

>
> thanks,
>
> greg k-h

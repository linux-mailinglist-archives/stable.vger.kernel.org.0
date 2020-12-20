Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40DD2DF39E
	for <lists+stable@lfdr.de>; Sun, 20 Dec 2020 06:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbgLTFJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Dec 2020 00:09:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:39234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbgLTFJs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 20 Dec 2020 00:09:48 -0500
X-Gm-Message-State: AOAM530m8lyM64iEiaQUx3R58/K6jwQ8XxEvYsUjdw2ifkvD5nLDUoUe
        MqB1ThYCmXPf0GtBSRVuPrvDGgmmO+IkANqpB7+gvg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608440948;
        bh=GNcHtmmK5oaVHaZAxSYIqYGpmWW61XjeRJLDrDtv2VI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=T/epbYFYuycN0qKI9D1avY2WbZqHTdNEyWd0n+45yZ+ZrgTeKIf4qwe4wRec+1cbZ
         EUq3Cm3p+vNfq+0qmde90fCRwzvqopBgFPssOVNikkmMZLrnMWpM8jz41NRm7UzJhO
         grzi98MO+nrmOBIUeCvz/x449p/xPnxPXyL1fY9NB6Wuwk7/RIANbGyO0VWe4QR/vu
         gzetq+3WDKTw743MVuGIImcnzj2j0egswYC/ZksOeh6p63rREFnkJ35qRrQ/WvBIPO
         MFYgZHSaE256ZjoEFpunCatVrHTuUGaKfE/mykdjvfpL5UHkqiTa4dUUKAaGTKf6K5
         KEO2HdQnp+3Kw==
X-Google-Smtp-Source: ABdhPJzRfUXXtBNRVLdrQskI9tuQL5lQhyNiDuGzVHYJBbQJs+oYq9S8tszPEoNxK7BkmOZtu8050lTm+wugzRPAAhc=
X-Received: by 2002:adf:e64b:: with SMTP id b11mr11996469wrn.257.1608440946397;
 Sat, 19 Dec 2020 21:09:06 -0800 (PST)
MIME-Version: 1.0
References: <20201219043006.2206347-1-namit@vmware.com> <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com> <CALCETrVtsdeOtGWMUcmT1dzDBxRpecpZDe02L61qEmJmFxSvYw@mail.gmail.com>
 <X967yWAoaTejRk5y@redhat.com>
In-Reply-To: <X967yWAoaTejRk5y@redhat.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 19 Dec 2020 21:08:55 -0800
X-Gmail-Original-Message-ID: <CALCETrVVa-cfogKZirRrP5tmy-gCDtb=jTpLk648BpBQsK9Z5A@mail.gmail.com>
Message-ID: <CALCETrVVa-cfogKZirRrP5tmy-gCDtb=jTpLk648BpBQsK9Z5A@mail.gmail.com>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Nadav Amit <nadav.amit@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        linux-mm <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 19, 2020 at 6:49 PM Andrea Arcangeli <aarcange@redhat.com> wrote:
>
> On Sat, Dec 19, 2020 at 06:01:39PM -0800, Andy Lutomirski wrote:
> > I missed the beginning of this thread, but it looks to me like
> > userfaultfd changes PTEs with not locking except mmap_read_lock().  It
>
> There's no mmap_read_lock, I assume you mean mmap_lock for reading.

Yes.

>
> The ptes are changed always with the PT lock, in fact there's no
> problem with the PTE updates. The only difference with mprotect
> runtime is that the mmap_lock is taken for reading. And the effect
> contested for this change doesn't affect the PTE, but supposedly the
> tlb flushing deferral.

Can you point me at where the lock ends up being taken in this path?
I apparently missed it somewhere.

> Anyway to wait the wrprotect to do the deferred flush, before the
> unprotect can even start, one more mutex in the mm to take in all
> callers of change_protection_range with the mmap_lock for reading may
> be enough.

I'll read the code again tomorrow.

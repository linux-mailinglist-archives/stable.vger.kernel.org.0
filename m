Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7F42DFFA0
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 19:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgLUSXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 13:23:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:46756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbgLUSXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Dec 2020 13:23:32 -0500
X-Gm-Message-State: AOAM533ju5yvu7RoFE545XABZ1X3vsW1vk7I4c4NkPmHYysdo2n08lHS
        lTWsIwABt7zDdNmZ3q7J+bYJmpR70oMiAOoMzpbwww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608574971;
        bh=09s/7/3Abqx6UuMNj0u19lQ8gCTkTlZe5NqmmaxK9+4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Bo2Fa9gWLOSAKLQOzb6Oj9YP9nN27xyxcbVrrkxKTgaUUis9adXsAlE2/PQ08Uour
         5ZXP8SsubuI5xmfpmWXU21mr+asURMlTMcL11Tuiyw8dcRfdrofSVP77gCtiTk6SfP
         IPdvY2lQIoggfdku1N5Os27Lp/UWEHNZa6Jn72Iwo4rpHUAF3Vn2q6w6ubIbhZ+EwB
         +8Cc9hqwT2ogGzrD48wKxfs6128Ln/14xdpWV17jgR7fpdIzaU/2iDlSypRZqflsX/
         36Sp7GH5M9zSlW8VmJyOrL1xQO+qqc3WLwdmRlieo+GiTaaU/ogXQ9qHelRL4WEjrA
         DFuE9CfYmVvqg==
X-Google-Smtp-Source: ABdhPJwjTRqYw8V9Gi4qEwVzEP3KAOAipT6YS4V/aZhUnVFW91AADzWb0GD1KyN5B6hdVMCwN/jvFo6XDpkmv5gcYbs=
X-Received: by 2002:a1c:630b:: with SMTP id x11mr17742545wmb.138.1608574969815;
 Mon, 21 Dec 2020 10:22:49 -0800 (PST)
MIME-Version: 1.0
References: <20201219043006.2206347-1-namit@vmware.com> <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com> <CALCETrVtsdeOtGWMUcmT1dzDBxRpecpZDe02L61qEmJmFxSvYw@mail.gmail.com>
 <X967yWAoaTejRk5y@redhat.com> <CALCETrVVa-cfogKZirRrP5tmy-gCDtb=jTpLk648BpBQsK9Z5A@mail.gmail.com>
 <X+Djjd8dW12u+rSR@redhat.com>
In-Reply-To: <X+Djjd8dW12u+rSR@redhat.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 21 Dec 2020 10:22:38 -0800
X-Gmail-Original-Message-ID: <CALCETrUUkGj00Z0HRuYOpjP8uGgbbs539EwG8tc71+PJR_=z_Q@mail.gmail.com>
Message-ID: <CALCETrUUkGj00Z0HRuYOpjP8uGgbbs539EwG8tc71+PJR_=z_Q@mail.gmail.com>
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

On Mon, Dec 21, 2020 at 10:04 AM Andrea Arcangeli <aarcange@redhat.com> wrote:
>
> Hello,
>
> On Sat, Dec 19, 2020 at 09:08:55PM -0800, Andy Lutomirski wrote:
> > On Sat, Dec 19, 2020 at 6:49 PM Andrea Arcangeli <aarcange@redhat.com> wrote:
> > > The ptes are changed always with the PT lock, in fact there's no
> > > problem with the PTE updates. The only difference with mprotect
> > > runtime is that the mmap_lock is taken for reading. And the effect
> > > contested for this change doesn't affect the PTE, but supposedly the
> > > tlb flushing deferral.
> >
> > Can you point me at where the lock ends up being taken in this path?
>
> pte_offset_map_lock in change_pte_range, as in mprotect, no difference.
>
> As I suspected on my follow up, the bug described wasn't there, but
> I'll look at the new theory posted.

Indeed.

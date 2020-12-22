Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2BB2E0F40
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 21:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgLVUQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 15:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgLVUQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 15:16:47 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F79CC0613D3;
        Tue, 22 Dec 2020 12:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Eb4oYoqAZRfDz+/ydpDOyvDen++mgZRQ1xf6qRXS0jM=; b=Kihezujl/NgUHtFjqSIBp8508s
        psorRppd6ox/i/CY4WCRNyeLoeD57xRUpTBde984iYXHEW1IxLx/H7a+kbfXZH2dEJGBMz66om6Po
        hVa523arlguvIchso5pVuVWOKfffwBthl4KDEeAMBnA/TnLCa96oDvgYur1Kc/5leh366YtOIdxlU
        flB5B4SVpg5sN80NPoDn75QhtxTgbaPrGXPj+wHLnGwuZ1opwVBYcWtfmftnPMDowDOtB2bKZRgeJ
        pkPpyqCsTR3dYQYTG6bD4CZH/VLVhLb4Ma/hnZtbTUmSc5vEuxEUK5BCYhnPmU0FBHmKrbLcWQDz/
        /AzjaH/g==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kro4X-0002uj-Ti; Tue, 22 Dec 2020 20:15:54 +0000
Date:   Tue, 22 Dec 2020 20:15:53 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>, Yu Zhao <yuzhao@google.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <20201222201553.GM874@casper.infradead.org>
References: <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X+JJqK91plkBVisG@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 22, 2020 at 02:31:52PM -0500, Andrea Arcangeli wrote:
> My previous suggestion to use a mutex to serialize
> userfaultfd_writeprotect with a mutex will still work, but we can run
> as many wrprotect and un-wrprotect as we want in parallel, as long as
> they're not simultaneous, we can do much better than a mutex.
> 
> Ideally we would need a new two_group_semaphore, where each group can
> run as many parallel instances as it wants, but no instance of one
> group can run in parallel with any instance of the other group. AFIK
> such a kind of lock doesn't exist right now.

Kent and I worked on one for a bit, and we called it a red-black mutex.
If team red had the lock, more members of team red could join in.
If team black had the lock, more members of team black could join in.
I forget what our rule was around fairness (if team red has the lock,
and somebody from team black is waiting, can another member of team red
take the lock, or must they block?)

It was to solve the direct-IO vs buffered-IO problem (you can have as many
direct-IO readers/writers at once or you can have as many buffered-IO
readers/writers at once, but exclude a mix of direct and buffered I/O).
In the end, we decided it didn't work all that well.

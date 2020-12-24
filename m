Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9E92E2445
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 06:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725536AbgLXFSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Dec 2020 00:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgLXFSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Dec 2020 00:18:55 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34883C061794;
        Wed, 23 Dec 2020 21:18:15 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id j13so593888pjz.3;
        Wed, 23 Dec 2020 21:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=LA2q2PwXp/daJxufMhCIRE8CL74yxjBvwbFCk0LzEik=;
        b=S27vCWUkNpeATmyIFjHiO2b6j/+sG4TMwFeBMjcE80wcYzHObbBZgKSD1wz5PCyGDw
         Wq2chyAEB2LUQnPJ//ywxSkp2Zs2+K+iMV+bITtcIN7VWGvoZqI/H9vhwz8mftkAwV+p
         MgqCmclPKFTpiwAmulbFLyuQoQKBWXjfGcIEg8jribkP701dcl22GvorZVI8CCg8ZR6d
         EZAxrbyzqHDNiOr2qUKcm3vixuXYwSdMyeD0J3xADLfyHz6e+SzTi+47TpsW6gffkhe8
         pltYbe/+d1KMfvxRbwExfXTL+lwFXSVAeT3+ed9G+NBsR2GZXGJDl5m8COV/9bsHBM37
         SzrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=LA2q2PwXp/daJxufMhCIRE8CL74yxjBvwbFCk0LzEik=;
        b=hK9Z6kJQ4S1WxqkLFfv8dglHxrE7mwxcIApZyrjaSxFRBllgO+87xi01hC/Czigz3M
         6yf3n2wHWZGLZAn4arZ5+M6+zDXfNhETLuV4KDOo+9iraAo2mavHFp5P9+o3LXk8lvx9
         4zzpN7cbMbw+BUdD1waR3/SJ3j8GLaXw8dh4zt4taK5H/rhyRnliCKqjNkP91RK8gzuo
         lqXR+OTML10ArjiOTIiRugqJLZSKOkQK6rvugmpccDmuiuqDo/AXlyuRcO0o3TU4/5zP
         iGlirhZdqEhxuNJYnnBekkFsIUXSfnAOqbFh+vzN5WSNxO5grkEqL5gVLDjJOiJtzZbM
         /ZBw==
X-Gm-Message-State: AOAM530WQH0REjrT4rvLuBT4JXicDq74p/0IOVJrfiNljzcI/vrEXQuS
        fUbQJiiNql+ro/LGyvvd+TY=
X-Google-Smtp-Source: ABdhPJx0VPOZ8gOLOrRuzvAcM5UsMBs0uA932mNpmABuZLTTP4XEpc68Z0U/b5FQeqTIFskS0rMKFQ==
X-Received: by 2002:a17:90a:708b:: with SMTP id g11mr2750334pjk.23.1608787094272;
        Wed, 23 Dec 2020 21:18:14 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:50a2:5929:401b:705e? ([2601:647:4700:9b2:50a2:5929:401b:705e])
        by smtp.gmail.com with ESMTPSA id 14sm1215361pjm.21.2020.12.23.21.18.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Dec 2020 21:18:12 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <X+QShVIUbYKAsc35@redhat.com>
Date:   Wed, 23 Dec 2020 21:18:09 -0800
Cc:     Yu Zhao <yuzhao@google.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Transfer-Encoding: 7bit
Message-Id: <06DF7858-1447-4531-9B5C-E20C44F0AF54@gmail.com>
References: <X+PE38s2Egq4nzKv@google.com>
 <C332B03D-30B1-4C9C-99C2-E76988BFC4A1@amacapital.net>
 <X+P2OnR+ipY8d2qL@redhat.com>
 <3A6A1049-24C6-4B2D-8C59-21B549F742B4@gmail.com>
 <X+QMKC7jPEeThjB1@google.com> <X+QShVIUbYKAsc35@redhat.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Dec 23, 2020, at 8:01 PM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> 
>> On Wed, Dec 23, 2020 at 07:09:10PM -0800, Nadav Amit wrote:
>>> Perhaps holding some small bitmap based on part of the deferred flushed
>>> pages (e.g., bits 12-17 of the address or some other kind of a single
>>> hash-function bloom-filter) would be more performant to avoid (most)
> 
> The concern here aren't only the page faults having to run the bloom
> filter, but how to manage the RAM storage pointed by the bloomfilter
> or whatever index into the storage, which would slowdown mprotect.
> 
> Granted that mprotect is slow to begin with, but the idea we can't make
> it any slower to make MADV_PAGEOUT or uffd-wp or clear_refs run
> faster since it's too important and too frequent in comparison.
> 
> Just to restrict the potential false positive IPI caused by page_count
> inevitable inaccuracies to uffd-wp and softdirty runtimes, a simple
> check on vm_flags should be enough.

Andrea,

I am not trying to be argumentative, and I did not think through about an
alternative solution. It sounds to me that your proposed solution is correct
and would probably be eventually (slightly) more efficient than anything
that I can propose.

Yet, I do want to explain my position. Reasoning on TLB flushes is hard, as
this long thread shows. The question is whether it has to be so hard. In
theory, we can only think about architectural considerations - whether a PTE
permissions are promoted/demoted and whether the PTE was changed/cleared.

Obviously, it is more complex than that. Yet, once you add into the equation
various parameters such as the VMA flags or whether a page is locked (which
Mel told me was once a consideration), things become much more complicated.
If all the logic of TLB flushes had been concentrated in a single point and
maintenance of this code did not require thought about users and use-cases,
I think things would have been much simpler, at least for me.

Regards,
Nadav


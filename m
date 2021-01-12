Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60482F3FA7
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 01:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728536AbhALWah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 17:30:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727908AbhALWaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 17:30:35 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAF6C061786;
        Tue, 12 Jan 2021 14:29:55 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id q4so2215333plr.7;
        Tue, 12 Jan 2021 14:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Y/mkD5de8m+mpayBIjRORwwldrvzEhn8Mi4jJftRcDI=;
        b=oyY3aNW7Pxb69vz+utmtcU2GPYOyJ5SqNAKAGKIP+laTePuc60PlelsK58yw4wUUf0
         vWjJOEysHeU7IHh/rBzXBPENyRO9f3bUhDjNmSpAYEVpCygIR53iaVWtBfeZlaPPjvqe
         X4vYUEQ/fMIUh4e4y6FxOmwJXrmI75HrmpiNK+mlBem0QnasUc2Nt3i2O/vaO5K71Y++
         ziIXBzxFcbNLl9OIcmaNhr9zsF3zckpj4QliylL8hPGfzwyXmUcq9jehHNIkoyS2aDGS
         IqiUWiOhhNveeQCjbYSituV2lfZeFWnnYpFZXZA1Cn1+xlnlImCjEywAw9PGsvLi1/nj
         Rt7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Y/mkD5de8m+mpayBIjRORwwldrvzEhn8Mi4jJftRcDI=;
        b=Igvqyio71+VuAUChmHvyX3DIQfNOpUSOp6yRuOn+Unawk07V7ybtEHEDUlRBxkfezn
         BZCQEW3EDBuH/k1n/7qaYZxGfPZp5dVmArQiGRvjhIpagxQ5j2PtFwf1KB+vOnYXemqH
         j4QiZHabpLDoHR3gxcvg/GRNKIVysgzVTsNdjZygQs4izM4SGXL9xq4LbKI5umR45MAK
         5DdKRNKGtSQESGUG8HDV9NO8oLdNPd13yyInnoxhxjRVUZLcLOde+8WKU4eTphyCo8sT
         SXCEx6xfHKQRD+2urZBr5JYMEEz6D7tp75pVeK/yS4iV+KLjRnWg6lO6CmsVIL2m9i9+
         PNYg==
X-Gm-Message-State: AOAM530NG/0VWPDDjWDfVdvY5zaS5nJ3usEGW+BVa/cgcBbtj5eqMZQs
        4q2JlGsoHo0QOpLF05siXcM=
X-Google-Smtp-Source: ABdhPJwpwMojoG1gozfbdfaGyrRQLqLKWPh3Cerp91arRFH/VdZndTffb9MzyH9D6diub2eZ4EAqBQ==
X-Received: by 2002:a17:902:bcc6:b029:dc:44a5:c363 with SMTP id o6-20020a170902bcc6b02900dc44a5c363mr1515847pls.5.1610490594619;
        Tue, 12 Jan 2021 14:29:54 -0800 (PST)
Received: from [192.168.88.245] (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id v10sm32697pjr.47.2021.01.12.14.29.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Jan 2021 14:29:53 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20210112214337.GA10434@willie-the-truck>
Date:   Tue, 12 Jan 2021 14:29:51 -0800
Cc:     Yu Zhao <yuzhao@google.com>,
        Laurent Dufour <ldufour@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vinayak Menon <vinmenon@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>, surenb@google.com
Content-Transfer-Encoding: 7bit
Message-Id: <F33D2DD9-97D5-44A0-890B-35FE686E36DC@gmail.com>
References: <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <CAHk-=wj=CcOHQpG0cUGfoMCt2=Uaifpqq-p-mMOmW8XmrBn4fQ@mail.gmail.com>
 <20210105153727.GK3040@hirez.programming.kicks-ass.net>
 <bfb1cbe6-a705-469d-c95a-776624817e33@codeaurora.org>
 <0201238b-e716-2a3c-e9ea-d5294ff77525@linux.vnet.ibm.com>
 <X/3VE64nr91WCtuM@hirez.programming.kicks-ass.net>
 <ec912505-ed4d-a45d-2ed4-7586919da4de@linux.vnet.ibm.com>
 <C7D5A74C-25BF-458A-AAD9-61E484B9F225@gmail.com>
 <X/3+6ZnRCNOwhjGT@google.com>
 <2C7AE23B-ACA3-4D55-A907-AF781C5608F0@gmail.com>
 <20210112214337.GA10434@willie-the-truck>
To:     Will Deacon <will@kernel.org>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Jan 12, 2021, at 1:43 PM, Will Deacon <will@kernel.org> wrote:
> 
> On Tue, Jan 12, 2021 at 12:38:34PM -0800, Nadav Amit wrote:
>>> On Jan 12, 2021, at 11:56 AM, Yu Zhao <yuzhao@google.com> wrote:
>>> On Tue, Jan 12, 2021 at 11:15:43AM -0800, Nadav Amit wrote:
>>>> I will send an RFC soon for per-table deferred TLB flushes tracking.
>>>> The basic idea is to save a generation in the page-struct that tracks
>>>> when deferred PTE change took place, and track whenever a TLB flush
>>>> completed. In addition, other users - such as mprotect - would use
>>>> the tlb_gather interface.
>>>> 
>>>> Unfortunately, due to limited space in page-struct this would only
>>>> be possible for 64-bit (and my implementation is only for x86-64).
>>> 
>>> I don't want to discourage you but I don't think this would end up
>>> well. PPC doesn't necessarily follow one-page-struct-per-table rule,
>>> and I've run into problems with this before while trying to do
>>> something similar.
>> 
>> Discourage, discourage. Better now than later.
>> 
>> It will be relatively easy to extend the scheme to be per-VMA instead of
>> per-table for architectures that prefer it this way. It does require
>> TLB-generation tracking though, which Andy only implemented for x86, so I
>> will focus on x86-64 right now.
> 
> Can you remind me of what we're missing on arm64 in this area, please? I'm
> happy to help get this up and running once you have something I can build
> on.

Let me first finish making something that we can use as a basis for a
discussion. I do not waste your time before I have something ready.

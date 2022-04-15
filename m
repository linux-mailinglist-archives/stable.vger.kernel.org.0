Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A74503097
	for <lists+stable@lfdr.de>; Sat, 16 Apr 2022 01:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbiDOWMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 18:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbiDOWME (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 18:12:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E561168;
        Fri, 15 Apr 2022 15:09:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D129FB82FAE;
        Fri, 15 Apr 2022 22:09:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D9FC385A5;
        Fri, 15 Apr 2022 22:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650060570;
        bh=uUTQqgUrEzM7Si1aiQakKXkiczJd/bLPM5S7/8UuewM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=v1978BaeFognAVHsSsO/IbUq5gZ2MfdtX3pU/XfWl2EDOtBmtFQ6U+QxtPEPewUqy
         t8q0ImX7X34MWexGSi8QR/FRCIG0iO6Gg1TIx7Sr10hjd0BuyBxZPfCgdzHbgK1OpC
         360VyOfe0eoYqVGzTn++ivmyJmcy7oHU68eCY6qI=
Date:   Fri, 15 Apr 2022 15:09:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Steve Capper <steve.capper@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v10] mm, hugetlbfs: Allow for "high" userspace addresses
Message-Id: <20220415150929.a62cbad83c22d6304560f626@linux-foundation.org>
In-Reply-To: <ab847b6edb197bffdfe189e70fb4ac76bfe79e0d.1650033747.git.christophe.leroy@csgroup.eu>
References: <ab847b6edb197bffdfe189e70fb4ac76bfe79e0d.1650033747.git.christophe.leroy@csgroup.eu>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 15 Apr 2022 16:45:13 +0200 Christophe Leroy <christophe.leroy@csgroup.eu> wrote:

> This is a fix for commit f6795053dac8 ("mm: mmap: Allow for "high"
> userspace addresses") for hugetlb.
> 
> This patch adds support for "high" userspace addresses that are
> optionally supported on the system and have to be requested via a hint
> mechanism ("high" addr parameter to mmap).
> 
> Architectures such as powerpc and x86 achieve this by making changes to
> their architectural versions of hugetlb_get_unmapped_area() function.
> However, arm64 uses the generic version of that function.
> 
> So take into account arch_get_mmap_base() and arch_get_mmap_end() in
> hugetlb_get_unmapped_area(). To allow that, move those two macros
> out of mm/mmap.c into include/linux/sched/mm.h
> 
> If these macros are not defined in architectural code then they default
> to (TASK_SIZE) and (base) so should not introduce any behavioural
> changes to architectures that do not define them.
> 
> For the time being, only ARM64 is affected by this change.
> 
> >From Catalin (ARM64):
>   We should have fixed hugetlb_get_unmapped_area() as well when we
> added support for 52-bit VA. The reason for commit f6795053dac8 was to
> prevent normal mmap() from returning addresses above 48-bit by default
> as some user-space had hard assumptions about this.
> 
> It's a slight ABI change if you do this for hugetlb_get_unmapped_area()
> but I doubt anyone would notice. It's more likely that the current
> behaviour would cause issues, so I'd rather have them consistent.

I'm struggling to understand the need for a -stable backport from the
above text.

Could we please get a simple statement of the end-user visible effects
of the shortcoming?  Target audience is -stable tree maintainers, and
people who we've never heard of who will be wondering whether they should
add this to their organization's older kernel.

>  fs/hugetlbfs/inode.c     | 9 +++++----
>  include/linux/sched/mm.h | 8 ++++++++
>  mm/mmap.c                | 8 --------
>  3 files changed, 13 insertions(+), 12 deletions(-)

I'm a bit surprised that this has reached version 10!  Was it really
that tricky?


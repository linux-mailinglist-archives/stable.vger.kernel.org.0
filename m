Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE7212F326
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 04:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbgACDC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 22:02:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:38120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbgACDC7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 22:02:59 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6358621582;
        Fri,  3 Jan 2020 03:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578020578;
        bh=vt52eM4buQ1/nXw6xZpK+qP9tLkU2kjauxegIfxwUAU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QzNogAThJ0ghybp7xHd/VqAJWY9/rD85imeifM1yf/Sq0ibB2HUBHpUeRIO6UG2s5
         J4dVyiglCc3gJpzLidkKvA494Lz1rJSu1YkDn9MgmcqdX9BkM0bXguhJx3VLthsiYL
         tWj0rnl2jfRi7uoXJkRQfl0g/cGD9Syl89YYI0PQ=
Date:   Thu, 2 Jan 2020 19:02:57 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] mm, debug_pagealloc: don't rely on static keys too
 early
Message-Id: <20200102190257.bef74c21f31373612160b78f@linux-foundation.org>
In-Reply-To: <20191219130612.23171-1-vbabka@suse.cz>
References: <20191219130612.23171-1-vbabka@suse.cz>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 19 Dec 2019 14:06:12 +0100 Vlastimil Babka <vbabka@suse.cz> wrote:

> Commit 96a2b03f281d ("mm, debug_pagelloc: use static keys to enable debugging")
> has introduced a static key to reduce overhead when debug_pagealloc is compiled
> in but not enabled. It relied on the assumption that jump_label_init() is
> called before parse_early_param() as in start_kernel(), so when the
> "debug_pagealloc=on" option is parsed, it is safe to enable the static key.
> 
> However, it turns out multiple architectures call parse_early_param() earlier
> from their setup_arch(). x86 also calls jump_label_init() even earlier, so no
> issue was found while testing the commit, but same is not true for e.g. ppc64
> and s390 where the kernel would not boot with debug_pagealloc=on as found by
> our QA.
> 
> To fix this without tricky changes to init code of multiple architectures, this
> patch partially reverts the static key conversion from 96a2b03f281d. Init-time
> and non-fastpath calls (such as in arch code) of debug_pagealloc_enabled() will
> again test a simple bool variable. Fastpath mm code is converted to a new
> debug_pagealloc_enabled_static() variant that relies on the static key, which
> is enabled in a well-defined point in mm_init() where it's guaranteed that
> jump_label_init() has been called, regardless of architecture.

I'm seeing this with x86_64 allmodconfig:

ERROR: "_debug_pagealloc_enabled_early" [sound/drivers/pcsp/snd-pcsp.ko] undefined!

Not sure why.  It's there:

q:/usr/src/25> nm mm/page_alloc.o|grep _debug_pagealloc_enabled
...
00000000000028a0 B _debug_pagealloc_enabled
...

and exported:

0000000000000072 r __kstrtab__debug_pagealloc_enabled

Odd.  Does this happen to you as well?

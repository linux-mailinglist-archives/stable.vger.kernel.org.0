Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DA92A84A8
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 18:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731964AbgKERQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 12:16:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731985AbgKERQF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 12:16:05 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C54C0613CF;
        Thu,  5 Nov 2020 09:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TIMBZnXKHyOtxwMG5kXS9tUqJFNVBMccMaKyX1NX5R0=; b=CjAEepDPVQZLN6qOIzsJGM923K
        zZnZQe7kUZGTS2csOQBu+mu4iriCbf/emFFoRNft8e0FHo2mkpOTEVDbW8mSYIZ5oRwIkRyYVirIE
        sfbNMEhVgUlpuuKVyf4MVnAlEZsQ6ZteKpmo9Ttqwwbj2h2B3iLv+KVsMNAml8drpsxSRRpx38lqY
        C6J1uvn+vMPiaEjcpYfIeH3EerCb8tlqnBe9LiN94dryFEujdoV1hwiUuawkz1vnQai9gzZMokhAC
        /DTZU8cc17QgQFC1fiAxKUc7bh2BbO4ohZgIPgHpW/+PHeIjOLFxGZ2+UGMssKqefBt2xBY5MAU7i
        YHeDD0tA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kairi-0008Mx-FS; Thu, 05 Nov 2020 17:16:02 +0000
Date:   Thu, 5 Nov 2020 17:16:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Minchan Kim <minchan@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Harish Sriram <harish@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "mm/vunmap: add cond_resched() in
 vunmap_pmd_range"
Message-ID: <20201105171602.GP17076@casper.infradead.org>
References: <20201105170249.387069-1-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105170249.387069-1-minchan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 05, 2020 at 09:02:49AM -0800, Minchan Kim wrote:
> This reverts commit e47110e90584a22e9980510b00d0dfad3a83354e.
> 
> While I was doing zram testing, I found sometimes decompression failed
> since the compression buffer was corrupted. With investigation,
> I found below commit calls cond_resched unconditionally so it could
> make a problem in atomic context if the task is reschedule.

I don't think you're supposed to call unmap_kernel_range() from
atomic context.  At least vfree() punts to __vfree_deferred() if
in_interrupt() is true.  I forget the original reason for why that is.

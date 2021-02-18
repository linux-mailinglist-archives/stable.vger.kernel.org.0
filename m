Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0485431EB48
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 16:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhBRPIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 10:08:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhBROtn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 09:49:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44957C061756;
        Thu, 18 Feb 2021 06:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1qnqSwl3zPIZ18NfoUqqslAfbYk9l/Wxn1L1wgv0bjQ=; b=MR2z5mqAU4EoGlW9G8W3WH6WlP
        PDh8ZNDTlp6jKbO+eCxnm4OwDESOyMsjV0rH25bi7qvtsEJfU4gykwYSda0luLWxhcClo2Z7sdqmz
        zYmaGJqiCM0nFgd5sPKQYv6nGPKgNL2vDKKb+4cQJPgZp6+vDFyxcc8yS8QCSZ9M2PpHn0/AjYuye
        GzWElpMLh46s6Vr19SdcpbqTildW6Uc/my+AFvYEH8IzTYm+Gdqsg5YZvZGBckHfbNLY7R8ZaFO6N
        tCFNAmKcVBfrnQlb4vWZNk0ctBMO0yOhalIX03yaPqYznGmeczNNjOGCT1FOzXYOy8L8f1fcXFAuT
        jzcoNVRw==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lCkZ0-001lVL-UI; Thu, 18 Feb 2021 14:46:12 +0000
Date:   Thu, 18 Feb 2021 14:45:54 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Davidlohr Bueso <dbueso@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] hugetlb: fix update_and_free_page contig page struct
 assumption
Message-ID: <20210218144554.GS2858050@casper.infradead.org>
References: <20210217184926.33567-1-mike.kravetz@oracle.com>
 <20210217110252.185c7f5cd5a87c3f7b0c0144@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210217110252.185c7f5cd5a87c3f7b0c0144@linux-foundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 17, 2021 at 11:02:52AM -0800, Andrew Morton wrote:
> On Wed, 17 Feb 2021 10:49:25 -0800 Mike Kravetz <mike.kravetz@oracle.com> wrote:
> > page structs are not guaranteed to be contiguous for gigantic pages.  The
>
> June 2014.  That's a long lurk time for a bug.  I wonder if some later
> commit revealed it.

I would suggest that gigantic pages have not seen much use.  Certainly
performance with Intel CPUs on benchmarks that I've been involved with
showed lower performance with 1GB pages than with 2MB pages until quite
recently.

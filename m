Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9ED4937E6
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 11:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353303AbiASKDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 05:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352594AbiASKDH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 05:03:07 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3077BC061574;
        Wed, 19 Jan 2022 02:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3kzXvtE5LHGh9bTwu8jZhdzSjC26IpQu1fC0KE7Jd6Q=; b=C6FU+F/ty02KfXJwEgFWxYmGW/
        //VF9NWRMEPVbDJJ1Nifscyzr8xFzkqZtFJMJs+Jr7bcXNlWRawWlAg/w8g14A3JPgtoe17NQ4dqa
        agmt9vjXbFSIECtQbjj75t2Bl5NJB9wGWFSLcQlQOtFLeaw4u5IWHAOJJCui7t4g9O7aBtP0jcElV
        cAO3DpKSHFpZnLXe6FEYNIJMn+A3M/cXqRO/aoVI0WLdd11cpxlWlY2eM1jXJRhBIs8vTcL5JoW+h
        vfmz59JcDVb5GS4O73nCXrk2cLFQOkGk7XRHOGTVS/dZ3Xc7DAXqVv8F8WIJZN82RFn06XYWVQRRF
        wMGLPHjQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nA7nw-00AWSf-JD; Wed, 19 Jan 2022 10:03:01 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 30F943004AD;
        Wed, 19 Jan 2022 11:02:59 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0FB0D211935FB; Wed, 19 Jan 2022 11:02:59 +0100 (CET)
Date:   Wed, 19 Jan 2022 11:02:59 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Peter Collingbourne <pcc@google.com>
Cc:     Andrey Konovalov <andreyknvl@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm/mmzone.c: fix page_cpupid_xchg_last() to READ_ONCE()
 the page flags
Message-ID: <Yefh00fKOIPj+kYC@hirez.programming.kicks-ass.net>
References: <20220118230539.323058-1-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118230539.323058-1-pcc@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 03:05:39PM -0800, Peter Collingbourne wrote:
> After submitting a patch with a compare-exchange loop similar to this
> one to set the KASAN tag in the page flags, Andrey Konovalov pointed
> out that we should be using READ_ONCE() to read the page flags. Fix
> it here.

What does it actually fix? If it manages to split the read and read
garbage the cmpxchg will fail and we go another round, no harm done.

> Fixes: 75980e97dacc ("mm: fold page->_last_nid into page->flags where possible")

As per the above argument, I don't think this rates a Fixes tag, there
is no actual fix.

> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Link: https://linux-review.googlesource.com/id/I2e1f5b5b080ac9c4e0eb7f98768dba6fd7821693

That's that doing here?

> Cc: stable@vger.kernel.org

That's massively over-selling things.

> ---
>  mm/mmzone.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/mmzone.c b/mm/mmzone.c
> index eb89d6e018e2..f84b84b0d3fc 100644
> --- a/mm/mmzone.c
> +++ b/mm/mmzone.c
> @@ -90,7 +90,7 @@ int page_cpupid_xchg_last(struct page *page, int cpupid)
>  	int last_cpupid;
>  
>  	do {
> -		old_flags = flags = page->flags;
> +		old_flags = flags = READ_ONCE(page->flags);
>  		last_cpupid = page_cpupid_last(page);
>  
>  		flags &= ~(LAST_CPUPID_MASK << LAST_CPUPID_PGSHIFT);

I think that if you want to touch that code, something like the below
makes more sense...

diff --git a/mm/mmzone.c b/mm/mmzone.c
index eb89d6e018e2..ed9f4bcdc9ee 100644
--- a/mm/mmzone.c
+++ b/mm/mmzone.c
@@ -89,13 +89,14 @@ int page_cpupid_xchg_last(struct page *page, int cpupid)
 	unsigned long old_flags, flags;
 	int last_cpupid;
 
+	old_flags = READ_ONCE(page->flags);
 	do {
-		old_flags = flags = page->flags;
-		last_cpupid = page_cpupid_last(page);
+		flags = old_flags;
+		last_cpupid = (flags >> LAST_CPUPID_PGSHIFT) & LAST_CPUPID_MASK;
 
 		flags &= ~(LAST_CPUPID_MASK << LAST_CPUPID_PGSHIFT);
 		flags |= (cpupid & LAST_CPUPID_MASK) << LAST_CPUPID_PGSHIFT;
-	} while (unlikely(cmpxchg(&page->flags, old_flags, flags) != old_flags));
+	} while (unlikely(!try_cmpxchg(&page->flags, &old_flags, flags)));
 
 	return last_cpupid;
 }

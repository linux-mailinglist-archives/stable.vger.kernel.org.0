Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43F5565DA3
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 20:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiGDS4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 14:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiGDS4b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 14:56:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A20B1C9
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 11:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bPvF5uGOULNmuvQrWBB9nLrBVObYOX+sHO4B1v6miA8=; b=Pa+KACBZquUBnONV9iMws2IEue
        mH7pnxG7oA6OQPfL6ulAyMwvjWq1RQ6LpWtHeDrBXwUXhVaIhcmWHk7oysHdK6ZX9fHA/VbXJNOU6
        R/DlTuL27RUJ9r0+xWmEGrBFjywcxeIHmc0pqOQJa50P7JWjOp4Bem3alkZHP/1nCGaLhV2+UNkUv
        qdiS9X51U4E88xKxxYwmZuDl09aUvzs2GsLo1cZg9AelZca4jH1Ghm2H8zFgp1ctDVaPPHv6WbkrZ
        3pfeLv663iBUpH1HD/1/Uqurt0cQJSl3vOC9vXcnyXZv5zTtv2gnCaJYKRvchzCC8cirz2bkZF3Nj
        WIUe2VFA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8RF7-00HWIl-Uz; Mon, 04 Jul 2022 18:56:21 +0000
Date:   Mon, 4 Jul 2022 19:56:21 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     gregkh@linuxfoundation.org
Cc:     bfoster@redhat.com, david@fromorbit.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] filemap: Handle sibling entries in
 filemap_get_read_batch()" failed to apply to 5.15-stable tree
Message-ID: <YsM31a0rCoJkswHz@casper.infradead.org>
References: <16561682994109@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16561682994109@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 25, 2022 at 04:44:59PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Compile-tested only, but it's fairly straightforward (if you understand
how the code mutated over time)

diff --git a/mm/filemap.c b/mm/filemap.c
index 00e391e75880..9cef95427575 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2341,6 +2341,8 @@ static void filemap_get_read_batch(struct address_space *mapping,
 			continue;
 		if (xas.xa_index > max || xa_is_value(head))
 			break;
+		if (xa_is_sibling(head))
+			break;
 		if (!page_cache_get_speculative(head))
 			goto retry;
 

> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> >From cb995f4eeba9d268fd4b56c2423ad6c1d1ea1b82 Mon Sep 17 00:00:00 2001
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Date: Fri, 17 Jun 2022 20:00:17 -0400
> Subject: [PATCH] filemap: Handle sibling entries in filemap_get_read_batch()
> 
> If a read races with an invalidation followed by another read, it is
> possible for a folio to be replaced with a higher-order folio.  If that
> happens, we'll see a sibling entry for the new folio in the next iteration
> of the loop.  This manifests as a NULL pointer dereference while holding
> the RCU read lock.
> 
> Handle this by simply returning.  The next call will find the new folio
> and handle it correctly.  The other ways of handling this rare race are
> more complex and it's just not worth it.
> 
> Reported-by: Dave Chinner <david@fromorbit.com>
> Reported-by: Brian Foster <bfoster@redhat.com>
> Debugged-by: Brian Foster <bfoster@redhat.com>
> Tested-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Fixes: cbd59c48ae2b ("mm/filemap: use head pages in generic_file_buffered_read")
> Cc: stable@vger.kernel.org
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 577068868449..ffdfbc8b0e3c 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2385,6 +2385,8 @@ static void filemap_get_read_batch(struct address_space *mapping,
>  			continue;
>  		if (xas.xa_index > max || xa_is_value(folio))
>  			break;
> +		if (xa_is_sibling(folio))
> +			break;
>  		if (!folio_try_get_rcu(folio))
>  			goto retry;
>  
> 

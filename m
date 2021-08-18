Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8A53F0980
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 18:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhHRQrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 12:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhHRQrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 12:47:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664E6C061764;
        Wed, 18 Aug 2021 09:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BcolAdz1++Lz5EKAbjNRqtUND/vI1maofEeX6aKJlvY=; b=MEM+1TG4nJWbwCPC8xryiQUkX+
        1CLRv7W3sHWrKGnzUH2U3RzElr7169+iSHhDfC+ANHIGxVu3rInkF1APeaq7Z0w0rNYoMC3iWXfRp
        qcb7Nmr1cBk6QVY2ShT9oEmnngZTGNsEa204N+im4dMUborvKqU+Cw8q0sPN6ESgALHzxRW47PPjk
        KfgV45mdgHOZczCqXY8Yv2bVIlcdiI7HKT/mU1McKSnmfMuVuRWuJMdUJpei8f2vnu8+Qp/33I01d
        6BGgiCX/51sNrJGXWEPHxKiYkLemgTR6WeNT3Nr49e0G74vudL4oY+thfd3rEQ/xR+XbzUXi5xEb1
        zoj1d9pw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mGOgv-0043X5-BL; Wed, 18 Aug 2021 16:45:53 +0000
Date:   Wed, 18 Aug 2021 17:45:25 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: Remove bogus VM_BUG_ON
Message-ID: <YR05JVZwfAlZO9Wh@casper.infradead.org>
References: <20210818144932.940640-1-willy@infradead.org>
 <2197941-297c-f820-aa57-fb5167794fb1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2197941-297c-f820-aa57-fb5167794fb1@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 18, 2021 at 09:34:51AM -0700, Hugh Dickins wrote:
> On Wed, 18 Aug 2021, Matthew Wilcox (Oracle) wrote:
> 
> > It is not safe to check page->index without holding the page lock.
> > It can be changed if the page is moved between the swap cache and the
> > page cache for a shmem file, for example.  There is a VM_BUG_ON below
> > which checks page->index is correct after taking the page lock.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 5c211ba29deb ("mm: add and use find_lock_entries")
> 
> I don't mind that VM_BUG_ON_PAGE() being removed, but question whether
> this Fixes anything, and needs to go to stable. Or maybe it's just that
> the shmem example is wrong - moving shmem from page to swap cache does
> not change page->index. Or maybe you have later changes in your tree
> which change that and do require this. Otherwise, I'll have to worry
> why my testing has missed it for six months.

I'm sorry, I think you're going to have to worry :-(  Syzbot found
it initially:

https://lore.kernel.org/linux-mm/0000000000009cfcda05c926b34b@google.com/

and then I hit it today during my testing (which is definitely due to
further changes in my tree).

I should have added:

Reported-by: syzbot+c87be4f669d920c76330@syzkaller.appspotmail.com

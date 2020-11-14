Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24EF2B3123
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 23:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgKNWPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 17:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgKNWPI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Nov 2020 17:15:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242C7C0613D1;
        Sat, 14 Nov 2020 14:15:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9WPLF26hKFYUTzyN6Nx1rFU4F1GrltbtRe7RdaEM3j8=; b=s1nYbcoBJadWzH1UGWqRLybfRp
        TWF6MtPizGtkEM9y1+nCR6ysNl6LQKtbIPatkPoDOD0ra9y4KBCyyR5OYWPxT2UNQgibeYRyX7a28
        B5RADvYeKowzWLl3zW6okApxB7uDrfdzBxJuCtb0o4dl8R5tzIHwcxKQHtJ7lPWMVAqSsCqGhB4h/
        m8ikvqjA+jnl78p7JgaSBdDymgjGJ+ncR9ORi+FzokgJfnGRGUa1P+rjuhUNxs0FVAW4YKcebb4ID
        S415Pmyr13LkqxuFJVs1GjmnsHIU8wlAeTApbDoUlGJsUoJFLh3rJJ5o32Iu5DRDOTKYs8LkXcedy
        3g10Z1oA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ke3ow-0006Yp-UB; Sat, 14 Nov 2020 22:14:59 +0000
Date:   Sat, 14 Nov 2020 22:14:58 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, a.sahrawat@samsung.com,
        Linux-MM <linux-mm@kvack.org>, maninder1.s@samsung.com,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>,
        mm-commits@vger.kernel.org, Nick Piggin <npiggin@gmail.com>,
        stable <stable@vger.kernel.org>, v.narang@samsung.com,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [patch 03/14] mm/vmscan: fix NR_ISOLATED_FILE corruption on
 64-bit
Message-ID: <20201114221458.GP17076@casper.infradead.org>
References: <20201113225115.b24faebc85f710d5aff55aa7@linux-foundation.org>
 <20201114065146.3H6OX7gIF%akpm@linux-foundation.org>
 <CAHk-=wj847SudR-kt+46fT3+xFFgiwpgThvm7DJWGdi4cVrbnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj847SudR-kt+46fT3+xFFgiwpgThvm7DJWGdi4cVrbnQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 14, 2020 at 01:39:47PM -0800, Linus Torvalds wrote:
> I've applied this patch, but I have to say that I absolutely detest it.
> 
> This is very fragile, and I think the problem is the nasty interface.

I agree, it's nast.

> Why don't we have simple wrappers that internally do that "mod", but
> actually expose "inc" and "dec" instead, and make it much harder to
> have these kinds of problems?

We actually need 'add' and 'sub', not 'inc' and 'dec'.  Sometimes we inc,
but often we need to add.  But, yes, 'mod' is a bad name.


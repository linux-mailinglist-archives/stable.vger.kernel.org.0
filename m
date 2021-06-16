Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33123AA262
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 19:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhFPR3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 13:29:13 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:52338 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhFPR3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 13:29:12 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9EAF221A6D;
        Wed, 16 Jun 2021 17:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1623864425; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2RjVqTk1bZ89HZ0Vl6VNbgo7QZEJ/jobK5ZhIBC94LU=;
        b=QV45H5Np7o2LLu6APjdnnUzf3ffFav31ia6AG0BjwJfrRa6x1u/P6WQGBGi97HnfeFmljt
        wIZ/1OFM4NpiEidsWjX7RknZ8/mlPWJraY5u7g45lItemJdOYA+OVRZ3BvXi50hAR0wQAR
        TvEhTEO0E9zg4hThThe17lpD+Xw6Cks=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1623864425;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2RjVqTk1bZ89HZ0Vl6VNbgo7QZEJ/jobK5ZhIBC94LU=;
        b=c084dfJJBHvrLr+KvQnACGhqnaAp0yf/EtJf+c5PTjFJI/oBAwMeKwg2HJaOuqXmtu7/+d
        I33wQdft/HBPr5CQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 7C9C0118DD;
        Wed, 16 Jun 2021 17:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1623864425; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2RjVqTk1bZ89HZ0Vl6VNbgo7QZEJ/jobK5ZhIBC94LU=;
        b=QV45H5Np7o2LLu6APjdnnUzf3ffFav31ia6AG0BjwJfrRa6x1u/P6WQGBGi97HnfeFmljt
        wIZ/1OFM4NpiEidsWjX7RknZ8/mlPWJraY5u7g45lItemJdOYA+OVRZ3BvXi50hAR0wQAR
        TvEhTEO0E9zg4hThThe17lpD+Xw6Cks=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1623864425;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2RjVqTk1bZ89HZ0Vl6VNbgo7QZEJ/jobK5ZhIBC94LU=;
        b=c084dfJJBHvrLr+KvQnACGhqnaAp0yf/EtJf+c5PTjFJI/oBAwMeKwg2HJaOuqXmtu7/+d
        I33wQdft/HBPr5CQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id jL7tHWk0ymDcOgAALh3uQQ
        (envelope-from <vbabka@suse.cz>); Wed, 16 Jun 2021 17:27:05 +0000
Subject: Re: [PATCH v2] mm/gup: fix try_grab_compound_head() race with
 split_huge_page()
To:     Yang Shi <shy828301@gmail.com>, Jann Horn <jannh@google.com>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Jan Kara <jack@suse.cz>, stable <stable@vger.kernel.org>
References: <20210615012014.1100672-1-jannh@google.com>
 <50d828d1-2ce6-21b4-0e27-fb15daa77561@nvidia.com>
 <CAG48ez3Vbcvh4AisU7=ukeJeSjHGTKQVd0NOU6XOpRru7oP_ig@mail.gmail.com>
 <CAHbLzkomex+fgC8RyogXu-s5o2UrORMO6D2yTsSXW5Wo5z9WRA@mail.gmail.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <6d21f8cb-4b72-bdec-386c-684ddbcdada1@suse.cz>
Date:   Wed, 16 Jun 2021 19:27:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAHbLzkomex+fgC8RyogXu-s5o2UrORMO6D2yTsSXW5Wo5z9WRA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/16/21 1:10 AM, Yang Shi wrote:
> On Tue, Jun 15, 2021 at 5:10 AM Jann Horn <jannh@google.com> wrote:
>>
>> On Tue, Jun 15, 2021 at 8:37 AM John Hubbard <jhubbard@nvidia.com> wrote:
>> > On 6/14/21 6:20 PM, Jann Horn wrote:
>> > > try_grab_compound_head() is used to grab a reference to a page from
>> > > get_user_pages_fast(), which is only protected against concurrent
>> > > freeing of page tables (via local_irq_save()), but not against
>> > > concurrent TLB flushes, freeing of data pages, or splitting of compound
>> > > pages.
>> [...]
>> > Reviewed-by: John Hubbard <jhubbard@nvidia.com>
>>
>> Thanks!
>>
>> [...]
>> > > @@ -55,8 +72,23 @@ static inline struct page *try_get_compound_head(struct page *page, int refs)
>> > >       if (WARN_ON_ONCE(page_ref_count(head) < 0))
>> > >               return NULL;
>> > >       if (unlikely(!page_cache_add_speculative(head, refs)))
>> > >               return NULL;
>> > > +
>> > > +     /*
>> > > +      * At this point we have a stable reference to the head page; but it
>> > > +      * could be that between the compound_head() lookup and the refcount
>> > > +      * increment, the compound page was split, in which case we'd end up
>> > > +      * holding a reference on a page that has nothing to do with the page
>> > > +      * we were given anymore.
>> > > +      * So now that the head page is stable, recheck that the pages still
>> > > +      * belong together.
>> > > +      */
>> > > +     if (unlikely(compound_head(page) != head)) {
>> >
>> > I was just wondering about what all could happen here. Such as: page gets split,
>> > reallocated into a different-sized compound page, one that still has page pointing
>> > to head. I think that's OK, because we don't look at or change other huge page
>> > fields.
>> >
>> > But I thought I'd mention the idea in case anyone else has any clever ideas about
>> > how this simple check might be insufficient here. It seems fine to me, but I
>> > routinely lack enough imagination about concurrent operations. :)
>>
>> Hmmm... I think the scariest aspect here is probably the interaction
>> with concurrent allocation of a compound page on architectures with
>> store-store reordering (like ARM). *If* the page allocator handled
>> compound pages with lockless, non-atomic percpu freelists, I think it
>> might be possible that the zeroing of tail_page->compound_head in
>> put_page() could be reordered after the page has been freed,
>> reallocated and set to refcount 1 again?
>>
>> That shouldn't be possible at the moment, but it is still a bit scary.
> 
> It might be possible after Mel's "mm/page_alloc: Allow high-order
> pages to be stored on the per-cpu lists" patch
> (https://patchwork.kernel.org/project/linux-mm/patch/20210611135753.GC30378@techsingularity.net/).

Those would be percpu indeed, but not "lockless, non-atomic", no? They are
protected by a local_lock.

>>
>>
>> I think the lockless page cache code also has to deal with somewhat
>> similar ordering concerns when it uses page_cache_get_speculative(),
>> e.g. in mapping_get_entry() - first it looks up a page pointer with
>> xas_load(), and any access to the page later on would be a _dependent
>> load_, but if the page then gets freed, reallocated, and inserted into
>> the page cache again before the refcount increment and the re-check
>> using xas_reload(), then there would be no data dependency from
>> xas_reload() to the following use of the page...
>>
> 


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14478429F8F
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 10:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234910AbhJLIQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 04:16:30 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:41436 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234865AbhJLIQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 04:16:29 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B90EF21EC5;
        Tue, 12 Oct 2021 08:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1634026467; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vK6FO1lIZ0kZ4bgsVjbVRQ9LsMl3rH95xJawzN+MiJo=;
        b=kFlVqvXuL+gVhPeGsMWT1vqPSbuz0HtqCzMIWtEt6JzX089M8Kr+2EshURp5zhIxV2Ys6b
        JljxXUoduU//Cs4vayQH+y3Ks5a1xVSXazXOR0gthVCykDwv9Tpv6pzfF2qfPJA4r4fJME
        QzWKHhfXr4ySDVmeYKHcCQoNBe/7U2Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1634026467;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vK6FO1lIZ0kZ4bgsVjbVRQ9LsMl3rH95xJawzN+MiJo=;
        b=ZuvQzKlDtAGGpzkxrLo5e2UK7gtj1hJuKfhl4+sp8D0/9Gcc3M1Jsxyl9YyvZUsjucVkEn
        n4+6hziW3gyIblAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7019C13ABC;
        Tue, 12 Oct 2021 08:14:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5w2tGuNDZWFCQwAAMHmgww
        (envelope-from <vbabka@suse.cz>); Tue, 12 Oct 2021 08:14:27 +0000
Message-ID: <b9568b73-70ef-cd0f-f533-41556cae6a0f@suse.cz>
Date:   Tue, 12 Oct 2021 10:14:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/1] gup: document and work around "COW can break either
 way" issue
Content-Language: en-US
To:     Jan Kara <jack@suse.cz>, Suren Baghdasaryan <surenb@google.com>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        jannh@google.com, torvalds@linux-foundation.org, peterx@redhat.com,
        aarcange@redhat.com, david@redhat.com, jgg@ziepe.ca,
        ktkhai@virtuozzo.com, shli@fb.com, namit@vmware.com, hch@lst.de,
        oleg@redhat.com, kirill@shutemov.name, willy@infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com
References: <20211012015244.693594-1-surenb@google.com>
 <20211012080649.GE9697@quack2.suse.cz>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20211012080649.GE9697@quack2.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/12/21 10:06, Jan Kara wrote:
> On Mon 11-10-21 18:52:44, Suren Baghdasaryan wrote:
>> From: Linus Torvalds <torvalds@linux-foundation.org>
>> 
>> From: Linus Torvalds <torvalds@linux-foundation.org>
>> 
>> commit 17839856fd588f4ab6b789f482ed3ffd7c403e1f upstream.
>> 
>> Doing a "get_user_pages()" on a copy-on-write page for reading can be
>> ambiguous: the page can be COW'ed at any time afterwards, and the
>> direction of a COW event isn't defined.
>> 
>> Yes, whoever writes to it will generally do the COW, but if the thread
>> that did the get_user_pages() unmapped the page before the write (and
>> that could happen due to memory pressure in addition to any outright
>> action), the writer could also just take over the old page instead.
>> 
>> End result: the get_user_pages() call might result in a page pointer
>> that is no longer associated with the original VM, and is associated
>> with - and controlled by - another VM having taken it over instead.
>> 
>> So when doing a get_user_pages() on a COW mapping, the only really safe
>> thing to do would be to break the COW when getting the page, even when
>> only getting it for reading.
>> 
>> At the same time, some users simply don't even care.
>> 
>> For example, the perf code wants to look up the page not because it
>> cares about the page, but because the code simply wants to look up the
>> physical address of the access for informational purposes, and doesn't
>> really care about races when a page might be unmapped and remapped
>> elsewhere.
>> 
>> This adds logic to force a COW event by setting FOLL_WRITE on any
>> copy-on-write mapping when FOLL_GET (or FOLL_PIN) is used to get a page
>> pointer as a result.
>> 
>> The current semantics end up being:
>> 
>>  - __get_user_pages_fast(): no change. If you don't ask for a write,
>>    you won't break COW. You'd better know what you're doing.
>> 
>>  - get_user_pages_fast(): the fast-case "look it up in the page tables
>>    without anything getting mmap_sem" now refuses to follow a read-only
>>    page, since it might need COW breaking.  Which happens in the slow
>>    path - the fast path doesn't know if the memory might be COW or not.
>> 
>>  - get_user_pages() (including the slow-path fallback for gup_fast()):
>>    for a COW mapping, turn on FOLL_WRITE for FOLL_GET/FOLL_PIN, with
>>    very similar semantics to FOLL_FORCE.
>> 
>> If it turns out that we want finer granularity (ie "only break COW when
>> it might actually matter" - things like the zero page are special and
>> don't need to be broken) we might need to push these semantics deeper
>> into the lookup fault path.  So if people care enough, it's possible
>> that we might end up adding a new internal FOLL_BREAK_COW flag to go
>> with the internal FOLL_COW flag we already have for tracking "I had a
>> COW".
>> 
>> Alternatively, if it turns out that different callers might want to
>> explicitly control the forced COW break behavior, we might even want to
>> make such a flag visible to the users of get_user_pages() instead of
>> using the above default semantics.
>> 
>> But for now, this is mostly commentary on the issue (this commit message
>> being a lot bigger than the patch, and that patch in turn is almost all
>> comments), with that minimal "enable COW breaking early" logic using the
>> existing FOLL_WRITE behavior.
>> 
>> [ It might be worth noting that we've always had this ambiguity, and it
>>   could arguably be seen as a user-space issue.
>> 
>>   You only get private COW mappings that could break either way in
>>   situations where user space is doing cooperative things (ie fork()
>>   before an execve() etc), but it _is_ surprising and very subtle, and
>>   fork() is supposed to give you independent address spaces.
>> 
>>   So let's treat this as a kernel issue and make the semantics of
>>   get_user_pages() easier to understand. Note that obviously a true
>>   shared mapping will still get a page that can change under us, so this
>>   does _not_ mean that get_user_pages() somehow returns any "stable"
>>   page ]
>> 
>> [surenb: backport notes
>>         Since gup_pgd_range does not exist, made appropriate changes on
>>         the the gup_huge_pgd, gup_huge_pd and gup_pud_range calls instead.
>> 	Replaced (gup_flags | FOLL_WRITE) with write=1 in gup_huge_pgd,
>>         gup_huge_pd and gup_pud_range.
>> 	Removed FOLL_PIN usage in should_force_cow_break since it's missing in
>> 	the earlier kernels.]
> 
> I'd be really careful with backporting this to stable. There was a lot of
> userspace breakage caused by this change if I remember right which needed
> to be fixed up later. There is a nice summary at
> https://lwn.net/Articles/849638/ and https://lwn.net/Articles/849876/ and
> some problems are still being found...

Yeah that was my initial reaction. But looks like back in April we agreed
that backporting only this commit could be feasible - the relevant subthread
starts around here [1]. The known breakage for just this commit was uffd
functionality introduced only in 5.7, and strace on dax on pmem (that was
never properly root caused). 5.4 stable already has the backport since year
ago, Suren posted 4.14 and 4.19 in April after [1]. Looks like nobody
reported issues? Continuing with 4.4 and 4.9 makes this consistent at least,
although the risk of breaking something is always there and the CVE probably
not worth it, but whatever...

[1]
https://lore.kernel.org/all/CAHk-=wj0JH6PnG7dW51Sr5ZqhomqSaSLTQV7z4Si2dLeSVcO_g@mail.gmail.com/

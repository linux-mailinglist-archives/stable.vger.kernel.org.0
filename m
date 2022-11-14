Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246546284B1
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 17:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237345AbiKNQKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 11:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237284AbiKNQKc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 11:10:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F77B859
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 08:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668442177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FRDOlAhtq+4FPxDn7xJvAO+rfsHWJZyuf4JMnt1m0vE=;
        b=ZZMMMlfR1nbzUAYOjb+QTByN2hxS7quKdWS32eLRYNy0NMnlkzN+Rn0NJiFRBhOnEI9Jjt
        VH9yj0Nj2ALce9tqua52M/FEKe9sL2KU9fI4bRNiC57vs1bqIGEvGciPdkFNHrcdyp6J5a
        ShZb9LcH/YKY6Af1dtHD8OpUpYjQOsA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-539-KvIx0AdIO0uFDqMNQudWWg-1; Mon, 14 Nov 2022 11:09:35 -0500
X-MC-Unique: KvIx0AdIO0uFDqMNQudWWg-1
Received: by mail-wm1-f70.google.com with SMTP id c1-20020a7bc001000000b003cfe40fca79so535630wmb.6
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 08:09:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FRDOlAhtq+4FPxDn7xJvAO+rfsHWJZyuf4JMnt1m0vE=;
        b=pttzLVYL4/E8XDhPkmwlNYgOuZmXqrzLE56hDqjzkA1Vb5HDl9n57FS2V+F1NnnV9d
         fMcDK8ad6w3+8KUWoHh1a3oaBWLMSgCJ7b7EbpS1WPi0I9xLzKBYpNzj4/+GKCQEes0P
         GJH136AGd44yryptuleyCceZaUzJoqsJVlVcb+f7I3gXCCTuOywbRfABB/zd9TpZRO1o
         BEeMA6ljI5X+KzYYApgoDa3tkF2B4R7J7qOmbmJw634V8KAoh3xq+e059iGjzGXviV6l
         wjMDuEk6Gq65yWaUwzFw85OxYH7+Tg7dcW+EVj5NK4g5aYGSRUB5tuF4WqewwFsCVOSe
         0MQQ==
X-Gm-Message-State: ANoB5plaadx3YStmLUJmBd9FmzZBTjgZ4kxfEDDMRm3YcSkI7HUhN7Bh
        QJWIjlo7UTmPmdVf/NlThWVyTpEkLgLeEOys6O5mrnD611WOrQF5MUggBMRprhx+jIs2fGV6Hr3
        jxJADx+MX3BISgEzO
X-Received: by 2002:a05:600c:4143:b0:3c6:bc31:20ed with SMTP id h3-20020a05600c414300b003c6bc3120edmr8592689wmm.41.1668442174564;
        Mon, 14 Nov 2022 08:09:34 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6jaWURvxgfsRAJxd6JqJAJZSFvhIsCymgU3NpsSC69NAaRQ9FIrIJbC8tZozb1WChbCSr4JQ==
X-Received: by 2002:a05:600c:4143:b0:3c6:bc31:20ed with SMTP id h3-20020a05600c414300b003c6bc3120edmr8592646wmm.41.1668442174142;
        Mon, 14 Nov 2022 08:09:34 -0800 (PST)
Received: from ?IPV6:2003:cb:c703:d300:d881:1fd5:bc95:5e2d? (p200300cbc703d300d8811fd5bc955e2d.dip0.t-ipconnect.de. [2003:cb:c703:d300:d881:1fd5:bc95:5e2d])
        by smtp.gmail.com with ESMTPSA id l22-20020a05600c16d600b003cf4eac8e80sm14761753wmn.23.2022.11.14.08.09.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 08:09:33 -0800 (PST)
Message-ID: <9af36be3-313b-e39c-85bb-bf30011bccb8@redhat.com>
Date:   Mon, 14 Nov 2022 17:09:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Ives van Hoorne <ives@codesandbox.io>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>, stable@vger.kernel.org
References: <20221110203132.1498183-1-peterx@redhat.com>
 <20221110203132.1498183-2-peterx@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v2 1/2] mm/migrate: Fix read-only page got writable when
 recover pte
In-Reply-To: <20221110203132.1498183-2-peterx@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10.11.22 21:31, Peter Xu wrote:
> Ives van Hoorne from codesandbox.io reported an issue regarding possible
> data loss of uffd-wp when applied to memfds on heavily loaded systems.  The
> sympton is some read page got data mismatch from the snapshot child VMs.
> 
> Here I can also reproduce with a Rust reproducer that was provided by Ives
> that keeps taking snapshot of a 256MB VM, on a 32G system when I initiate
> 80 instances I can trigger the issues in ten minutes.
> 
> It turns out that we got some pages write-through even if uffd-wp is
> applied to the pte.
> 
> The problem is, when removing migration entries, we didn't really worry
> about write bit as long as we know it's not a write migration entry.  That
> may not be true, for some memory types (e.g. writable shmem) mk_pte can
> return a pte with write bit set, then to recover the migration entry to its
> original state we need to explicit wr-protect the pte or it'll has the
> write bit set if it's a read migration entry.
> 
> For uffd it can cause write-through.  I didn't verify, but I think it'll be
> the same for mprotect()ed pages and after migration we can miss the sigbus
> instead.

I don't think so. mprotect() handling relies on vma->vm_page_prot, which 
is supposed to do the right thing. E.g., map the pte protnone without 
VM_READ/VM_WRITE/....

> 
> The relevant code on uffd was introduced in the anon support, which is
> commit f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration",
> 2020-04-07).  However anon shouldn't suffer from this problem because anon
> should already have the write bit cleared always, so that may not be a
> proper Fixes target.  To satisfy the need on the backport, I'm attaching
> the Fixes tag to the uffd-wp shmem support.  Since no one had issue with
> mprotect, so I assume that's also the kernel version we should start to
> backport for stable, and we shouldn't need to worry before that.
> 
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: b1f9e876862d ("mm/uffd: enable write protection for shmem & hugetlbfs")
> Reported-by: Ives van Hoorne <ives@codesandbox.io>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>   mm/migrate.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index dff333593a8a..8b6351c08c78 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -213,8 +213,14 @@ static bool remove_migration_pte(struct folio *folio,
>   			pte = pte_mkdirty(pte);
>   		if (is_writable_migration_entry(entry))
>   			pte = maybe_mkwrite(pte, vma);
> -		else if (pte_swp_uffd_wp(*pvmw.pte))
> +		else
> +			/* NOTE: mk_pte can have write bit set */
> +			pte = pte_wrprotect(pte);


Any particular reason why not to simply glue this to pte_swp_uffd_wp(), 
because only that needs special care:

if (pte_swp_uffd_wp(*pvmw.pte)) {
	pte = pte_wrprotect(pte);
	pte = pte_mkuffd_wp(pte);
}


And that would match what actually should have been done in commit 
f45ec5ff16a7 -- only special-case uffd-wp.

Note that I think there are cases where we have a PTE that was 
!writable, but after migration we can map it writable.


BTW, does unuse_pte() need similar care?

new_pte = pte_mkold(mk_pte(page, vma->vm_page_prot));
if (pte_swp_uffd_wp(*pte))
	new_pte = pte_mkuffd_wp(new_pte);
set_pte_at(vma->vm_mm, addr, pte, new_pte);


-- 
Thanks,

David / dhildenb


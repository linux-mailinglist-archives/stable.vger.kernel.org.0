Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33F462A133
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 19:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbiKOSSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 13:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiKOSSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 13:18:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472862FC11
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 10:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668536267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zM9NVAiHgjBvRccxutMAlz4UOKHMx1Iq+kM6b0m0gaI=;
        b=b7i+rRpK0fHQOs4humFDMLHL75Js0Ex2cCe8140CvarSn4q4XyMRCXmceLGCesFI+uh0M1
        nQuS2QLtOHbAVwGlseupPGcaN+i2jm8YDxM+W2GiS+IiY77p3/sdn+apLU3eoKzPIYeeID
        K//La77kciverlKmP2nfrICzUl9SUAY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-301-XWlOTsLZNbyfVRY0Ll2bCA-1; Tue, 15 Nov 2022 13:17:46 -0500
X-MC-Unique: XWlOTsLZNbyfVRY0Ll2bCA-1
Received: by mail-wr1-f70.google.com with SMTP id c18-20020adfa312000000b002364fabf2ceso3038685wrb.2
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 10:17:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zM9NVAiHgjBvRccxutMAlz4UOKHMx1Iq+kM6b0m0gaI=;
        b=AI2XG+IoU0W8LlexXxCtWVerJWCDO6HE6fOczRQhDhICasNxEnnsI/zR4jIIgc44D7
         C/5Qfd9wM46RhTB2Y5BGqBH4WBR9rW0dZPnhSGkmWhs0JplYVUe8Nj+8XB3Jz6wErsNo
         FRiETDIIZsjtyIwCXXho2RJM7EJgteYQgorI5yJ1frEo+k1Ycx1qAY95cA+I47gh8byp
         2AVNuuEiLI4lrZymF5bvPCDoyYPLafqjjBjyZHon+MxySWGdtGdFuYDDJYBZ1hNWFA30
         SUEBc3efR0TVSsa19TZY/Gdgb5CHGSNOi5yWL10wTlzX5BF0IunaQZa1COJ7D69kkWaW
         FGxg==
X-Gm-Message-State: ANoB5pn5PjIzgrDBy4eYfhFGoMzxPc8vpjMvCj3tWmZp59p+EAhMzYjI
        O95EaiYwdO2OTjXGu2CDfxILzE6dOXXRf+/7opqnlKw3XtqJkcMGzrX3X5DF+dcoHHhspDG69fb
        RPbKz28yGNMNYIlC+
X-Received: by 2002:a05:600c:4f06:b0:3cf:a323:bfe6 with SMTP id l6-20020a05600c4f0600b003cfa323bfe6mr2434581wmq.86.1668536265069;
        Tue, 15 Nov 2022 10:17:45 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6FRbcS4vsa5azpDI/ImCO2GqAsz5ThBO9bUYJE/LjiknvN5Mt9qC3X8dURVYSCU/NMeS3Wdw==
X-Received: by 2002:a05:600c:4f06:b0:3cf:a323:bfe6 with SMTP id l6-20020a05600c4f0600b003cfa323bfe6mr2434558wmq.86.1668536264756;
        Tue, 15 Nov 2022 10:17:44 -0800 (PST)
Received: from ?IPV6:2003:cb:c707:9d00:9303:90ce:6dcb:2bc9? (p200300cbc7079d00930390ce6dcb2bc9.dip0.t-ipconnect.de. [2003:cb:c707:9d00:9303:90ce:6dcb:2bc9])
        by smtp.gmail.com with ESMTPSA id x11-20020a5d54cb000000b002415dd45320sm12973262wrv.112.2022.11.15.10.17.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Nov 2022 10:17:44 -0800 (PST)
Message-ID: <5ddf1310-b49f-6e66-a22a-6de361602558@redhat.com>
Date:   Tue, 15 Nov 2022 19:17:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v3 1/2] mm/migrate: Fix read-only page got writable when
 recover pte
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc:     Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Ives van Hoorne <ives@codesandbox.io>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Alistair Popple <apopple@nvidia.com>, stable@vger.kernel.org
References: <20221114000447.1681003-1-peterx@redhat.com>
 <20221114000447.1681003-2-peterx@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20221114000447.1681003-2-peterx@redhat.com>
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

On 14.11.22 01:04, Peter Xu wrote:
> Ives van Hoorne from codesandbox.io reported an issue regarding possible
> data loss of uffd-wp when applied to memfds on heavily loaded systems.  The
> symptom is some read page got data mismatch from the snapshot child VMs.
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
> write bit set if it's a read migration entry.  For uffd it can cause
> write-through.
> 
> The relevant code on uffd was introduced in the anon support, which is
> commit f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration",
> 2020-04-07).  However anon shouldn't suffer from this problem because anon
> should already have the write bit cleared always, so that may not be a
> proper Fixes target, while I'm adding the Fixes to be uffd shmem support.
> 
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: b1f9e876862d ("mm/uffd: enable write protection for shmem & hugetlbfs")
> Reported-by: Ives van Hoorne <ives@codesandbox.io>
> Reviewed-by: Alistair Popple <apopple@nvidia.com>
> Tested-by: Ives van Hoorne <ives@codesandbox.io>
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
> +
> +		if (pte_swp_uffd_wp(*pvmw.pte)) {
> +			WARN_ON_ONCE(pte_write(pte));
>   			pte = pte_mkuffd_wp(pte);
> +		}
>   
>   		if (folio_test_anon(folio) && !is_readable_migration_entry(entry))
>   			rmap_flags |= RMAP_EXCLUSIVE;

As raised, I don't agree to this generic non-uffd-wp change without 
further, clear justification.

I won't nack it, but I won't ack it either.

-- 
Thanks,

David / dhildenb


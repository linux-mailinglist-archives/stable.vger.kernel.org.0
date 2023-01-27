Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F4867EAD4
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 17:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbjA0QY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 11:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbjA0QYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 11:24:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E9B83955
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 08:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674836643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rBcfIHEg4jZbTQIImkzkLN9g2iVk6db6jthiIxejuwA=;
        b=QF2A4LeBPwX65noixYO8JgYWTPdysstjERrxpemwJYwjzlWMxlvBL7TT87e8jpOLS7VqU7
        qYKFmSIZvrGHdhbkJ13srv7omBT8UaVLFHnibnqnpLV4LqRCRE+W1Nd4CAvnud0PFGJLuy
        JgNRVyDK4NcRypbf8KvzfFd4jRSWwN8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-58-Ja3JXvBvNgG9c1TB8bZ5nQ-1; Fri, 27 Jan 2023 11:24:02 -0500
X-MC-Unique: Ja3JXvBvNgG9c1TB8bZ5nQ-1
Received: by mail-wm1-f69.google.com with SMTP id u12-20020a05600c210c00b003da1c092b83so1641341wml.7
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 08:24:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rBcfIHEg4jZbTQIImkzkLN9g2iVk6db6jthiIxejuwA=;
        b=kZ44XVS4EHoktM2/LdYl4E9MjpptbC94MF1cogZRLxUuAjN/YBIqln3gmTjYpBcphM
         EJUlx5BxoaVBbGcEKJwRHPM0mLif3km5voTCFTVbpg4Leh9txhOvkeIvyHU532w9USfv
         VM4mR/B6DKzIy8ehLQYqPGoJzO4pPi5Azk3TnMSeA/2cEs7moN0A62auc0Ak7L6y2MaP
         vBeDAd9EUUYpW4IJkZEZpcEU3NqbTq7HerTn702zvDCSND7NwGIhHKKg15kdIpEAlAkw
         YtJ7/shvoPw5GDrZuGwnLTLaiWBRxjoPJgSAkvNYu9wVIaIfwqHz+nfQWxNfD+2ZN9X7
         Ta7Q==
X-Gm-Message-State: AO0yUKUheAT04fmWL6rs1+hbpfhAZLrwL/uC9YiJasEVW8kxVUJJVYbc
        3JVtur21QFl3rX2v+9mRG9W1/WN5TLg8g1iBLC2w0h9AU+SHd3yX8Qqasli8IQs0lLzvbow80GM
        9AF9gE1H4IuLfbE3S
X-Received: by 2002:a5d:5588:0:b0:2bf:cfb4:2e2 with SMTP id i8-20020a5d5588000000b002bfcfb402e2mr3530697wrv.17.1674836641200;
        Fri, 27 Jan 2023 08:24:01 -0800 (PST)
X-Google-Smtp-Source: AK7set/Y+LNaZDyABiiOmf5N54VfZvfoeUt9bSW+AQh4dtqSkfuGAZY0DclafN1Se1z2VO+XUxpTjQ==
X-Received: by 2002:a5d:5588:0:b0:2bf:cfb4:2e2 with SMTP id i8-20020a5d5588000000b002bfcfb402e2mr3530671wrv.17.1674836640968;
        Fri, 27 Jan 2023 08:24:00 -0800 (PST)
Received: from ?IPV6:2003:d8:2f16:1800:a9b4:1776:c5d9:1d9a? (p200300d82f161800a9b41776c5d91d9a.dip0.t-ipconnect.de. [2003:d8:2f16:1800:a9b4:1776:c5d9:1d9a])
        by smtp.gmail.com with ESMTPSA id z14-20020a5d640e000000b002bfb5bda59asm4467446wru.25.2023.01.27.08.23.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 08:24:00 -0800 (PST)
Message-ID: <f9f13d4d-5882-2647-0032-e4f0e9296c69@redhat.com>
Date:   Fri, 27 Jan 2023 17:23:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 2/2] migrate: hugetlb: Check for hugetlb shared PMD in
 node migration
Content-Language: en-US
To:     Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Peter Xu <peterx@redhat.com>, Michal Hocko <mhocko@suse.com>,
        Yang Shi <shy828301@gmail.com>,
        Vishal Moola <vishal.moola@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
References: <20230126222721.222195-1-mike.kravetz@oracle.com>
 <20230126222721.222195-3-mike.kravetz@oracle.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230126222721.222195-3-mike.kravetz@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26.01.23 23:27, Mike Kravetz wrote:
> migrate_pages/mempolicy semantics state that CAP_SYS_NICE is required
> to move pages shared with another process to a different node.
> page_mapcount > 1 is being used to determine if a hugetlb page is shared.
> However, a hugetlb page will have a mapcount of 1 if mapped by multiple
> processes via a shared PMD.  As a result, hugetlb pages shared by multiple
> processes and mapped with a shared PMD can be moved by a process without
> CAP_SYS_NICE.
> 
> To fix, check for a shared PMD if mapcount is 1.  If a shared PMD is
> found consider the page shared.
> 
> Fixes: e2d8cf405525 ("migrate: add hugepage migration code to migrate_pages()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
> ---
>   mm/mempolicy.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 85a34f1f3ab8..72142fbe7652 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -600,7 +600,8 @@ static int queue_pages_hugetlb(pte_t *pte, unsigned long hmask,
>   
>   	/* With MPOL_MF_MOVE, we migrate only unshared hugepage. */
>   	if (flags & (MPOL_MF_MOVE_ALL) ||
> -	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1)) {
> +	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1 &&
> +	     !hugetlb_pmd_shared(pte))) {
>   		if (isolate_hugetlb(page, qp->pagelist) &&
>   			(flags & MPOL_MF_STRICT))
>   			/*

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb


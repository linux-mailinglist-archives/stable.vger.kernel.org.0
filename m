Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0951967EAD2
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 17:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234847AbjA0QYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 11:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234837AbjA0QYe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 11:24:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE9E820FF
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 08:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674836625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ay4J8NiVmukoYZxh47vc7cE5H4Ol6HWWCqzI6lRkn7Y=;
        b=VYrxYL7VD9NwBOBD2AxnTyypuQvlRhIjFrLzAtFI5kAalufJyEzPssreSK/pPstskP1JHF
        mST6+lk7Cw5JfsPoU3+8Gbo/U5zPWu7W0gT+W5XohVAnN6EZOYUfZcuvMv/R0VBR0qcCqn
        25VSyfPTbh86bUSsa7b+1+N9uVuCHDI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-178-6Cw4YEzrOBuZSXPTe37FAw-1; Fri, 27 Jan 2023 11:23:42 -0500
X-MC-Unique: 6Cw4YEzrOBuZSXPTe37FAw-1
Received: by mail-wm1-f71.google.com with SMTP id o22-20020a05600c511600b003db02b921f1so4914625wms.8
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 08:23:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ay4J8NiVmukoYZxh47vc7cE5H4Ol6HWWCqzI6lRkn7Y=;
        b=wpMONTryyZag7T4+crhaapHgXAqrcjIzwICCoCtDPdyiNTYadxBXU/Jocrsjf5bwyA
         wYasQYGnblA89YshvIXQ7Rm8dAJvxMZJuXfvb4+o1cG5TFFAjvPS88yPmwJlB8cc+xED
         Ejh2W8+JmNMokCUZ8i7T4MxEwHtlUX/+9jdUhe0rYBag1Ej54mf2xbKYy6gB18Af1zJI
         riubmeg1JpXuobKOVowVnuNpi8I/TvdxSjwWkyKeM1Ux9aPVz+PzX9uPCY3DcFCRTBWi
         AxClF9S/4odDi+9cjcBPYtUJd0mZPfJHSuQIYDKXzq24b5hVEQ/5vF65QACc/P1eLhHL
         fH5A==
X-Gm-Message-State: AFqh2krzw9OwocGX6hKk+1ZtiHWO8/+vg5HJ49sPBWXxK3NGkVyqC4ae
        h0/xKkEpovY5IZtwnNUQEO57VNEn3xEjIkPYuKVsDwASzvO3H6KEf/XVWr4VS4H55e8gAvdD9+7
        yVKUX2eA96KEtK3eW
X-Received: by 2002:adf:a318:0:b0:2bd:dc0c:ffd1 with SMTP id c24-20020adfa318000000b002bddc0cffd1mr36614102wrb.13.1674836621246;
        Fri, 27 Jan 2023 08:23:41 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuB2dMIFD7bUBu52H/xM+AQhiucG06bJTl/Uapk0YVnQa+vB4PB/FAEEMFu1JwsZHx3L7robg==
X-Received: by 2002:adf:a318:0:b0:2bd:dc0c:ffd1 with SMTP id c24-20020adfa318000000b002bddc0cffd1mr36614088wrb.13.1674836620959;
        Fri, 27 Jan 2023 08:23:40 -0800 (PST)
Received: from ?IPV6:2003:d8:2f16:1800:a9b4:1776:c5d9:1d9a? (p200300d82f161800a9b41776c5d91d9a.dip0.t-ipconnect.de. [2003:d8:2f16:1800:a9b4:1776:c5d9:1d9a])
        by smtp.gmail.com with ESMTPSA id r8-20020adfda48000000b002be25db0b7bsm4403700wrl.10.2023.01.27.08.23.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 08:23:40 -0800 (PST)
Message-ID: <4ad5163f-5368-0bd8-de9b-1400a7a653ed@redhat.com>
Date:   Fri, 27 Jan 2023 17:23:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 1/2] mm: hugetlb: proc: check for hugetlb shared PMD in
 /proc/PID/smaps
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
 <20230126222721.222195-2-mike.kravetz@oracle.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230126222721.222195-2-mike.kravetz@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26.01.23 23:27, Mike Kravetz wrote:
> A hugetlb page will have a mapcount of 1 if mapped by multiple processes
> via a shared PMD.  This is because only the first process increases the
> map count, and subsequent processes just add the shared PMD page to
> their page table.
> 
> page_mapcount is being used to decide if a hugetlb page is shared or
> private in /proc/PID/smaps.  Pages referenced via a shared PMD were
> incorrectly being counted as private.
> 
> To fix, check for a shared PMD if mapcount is 1.  If a shared PMD is
> found count the hugetlb page as shared.  A new helper to check for a
> shared PMD is added.
> 
> Fixes: 25ee01a2fca0 ("mm: hugetlb: proc: add hugetlb-related fields to /proc/PID/smaps")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
> ---
>   fs/proc/task_mmu.c      | 10 ++++++++--
>   include/linux/hugetlb.h | 12 ++++++++++++
>   2 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index e35a0398db63..cb9539879402 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -749,8 +749,14 @@ static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
>   
>   		if (mapcount >= 2)
>   			mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
> -		else
> -			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
> +		else {

Better:

if (mapcount >= 2 || hugetlb_pmd_shared(pte))
	mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
else
	mss->private_hugetlb += huge_page_size(hstate_vma(vma));



-- 
Thanks,

David / dhildenb


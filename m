Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0068F65E6FB
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 09:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjAEIlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 03:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbjAEIlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 03:41:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C16B4D4B8
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 00:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672908043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V0EEGFVxQgHq62o0vTXA8Zrg5fmlPp4zowvFDCM/JBo=;
        b=RrEGZ23Zhk90qYL7G7za9n/zSH3aHwIZ/+C0RDyqMSPyJO0vyr3G+iGaljgoCB8Ct5j4tr
        2ZYO07ZhOX8IHvX+YRJfgVG1dpXMtOrzw/HjqZIC9RkRM75/w019PIfdRi1COIDmsBked3
        Oo0ya3yQdu1YDL/AJj6Ryec3efabaHg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-298-Otg0v0grMhuczIv1934fyA-1; Thu, 05 Jan 2023 03:40:37 -0500
X-MC-Unique: Otg0v0grMhuczIv1934fyA-1
Received: by mail-wm1-f72.google.com with SMTP id j1-20020a05600c1c0100b003d99070f529so677799wms.9
        for <stable@vger.kernel.org>; Thu, 05 Jan 2023 00:40:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V0EEGFVxQgHq62o0vTXA8Zrg5fmlPp4zowvFDCM/JBo=;
        b=2h3CLk/kXhEWFM3CJt5E7b6z2/dxsJZTaXtyF9hTokL5PAb0Q0CDTVobvRBgguJ8z6
         LjglzA9J+CGl0r/RtasrDPn355QZtmXmOBMeFf3CkPAySfKaOY8DbC6qA6dEBGttRKK/
         Y3kBFWLNSvpmPc2kZcEb4wE2LGO3QvovKNjTbYbp7TVv0/gbLXdpKMT91mnqwYpKfu76
         HXjgLQAYYF1ZT3fk7qqJRYahzCX0u4B18G8d2Wu0NEP/LJvdhhsSjzeB8NA3JBPrpARo
         rYhDAxINPIzotftA7q70IDrMvVP1IFi1oEGIjGT7k48o9LiYpBgY+35e3ERPTuCemB11
         Y2TA==
X-Gm-Message-State: AFqh2kpe9PUTd7ERL+VH/r33GVvu8tzBc0ylIRIKvou51Ftugnpc79am
        SuguqRmmvKc0v+9/pcCr2B4c+K8ll9rjICT0/GlAgZZER2mMUBmBx0CM+EfOE9oLxNsE/DHp9I/
        AyJm9xYYgmCO+Xqjc
X-Received: by 2002:a05:600c:4e09:b0:3d4:5741:af9b with SMTP id b9-20020a05600c4e0900b003d45741af9bmr39382070wmq.0.1672907976070;
        Thu, 05 Jan 2023 00:39:36 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt+eMzp4Or8SPLGMCE7Sk7rJ0RqIPD6WCkqertmKUjTxcUtwA44aRvdfXaiUEttQmz5pbu3bg==
X-Received: by 2002:a05:600c:4e09:b0:3d4:5741:af9b with SMTP id b9-20020a05600c4e0900b003d45741af9bmr39382056wmq.0.1672907975762;
        Thu, 05 Jan 2023 00:39:35 -0800 (PST)
Received: from ?IPV6:2003:cb:c707:6e00:ff02:ec7a:ded5:ec1e? (p200300cbc7076e00ff02ec7aded5ec1e.dip0.t-ipconnect.de. [2003:cb:c707:6e00:ff02:ec7a:ded5:ec1e])
        by smtp.gmail.com with ESMTPSA id c7-20020a05600c0a4700b003c6bbe910fdsm1908482wmq.9.2023.01.05.00.39.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jan 2023 00:39:35 -0800 (PST)
Message-ID: <db5797a5-c4e9-753d-790a-3d432ac525e3@redhat.com>
Date:   Thu, 5 Jan 2023 09:39:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 1/3] mm/hugetlb: Pre-allocate pgtable pages for uffd
 wr-protects
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-stable <stable@vger.kernel.org>
References: <20230104225207.1066932-1-peterx@redhat.com>
 <20230104225207.1066932-2-peterx@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230104225207.1066932-2-peterx@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04.01.23 23:52, Peter Xu wrote:
> Userfaultfd-wp uses pte markers to mark wr-protected pages for both shmem
> and hugetlb.  Shmem has pre-allocation ready for markers, but hugetlb path
> was overlooked.
> 
> Doing so by calling huge_pte_alloc() if the initial pgtable walk fails to
> find the huge ptep.  It's possible that huge_pte_alloc() can fail with high
> memory pressure, in that case stop the loop immediately and fail silently.
> This is not the most ideal solution but it matches with what we do with
> shmem meanwhile it avoids the splat in dmesg.
> 
> Cc: linux-stable <stable@vger.kernel.org> # 5.19+
> Fixes: 60dfaad65aa9 ("mm/hugetlb: allow uffd wr-protect none ptes")
> Reported-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>   mm/hugetlb.c | 13 +++++++++++--
>   1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index bf7a1f628357..017d9159cddf 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6649,8 +6649,17 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
>   		spinlock_t *ptl;
>   		ptep = hugetlb_walk(vma, address, psize);

if (!ptep && likely(!uffd_wp)) {
	/* Nothing to protect. */
	address |= last_addr_mask;
	continue;
} else if (!ptep) {
	...
}

Might look slightly more readable would minimize changes. This should 
work, so

Acked-by: David Hildenbrand <david@redhat.com>

>   		if (!ptep) {
> -			address |= last_addr_mask;
> -			continue;
> +			if (!uffd_wp) {
> +				address |= last_addr_mask;
> +				continue;
> +			}
> +			/*
> +			 * Userfaultfd wr-protect requires pgtable
> +			 * pre-allocations to install pte markers.
> +			 */
> +			ptep = huge_pte_alloc(mm, vma, address, psize);
> +			if (!ptep)
> +				break;
>   		}
>   		ptl = huge_pte_lock(h, mm, ptep);
>   		if (huge_pmd_unshare(mm, vma, address, ptep)) {

-- 
Thanks,

David / dhildenb


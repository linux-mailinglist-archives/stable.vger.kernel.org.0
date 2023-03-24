Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8288E6C887C
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 23:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbjCXWhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 18:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbjCXWhw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 18:37:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7577681
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 15:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679697419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=245sQ3Egn4hz+1e4Tmo/BWRmLOSVsP8k+1a6ph+rjmI=;
        b=QcCY25SWRoS7c/IdvOa2AD3Ck/ysdTylGrbqIwpHuGy2vaAfmKVfUES768KC7ZWVrbZt3K
        rAmOf36nsY67WuCf1ZrLrUoaQR8lFJi9nGbUxu46vdNGh3XBHqRgLbdOvn7v0QDzM5Xdu5
        aLCDPEN0vtc7L2UkBmmoubG16M9Iqw8=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-VLoW-jBrNnegl7XGYDmTwg-1; Fri, 24 Mar 2023 18:36:56 -0400
X-MC-Unique: VLoW-jBrNnegl7XGYDmTwg-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-54161af1984so31811377b3.3
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 15:36:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679697415;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=245sQ3Egn4hz+1e4Tmo/BWRmLOSVsP8k+1a6ph+rjmI=;
        b=iJpsCLmkZmud5oDyhuH9QyNnDzWGQNjjlOENlV1IPmVGbZnTwPx3Mj9/kuKFe1vqQM
         oXZaIoDN/zAc0kO4wyKyXzEgvtiulXVKGXYMfuQa9SFQ3Y8xNzKfCdnlSvPin3LPBdOh
         5msTjtGIze9I8BPQqGnXnRbENZVlXs7vzSLYydmEsvDW9tzByoBN2Vt+7O9CtCifarDC
         3XOr1m2Di1nehJ6OGP6fE1vx20sOsJNRLTGLPCsIRiKaWGvoJWL+Rr1NVFNBbklow32p
         CODf0Pf9fxpeIICh4fRj4exIpY6nJNeWH+bAgiO28UWgA7ASYHY2zxILn0+M2q9N5zPO
         +qqQ==
X-Gm-Message-State: AAQBX9cQOhV5K3tM6QDWmJCCZ6cQm0cvwuPdUxrA9f5br3Z1qzBLnbUq
        yt10XeLzhSOtWVdYQ/lAUwRdulF0BhVnGjYVB3mMSPNHFipcb3Hi0dsEtaQvglqPdEK291J/nTU
        thHxr18UnYKFgnwyC
X-Received: by 2002:a0d:dfd1:0:b0:541:64e4:2094 with SMTP id i200-20020a0ddfd1000000b0054164e42094mr4013384ywe.24.1679697415397;
        Fri, 24 Mar 2023 15:36:55 -0700 (PDT)
X-Google-Smtp-Source: AKy350bbwDMlwcxIQGcKee8Lw++uBBz1BazzuQGpq2PjaQ8HDMN/bfcPjM7kEylxlrs5ohlMI/tbdg==
X-Received: by 2002:a0d:dfd1:0:b0:541:64e4:2094 with SMTP id i200-20020a0ddfd1000000b0054164e42094mr4013371ywe.24.1679697415091;
        Fri, 24 Mar 2023 15:36:55 -0700 (PDT)
Received: from [100.69.142.128] ([206.173.106.22])
        by smtp.gmail.com with ESMTPSA id q9-20020a814309000000b00545a08184f4sm664550ywa.132.2023.03.24.15.36.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 15:36:54 -0700 (PDT)
Message-ID: <8a06be33-1b44-b992-f80a-8764810ebf3f@redhat.com>
Date:   Fri, 24 Mar 2023 23:36:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v3] mm/hugetlb: Fix uffd wr-protection for CoW
 optimization path
Content-Language: en-US
To:     Mike Kravetz <mike.kravetz@oracle.com>,
        Peter Xu <peterx@redhat.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        linux-stable <stable@vger.kernel.org>
References: <20230324142620.2344140-1-peterx@redhat.com>
 <20230324222707.GA3046@monkey>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230324222707.GA3046@monkey>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24.03.23 23:27, Mike Kravetz wrote:
> On 03/24/23 10:26, Peter Xu wrote:
>> This patch fixes an issue that a hugetlb uffd-wr-protected mapping can be
>> writable even with uffd-wp bit set.  It only happens with hugetlb private
>> mappings, when someone firstly wr-protects a missing pte (which will
>> install a pte marker), then a write to the same page without any prior
>> access to the page.
>>
>> Userfaultfd-wp trap for hugetlb was implemented in hugetlb_fault() before
>> reaching hugetlb_wp() to avoid taking more locks that userfault won't need.
>> However there's one CoW optimization path that can trigger hugetlb_wp()
>> inside hugetlb_no_page(), which will bypass the trap.
>>
>> This patch skips hugetlb_wp() for CoW and retries the fault if uffd-wp bit
>> is detected.  The new path will only trigger in the CoW optimization path
>> because generic hugetlb_fault() (e.g. when a present pte was wr-protected)
>> will resolve the uffd-wp bit already.  Also make sure anonymous UNSHARE
>> won't be affected and can still be resolved, IOW only skip CoW not CoR.
>>
>> This patch will be needed for v5.19+ hence copy stable.
>>
>> Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
>> Cc: linux-stable <stable@vger.kernel.org>
>> Fixes: 166f3ecc0daf ("mm/hugetlb: hook page faults for uffd write protection")
>> Signed-off-by: Peter Xu <peterx@redhat.com>
>> ---
>>
>> Notes:
>>
>> v2 is not on the list but in an attachment in the reply; this v3 is mostly
>> to make sure it's not the same as the patch used to be attached.  Sorry
>> Andrew, we need to drop the queued one as I rewrote the commit message.
> 
> My appologies!  I saw the code path missed in v2 and assumed you did not
> think it applied.  So, I said nothing.  My bad!
> 
>> Muhammad, I didn't attach your T-b because of the slight functional change.
>> Please feel free to re-attach if it still works for you (which I believe
>> should).
>>
>> thanks,
>> ---
>>   mm/hugetlb.c | 14 ++++++++++++--
>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 8bfd07f4c143..a58b3739ed4b 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -5478,7 +5478,7 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
>>   		       struct folio *pagecache_folio, spinlock_t *ptl)
>>   {
>>   	const bool unshare = flags & FAULT_FLAG_UNSHARE;
>> -	pte_t pte;
>> +	pte_t pte = huge_ptep_get(ptep);
>>   	struct hstate *h = hstate_vma(vma);
>>   	struct page *old_page;
>>   	struct folio *new_folio;
>> @@ -5487,6 +5487,17 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
>>   	unsigned long haddr = address & huge_page_mask(h);
>>   	struct mmu_notifier_range range;
>>   
>> +	/*
>> +	 * Never handle CoW for uffd-wp protected pages.  It should be only
>> +	 * handled when the uffd-wp protection is removed.
>> +	 *
>> +	 * Note that only the CoW optimization path (in hugetlb_no_page())
>> +	 * can trigger this, because hugetlb_fault() will always resolve
>> +	 * uffd-wp bit first.
>> +	 */
>> +	if (!unshare && huge_pte_uffd_wp(pte))
>> +		return 0;
> 
> This looks correct.  However, since the previous version looked correct I must
> ask.  Can we have unshare set and huge_pte_uffd_wp true?  If so, then it seems
> we would need to possibly propogate that uffd_wp to the new pte as in v2

We can. A reproducer would share an anon hugetlb page because parent and 
child. In the parent, we would uffd-wp that page. We could trigger 
unsharing by R/O-pinning that page.

-- 
Thanks,

David / dhildenb


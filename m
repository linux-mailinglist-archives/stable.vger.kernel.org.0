Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30BF26CB02E
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 22:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjC0U6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 16:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjC0U6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 16:58:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB9D172C
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 13:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679950672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l0k5HQijZZiTI5JKuN0wulOwFUsOATJ37PiPOJOEgWU=;
        b=W0U2bM8eND8fVvLvN7yl26bJvYrZETNCt1niRiEVOYkXh8lqbMIPBthXxhaGSlyyvFZUDU
        hbakCgS1JUAKPH0svCPdmuG9RYNFq1wmv46Vanpkl5THguHVslIu4mByMTMg2JrZ9d3hQa
        KxhL7nCXmtwcL9ea4G8iIq/mK1C7bfk=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-pN-srTyrMG2StVXbzKCr1Q-1; Mon, 27 Mar 2023 16:57:49 -0400
X-MC-Unique: pN-srTyrMG2StVXbzKCr1Q-1
Received: by mail-pf1-f199.google.com with SMTP id 16-20020a056a00073000b006260bbaa3a4so4834778pfm.16
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 13:57:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679950668;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l0k5HQijZZiTI5JKuN0wulOwFUsOATJ37PiPOJOEgWU=;
        b=gB8R/Gh9UEI6eoaJ6keycYYFs/H/keXMp+ggHo0TRJtqa9YUPCEbNkzZbU5txJA6/y
         VkMkgipdf5CNlWDEJfuZr3wSpkMlQGAM4JHb3RBNpdxnqdnZDqC8vfMx5Lew9BY9GMhr
         O6sQfT23gfTNvrTkrCvPXoF3I2lbgSdf7DIRkI17XDy6lCiB6aVXV/GLtMiorFHlwml9
         8ai7ogioPtA4IseG7gYxyjG17mx2hnrQm8AkQ/XYhh0JY5tcPSHa1UAsInC9oskZ4bto
         mx2qkgz7BpNu+wXD1xScSAfptfvqS53HtI8HMK9vP6zw5o4VbTYjp3JhqoKXQkXX+fhI
         UxnQ==
X-Gm-Message-State: AO0yUKW9ncVhHGxmWv9t75RGWbJMzTmhjKxcIOUEgOtuHO+76Y/udEL2
        TRo3tcQtj82PyA8+YMrOajMokx/hjY3mlUYeSHOzK/yfDdfMNQWvF70s0wS53JKJAXzOtdf7gga
        C50d3BImeV2mGvx1S
X-Received: by 2002:a17:90b:2243:b0:23f:7176:df32 with SMTP id hk3-20020a17090b224300b0023f7176df32mr13751414pjb.40.1679950667912;
        Mon, 27 Mar 2023 13:57:47 -0700 (PDT)
X-Google-Smtp-Source: AKy350a0pTeUjTnPuwRDsnKWfscYaKPzIjcxZsvU3tPZsN9ULXGT5CBiCjeFnwCwJ4yaAP2G4njNvw==
X-Received: by 2002:a17:90b:2243:b0:23f:7176:df32 with SMTP id hk3-20020a17090b224300b0023f7176df32mr13751400pjb.40.1679950667631;
        Mon, 27 Mar 2023 13:57:47 -0700 (PDT)
Received: from [172.16.65.120] ([64.114.255.114])
        by smtp.gmail.com with ESMTPSA id j8-20020a17090a060800b0023d01900d7bsm7675288pjj.0.2023.03.27.13.57.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 13:57:47 -0700 (PDT)
Message-ID: <c762297d-5c65-f20a-4c11-90d2f966c675@redhat.com>
Date:   Mon, 27 Mar 2023 22:57:46 +0200
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
 <8a06be33-1b44-b992-f80a-8764810ebf3f@redhat.com> <ZCBavqZE2cyVOzaW@x1n>
 <20230327183438.GC4184@monkey>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230327183438.GC4184@monkey>
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

On 27.03.23 20:34, Mike Kravetz wrote:
> On 03/26/23 10:46, Peter Xu wrote:
>> On Fri, Mar 24, 2023 at 11:36:53PM +0100, David Hildenbrand wrote:
>>>>> @@ -5487,6 +5487,17 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
>>>>>    	unsigned long haddr = address & huge_page_mask(h);
>>>>>    	struct mmu_notifier_range range;
>>>>> +	/*
>>>>> +	 * Never handle CoW for uffd-wp protected pages.  It should be only
>>>>> +	 * handled when the uffd-wp protection is removed.
>>>>> +	 *
>>>>> +	 * Note that only the CoW optimization path (in hugetlb_no_page())
>>>>> +	 * can trigger this, because hugetlb_fault() will always resolve
>>>>> +	 * uffd-wp bit first.
>>>>> +	 */
>>>>> +	if (!unshare && huge_pte_uffd_wp(pte))
>>>>> +		return 0;
>>>>
>>>> This looks correct.  However, since the previous version looked correct I must
>>>> ask.  Can we have unshare set and huge_pte_uffd_wp true?  If so, then it seems
>>>> we would need to possibly propogate that uffd_wp to the new pte as in v2
>>
>> Good point, thanks for spotting!
>>
>>>
>>> We can. A reproducer would share an anon hugetlb page because parent and
>>> child. In the parent, we would uffd-wp that page. We could trigger unsharing
>>> by R/O-pinning that page.
>>
>> Right.  This seems to be a separate bug..  It should be triggered in
>> totally different context and much harder due to rare use of RO pins,
>> meanwhile used with userfault-wp.
>>
>> If both of you agree, I can prepare a separate patch for this bug, and I'll
>> better prepare a reproducer/selftest with it.
>>
> 
> I am OK with separate patches, and agree that the R/O pinning case is less
> likely to happen.

Yes, the combination should be rather rare and we can fix that 
separately. Ideally, we'd try to mimic the same uffd code flow in 
hugetlb cow/unshare handling that we use in memory.c

> 
> Since this patch addresses the issue found by Muhammad,
> 
> Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>

Hopefully we didn't forget about yet another case :D

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb


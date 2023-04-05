Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECAA76D82BB
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 17:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238687AbjDEPzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 11:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjDEPze (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 11:55:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B369A1
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 08:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680710091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vp3w4ancoxCL4bBUeQO/Nr+Lv6anEYF8uurUtTzkQO0=;
        b=D1SD/LFI/xktYCHzgJmeRXgkhrOxW6lB9GWaAhcQpdIMX7TDECoEYsGc71nwYj1bDvY5u7
        iqle/KRZRb7Lt0NyRPgQoULjMl2TQCENTnYlZ86D4WjrzcjADVo9CEi16BElR9FIbYLMFD
        dtZPozeXslyN37kWkBXovycUFfWIp+U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-422-SQflFBlSODio4P0TXGqpcg-1; Wed, 05 Apr 2023 11:54:50 -0400
X-MC-Unique: SQflFBlSODio4P0TXGqpcg-1
Received: by mail-wm1-f72.google.com with SMTP id bg33-20020a05600c3ca100b003ef6d684105so15025659wmb.1
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 08:54:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680710089;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vp3w4ancoxCL4bBUeQO/Nr+Lv6anEYF8uurUtTzkQO0=;
        b=FmoJwpLa2rbKUl1GNKsyw1W/NqJ/YCNYRHs0MAReO/g5hqNXqz1JFgGF/0IODYtEfI
         JqAdx1G9iSK9wSm9VslPpf6HKrYD97soBQLJbS/8KMpb6iPkzAOR5kDzfd0uWCh0BjD+
         ORxO6zsyg9UUIWz9tQEmWYOT0fQ9nusFjUI80/KVfTDkuzfE9JQpyv9lub379Aq/dHC9
         /J0KWqOEfsSEx+rGaMHeWV+3Be1ZDYciG8TST43RNR+3NVSeGKUHRuZK7wkFpguAHiHM
         8StdbDPo6uQoSh8f4dr5eKiMgFHuudyXjXk1AZf9LZMNBR2vHKDHgX61UCMjePiNBkRZ
         NW3A==
X-Gm-Message-State: AAQBX9fUVw9F68yWSp9/qr+ui8HQ1qjm53fEkPTjmQQoaG8qmnsb+JwM
        7HEcgum5XH+SiWjIo1rjgV07zZI2CuLr9Q/AmiwoZcmnI/e0+GV+GJ2XGRK/FvkZmHBVqa0d36V
        yPdfGwCQBEFHQ8UNS
X-Received: by 2002:adf:e0c3:0:b0:2cf:e747:b0d4 with SMTP id m3-20020adfe0c3000000b002cfe747b0d4mr4423526wri.40.1680710088969;
        Wed, 05 Apr 2023 08:54:48 -0700 (PDT)
X-Google-Smtp-Source: AKy350bvV4mM6l4icTruP+qcXPPdpwTQeXltyFNrRrLmVB/ZGcHH+qjmdVbXXVCHqfw84CwFj+T03A==
X-Received: by 2002:adf:e0c3:0:b0:2cf:e747:b0d4 with SMTP id m3-20020adfe0c3000000b002cfe747b0d4mr4423506wri.40.1680710088611;
        Wed, 05 Apr 2023 08:54:48 -0700 (PDT)
Received: from ?IPV6:2003:cb:c703:d00:ca74:d9ea:11e0:dfb? (p200300cbc7030d00ca74d9ea11e00dfb.dip0.t-ipconnect.de. [2003:cb:c703:d00:ca74:d9ea:11e0:dfb])
        by smtp.gmail.com with ESMTPSA id c1-20020adfef41000000b002d322b9a7f5sm15323873wrp.88.2023.04.05.08.54.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 08:54:48 -0700 (PDT)
Message-ID: <19dad66f-4ec8-358c-df7f-35481f855c81@redhat.com>
Date:   Wed, 5 Apr 2023 17:54:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] mm/khugepaged: Check again on anon uffd-wp during
 isolation
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     Axel Rasmussen <axelrasmussen@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Yang Shi <shy828301@gmail.com>,
        linux-stable <stable@vger.kernel.org>
References: <20230405155120.3608140-1-peterx@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230405155120.3608140-1-peterx@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05.04.23 17:51, Peter Xu wrote:
> Khugepaged collapse an anonymous thp in two rounds of scans.  The 2nd round
> done in __collapse_huge_page_isolate() after hpage_collapse_scan_pmd(),
> during which all the locks will be released temporarily. It means the
> pgtable can change during this phase before 2nd round starts.
> 
> It's logically possible some ptes got wr-protected during this phase, and
> we can errornously collapse a thp without noticing some ptes are
> wr-protected by userfault.  e1e267c7928f wanted to avoid it but it only did
> that for the 1st phase, not the 2nd phase.
> 
> Since __collapse_huge_page_isolate() happens after a round of small page
> swapins, we don't need to worry on any !present ptes - if it existed
> khugepaged will already bail out.  So we only need to check present ptes
> with uffd-wp bit set there.
> 
> This is something I found only but never had a reproducer, I thought it was
> one caused a bug in Muhammad's recent pagemap new ioctl work, but it turns
> out it's not the cause of that but an userspace bug.  However this seems to
> still be a real bug even with a very small race window, still worth to have
> it fixed and copy stable.
> 
> Cc: linux-stable <stable@vger.kernel.org>
> Fixes: e1e267c7928f ("khugepaged: skip collapse if uffd-wp detected")
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>   mm/khugepaged.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index a19aa140fd52..42ac93b4bd87 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -575,6 +575,10 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>   			result = SCAN_PTE_NON_PRESENT;
>   			goto out;
>   		}
> +		if (pte_uffd_wp(pteval)) {
> +			result = SCAN_PTE_UFFD_WP;
> +			goto out;
> +		}
>   		page = vm_normal_page(vma, address, pteval);
>   		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
>   			result = SCAN_PAGE_NULL;

Yes, I agree that would be a small race where it could happen.

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb


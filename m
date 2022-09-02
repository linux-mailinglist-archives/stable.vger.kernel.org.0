Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A91CA5AA84E
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 08:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235376AbiIBGtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 02:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235287AbiIBGtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 02:49:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5775CBC82C
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 23:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662101363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gn1/pFkVAm17ZLauzUxMQF2RNXwPzrIq/JD90gpJ8rE=;
        b=gpCQsZWBfsMo8GGn9ORFk6PaW7FVk9j/+Q9JF5dfOb1CenXW7naTckuCSwgJ3XdUnHltzk
        jkIKItc15OFhgRpapz+6N1AVvEkpK8VkasFMP6Bf3/aK2yQlygBw0bF+sm5RIeTr+DI3mf
        tXGtEuIH7fEKiyepkXJjtt5qDj3pTB8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-455-1G7S8RboPJOThkLmO4ZzHg-1; Fri, 02 Sep 2022 02:49:22 -0400
X-MC-Unique: 1G7S8RboPJOThkLmO4ZzHg-1
Received: by mail-wm1-f70.google.com with SMTP id j22-20020a05600c485600b003a5e4420552so2491827wmo.8
        for <stable@vger.kernel.org>; Thu, 01 Sep 2022 23:49:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=Gn1/pFkVAm17ZLauzUxMQF2RNXwPzrIq/JD90gpJ8rE=;
        b=vRqyk9oZmUQVHHvylVjTzhTcgZby0nHPg0erP6jJ3W1ubWPF6Y4MlCeuS/YNs+HZdZ
         gk2MOtvmwSwhn+KW5Uwhm7LwMcOsK5tdX6GHDt6Wpr/sbA6bOMXo+oQa7Cz8fsfk2Mfc
         JKTrQjXarZdphd+nyA+/WFzLto4LGmEfWUh+zw4chOJdHAK8LJmawl50s2glB4+rv32a
         /xfswLcgbOFUshXa//PYCrUs1U+PC54YBOPzTJkSYIUm3U2g2Rcg9Dw/18e00TgZ4xzS
         oRmll2gIY7aBymLKz6/bikitRrNyKhYeJc3shV3a7JcL4rXYNBCaBEB/ZmjNho7lnh0w
         xf9A==
X-Gm-Message-State: ACgBeo1ZxzjM3qaig7YggQt2aGijxYb4EeXa+8EBRzAoIpTcM/dMFVvs
        zW5r/URgtGfavcuoAkxjPPDXgNxbmL/GwXg4YKw3rrxjXcKKzoNm0elvatR+6HWy9Bjs68lhbDa
        ZyXJtV5q9r6q2iDWd
X-Received: by 2002:a05:6000:817:b0:226:3d89:ebb4 with SMTP id bt23-20020a056000081700b002263d89ebb4mr17030584wrb.699.1662101361045;
        Thu, 01 Sep 2022 23:49:21 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6On1hWE9c9E9R4xYZDbPw8MSd6lWCiA5BI3pDap4N3u8UFtfr1D4s/X8k/SOFVxoKi18Qhbg==
X-Received: by 2002:a05:6000:817:b0:226:3d89:ebb4 with SMTP id bt23-20020a056000081700b002263d89ebb4mr17030567wrb.699.1662101360797;
        Thu, 01 Sep 2022 23:49:20 -0700 (PDT)
Received: from ?IPV6:2003:cb:c714:4800:2077:1bf6:40e7:2833? (p200300cbc714480020771bf640e72833.dip0.t-ipconnect.de. [2003:cb:c714:4800:2077:1bf6:40e7:2833])
        by smtp.gmail.com with ESMTPSA id g13-20020a05600c4ecd00b003a4c6e67f01sm9088534wmq.6.2022.09.01.23.49.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Sep 2022 23:49:20 -0700 (PDT)
Message-ID: <093bae05-419d-737d-73f0-6de59b39b34a@redhat.com>
Date:   Fri, 2 Sep 2022 08:49:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Peter Xu <peterx@redhat.com>,
        Alistair Popple <apopple@nvidia.com>,
        Nadav Amit <namit@vmware.com>, Yang Shi <shy828301@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@kernel.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Christoph von Recklinghausen <crecklin@redhat.com>,
        Don Dutile <ddutile@redhat.com>
References: <20220901083559.67446-1-david@redhat.com>
 <20220901153512.a59e9e584fb00a350788f56e@linux-foundation.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v1] mm: fix PageAnonExclusive clearing racing with
 concurrent RCU GUP-fast
In-Reply-To: <20220901153512.a59e9e584fb00a350788f56e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02.09.22 00:35, Andrew Morton wrote:
> On Thu,  1 Sep 2022 10:35:59 +0200 David Hildenbrand <david@redhat.com> wrote:
> 
>> The possible issues due to reordering are of theoretical nature so far
>> and attempts to reproduce the race failed.
>>
>> Especially the "no PTE change" case isn't the common case, because we'd
>> need an exclusive anonymous page that's mapped R/O and the PTE is clean
>> in KSM code -- and using KSM with page pinning isn't extremely common.
>> Further, the clear+TLB flush we used for now implies a memory barrier.
>> So the problematic missing part should be the missing memory barrier
>> after pinning but before checking if the PTE changed.
> 
> Obscure bug, large and tricky patch.  Is a -stable backport really
> justifiable?

Fair question, was asking myself the same. As you're wondering about the
same, I don't think so. Let's drop it.

Out of the CONFIG_HAVE_FAST_GUP supporting architectures primarily only
the 32bit architectures can even lose the PageAnonExclusive during
swapout (until we make them all preserve it in the swp PTE), the other
ones already support preserve it.

So unless fork() would be involved at the wrong time as well,  x86-64,
s390x, aarch64, ppc64 book3s ... wouldn't even have a real issue with
this race.

(note that the actual code changes are small -- but yes, I think
linux-stable rules always consider the full patch LOC)

-- 
Thanks,

David / dhildenb


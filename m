Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5BA558E102
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 22:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244953AbiHIUX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 16:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237427AbiHIUX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 16:23:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 073471EEF1
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 13:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660076633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ks5e3vG8/bg6ecSj9dekO7KiLf2ruNOcJnb5Pq8KV1g=;
        b=G7i6KRDVmDhDlvLYDV+YmRKbcSSN366qhLou1T/9Hw758g12LesiFTUMshWQxdHWuEGaCK
        EdRW5Sm5thzb6VCz4crHiytCBiPFjPU//em5XWRXbbYfgEVGfZXWbgM4ZoZ22DxS8a0ULL
        Wxz6nXwn9mzEgizgfywrhGh6OjIPyFw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-Z0Nl3zCFNnm0yqC-2cRqgw-1; Tue, 09 Aug 2022 16:23:51 -0400
X-MC-Unique: Z0Nl3zCFNnm0yqC-2cRqgw-1
Received: by mail-wm1-f72.google.com with SMTP id h62-20020a1c2141000000b003a4f57eaeaaso1229376wmh.8
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 13:23:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=ks5e3vG8/bg6ecSj9dekO7KiLf2ruNOcJnb5Pq8KV1g=;
        b=2dXhZTId0hNONLJgHzueCJaCtF4ZRfR08JBpvBWM+Eme4xa/GdMPDC4OLiglspEf1y
         ZK+EZIu7ssHjNZIOdd8CgvDANK6u0j/j7JeI9d0U9kSJMET4wPjSkxRS89so+COQ/PZO
         wevtncDQS6TRFaKj3Ezp4X72/sp8cEQEsWOQq2BangSpdjQnF1DBK7rhzY8LumxxS4dl
         BQa5BHvfvVf6vvYh5dDO3/DV+GJsPhuwqEJdyIUNesuandraRfciyL6VxKYx5jZS2mn5
         pqrFL1kPQiryU+1qSUMaWp3aOZmQ/kzgJEgBUdsE0Z8KOUnn+ZucXXmUCXw66zt7JWlO
         5nAQ==
X-Gm-Message-State: ACgBeo2XqJFwNq3Guas0CxI3BR9PwfGMJlN/qmP0cW9YkeTdfUbt2ro+
        Pz/+QsxsaPXLFIZBuELYGI9AAwV2wBNXH+ykSZqHTySr5cVVAt6Easvqb6Mt6a1YyQAD3pzb/7i
        Xg5fxqxQ/vpcch847
X-Received: by 2002:a7b:c003:0:b0:39c:5642:e415 with SMTP id c3-20020a7bc003000000b0039c5642e415mr103191wmb.111.1660076630662;
        Tue, 09 Aug 2022 13:23:50 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5MME3AJynexSREakjc/wtM1ePCr1r4osXSZ1oZmWn8F0r7gEvOHDAhoGVLa2hTVXuiIT2gIQ==
X-Received: by 2002:a7b:c003:0:b0:39c:5642:e415 with SMTP id c3-20020a7bc003000000b0039c5642e415mr103178wmb.111.1660076630387;
        Tue, 09 Aug 2022 13:23:50 -0700 (PDT)
Received: from ?IPV6:2003:cb:c705:3700:aed2:a0f8:c270:7f30? (p200300cbc7053700aed2a0f8c2707f30.dip0.t-ipconnect.de. [2003:cb:c705:3700:aed2:a0f8:c270:7f30])
        by smtp.gmail.com with ESMTPSA id q11-20020a5d658b000000b0021e4bc9edbfsm11591467wru.112.2022.08.09.13.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 13:23:50 -0700 (PDT)
Message-ID: <915e2f40-b94a-cef4-7aa7-a402e93dae68@redhat.com>
Date:   Tue, 9 Aug 2022 22:23:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1] mm/gup: fix FOLL_FORCE COW security issue and remove
 FOLL_COW
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <20220808073232.8808-1-david@redhat.com>
 <CAHk-=wgsDOz5MfYYS9mE7PvFn4kLhTFdBwXvN6HCEsw1kvJnRQ@mail.gmail.com>
 <91e18a2f-c93d-00b8-7c1b-6d8493c3b2d5@redhat.com>
 <CAHk-=whg0ddey-LqFAPfZJDXHMjaHJNojAV3q17yvjc6W8QRvQ@mail.gmail.com>
 <CAHk-=wgYAy5ho0Wqx+eri_+a5apYU1Th826UScE7rZRiyhPcGA@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <CAHk-=wgYAy5ho0Wqx+eri_+a5apYU1Th826UScE7rZRiyhPcGA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09.08.22 22:20, Linus Torvalds wrote:
> On Tue, Aug 9, 2022 at 1:14 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> But as there are two bits, I'm sure somebody ends up touching one and
>> not the other.
> 
> Ugh. The nommu code certainly does odd things here. That just looks wrong.
> 
> And the hugetlb code does something horrible too, but never *sets* it,
> so it looks like some odd subset of VM_SHARED.

mm/mmap.c:do_mmap() contains the magic bit

switch (flags & MAP_TYPE) {
case MAP_SHARED:
...
case MAP_SHARED_VALIDATE:
...
vm_flags |= VM_SHARED | VM_MAYSHARE;
if (!(file->f_mode & FMODE_WRITE))
	vm_flags &= ~(VM_MAYWRITE | VM_SHARED);
fallthrough;


VM_SHARED semantics are confusing.


-- 
Thanks,

David / dhildenb


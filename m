Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B5262A0C8
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 18:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbiKORzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 12:55:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiKORzO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 12:55:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8502613
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 09:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668534855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uzsXZUjzU9Tvku34iqNRXqR/c9ishDJ+OI6Nt0ZJdPc=;
        b=WIg91AfKVxDDsilQeCS1oa0FUxCWU2zgcgWu1grBGcUeW4L6yCYLoMbQk94frJbni8CJjk
        kDu+KT/JLurzb4RBr9ZBI0UgJVG3Sjp2juCSMWjaScktSxopYigj2d8Nhaz3TGljiPjRBE
        FZXl3QeXBSFQ4tmq8cEJzms05CD9GuQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-638-B24NvTFmMSuTBBhj8i2ZDA-1; Tue, 15 Nov 2022 12:54:12 -0500
X-MC-Unique: B24NvTFmMSuTBBhj8i2ZDA-1
Received: by mail-wm1-f70.google.com with SMTP id o5-20020a05600c510500b003cfca1a327fso8103429wms.8
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 09:54:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uzsXZUjzU9Tvku34iqNRXqR/c9ishDJ+OI6Nt0ZJdPc=;
        b=TLnOpz39aRzIqP+T7/ROsPTLoRw2zCRi6BaDoLbCpq0KMHe5oJVPz4g2Qd+X1MHucG
         WTATeNIAt37CM/GKjwiewpkb6N0Q/8KrlDwR7I3v7S+f/GsJstyWDNE4QmHZia+94JeB
         UYOotMGenOBhZaMbYYeUkB8uIXYtqlRzxZxCKTQcc0ELaCDj4AboYnlv98wVhXt6nIBm
         KvFZ+jOEQ8VeggtBPoA0+KWSQnuK13f5xzYbyyKvgSZgorVQjMCRaWSFiNFjfZJSVa65
         18gDfAfivXSepsjaW6yH4ycQpQW1qzuKc2iJAOZC1t6CYxJgBKdhc3dQY36XGFzOwB6b
         3Zog==
X-Gm-Message-State: ANoB5pkKtWNZpgCZXjIGFKAy/hiqUALA8aFPvHa+rZrRP39M1/VC24+w
        0wtnPu1zJhkTTAQQDT82Duv9ZXii/xueNLZ+ulpQx+zwd+95NAlM82Cq5kD0PsDyNU7h0bv3nXl
        HZQriT8xiMEXuLD2w
X-Received: by 2002:a7b:c4c7:0:b0:3cf:d58f:f66e with SMTP id g7-20020a7bc4c7000000b003cfd58ff66emr1250027wmk.165.1668534851622;
        Tue, 15 Nov 2022 09:54:11 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6K+CGiRDbCQ2KRVGAKLsIuam+vG0fIXgaiakr/jVXt3paVvOZlfQEzsQil6+QkbVPr7qTsvg==
X-Received: by 2002:a7b:c4c7:0:b0:3cf:d58f:f66e with SMTP id g7-20020a7bc4c7000000b003cfd58ff66emr1250008wmk.165.1668534851218;
        Tue, 15 Nov 2022 09:54:11 -0800 (PST)
Received: from ?IPV6:2003:cb:c707:9d00:9303:90ce:6dcb:2bc9? (p200300cbc7079d00930390ce6dcb2bc9.dip0.t-ipconnect.de. [2003:cb:c707:9d00:9303:90ce:6dcb:2bc9])
        by smtp.gmail.com with ESMTPSA id p14-20020a5d458e000000b0022eafed36ebsm12978003wrq.73.2022.11.15.09.54.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Nov 2022 09:54:10 -0800 (PST)
Message-ID: <2ed12722-2359-cb07-53e7-566d959d311e@redhat.com>
Date:   Tue, 15 Nov 2022 18:54:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v2 1/2] mm/migrate: Fix read-only page got writable when
 recover pte
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Ives van Hoorne <ives@codesandbox.io>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>, stable@vger.kernel.org
References: <20221110203132.1498183-1-peterx@redhat.com>
 <20221110203132.1498183-2-peterx@redhat.com>
 <9af36be3-313b-e39c-85bb-bf30011bccb8@redhat.com> <Y3KgYeMTdTM0FN5W@x1n>
 <ec8b3c86-d3b2-f898-7297-c20a58ae2ac1@redhat.com> <Y3O5bCXSbvKJrjRL@x1n>
 <82d7a142-8c78-4168-37e9-7b677b18987a@redhat.com>
Organization: Red Hat
In-Reply-To: <82d7a142-8c78-4168-37e9-7b677b18987a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.11.22 18:22, David Hildenbrand wrote:
>>> I consider UFFD-wp a special case: while the default VMA protection might
>>> state that it is writable, you actually want individual PTEs to be
>>> write-protected and have to manually remove the protection.
>>>
>>> softdirty tracking is another special case: however, softdirty tracking is
>>> enabled for the whole VMA. For remove_migration_pte() that should be fine (I
>>> guess) because writenotify is active when the VMA needs to track softdirty
>>> bits, and consequently vma->vm_page_prot has the proper default permissions.
>>>
>>>
>>> I wonder if the following (valid), for example is possible:
>>>
>>>
>>> 1) clear_refs() clears VM_SOFTDIRTY and pte_wrprotect() the pte.
>>> -> writenotify is active and vma->vm_page_prot updated accordingly
>>>
>>> VM_SOFTDIRTY is reset due to VMA merging and vma->vm_page_prot is updated
>>> accordingly. See mmap_region() where we set VM_SOFTDIRTY.
>>>
>>> If you now migrate the (still write-protected in the PTE) page, it was not
>>> writable, but it can be writable on the destination.
>>
>> I didn't even notice merging could work with soft-dirty enabled, that's
>> interesting to know.
>>
>> Yes I think it's possible and I agree it's safe, as VM_SOFTDIRTY is set for
>> the merged vma so afaiu the write bit is safe to set.  We get a bunch of
>> false positives but that's how soft-dirty works.
>>
>> I think the whole problem is easier if we see this at a higher level.
>> You're discussing this from vma pov and it's fair to do so, at least I
>> agree with what you mentioned so far and I can't see anything outside
>> uffd-wp that can be affected.  However, it is also true when you noticed we
>> already have quite a few paragraphs trying to discuss the safety for this
>> and that, that's the part where I think we need justification and it's not
>> that "natural".

Forgot to reply to that part:

No it isn't natural. But sneaking such a change into your fix seems 
wrong. Touching !uffd-wp code should be separate, if we want to do this 
at all (as we discussed, maybe the better/cleaner approach is to 
eliminate writable migration entries if possible).

-- 
Thanks,

David / dhildenb


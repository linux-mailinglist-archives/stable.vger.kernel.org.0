Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B85458DFD2
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 21:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345191AbiHITHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 15:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345877AbiHITGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 15:06:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 626E22AC55
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 11:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660070737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8IbhLYjobqT2aTBvz3U46stbRUAh6ZahUb2ByDCNf0A=;
        b=TNum+KWLYec3Di+h32/Isu0qH5SxlmanT4GbdNIxh3jmBA884JDTCtS5w9vjNYDwMHMmMI
        uoO28ARsiR+cLEhQcRJi/M6dfkWixFbMQPwPEOxGstNyrd4sl3+uBS8BqdAvdjKBkr6up2
        isY4LCfCaxaIvJuUKfg0dbRd9g0HP+M=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-oAyyqGkXNsarofsblMeWlQ-1; Tue, 09 Aug 2022 14:45:36 -0400
X-MC-Unique: oAyyqGkXNsarofsblMeWlQ-1
Received: by mail-wm1-f72.google.com with SMTP id v130-20020a1cac88000000b003a4f057ed9fso6362338wme.7
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 11:45:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=8IbhLYjobqT2aTBvz3U46stbRUAh6ZahUb2ByDCNf0A=;
        b=fBuuzNwatc7rSlKstA6A46lYvtp6JYbLVsvPfbekzgoTL7U+sp13txNnG/moGwQzdZ
         X9e55uYXaQ0B6Lw/nOlhaRmIWk90aP8fRK8NxFeSX3QwVOww6NYUMM3mtJCq8XZnPJaL
         +iiGRyIFy4tefK7iLRaLmWwP1F+jgLmp17DpznuxNfdUVPnZLhSYZsFyYny3Tzf2fpmg
         o/aWLowrXuoaAE2xr+FZFHrVxF43Kone2Vnam2+/PtnR9wLMdjNL22SqUoW4gKwQq3HI
         jGl0gCgr41XczgiAKny/LzPmghC7Q5/fv1DZ3hT5Vs24E/AUeaAl5KafLaP7V90KHiEt
         lFGQ==
X-Gm-Message-State: ACgBeo3nUaJrO10b68GGyjKky+nHOT7fE1dgB7L7s8q6hfIdMMFNVAOZ
        m5tf3ROBF8TdbA3SsqOwCOj4eYQ7Jthrad779RTUe2Jv51nyOHVTfkCIatOJCMp6Nfd+JeZ9Vof
        3aAWuC7V5ZLAm4zX1
X-Received: by 2002:a05:6000:1b88:b0:21f:eae8:d695 with SMTP id r8-20020a0560001b8800b0021feae8d695mr15071139wru.26.1660070735055;
        Tue, 09 Aug 2022 11:45:35 -0700 (PDT)
X-Google-Smtp-Source: AA6agR69MLCunWf5SVWzymZ3UNdd8BL3fDtH5qkRFmVvHOW7S1grl/vbJS0Sb54Gqln+3VynlhGkbA==
X-Received: by 2002:a05:6000:1b88:b0:21f:eae8:d695 with SMTP id r8-20020a0560001b8800b0021feae8d695mr15071118wru.26.1660070734738;
        Tue, 09 Aug 2022 11:45:34 -0700 (PDT)
Received: from ?IPV6:2003:cb:c705:3700:aed2:a0f8:c270:7f30? (p200300cbc7053700aed2a0f8c2707f30.dip0.t-ipconnect.de. [2003:cb:c705:3700:aed2:a0f8:c270:7f30])
        by smtp.gmail.com with ESMTPSA id i2-20020a05600c14c200b003a53ec3d847sm7225855wmh.29.2022.08.09.11.45.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 11:45:34 -0700 (PDT)
Message-ID: <1a48d71d-41ee-bf39-80d2-0102f4fe9ccb@redhat.com>
Date:   Tue, 9 Aug 2022 20:45:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
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
 <CAHk-=wiEAH+ojSpAgx_Ep=NKPWHU8AdO3V56BXcCsU97oYJ1EA@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v1] mm/gup: fix FOLL_FORCE COW security issue and remove
 FOLL_COW
In-Reply-To: <CAHk-=wiEAH+ojSpAgx_Ep=NKPWHU8AdO3V56BXcCsU97oYJ1EA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09.08.22 20:27, Linus Torvalds wrote:
> I'm still reading through this, but
> 
>  STOP DOING THIS
> 
> On Mon, Aug 8, 2022 at 12:32 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> +       VM_BUG_ON(!is_cow_mapping(vma->vm_flags));
> 
> Using BUG_ON() for debugging is simply not ok.
> 
> And saying "but it's just a VM_BUG_ON()" does not change *anything*.
> At least Fedora enables that unconditionally for normal people, it is
> not some kind of "only VM people do this".
> 
> Really. BUG_ON() IS NOT FOR DEBUGGING.

I totally agree with BUG_ON ... but if I get talked to in all-caps on a
Thursday evening and feel like I just touched the forbidden fruit, I
have to ask for details about VM_BUG_ON nowadays.

VM_BUG_ON is only active with CONFIG_DEBUG_VM. ... which indicated some
kind of debugging at least to me. I *know* that Fedora enables it and I
*know* that this will make Fedora crash.

I know why Fedora enables this debug option, but it somewhat destorys
the whole purpose of VM_BUG_ON kind of nowadays?

For this case, this condition will never trigger and I consider it much
more a hint to the reader that we can rest assured that this condition
holds. And on production systems, it will get optimized out.

Should we forbid any new usage of VM_BUG_ON just like we mostly do with
BUG_ON?

> 
> Stop it. Now.
> 
> If you have a condition that must not happen, you either write that
> condition into the code, or - if you are convinced it cannot happen -
> you make it a WARN_ON_ONCE() so that people can report it to you.

I can just turn that into a WARN_ON_ONCE() or even a VM_WARN_ON_ONCE().

-- 
Thanks,

David / dhildenb


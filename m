Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F50E58E144
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 22:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245677AbiHIUmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 16:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245467AbiHIUmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 16:42:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38DC321241
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 13:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660077731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ft7/3/k2/7AI7wRPnrTn6/PiafTIMMMl8iv+c+g4UYE=;
        b=IY3Wit7kTqhT8vEKCwrb0bLv7/Go35qyu7exwVof1F8D06EDYchjlLcFdZW/25GT+LSSq2
        +1ukq3Scl2cbLV49AWFXdDQxS42XKvbHXSnkC9OWnK0M43AhnJRN1RjelZ/P7hW5M3DCXr
        fMAl3KVIwChBYUYuv+6bB88LlfTXOuE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-YnJSvX-BNNO5pnki-61cBA-1; Tue, 09 Aug 2022 16:42:09 -0400
X-MC-Unique: YnJSvX-BNNO5pnki-61cBA-1
Received: by mail-wr1-f71.google.com with SMTP id t12-20020adfba4c000000b0021e7440666bso2023591wrg.22
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 13:42:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=Ft7/3/k2/7AI7wRPnrTn6/PiafTIMMMl8iv+c+g4UYE=;
        b=Exg8tYR8lKKY41NUvIp4WbszBqygohVnZH41n2VCqOpalwBKBxfyKZ9ZvmfciLUIFu
         UMPl3eX+g4D07sCJLL7w7RiXl+7VlOF+ob2qdNqUrSPBnwY+TSelDHLGdKGEscrFMk+k
         7NsMUAIRa7fx99971dptQpzKdOocQY9ShVa2MWJrVqlefq1jxLiQ56ZwbJKiaROCop+Y
         csvYj6md817oAjPmU4sLlOXx6np1zcXmHLD1bRXBqG3x94Irf+2paoypmlXfmW2bBx69
         eQA4b9Fu/dJM6MrDGs2v4QPIahR1VwVMV7dlmgnP7sM+LQHzspca72ppS9j9A/fPK27X
         5puQ==
X-Gm-Message-State: ACgBeo23fn7/0NNaQtkal8aa/DZAZjeVOT46WKlq0GT8hdqi3OCFdX7s
        zZ/Ip5J6WDEJ8MyNy1awEUtinah5nyeWez64tJiC4a3kpIKXwgDUSse+CTjTkuI2Z+6UnX4Pisa
        GvFWgjfD48KlLaO5D
X-Received: by 2002:a05:6000:1f0e:b0:221:6d6f:5c7e with SMTP id bv14-20020a0560001f0e00b002216d6f5c7emr13477460wrb.256.1660077727993;
        Tue, 09 Aug 2022 13:42:07 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4iIiC6hStqy3Z4Hjcgi0BBwQ7RRcz3zdqmXKR+jrTcF24Ep9h2BTpKi9m93Ywx/SPxAehwzQ==
X-Received: by 2002:a05:6000:1f0e:b0:221:6d6f:5c7e with SMTP id bv14-20020a0560001f0e00b002216d6f5c7emr13477446wrb.256.1660077727693;
        Tue, 09 Aug 2022 13:42:07 -0700 (PDT)
Received: from ?IPV6:2003:cb:c705:3700:aed2:a0f8:c270:7f30? (p200300cbc7053700aed2a0f8c2707f30.dip0.t-ipconnect.de. [2003:cb:c705:3700:aed2:a0f8:c270:7f30])
        by smtp.gmail.com with ESMTPSA id r27-20020adfa15b000000b0021d70a871cbsm14650710wrr.32.2022.08.09.13.42.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 13:42:07 -0700 (PDT)
Message-ID: <13f149cc-6535-8b50-04de-70437a679826@redhat.com>
Date:   Tue, 9 Aug 2022 22:42:06 +0200
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
 <c096cc82-60b4-9e75-06ad-156461292941@redhat.com>
 <CAHk-=wh1q7ZSWhDWOyqmVawqjq55sUVkn8ASjE_b2VOcE1vFaA@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <CAHk-=wh1q7ZSWhDWOyqmVawqjq55sUVkn8ASjE_b2VOcE1vFaA@mail.gmail.com>
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

On 09.08.22 22:30, Linus Torvalds wrote:
> On Tue, Aug 9, 2022 at 1:20 PM David Hildenbrand <david@redhat.com> wrote:
>>
>> IIUC VM_MAYSHARE is always set in a MAP_SHARED mapping, but for file
>> mappings we only set VM_SHARED if the file allows for writes
> 
> Heh.
> 
> This is a horrific hack, and probably should go away.
> 
> Yeah, we have that
> 
>                         if (!(file->f_mode & FMODE_WRITE))
>                                 vm_flags &= ~(VM_MAYWRITE | VM_SHARED);
> 
> 
> but I think that's _entirely_ historical.
> 
> Long long ago, in a galaxy far away, we didn't handle shared mmap()
> very well. In fact, we used to not handle it at all.
> 
> But nntpd would use write() to update the spool file, adn them read it
> through a shared mmap.
> 
> And since our mmap() *was* coherent with people doing write() system
> calls, but didn't handle actual dirty shared mmap, what Linux used to
> do was to just say "Oh, you want a read-only shared file mmap? I can
> do that - I'll just downgrade it to a read-only _private_ mapping, and
> it actually ends up with the same semantics".
> 
> And here we are, 30 years later, and it still does that, but it leaves
> the VM_MAYSHARE flag so that /proc/<pid>/maps can show that it's a
> shared mapping.

I was suspecting that this code is full of legacy :)

What would make sense to me is to just have VM_SHARED and make it
correspond to MAP_SHARED, that would at least confuse me less. Once I
have some spare cycles I'll see how easy that might be to achieve.

-- 
Thanks,

David / dhildenb


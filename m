Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A35427800
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 09:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhJIIBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 04:01:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58404 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229642AbhJIIBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Oct 2021 04:01:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633766379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6u97Dq8sBwCpsJ9hCCZ7sWpY+KYop/TEoR6sgGmHBpM=;
        b=MSuj093E6UA83vgYAi4czAfq4l5hK6eRZwQgQ2B27vmNIu3KYN5XRMlLOfHvAyC5mRpqIM
        u9Bz4j9XHhqEX9KDTJMw5MFRSPkK4dQXqyHMbn2cgwRZxAby832MfRg+0V9Zvp5truJEEt
        5g0owePnH+Hvrc/PwEk+oDv0bQyEOqg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-OX3DtVHsOO-agxqmFo-mZA-1; Sat, 09 Oct 2021 03:59:38 -0400
X-MC-Unique: OX3DtVHsOO-agxqmFo-mZA-1
Received: by mail-wr1-f69.google.com with SMTP id d13-20020adf9b8d000000b00160a94c235aso9038923wrc.2
        for <stable@vger.kernel.org>; Sat, 09 Oct 2021 00:59:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=6u97Dq8sBwCpsJ9hCCZ7sWpY+KYop/TEoR6sgGmHBpM=;
        b=oz18DWOne7aNfixK91TzP9gfbDGymXXPrh89Kb0Qu5v/g/atnGNfdYWM97SXE8JOCS
         pyPXMJsQGlaN3xzbDkoNZMKRbuAbwPoV1FuUmvnYCxTH2hUJctW2k6T/I+YIY2S8+qj9
         M16cTZsoLZoi5jDbHKxxwrPjam6ATTf+eUQYxjIbpkcxZU9L4hQSxL5k8g/sasAGR3OD
         uxbkVTameN+qJeGmqBkun8Mrot9w2QnLeabwQYfhRjK71dQR9Y1Fi+ODcwc2GGW/8JLI
         8SNG1V5vcMUAqvVotmZPKEZimWNQ4WakjsJVLcHdqJrAq2v2Vzi24RzS+/zYSxJ6hv+5
         WiGA==
X-Gm-Message-State: AOAM533SA3EPCC98M0VWHJhn2dGqIE3YkShe0QsbacSRv9aLe2R7HVYM
        RAeXa7CaYSg6tgAQOLUZGJ0QhszSdd5s7OHsNOKBZvZw5FUhSPGyQbPXKhQKpSn76Un7cqTdIa+
        qcjizxlUzIiCZOnLu6h0dh/5C93F9UcBJqcOcN5Ut51BypQN+NEqYtvpZQCVk7RG9
X-Received: by 2002:adf:bb52:: with SMTP id x18mr9791308wrg.169.1633766376893;
        Sat, 09 Oct 2021 00:59:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAd1IVbqSYiVzuYLGs0k5bi+qenL3GHYvxiDEdNaXFITlkCF1NELfCH3kViXWbkhF9QA52vg==
X-Received: by 2002:adf:bb52:: with SMTP id x18mr9791283wrg.169.1633766376585;
        Sat, 09 Oct 2021 00:59:36 -0700 (PDT)
Received: from [192.168.3.132] (p4ff236d4.dip0.t-ipconnect.de. [79.242.54.212])
        by smtp.gmail.com with ESMTPSA id k10sm1473294wrh.64.2021.10.09.00.59.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Oct 2021 00:59:36 -0700 (PDT)
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
References: <20211007235055.469587-1-namit@vmware.com>
 <d5a244e9-a04e-8794-e55f-380db5e8c6c4@redhat.com>
 <E2ADE3F0-74B1-4D1D-80AE-0BBC49D932E6@gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH] mm/userfaultfd: provide unmasked address on page-fault
Message-ID: <f5ea62e1-cf21-6bd8-37f8-1a0f9637402c@redhat.com>
Date:   Sat, 9 Oct 2021 09:59:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <E2ADE3F0-74B1-4D1D-80AE-0BBC49D932E6@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09.10.21 00:02, Nadav Amit wrote:
> 
> 
>> On Oct 8, 2021, at 1:05 AM, David Hildenbrand <david@redhat.com> wrote:
>>
>> On 08.10.21 01:50, Nadav Amit wrote:
>>> From: Nadav Amit <namit@vmware.com>
>>> Userfaultfd is supposed to provide the full address (i.e., unmasked) of
>>> the faulting access back to userspace. However, that is not the case for
>>> quite some time.
>>> Even running "userfaultfd_demo" from the userfaultfd man page provides
>>> the wrong output (and contradicts the man page). Notice that
>>> "UFFD_EVENT_PAGEFAULT event" shows the masked address.
>>> 	Address returned by mmap() = 0x7fc5e30b3000
>>> 	fault_handler_thread():
>>> 	    poll() returns: nready = 1; POLLIN = 1; POLLERR = 0
>>> 	    UFFD_EVENT_PAGEFAULT event: flags = 0; address = 7fc5e30b3000
>>> 		(uffdio_copy.copy returned 4096)
>>> 	Read address 0x7fc5e30b300f in main(): A
>>> 	Read address 0x7fc5e30b340f in main(): A
>>> 	Read address 0x7fc5e30b380f in main(): A
>>> 	Read address 0x7fc5e30b3c0f in main(): A
>>> Add a new "real_address" field to vmf to hold the unmasked address. It
>>> is possible to keep the unmasked address in the existing address field
>>> (and mask whenever necessary) instead, but this is likely to cause
>>> backporting problems of this patch.
>>
>> Can we be sure that no existing users will rely on this behavior that has been the case since end of 2016 IIRC, one year after UFFD was upstreamed?
> 
> Let me to blow off your mind: how do you be sure that the current behavior does not make applications to misbehave? It might cause performance issues as it did for me or hidden correctness issues.
> 

Fair point, but now we can speculate what's more likely:

Having an app rely on >4 year old kernel behavior just after the feature 
was released or having and app rely on kernel behavior that was the case 
for the last 4 years?

<offtopic>
Someone once told me about the unwritten way to remove things from the 
kernel. 1) Silently break it upstream 2) Wait 2 kernel releases 3) 
Propose removal of the feature because it's broken and nobody complained.
<\offtopic>

You might ask "why does David even care?", here is why:

For the records, I *do* have a prototype from last year that breaks with 
this new behavior as far as I can tell: using uffd in the context of 
virtio-balloon in QEMU. I just pushed the latest state to a !private 
github tree:
   https://github.com/davidhildenbrand/qemu/tree/virtio-balloon-uffd


In that code, I made sure that I'm only dealing with 4k pages (because 
that's the only thing virtio-balloon really can deal with), and during 
the debugging I figured that the kernel always returns 4k aligned page 
fault addresses, so I didn't care about masking. I'll reuse the 
unmodified fault address for UFFDIO_ZEROPAGE()/UFFDIO_COPY()/... which 
should then fail because:

"
EINVAL The start or the len field of the ufdio_range structure
               was not a multiple of the system page size; or len was
               zero; or the specified range was otherwise invalid.
"


If I'm too lazy to read all documentation, I'm quite sure that there are 
other people that don't. I don't care to much if this patch breaks that 
prototype, it's just a prototype after all, but I am concerned that we 
might break other users in a similar way.

>> I do wonder what the official ABI nowadays is, because man pages aren't necessarily the source of truth.
> 
> Documentation/admin-guide/mm/userfaultfd.rst says: "You get the address of the access that triggered the missing page
> event”.
> 
> So it is a bug.

The least thing I would expect in the patch description is a better 
motivation ("who cares and why" -- I know you have a better motivation 
that making the doc correct :) ) and a discussion on the chances of this 
actually breaking other apps (see my example).

I'd sleep better if we'd glue the changed behavior to a new feature 
flag, but that's just my 2 cents.

-- 
Thanks,

David / dhildenb


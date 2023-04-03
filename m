Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEFE6D3E67
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 09:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbjDCHt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 03:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbjDCHtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 03:49:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248781FDC
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 00:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680508117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gg+D4CsPnhSBX6Ep/vVZ03qpNvjb7Nx0ShML5od8/7w=;
        b=dpK8+CCEYMOjVW1FKWdtH4lgkac6A33uwEw0dVCcVp2gKueB/eJery2K5qYv8fdetpO9RK
        Hxa2GD11D65BEVqiDawXGT7hk1xR4yY1MF/qKT3Mt16DN/8ZtKxFs226tiokXB8JXX7tze
        KGw1lP6Gqoem56PWJg7BlxqDc0rxEmc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-230-xzA9UF_gP_C0f7RkVDzWNw-1; Mon, 03 Apr 2023 03:48:34 -0400
X-MC-Unique: xzA9UF_gP_C0f7RkVDzWNw-1
Received: by mail-wm1-f69.google.com with SMTP id r11-20020a05600c458b00b003eea8d25f06so14327178wmo.1
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 00:48:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680508113;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gg+D4CsPnhSBX6Ep/vVZ03qpNvjb7Nx0ShML5od8/7w=;
        b=UNbNkO6N69QIE6S8GT2gqUg5Vcm5cvVB0B67MiyJ5ZwPgxoiHKFdJpzL4L8RR2wqjq
         KheVAtMxyFmlGmGUI6kZQqJvLlBcyP5lJ3nN28vopVVSvFjPhQZu8m/UlQL3xkiM9La1
         jlArxTCqbUkZO72RBHbH1+LWDCOon00sYFeDfOvpWsgMZVe8NxHrKmIwc60dVaWARxfx
         HTco6WjkeX1bE/qcAWdVLnSEKTtf7TyuDUVDAC7lpcd7gwzYSUGp13KX808V6/u1dukP
         AvqPZu2tiBU8v851xkieQkE7J9kguU02aqjfUFOCJFYcbF2QrIMZjfaVnBS7/AMgNX5C
         LERw==
X-Gm-Message-State: AO0yUKXYD/a3p5ZUCjpoguSrxcW/J0vrT5praOEJqmfnS4RL4ljC+JAG
        7lDyCP58LLXFWFAcb1aKrq6UkAswktYMuC5uW6ZpO49WCi/EJV36n5crSKikBFrL/d83BXy4lnJ
        vZXUSAcq9FdpG7899
X-Received: by 2002:a05:600c:2043:b0:3ee:4678:dde with SMTP id p3-20020a05600c204300b003ee46780ddemr26761749wmg.27.1680508113587;
        Mon, 03 Apr 2023 00:48:33 -0700 (PDT)
X-Google-Smtp-Source: AK7set+hIQJPk9AeYQ1jOGL8hezQ5AK7xpXic1LUhQyAL2YtCFuergW3icXKd9hRk2LAG4cOh0BRKQ==
X-Received: by 2002:a05:600c:2043:b0:3ee:4678:dde with SMTP id p3-20020a05600c204300b003ee46780ddemr26761730wmg.27.1680508113216;
        Mon, 03 Apr 2023 00:48:33 -0700 (PDT)
Received: from ?IPV6:2003:cb:c702:5e00:8e78:71f3:6243:77f0? (p200300cbc7025e008e7871f3624377f0.dip0.t-ipconnect.de. [2003:cb:c702:5e00:8e78:71f3:6243:77f0])
        by smtp.gmail.com with ESMTPSA id q13-20020a7bce8d000000b003ef71d541cbsm11216347wmj.1.2023.04.03.00.48.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 00:48:32 -0700 (PDT)
Message-ID: <cf4595d5-8b6c-efee-a721-c908bb3e3a5d@redhat.com>
Date:   Mon, 3 Apr 2023 09:48:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 01/29] Revert "userfaultfd: don't fail on unrecognized
 features"
Content-Language: en-US
To:     Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Leonardo Bras Soares Passos <lsoaresp@redhat.com>,
        linux-stable <stable@vger.kernel.org>
References: <20230330155707.3106228-1-peterx@redhat.com>
 <20230330155707.3106228-2-peterx@redhat.com>
 <CAJHvVcgDZBi6pH0BD12sQ3T+7Kr9exX1QU3-YLTd1voYhVBN0w@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <CAJHvVcgDZBi6pH0BD12sQ3T+7Kr9exX1QU3-YLTd1voYhVBN0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30.03.23 21:04, Axel Rasmussen wrote:
> On Thu, Mar 30, 2023 at 8:57 AM Peter Xu <peterx@redhat.com> wrote:
>>
>> This is a proposal to revert commit 914eedcb9ba0ff53c33808.
>>
>> I found this when writting a simple UFFDIO_API test to be the first unit
>> test in this set.  Two things breaks with the commit:
>>
>>    - UFFDIO_API check was lost and missing.  According to man page, the
>>    kernel should reject ioctl(UFFDIO_API) if uffdio_api.api != 0xaa.  This
>>    check is needed if the api version will be extended in the future, or
>>    user app won't be able to identify which is a new kernel.
> 
> 100% agreed, this was a mistake.
> 
>>
>>    - Feature flags checks were removed, which means UFFDIO_API with a
>>    feature that does not exist will also succeed.  According to the man
>>    page, we should (and it makes sense) to reject ioctl(UFFDIO_API) if
>>    unknown features passed in.
> 
> I still strongly disagree with reverting this part, my feeling is
> still that doing so makes things more complicated for no reason.
> 
> Re: David's point, it's clearly wrong to change semantics so a thing
> that used to work now fails. But this instead makes it more permissive
> - existing userspace programs continue to work as-is, but *also* one
> can achieve the same thing more simply (combine probing +
> configuration into one step). I don't see any problem with that,
> generally.
> 
> But, if David and others don't find my argument convincing, it isn't
> the end of the world. It just means I have to go update my userspace
> code to be a bit more complicated. :)


I'd probably find it more convincing if we'd started out with that 
approach ;) . User space would have to deal with the behavior of old 
kernels either way already? IOW, old kernels would reject the new flags, 
new kernels would not reject them but mask them out. So changing that 
behavior after the effects is somewhat suboptimal IMHO ... and rather 
makes things more complicated.

-- 
Thanks,

David / dhildenb


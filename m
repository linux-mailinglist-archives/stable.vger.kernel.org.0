Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A17F58DFE6
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 21:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344975AbiHITHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 15:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348393AbiHITGu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 15:06:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0E0E9286EA
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 11:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660071185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5MxbEkPFfHnhv9lIG9SKrVYa+3yd5Ii2mgv7KMCMiKA=;
        b=MwVPwrnkbAFEUC9IAx+zOQqkmwQfCd6a7ltEHWCNbPk67eHZPR1jwf7uDDEwWZB/eJon8s
        3qycWranGQzYZcaupPw1qLifh2lQ2Osl1GA2nNHQoAenDGtHeci32O0E2GVvoLxtpCRubP
        AHLKWXkzo5ngpzYg7O9qxK0agRfxhsk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-aE5-sZ7-NvGs976kUkDCqw-1; Tue, 09 Aug 2022 14:53:03 -0400
X-MC-Unique: aE5-sZ7-NvGs976kUkDCqw-1
Received: by mail-wr1-f72.google.com with SMTP id c20-20020adfa314000000b0021f1757ea8aso1982638wrb.2
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 11:53:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=5MxbEkPFfHnhv9lIG9SKrVYa+3yd5Ii2mgv7KMCMiKA=;
        b=cdrnAH35Q96Yv54iUR2z3Lm4qrPGDgyPn6XXv22XxTntO8ZBrDmNI5JkguTgrD4xFC
         WN+ysRw/xQEG7q5AY9myvejq2wZZqc06zX122ASSOkvmhBfi3jbqZim8UBtVlcaUMeQF
         vBi09M+AlK1H2gPdhOHTvinsyfearsjSXt94JgDPUpg1DcTyMRbfHthyBxpJd8OTACCi
         8X0yHFDMUCagkgA7YnOYFPi9xPzNcfH2KU7WLJ7tPDRKZ//NKkQQ5l1bu7E665uDzt9t
         cktzUSqlbTKWEssw9/iKgw7eY0OIkmZfmf0de3eAN01h5Mt5d7zqZoQtW2vZn9iG4k2R
         HhQQ==
X-Gm-Message-State: ACgBeo2maX09+kuZMsoZnm0807zKfnAG9MWSR5e+akEO7snNBL4shQVH
        kimoVzsFUL7h0ZwSe4e1J2vFmvzMnlf2ydrwJ8puvusFoBzsCyjakDYakQrs7DJQL/qgdtywf7S
        WK7ymxYODxLoq440a
X-Received: by 2002:a05:6000:15c5:b0:220:727a:24bf with SMTP id y5-20020a05600015c500b00220727a24bfmr15682593wry.621.1660071182503;
        Tue, 09 Aug 2022 11:53:02 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7B1MwvtmEN6yaB1m5uxgVV9LrfTrVuas1WczTE6dxZ7xo83OW/ncC8YwQvF+UDacFqG6b94g==
X-Received: by 2002:a05:6000:15c5:b0:220:727a:24bf with SMTP id y5-20020a05600015c500b00220727a24bfmr15682577wry.621.1660071182244;
        Tue, 09 Aug 2022 11:53:02 -0700 (PDT)
Received: from ?IPV6:2003:cb:c705:3700:aed2:a0f8:c270:7f30? (p200300cbc7053700aed2a0f8c2707f30.dip0.t-ipconnect.de. [2003:cb:c705:3700:aed2:a0f8:c270:7f30])
        by smtp.gmail.com with ESMTPSA id o4-20020a056000010400b0021e501519d3sm14070439wrx.67.2022.08.09.11.53.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 11:53:01 -0700 (PDT)
Message-ID: <d8765f51-c6f6-1d21-82ba-877515acf17d@redhat.com>
Date:   Tue, 9 Aug 2022 20:53:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1] mm/gup: fix FOLL_FORCE COW security issue and remove
 FOLL_COW
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>
References: <20220808073232.8808-1-david@redhat.com>
 <CAHk-=wi81ujYGP0gmyy2kDke_ExL742Lo_hLepGjCa8mS81A7w@mail.gmail.com>
 <YvKsBUuwLNlHwhnE@nvidia.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <YvKsBUuwLNlHwhnE@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09.08.22 20:48, Jason Gunthorpe wrote:
> On Tue, Aug 09, 2022 at 11:40:50AM -0700, Linus Torvalds wrote:
>> On Mon, Aug 8, 2022 at 12:32 AM David Hildenbrand <david@redhat.com> wrote:
>>>
>>> For example, a write() via /proc/self/mem to a uffd-wp-protected range has
>>> to fail instead of silently granting write access and bypassing the
>>> userspace fault handler. Note that FOLL_FORCE is not only used for debug
>>> access, but also triggered by applications without debug intentions, for
>>> example, when pinning pages via RDMA.
>>
>> So this made me go "Whaa?"
>>
>> I didn't even realize that the media drivers and rdma used FOLL_FORCE.
>>
>> That's just completely bogus.
>>
>> Why do they do that?
>>
>> It seems to be completely bogus, and seems to have no actual valid
>> reason for it. Looking through the history, it goes back to the
>> original code submission in 2006, and doesn't have a mention of why.
> 
> It is because of all this madness with COW.
> 
> Lets say an app does:
> 
>  buf = mmap(MAP_PRIVATE)
>  rdma_pin_for_read(buf)
>  buf[0] = 1 
> 
> Then the store to buf[0] will COW the page and the pin will become
> decoherent.
> 
> The purpose of the FORCE is to force COW to happen early so this is
> avoided.
> 
> Sadly there are real apps that end up working this way, eg because
> they are using buffer in .data or something.
> 
> I've hoped David's new work on this provided some kind of path to a
> proper solution, as the need is very similar to all the other places
> where we need to ensure there is no possiblity of future COW.
> 
> So, these usage can be interpreted as a FOLL flag we don't have - some
> kind of (FOLL_EXCLUSIVE | FOLL_READ) to match the PG_anon_exclusive
> sort of idea.

Thanks Jason for the explanation.

I have patches in the works to no longer use FOLL_FORCE|FOLL_WRITE for
taking a reliable longerterm R/O pin in a MAP_PRIVATE mapping. The
patches are mostly done (and comparably simple), I merely deferred
sending them out because I stumbled over this issue first.

Some ugly corner cases of MAP_SHARED remain, but for most prominent use
cases, my upcoming patches should allow us to just have longterm R/O
pins working as expected.

-- 
Thanks,

David / dhildenb


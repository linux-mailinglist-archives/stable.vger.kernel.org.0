Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD8D658E018
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 21:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245408AbiHITVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 15:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346488AbiHITU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 15:20:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 495AF29A
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 12:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660072846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H8h4Jng7BDnvUHW4yaisoTMe84LTGwEUPKezp1k3H30=;
        b=J0kGOSKXC3bYfAiCQnGXAybxgW0RoKD4wECnKh1Y4qT7E7HY/yf8+uGohOAhCZYjNhVQ+g
        HSs5D7esNxJIp4Bp++PIL9YVCz9qF4KgPu+N3u0ecqqA1dh/6HxnJ2hbPSFVyKqHEm3+3O
        61LIAuLfsvkMkAreNxG1NOchDO2q1ws=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-o1XuWq0VM7yACX5wMGE_Bw-1; Tue, 09 Aug 2022 15:20:45 -0400
X-MC-Unique: o1XuWq0VM7yACX5wMGE_Bw-1
Received: by mail-wm1-f71.google.com with SMTP id a17-20020a05600c349100b003a545125f6eso2997380wmq.4
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 12:20:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=H8h4Jng7BDnvUHW4yaisoTMe84LTGwEUPKezp1k3H30=;
        b=06j2WfLe5/gj5qUbyRK3jYQlPYm4LM9Efy51zEo7m4+UIMEo1Tzao0vtKSIyWd5QHL
         6DUjN4isgylkWsoDHioKinNwM/R0aXFzNMKdNaGBmJ3a506YfJq9MAhqkaTUEp3OJhEN
         KiliNhu8HhFlL8tAlCbIWo/2BbgJxpIXhPrhjT89NyQc0uQLA6Dm8Iwfd1bFVRlpZHqz
         5qmRmX6dqEBAteGx9rF9QKiqxs/OAs9Kq+wBMIXnwKYP+IMHTZ1woLCnzP49fuXXSrfC
         nVvNY64upFTkz2vyXK4vBJocelxTEIAprMPL4OPVh4grpoQiHEQGWXhVw4ZjYD81AjFq
         xIFg==
X-Gm-Message-State: ACgBeo0L7Jsxzo0kP8Lijy1EizpsyHZPAjnIfelYQViSAym8ifgAizCR
        92ZAz+pRIprenqr+qWh4KbDrY1hxV15X/yK+zmpsW9r7QybA9dhOSi9W65kOYeDpYmsjrUg4hmL
        pMUj8sQp/pQgJ4p1D
X-Received: by 2002:a1c:ed05:0:b0:3a2:ebae:c5e7 with SMTP id l5-20020a1ced05000000b003a2ebaec5e7mr15510wmh.78.1660072844097;
        Tue, 09 Aug 2022 12:20:44 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4LubkX0tuGA9aKXvqxL9u6Pg1ZLUrPaG3+BlBR8O2coLYRUWNXjx9DEti7PhyhEHYDH5631w==
X-Received: by 2002:a1c:ed05:0:b0:3a2:ebae:c5e7 with SMTP id l5-20020a1ced05000000b003a2ebaec5e7mr15496wmh.78.1660072843868;
        Tue, 09 Aug 2022 12:20:43 -0700 (PDT)
Received: from ?IPV6:2003:cb:c705:3700:aed2:a0f8:c270:7f30? (p200300cbc7053700aed2a0f8c2707f30.dip0.t-ipconnect.de. [2003:cb:c705:3700:aed2:a0f8:c270:7f30])
        by smtp.gmail.com with ESMTPSA id q25-20020a1ce919000000b003a32251c3f0sm17052196wmc.33.2022.08.09.12.20.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 12:20:43 -0700 (PDT)
Message-ID: <5593cbb7-eb29-82f0-490e-dd72ceafff9b@redhat.com>
Date:   Tue, 9 Aug 2022 21:20:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>
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
 <CAHk-=wjh3wkhQWN8BHFUT6t52kfNMcRd+1JczD4Sgp_q11w8eA@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v1] mm/gup: fix FOLL_FORCE COW security issue and remove
 FOLL_COW
In-Reply-To: <CAHk-=wjh3wkhQWN8BHFUT6t52kfNMcRd+1JczD4Sgp_q11w8eA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09.08.22 21:07, Linus Torvalds wrote:
> On Tue, Aug 9, 2022 at 11:48 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>>
>> It is because of all this madness with COW.
> 
> Yes, yes, but we have the proper long-term pinning now with
> PG_anon_exclusive, and it actually gets the pinning right not just
> over COW, but even over a fork - which that early write never did.
> 
> David, I thought all of that got properly merged? Is there something
> still missing?

The only thing to get R/O longterm pins in MAP_PRIVATE correct that's
missing is that we have to break COW when taking a R/O longterm pin when
*not* finding an anon page inside a private mapping. Regarding anon
pages I am not aware of issues (due to PG_anon_exclusive).

If anybody here wants to stare at a webpage, the following commit
explains the rough idea for MAP_PRIVATE:

https://github.com/davidhildenbrand/linux/commit/cd7989fb76d2513c86f01e6f7a74415eee5d3150

Once we have that in place, we can mostly get rid of
FOLL_FORCE|FOLL_WRITE for R/O longterm pins. There are some corner cases
though that need some additional thought which i am still working on.
FS-handled COW in MAP_SHARED mappings is just nasty (hello DAX).

(the wrong use of FOLL_GET instead of FOLL_PIN for O_DIRECT and friends
still persists, but that's a different thing to handle and it's only
problematic with concurrent fork() IIRC)

-- 
Thanks,

David / dhildenb


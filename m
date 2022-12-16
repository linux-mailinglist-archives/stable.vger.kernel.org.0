Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF13564EE57
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 16:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbiLPP7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 10:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbiLPP6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 10:58:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F201146
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 07:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671206263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6dLsRoolqx1zZhtmb36YfFuBLbtpT274h3r2aL8GL4k=;
        b=Gi98tnxYfVhe9t8XeWwMdKqfM/uOm3B6mRskY2pJfqI2WqxX/6K/bK4jVIqpLhuy8eekQ0
        VH7tXDzjm5YP+rtMvthQQDDTGMYcx4vH6Zq4JuuU7ip1OQEgG5D2ek2qb6SzxVjonFvlGA
        E0XelD39ySvO9P6s5UrodiVXnZVHccE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-120-3Ej8ltyfMnCA8xGbROLi5g-1; Fri, 16 Dec 2022 10:57:37 -0500
X-MC-Unique: 3Ej8ltyfMnCA8xGbROLi5g-1
Received: by mail-wm1-f70.google.com with SMTP id m38-20020a05600c3b2600b003d1fc5f1f80so2739872wms.1
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 07:57:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :content-language:references:cc:to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6dLsRoolqx1zZhtmb36YfFuBLbtpT274h3r2aL8GL4k=;
        b=lBuzhsfA0Bs2eRF9d7PuoUkT1DcjUk7amYZVUMRejCT8+PTEjKe0IGPfS/eLTPlQ+H
         lOU8k8IZHXzXwZw0QokIIlwKjp7fjg/jor6lQVWkgMx6FeiMbRZ0EXkzAPV5PDQzB97f
         jfkpCe8B+ZSkha3CDEievZypybzUkQQZKQZ+5aP8djMixxLfDmoFk9eP6x8TRuLwdD0M
         IuF/egN4zyuTighx6CMoem8jhQ30jv71ksm9rzDjktOh/CzJ9Efn7Lf6HSxJ8mJqiPM0
         eZ9Xa7krqhYPZ15z3MZqOdyBsqXdeYOYbCntA0EDd+U0HiWMCfJuNKKDZja0LbcVDYTV
         j+iA==
X-Gm-Message-State: ANoB5plaVuis0SqDTDuLY1oSeHNMb7nbt9bsC+L9qMx6pXLLuTkmB5Ub
        PJPVCa0hsSiPzxo8sjkxap6tPM/3+OarLj/aj4QcmSuF3DFFNrT0/fo2R+nJddYgM7h198iWPcN
        UxcTorBR6ql4Bx0tr
X-Received: by 2002:a05:600c:3549:b0:3c6:e61e:ae8c with SMTP id i9-20020a05600c354900b003c6e61eae8cmr35405997wmq.28.1671206256116;
        Fri, 16 Dec 2022 07:57:36 -0800 (PST)
X-Google-Smtp-Source: AA0mqf64C2aBB45GXwS++QO6Sr3F4ze8EYUjLXrts0880Hw6xU+tVgHq4xUPJI4/W644ZIm86uv0JQ==
X-Received: by 2002:a05:600c:3549:b0:3c6:e61e:ae8c with SMTP id i9-20020a05600c354900b003c6e61eae8cmr35405979wmq.28.1671206255823;
        Fri, 16 Dec 2022 07:57:35 -0800 (PST)
Received: from [192.168.3.108] (p4ff23686.dip0.t-ipconnect.de. [79.242.54.134])
        by smtp.gmail.com with ESMTPSA id 8-20020a05600c028800b003c6d21a19a0sm2868815wmk.29.2022.12.16.07.57.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 07:57:35 -0800 (PST)
Message-ID: <8c36dd0a-90be-91bf-0ded-55b34ee0a770@redhat.com>
Date:   Fri, 16 Dec 2022 16:57:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Pengfei Xu <pengfei.xu@intel.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Huang Ying <ying.huang@intel.com>, stable@vger.kernel.org
References: <20221214200453.1772655-1-peterx@redhat.com>
 <20221214200453.1772655-2-peterx@redhat.com>
 <618b69be-0e99-e35f-04b3-9c63d78ece50@redhat.com> <Y5yGp6ToQD+eYrv/@x1n>
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH 1/2] mm/uffd: Fix pte marker when fork() without fork
 event
In-Reply-To: <Y5yGp6ToQD+eYrv/@x1n>
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

>>
>> Wouldn't it be cleaner to be able to "clean" specific markers from a PTE
>> marker without having to special case on each and everyone? I mean, only
>> uffd-wp is really special such that it might disappear for the target.
> 
> Quotting the commit message in patch 2:
> 
>    Currently there is a priority difference between the uffd-wp bit and the
>    swapin error entry, in which the swapin error always has higher priority
>    (e.g. we don't need to wr-protect a swapin error pte marker).
> 
>    If there will be a 3rd bit introduced, we'll probably need to consider a
>    more involved approach so we may need to start operate on the bits.
>    Let's leave that for later.
> 
> I actually started the fix with something like that, but I noticed it's not
> needed to add more code if there's no 3rd bit introduced so I dropped that.
> I decided to go the simpler change approach and leave that for later.

Okay, makes sense.

> 
>>
>> Something like (pseudocode):
>>
>> if (!userfaultfd_wp(dst_vma))
>> 	pte_marker_clear_uff_wp(entry);
>> if (!pte_marker_empty(entry)) {
>> 	pte = make_pte_marker(pte_marker_get(entry));
>> 	set_pte_at(dst_mm, addr, dst_pte, pte);
>> }
>>
>> Then this fix would be correct and backport-able even without #2. And it
>> would work for new types of markers :)
> 
> When that comes, we may need one set_pte_marker_at() taking care of empty
> pte markers, otherwise there can be a lot of such check.

Right. In the future it might be cleaner.

> 
>>
>>
>> I'd prefer a fix that doesn't break something else temporarily, even if the
>> stable backport might require 5 additional minutes to do. So squashing #2
>> into #1 would also work.
> 
> The thing is whether do we care about someone: (1) explicitly checkout at
> the commit of patch 1, then (2) runs the kernel, hit a swapnin error, (3)
> fork(), and (4) access the swapin error page in the child.

I'm more concerned about backports, when one backports #1 but not #2. In 
theory, patch #2 fixes patch #1, because that introduced IMHO a real 
regression -- a possible memory corruption when discarding a hwpoison 
marker. Warnings are not nice but at least indicate that something needs 
a second look.

> 
> To me I don't care even starting from (1).. because it really shouldn't
> happen at all in any serious environment.
> 
> The other reason is these are indeed two issues to solve.  Even if by
> accident we kept the swapin error in old code we'll probably dump an
> warning which is not wanted either.  It's not something someone will really
> get benefit from..
> 
> So like many other places, I don't have a strong opinion, but personally I
> prefer the current approach.


Me neither, two patches just felt more complicated than it should be.

Anyhow, the final code change LGTM.

-- 
Thanks,

David / dhildenb


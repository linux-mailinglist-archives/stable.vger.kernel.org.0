Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6F76D3E1D
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 09:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbjDCHaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 03:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbjDCHau (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 03:30:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3DA810E9
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 00:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680507002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nWUExWagVX656w1EVGsZGTKDtHF/b0n+CImW2plVgjs=;
        b=IfohvKsSqX7rPbhJY1UXqsax8nxQcvWY+u9oIEMiTBx7JdyMTgj4xRIe2byt/9kknH+u5n
        UgnOOsthwqQ8U5t9/TOIcOtPvubmIYhvHsno+FXARTyiGwBKtxAOtL3Eo7t//f3XrR6JG/
        +3hSWxGtPBWhn4LheA0hI5KBx909/ps=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-shZZWMHNNFyxVMdkuDp9ag-1; Mon, 03 Apr 2023 03:30:00 -0400
X-MC-Unique: shZZWMHNNFyxVMdkuDp9ag-1
Received: by mail-wr1-f72.google.com with SMTP id b14-20020a05600003ce00b002cfefd8e637so2997963wrg.15
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 00:30:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680507000;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nWUExWagVX656w1EVGsZGTKDtHF/b0n+CImW2plVgjs=;
        b=0xQRk3FZwjh+xptiGgEwW3Z1wjcYqskoXwOPx6NRb4ecMcI/bQ1PaW1lAVWGp2Cn+m
         SylUTnJxkcwn5B7iyK+aLTIhFG3yinr+yzrkvPEv26ynVbS57mKGCV0nKktPxbj44cRf
         918k8sQuvPBCsZH2wPqgURHCzpYw8cW6FJG7I7Ut0XtADvbMJszpRUaVP6nOb2mtnwFv
         3M0H2TEwC4YkzChUvoKJGO8gxrJ6mUq3Q5HqR5m9V7AaVjZ6+2wMHr+74Xol756I4D/8
         IHWx2cILh9e1AgOROB1N+sXs/ckFMSV37FJStOouY6FzpMMIpGRhc5QX5mojcQHyG6Ri
         5d/Q==
X-Gm-Message-State: AO0yUKUv0JiDC9imwdiUGPhZxleFx0XL2QkQjp3WVVYJNwqtUhUyGn3N
        G083fQUv5A3y6nCYfJfK55kvtKP7bk3pZeeH+chskmukZvX9HABhSRuOX7G2A1mc9PSCHW7LeSh
        N4xTTLFJJJ6XaIcXx
X-Received: by 2002:a1c:4b09:0:b0:3ed:1f9c:af12 with SMTP id y9-20020a1c4b09000000b003ed1f9caf12mr27138310wma.22.1680506999869;
        Mon, 03 Apr 2023 00:29:59 -0700 (PDT)
X-Google-Smtp-Source: AK7set/3IMtRpZ1SJxXyUz7jYIt+isjmplQwS+1rFMbpAePhy6wNg4p18ZoFNBqFDo8+tUpWAUBYsg==
X-Received: by 2002:a1c:4b09:0:b0:3ed:1f9c:af12 with SMTP id y9-20020a1c4b09000000b003ed1f9caf12mr27138297wma.22.1680506999575;
        Mon, 03 Apr 2023 00:29:59 -0700 (PDT)
Received: from ?IPV6:2003:cb:c702:5e00:8e78:71f3:6243:77f0? (p200300cbc7025e008e7871f3624377f0.dip0.t-ipconnect.de. [2003:cb:c702:5e00:8e78:71f3:6243:77f0])
        by smtp.gmail.com with ESMTPSA id i22-20020a05600c355600b003ede6540190sm18727435wmq.0.2023.04.03.00.29.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 00:29:58 -0700 (PDT)
Message-ID: <5618f454-7a88-0443-59e7-df9780e9fa50@redhat.com>
Date:   Mon, 3 Apr 2023 09:29:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [v4 PATCH] fs/proc: task_mmu.c: don't read mapcount for migration
 entry
Content-Language: en-US
To:     Yang Shi <shy828301@gmail.com>, Vlastimil Babka <vbabka@suse.cz>
Cc:     kirill.shutemov@linux.intel.com, jannh@google.com,
        willy@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220203182641.824731-1-shy828301@gmail.com>
 <132ba4a4-3b1d-329d-1db4-f102eea2fd08@suse.cz>
 <9ba70a5e-4e12-0e9f-a6a4-d955bf25d0fe@redhat.com>
 <64ec7939-0733-7925-0ec0-d333e62c5f21@suse.cz>
 <CAHbLzkoZctsJf92Lw3wKMuSqT7-aje0SiAjc6JVW5Z3bNS1JNg@mail.gmail.com>
 <efab25ef-c29c-3671-5f26-060bba76d481@suse.cz>
 <CAHbLzkomXCwabFrNaNyuGBozmindHqVD0ki4n75XJ2V8Uw=9rw@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <CAHbLzkomXCwabFrNaNyuGBozmindHqVD0ki4n75XJ2V8Uw=9rw@mail.gmail.com>
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

On 24.03.23 21:12, Yang Shi wrote:
> On Fri, Mar 24, 2023 at 4:25 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> On 3/23/23 21:45, Yang Shi wrote:
>>> On Thu, Mar 23, 2023 at 3:11 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>>
>>> Out of curiosity, is there any public link for this CVE? Google search
>>> can't find it.
>>
>> Only this one is live so far, AFAIK
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=2180936
> 
> Thank you.

There is now

https://access.redhat.com/security/cve/cve-2023-1582

-- 
Thanks,

David / dhildenb


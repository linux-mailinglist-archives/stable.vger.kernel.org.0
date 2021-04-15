Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF08361074
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 18:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhDOQxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 12:53:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45286 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232759AbhDOQxd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 12:53:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618505589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mOZmiQsPM2z8JFg2yCo7YvOl2YlV7mTl6vjBKTI8sno=;
        b=HhtQwKvyhgXCxUw07JqyJo+wylupGJ16gKmp5reR1I105IxuELvccysFpBW+jTfcXi7rl1
        rgqD6/S/k9TDUSdyv3ktDqdpOIdpoRBS/RnCBresriPLGnlVZQBWP++Rr30FiYuhTPCOUv
        SWRvtBvNAvyvblFvenDqfKmk8zQ2PNE=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-6iwxPYD0PaSz-LMSZVhDjA-1; Thu, 15 Apr 2021 12:53:08 -0400
X-MC-Unique: 6iwxPYD0PaSz-LMSZVhDjA-1
Received: by mail-qk1-f198.google.com with SMTP id c9so1919946qkm.11
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 09:53:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=mOZmiQsPM2z8JFg2yCo7YvOl2YlV7mTl6vjBKTI8sno=;
        b=O+y6XNC1AsdVhSaE3qIxvtStNCQ+wAoO0fDzEDRiKQkvVK5SJcNqm+0yrf3Sk1heI1
         EoIycyvHexKkvoPhN+nefdKO5oW6i9pFI8+zb9kHB+5hqpg975n5E3lO0xg9cASXHlDc
         zMocKY2rx9VamABVW+dydWcEeszjOcjjgd2nF3ZIlWRv3olPETFJJ26JoS9CaB56B57j
         Sgd29pBFdgBlenP0u3TKQ840gk1QMvGI+XcHS0dcVm83RWv+oJL8yGxPZxE/MkHaU8A6
         8Q0n7CbDF3GZkXye5apIOfiAvnFkydLHNC9l23MLYoz/N+s9XCswAgTveYoG6nz9p32z
         ubEQ==
X-Gm-Message-State: AOAM532pMtdB1+BzO2xhoGILJDU1thqUTtJUcuGn+U7pfr4zrZ8n+CBM
        KzPJvID6rR+X2cacyxgImhf7VL3zuJyd8gcKO2C9zgqQqqkNsiDwMIqPmLRvdXXG+xkO9pX6xYl
        LoCWf1jjj8Vn21mjc
X-Received: by 2002:ae9:eb8a:: with SMTP id b132mr4255232qkg.296.1618505587821;
        Thu, 15 Apr 2021 09:53:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrDSSW59HtlgLMvEXKM92wd1+sNACdsKWQFt9qD/GAPiFXLioBFNt+Mx3E93UmMiShqhM9ug==
X-Received: by 2002:ae9:eb8a:: with SMTP id b132mr4255216qkg.296.1618505587640;
        Thu, 15 Apr 2021 09:53:07 -0700 (PDT)
Received: from llong.remote.csb ([2601:191:8500:76c0::cdbc])
        by smtp.gmail.com with ESMTPSA id i5sm2356913qka.126.2021.04.15.09.53.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 09:53:07 -0700 (PDT)
From:   Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] locking/qrwlock: Fix ordering in
 queued_write_lock_slowpath
To:     Will Deacon <will@kernel.org>, Ali Saidi <alisaidi@amazon.com>
Cc:     benh@kernel.crashing.org, boqun.feng@gmail.com,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, peterz@infradead.org, stable@vger.kernel.org,
        steve.capper@arm.com
References: <20210415150228.GA26439@willie-the-truck>
 <20210415162646.9882-1-alisaidi@amazon.com>
 <20210415164525.GC26594@willie-the-truck>
Message-ID: <c288c94a-a545-492a-79c1-3d741c001504@redhat.com>
Date:   Thu, 15 Apr 2021 12:53:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210415164525.GC26594@willie-the-truck>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/15/21 12:45 PM, Will Deacon wrote:
>
>>> With that in mind, it would probably be a good idea to eyeball the qspinlock
>>> slowpath as well, as that uses both atomic_cond_read_acquire() and
>>> atomic_try_cmpxchg_relaxed().
>> It seems plausible that the same thing could occur here in qspinlock:
>>            if ((val & _Q_TAIL_MASK) == tail) {
>>                    if (atomic_try_cmpxchg_relaxed(&lock->val, &val, _Q_LOCKED_VAL))
>>                            goto release; /* No contention */
>>            }
> Just been thinking about this, but I don't see an issue here because
> everybody is queuing the same way (i.e. we don't have a mechanism to jump
> the queue like we do for qrwlock) and the tail portion of the lock word
> isn't susceptible to ABA. That is, once we're at the head of the queue
> and we've seen the lock become unlocked via atomic_cond_read_acquire(),
> then we know we hold it.
>
> So qspinlock looks fine to me, but I'd obviously value anybody else's
> opinion on that.

I agree with your assessment of qspinlock. I think qspinlock is fine.

Cheers,
Longman


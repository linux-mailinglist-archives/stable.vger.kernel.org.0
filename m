Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830504538F0
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 18:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239203AbhKPR6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 12:58:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52749 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239188AbhKPR6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 12:58:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637085323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kuOkTmnmzpEcWTaBUi8Ivg0rAjuxlq5HIO8I27HgTWE=;
        b=eUU93m+0zwNoDwunWjmnrlFNGJxxCwS17NIoeRhdSKTEca5UKSR4HVZ9Xro2FSl4Ql0x9C
        h37CtHNDz76FWaczbrr5rjDq5WqaESVS3zgaG2qv0TK8rvusd5g7TZkmtD/w7oOt320VUR
        ChCDcBTrtpSORuAcC5MBxmVw9uTIaTo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-cdZrgpfMMvaygJcB_XCkUw-1; Tue, 16 Nov 2021 12:55:20 -0500
X-MC-Unique: cdZrgpfMMvaygJcB_XCkUw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4D068042E6;
        Tue, 16 Nov 2021 17:55:17 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D4205D9DE;
        Tue, 16 Nov 2021 17:55:14 +0000 (UTC)
Message-ID: <31ab6220-b8e8-5a5d-494a-b1bad7eff818@redhat.com>
Date:   Tue, 16 Nov 2021 18:55:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/1] KVM: x86/mmu: Fix TLB flush range when handling
 disconnected pt
Content-Language: en-US
To:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>, stable@vger.kernel.org
References: <20211115211704.2621644-1-bgardon@google.com>
 <YZL1ZiKQVRQd8rZi@google.com>
 <CANgfPd-UQKbnkoKGS0yoQvTtMAyPc0Xa2=o7ics2vQ50-KGQHA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CANgfPd-UQKbnkoKGS0yoQvTtMAyPc0Xa2=o7ics2vQ50-KGQHA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/16/21 18:29, Ben Gardon wrote:
>> TL;DR: this type of optional refactoring doesn't belong in a patch Cc'd for stable,
>> and my personal preference is to always declare variables at function scope (it's
>> not a hard rule though, Paolo has overruled me at least once:-)  ).
>
> That makes sense. I don't have a preference either way. Paolo, if you
> want the version without the refactor, the version I sent in the RFC
> should be good. If the refactor is desired, I can separate it out into
> another patch and send a v2 of this patch as a mini series, tagging
> only the fix for stable.

It's really a damned-if-you-do/damned-if-you-don't situation.  And also 
keeping the patch as similar as possible in stable has the advantage 
that future backports have a slightly lower chance of breaking due to 
shadowed variables.

In the end I agree with both of you :) and in this case I tend to accept 
the patch as written.  So I queued it, though it probably will not be in 
the immediately next pull request.

My plan for the next couple days is to send a pull request and finally 
move the development tree to 5.16-rc1, so that I can push to kvm/next 
all the SVM, memslot and xarray stuff that's pending.  Then I'll go back 
to this one.

Paolo

> I've generally preferred declaring variables at function scope too
> since that seems like the overwhelming convention, but it's always
> struck me as a bit of a waste to not make use of scoping rules more.
> It does make it nice and clear how things should be laid out when
> debugging the kernel with GDB or something though.
> 
> In any case, please let me know how you'd like the changes organized
> and I can send up follow ups as needed, or we can just move forward
> with the RFC version.
> 


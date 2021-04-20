Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE50365D39
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 18:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbhDTQZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 12:25:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55859 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232473AbhDTQZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 12:25:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618935898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iLcG5OyaNHku0PtrgN264QDcVOjTc4dbGZJwd4rN2TU=;
        b=iETUMNKhhxfGZVk5/iLxd88xa8d+HwmvMHzZYNZT6VHYYi/NlvwLlB6rYh4rm/dAOKFb57
        H5RGrL4U38CGY5uDHR7/zMH3byM7gBx+89tKhIi/2sr37Vox0DYo0FLChCuTOuyzK8fWBz
        WPMdDrUezLvI+wNPFFFso8c3/9CTAww=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-ogwJkK-ZMXCHdXqTZwjLKw-1; Tue, 20 Apr 2021 12:24:55 -0400
X-MC-Unique: ogwJkK-ZMXCHdXqTZwjLKw-1
Received: by mail-ed1-f72.google.com with SMTP id c15-20020a056402100fb029038518e5afc5so5875944edu.18
        for <stable@vger.kernel.org>; Tue, 20 Apr 2021 09:24:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iLcG5OyaNHku0PtrgN264QDcVOjTc4dbGZJwd4rN2TU=;
        b=IC5db2pgqFZmhb+JnoKGFuJ2hRxBezRIXS0WzH71g/lUkcQiXznL3PDNG26MJFKec6
         DZVD3DPK3GtVguKeajqkC6GB9QyCTgy2G1uOq4u3fyOUmbJleTCsjSUZFFkwx2bWdjTp
         V8/fi3vsv8CFsdtg8CXk+9lfrMV7ChXNgV7XwJl6uiCK9wIeSymnheBn1FRLdgDZG1JO
         4umfzqrJ0B5TwuWbntkbpH/4cuH3rQfVvrIGFOmpGVL+Ly+pfPw+K4BNPz5OhuuUJZGI
         ikUQe0ONyXyv6ai1Ixl6cyqcL/4GublVu89tjnGqSQIZQlc/0WUMb835A48Jq9BDoEpU
         d1DQ==
X-Gm-Message-State: AOAM5301A3+wZGrkq7drHUyoBAz1KM/aG1LHFUYVIDoaT7Y0F2HnOFgZ
        2rXQ2pgKP+JM5FichOQYHceIHvpP70Toixqs4jiemcqkxZB/4lpDoIhWepBcB2OknXVEk7bN955
        0sKIfT1Z3DlGspT/NHhjS9I4WL19KAEhxDcEfDy3HE3ulRE87i6zjB48bNb1MKpKIQWTB
X-Received: by 2002:a17:906:34da:: with SMTP id h26mr27944401ejb.496.1618935893469;
        Tue, 20 Apr 2021 09:24:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJws1XKsATYiny/fBfVmMA+efwU+NuFd8mA4iIaBE90k/UA9tkXxnm8FYavk2EfJmE9m/sgjwg==
X-Received: by 2002:a17:906:34da:: with SMTP id h26mr27944372ejb.496.1618935893207;
        Tue, 20 Apr 2021 09:24:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id b22sm16228566edv.96.2021.04.20.09.24.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 09:24:52 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: Always run vCPU thread with blocked
 SIG_IPI
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
References: <20210420081614.684787-1-pbonzini@redhat.com>
 <20210420143739.GA4440@xz-x1> <20210420153223.GB4440@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <84c52ebe-58a2-6188-270e-c86409e44fa3@redhat.com>
Date:   Tue, 20 Apr 2021 18:24:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210420153223.GB4440@xz-x1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20/04/21 17:32, Peter Xu wrote:
> On Tue, Apr 20, 2021 at 10:37:39AM -0400, Peter Xu wrote:
>> On Tue, Apr 20, 2021 at 04:16:14AM -0400, Paolo Bonzini wrote:
>>> The main thread could start to send SIG_IPI at any time, even before signal
>>> blocked on vcpu thread.  Therefore, start the vcpu thread with the signal
>>> blocked.
>>>
>>> Without this patch, on very busy cores the dirty_log_test could fail directly
>>> on receiving a SIGUSR1 without a handler (when vcpu runs far slower than main).
>>>
>>> Reported-by: Peter Xu <peterx@redhat.com>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>
>> Yes, indeed better! :)
>>
>> Reviewed-by: Peter Xu <peterx@redhat.com>
> 
> I just remembered one thing: this will avoid program quits, but still we'll get
> the signal missing.

In what sense the signal will be missing?  As long as the thread exists, 
the signal will be accepted (but not delivered because it is blocked); 
it will then be delivered on the first KVM_RUN.

Paolo

   From that pov I slightly prefer the old patch.  However
> not a big deal so far as only dirty ring uses SIG_IPI, so there's always ring
> full which will just delay the kick. It's just we need to remember this when we
> extend IPI to non-dirty-ring tests as the kick is prone to be lost then.
> 
> Thanks,
> 


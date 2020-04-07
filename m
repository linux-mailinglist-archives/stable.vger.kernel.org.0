Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D45941A17AE
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 00:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgDGWEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 18:04:47 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25475 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726483AbgDGWEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 18:04:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586297086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xrH2lLfAiq23v5Jxv+IpDhUxu2udMFmlhuyHKnLXEqg=;
        b=Ty2m+DFz7lUNx5rs1/BO9KlFnCh2z6B1VSRHYD2XqW8e2O2sPdH7CiJZHYG82HCqa/zjW4
        bd12/5JtpE0g83uxR/SZqxq1fu9/XKX/PnWUuVs+RUaUUATN2P+VbceFQATk4Y0IfoblaX
        zem0GB1E2vCxa0XZptRKCxj+yGJZwNQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-7CY0RLM1N7eYBWZbXk3txg-1; Tue, 07 Apr 2020 18:04:43 -0400
X-MC-Unique: 7CY0RLM1N7eYBWZbXk3txg-1
Received: by mail-wm1-f72.google.com with SMTP id s22so1712025wmh.8
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 15:04:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xrH2lLfAiq23v5Jxv+IpDhUxu2udMFmlhuyHKnLXEqg=;
        b=C3UP8JK3wg/0wQUMqZyrTDu8ijgd3XujxcE0Pa0AuQvULQZ1W4ymZHVZ4Ww1Q0pHkv
         lCmnJ74uVJz6v7hwLjUdh91/aBmZ6ChnS9z5DG6FCcdKXyCKWa191mQxC/cOYBtwqJX8
         mOamSpQPlIKL9Iq1k/Nj6Rhsor8E+bGiCfUk8wLKvahLVsqNlzJIYT6cnGEKj9L6l/nj
         WsLZ0zkbvPKKZetgdI3Cn3X+3vBgV1xvrsdRLA/aiEzYLi538h08dqhPvVONtlFqdjEI
         aOXjoxrwvQ9vRhP4GY8hzd1B185Qvwp+goSU4r3eoXWEslDrzw3zR8RnwLSKMQYKW28E
         mVFA==
X-Gm-Message-State: AGi0PuYcwuKph+e78wx1ccJ1JTKZCFpFtYIwiCagU2YAM8ZqFA/ulNja
        d7i0uopimppRuW75Fy+6gsmcBjfnGCG/4UWyX8+i6frGBe6PbtkfAZXvPavlvworjekqXeM+gbo
        jEFWAktb9zKcUW/XI
X-Received: by 2002:adf:8b5c:: with SMTP id v28mr4563549wra.98.1586297082517;
        Tue, 07 Apr 2020 15:04:42 -0700 (PDT)
X-Google-Smtp-Source: APiQypLGbUTjfdz6MpZ4qxUe2T9cFiSjdOrwlcJVFzepk8Hol5dhGGIbKBsCKOQCM8Zck3xQ0lCQsQ==
X-Received: by 2002:adf:8b5c:: with SMTP id v28mr4563476wra.98.1586297081368;
        Tue, 07 Apr 2020 15:04:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:bd61:914:5c2f:2580? ([2001:b07:6468:f312:bd61:914:5c2f:2580])
        by smtp.gmail.com with ESMTPSA id t17sm28293907wrv.53.2020.04.07.15.04.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 15:04:40 -0700 (PDT)
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Vivek Goyal <vgoyal@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
References: <20200407172140.GB64635@redhat.com>
 <772A564B-3268-49F4-9AEA-CDA648F6131F@amacapital.net>
 <87eeszjbe6.fsf@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ce81c95f-8674-4012-f307-8f32d0e386c2@redhat.com>
Date:   Wed, 8 Apr 2020 00:04:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87eeszjbe6.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/04/20 22:20, Thomas Gleixner wrote:
>>> Havind said that, I thought disabling interrupts does not mask exceptions.
>>> So page fault exception should have been delivered even with interrupts
>>> disabled. Is that correct? May be there was no vm exit/entry during
>>> those 10 seconds and that's why.
> No. Async PF is not a real exception. It has interrupt semantics and it
> can only be injected when the guest has interrupts enabled. It's bad
> design.

Page-ready async PF has interrupt semantics.

Page-not-present async PF however does not have interrupt semantics, it
has to be injected immediately or not at all (falling back to host page
fault in the latter case).  So page-not-present async PF definitely
needs to be an exception, this is independent of whether it can be
injected when IF=0.

Hypervisors do not have any reserved exception vector, and must use
vectors up to 31, which is why I believe #PF was used in the first place
(though that predates my involvement in KVM by a few years).  These
days, #VE would be a much better exception to use instead (and it also
has a defined mechanism to avoid reentrancy).

Paolo


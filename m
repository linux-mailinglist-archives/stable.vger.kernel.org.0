Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3109A4259BD
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 19:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242054AbhJGRtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 13:49:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30283 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233133AbhJGRtl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 13:49:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633628867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zMIgq/shF4zYaj1gUby36uqdLSqQ0DPEM64q06xf0oM=;
        b=cH5XmbRCH4z+kSEX4xI0iOYPSHCferRJkVLv2s9VWnG+xmtBWsXaR2sQBi4yDPvHWfC+RG
        yXfzE4MmkAJb9hIlBPUKSxv1Z3BtZXLf/mXAxe7PxnqHjlySoBM8Z6dVAJ4fNf1xdpgBb0
        ewC/znNaYdllJmJMN3G4t4RRGXmfmIg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-FTtndf7RMBuE4YSU8e1Zkg-1; Thu, 07 Oct 2021 13:47:45 -0400
X-MC-Unique: FTtndf7RMBuE4YSU8e1Zkg-1
Received: by mail-wr1-f69.google.com with SMTP id v15-20020adfa1cf000000b00160940b17a2so5299229wrv.19
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 10:47:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zMIgq/shF4zYaj1gUby36uqdLSqQ0DPEM64q06xf0oM=;
        b=ZSt6ecLD8GOr1Td1REr7kImn1MvoJYNllKvBELOsnfHSIecegNZvYGJRBF/WaQLUzK
         igahLKWKctBrYuNezXCpJH/Rzjx+iJvx8X9lZ6+BrwXOhRhVsCY0PA7iCt/atxy0578q
         XB9p1EIbqFhmS7BPLaMNGMNv55l/RIzmPfpu4UgGj13qY5VSUmwiM6gsIdo6J+HT2g6A
         DcJoZQ3VWCXudogpY0VMC8oiJVjRJgYxhss8rfhbqo9wcUsku10fAAH4oFdp0Mg+NSX9
         boZlcYnl3vYEfRIsKXbEqIby0/yr8RzNE3llQP6yr00co4ffXe1UU0QYQ3LwJ2Z8ChXa
         WpDA==
X-Gm-Message-State: AOAM5339T43ERwf2lyVM124KXjUCCsEDTrXcksPhHkPI4A7oTxsfHL+G
        E0lASw5wjGn2ES7fIsRUPbmOLHG6pBN2EFd7kpPLPin7zmlpq6j47H7OiOXpuCLYUXDMloP0/Hj
        Lio895Bko6GufH73Y
X-Received: by 2002:adf:97d0:: with SMTP id t16mr6921550wrb.124.1633628864695;
        Thu, 07 Oct 2021 10:47:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVQLk62OBdz/FxDWWdF4DHH5+h/b3zennVSvs4B8TXw3JIJsMFZYSDdaYmn9xuR8+I3uSEKA==
X-Received: by 2002:adf:97d0:: with SMTP id t16mr6921533wrb.124.1633628864451;
        Thu, 07 Oct 2021 10:47:44 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h18sm84173wmq.23.2021.10.07.10.47.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 10:47:43 -0700 (PDT)
Message-ID: <81bfc7de-2b9e-f210-0073-b31535d7b302@redhat.com>
Date:   Thu, 7 Oct 2021 19:47:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH MANUALSEL 5.14 4/9] KVM: x86: reset pdptrs_from_userspace
 when exiting smm
Content-Language: en-US
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>
References: <20211006133021.271905-1-sashal@kernel.org>
 <20211006133021.271905-4-sashal@kernel.org>
 <e5b8a6d4-6d5c-ada9-bb36-7ed3c8b7d637@redhat.com>
 <CA+G9fYt6J2UTgC8Ths11xHefj6qYOqS0JMfSMoHYwvMy3NzxWQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CA+G9fYt6J2UTgC8Ths11xHefj6qYOqS0JMfSMoHYwvMy3NzxWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/10/21 17:23, Naresh Kamboju wrote:
> Is this expected to be in stable-rc 5.10 and below ?
> Because it is breaking the builds on queue/5.10, queue/5.4 and older branches.
> 
> arch/x86/kvm/x86.c: In function 'kvm_smm_changed':
> arch/x86/kvm/x86.c:6612:27: error: 'struct kvm_vcpu_arch' has no
> member named 'pdptrs_from_userspace'
>   6612 |                 vcpu->arch.pdptrs_from_userspace = false;
>        |                           ^
> make[3]: *** [scripts/Makefile.build:262: arch/x86/kvm/x86.o] Error 1

No, it was added in 5.14.

Paolo


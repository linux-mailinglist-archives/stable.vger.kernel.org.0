Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A2935DE6E
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 14:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238768AbhDMMPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 08:15:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236988AbhDMMPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 08:15:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618316117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aqf0RiZSoAYfI4s0e2+ZgKSiJco7N8Kba8wSDbcvYCc=;
        b=TMWLLvIIl04hagtpe6OblGypZQSvWNHooOkG3g/GA6Af1MWHl1a5j+0kzosu/DQFbwuJ1p
        GYrh8FYbdjdZpXsN+l+NKpN1gq3keBaiyM/UfHXcYmADLJZDkC1h5iqPxQ2KtqgrIlS2Yi
        9kCUuK73WUyKFOLqz2WLinu9g5OGGGE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-lY-rq-9KM2mLGA7SyGj-CA-1; Tue, 13 Apr 2021 08:15:15 -0400
X-MC-Unique: lY-rq-9KM2mLGA7SyGj-CA-1
Received: by mail-ed1-f72.google.com with SMTP id l9-20020a0564021249b02903827849a98dso1150544edw.6
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 05:15:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aqf0RiZSoAYfI4s0e2+ZgKSiJco7N8Kba8wSDbcvYCc=;
        b=Ku47mlknLFKrh4psyCmuCz9qiARurOz+ZHj/582sitMTQO/9a1FvM1bHKSgzinLnf/
         M5LULa/vsuHvryS1FrTJfDmHKeyKkhQeQhyzSzs9OLDSECFQcmhIL4RDp3iYNgVM3KGf
         RIZmY1sxJItBsZVuRTIRohPKtXIbobH1thrBd2d3VilZjI7qHLnapJ14s1XLl8Lo4m2a
         9/kQMIxVfdSACVpxZgaXAbBB+gaSIP4WCRrU51yMXE5t7azKFqGCrhfJgEijMaMLLnVw
         tNtL0RzXt0LugoqUEGR7v0rGaNXTCyZ/IU+FUytdY/7UN4YitrQJWjg7w0BFeZxPPphw
         v9Iw==
X-Gm-Message-State: AOAM531vRUqRzZ4W3R8whvGRyN66yZgHmdpe+Jj95Y0XbKo/Cm9MG2Jn
        PutBlryGCUF+9zBKq4rNp8V+8vloRRJW/u1Jy6ZM1sbNbwqXH3iRi5d3S1zqG4xMMbGah+LO0i4
        E/2FY4ULVQ/fL6qxJ
X-Received: by 2002:a17:906:3549:: with SMTP id s9mr9309564eja.327.1618316114728;
        Tue, 13 Apr 2021 05:15:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJye3ZXpM2j4/xA1ZsYOu2bEOUbV5nlWPoAJCBVywHcjFdlmDPmkeyBoZhrkjlFGbk70xZ8uSA==
X-Received: by 2002:a17:906:3549:: with SMTP id s9mr9309548eja.327.1618316114534;
        Tue, 13 Apr 2021 05:15:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j6sm9057849edw.73.2021.04.13.05.15.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 05:15:13 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: x86: Fix split-irqchip vs interrupt injection
 window request
To:     Lai Jiangshan <jiangshanlai+lkml@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Filippo Sironi <sironi@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "v4.7+" <stable@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
References: <20201127112114.3219360-1-pbonzini@redhat.com>
 <20201127112114.3219360-3-pbonzini@redhat.com>
 <CAJhGHyCdqgtvK98_KieG-8MUfg1Jghd+H99q+FkgL0ZuqnvuAw@mail.gmail.com>
 <YHS/BxMiO6I1VOEY@google.com>
 <CAJhGHyAcnwkCfTcnxXcgAHnF=wPbH2EDp7H+e74ce+oNOWJ=_Q@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <80b013dc-0078-76f4-1299-3cff261ef7d8@redhat.com>
Date:   Tue, 13 Apr 2021 14:15:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAJhGHyAcnwkCfTcnxXcgAHnF=wPbH2EDp7H+e74ce+oNOWJ=_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13/04/21 13:03, Lai Jiangshan wrote:
> This patch claims that it has a place to
> stash the IRQ when EFLAGS.IF=0, but inject_pending_event() seams to ignore
> EFLAGS.IF and queues the IRQ to the guest directly in the first branch
> of using "kvm_x86_ops.set_irq(vcpu)".

This is only true for pure-userspace irqchip.  For split-irqchip, in 
which case the "place to stash" the interrupt is 
vcpu->arch.pending_external_vector.

For pure-userspace irqchip, KVM_INTERRUPT only cares about being able to 
stash the interrupt in vcpu->arch.interrupt.injected.  It is indeed 
wrong for userspace to call KVM_INTERRUPT if the vCPU is not ready for 
interrupt injection, but KVM_INTERRUPT does not return an error.

Ignoring the fact that this would be incorrect use of the API, are you 
saying that the incorrect injection was not possible before this patch?

Paolo


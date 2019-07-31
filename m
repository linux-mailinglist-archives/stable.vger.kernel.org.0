Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 462C67C257
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 14:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbfGaMzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 08:55:36 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33884 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfGaMzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 08:55:36 -0400
Received: by mail-wr1-f68.google.com with SMTP id 31so69599096wrm.1
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 05:55:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=inYUgJMClSBxeCZ5ua9oZG9WtRjGPUuf4CzpS2AwxKs=;
        b=SkiwF9zX0UJoVoQMK818x5lR4tja+BkNwdTAG4z4EQ2tfQSNdITmSlc0pmPtrALdyk
         DS56ArlqeLjS7LHKiX7/R/zxF5xRGzpxuiwsFYVinoFcRwS2xiyhILwY7Pi91Qdgc3ss
         E6GCgj7VnklLzRPhoCFDLSbCSpUujrJRm2Ri225vGCbIU2CIos0jjlNnzfZZBhT4fqzU
         NcSmY2AXE0u3eZSHpZMqcDFQ8iS9CZYqt1Y86uYLI784KT++bXJviT9W5S+9E7nxriui
         fccvE/8fXSLxuWtZ4+VfBk00P7vwg3f6ZtxEIfwEQjvrKZweOvUu0/wdzNRrlXkN1Gv3
         BJkA==
X-Gm-Message-State: APjAAAVUmr4sPybY2yjuXu6ACDfVAIIK/nPlRABgRv8zJum96sArPi9c
        t+1wPE5fyWG6t2QUdtrxTA6hsA==
X-Google-Smtp-Source: APXvYqwCf62ldPWvGGU8UmKgsxpBKfaLCnTreng8h5G6SJLRotAe/VLh/nJpN/VFHHc3WzbeLtqcGA==
X-Received: by 2002:a05:6000:118a:: with SMTP id g10mr18463602wrx.175.1564577734089;
        Wed, 31 Jul 2019 05:55:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91e7:65e:d8cd:fdb3? ([2001:b07:6468:f312:91e7:65e:d8cd:fdb3])
        by smtp.gmail.com with ESMTPSA id g19sm128484284wrb.52.2019.07.31.05.55.33
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 05:55:33 -0700 (PDT)
Subject: Re: [PATCH v2 3/3] KVM: Fix leak vCPU's VMCS value into other pCPU
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        stable@vger.kernel.org, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
References: <1564572438-15518-3-git-send-email-wanpengli@tencent.com>
 <1564573198-16219-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9240ada8-8e18-d2b2-006e-41ededb89efb@redhat.com>
Date:   Wed, 31 Jul 2019 14:55:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1564573198-16219-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31/07/19 13:39, Wanpeng Li wrote:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ed061d8..12f2c91 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2506,7 +2506,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
>  				continue;
>  			if (vcpu == me)
>  				continue;
> -			if (swait_active(&vcpu->wq) && !kvm_arch_vcpu_runnable(vcpu))
> +			if (READ_ONCE(vcpu->preempted) && swait_active(&vcpu->wq))
>  				continue;
>  			if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
>  				!kvm_arch_vcpu_in_kernel(vcpu))
> 

This cannot work.  swait_active means you are waiting, so you cannot be
involuntarily preempted.

The problem here is simply that kvm_vcpu_has_events is being called
without holding the lock.  So kvm_arch_vcpu_runnable is okay, it's the
implementation that's wrong.

Just rename the existing function to just vcpu_runnable and make a new
arch callback kvm_arch_dy_runnable.   kvm_arch_dy_runnable can be
conservative and only returns true for a subset of events, in particular
for x86 it can check:

- vcpu->arch.pv.pv_unhalted

- KVM_REQ_NMI or KVM_REQ_SMI or KVM_REQ_EVENT

- PIR.ON if APICv is set

Ultimately, all variables accessed in kvm_arch_dy_runnable should be
accessed with READ_ONCE or atomic_read.

And for all architectures, kvm_vcpu_on_spin should check
list_empty_careful(&vcpu->async_pf.done)

It's okay if your patch renames the function in non-x86 architectures,
leaving the fix to maintainers.  So, let's CC Marc and Christian since
ARM and s390 have pretty complex kvm_arch_vcpu_runnable as well.

Paolo

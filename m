Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8B3804B3
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 08:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfHCGg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 02:36:29 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40489 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfHCGg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Aug 2019 02:36:28 -0400
Received: by mail-wr1-f66.google.com with SMTP id r1so79267301wrl.7
        for <stable@vger.kernel.org>; Fri, 02 Aug 2019 23:36:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CxBS9dU0c4bmMBQFrGHmBgCL8Xa1VLsfjnTYVWRb6Mo=;
        b=dqoh5jytszscMKeFyuT1WAPm+M8K+IjDh7c2q+SxciQTDb6hLkrHpbm6sDgekEFcYt
         +C4JW5PcWrmwvjIJIaHbT26xCg5OawSVUMN0Dc8nyzUWU0uBJCX+PiVapnK3zPTOVCW6
         /4CYlaEdPZR79JvlfGH/M3dJg2aHlEa8KlPzRrPRVrKJkc2RNDznjzSnHo22/CMJn1QH
         VFejW3cWx2QwH3BxNyTuSWvQ5hmobNFajPXL6s0kQ4nMmAop29LZPU4M2KSqcoYz8xna
         9XfdZWMR7ptX93ggMIz3Is9jESZC6PEahzp1NxVuBMaMCQj4DY8f73KcBQXlD+T8ED0E
         Ox5A==
X-Gm-Message-State: APjAAAWamvPGHHzBf4kgxDedUYvuUwP3RQkIw6ur/rQnZzugQQ9ziNYk
        rLSl8ja7LaIGN9EVG/Uk4bhtEo6h8gA=
X-Google-Smtp-Source: APXvYqzZQCJeHqyLw20M7N2TNmKBi8IwDHr1fSzkT1RENNvynG3/SjhC6PDSr6O2Hjklu3bZBeMSuA==
X-Received: by 2002:a05:6000:4b:: with SMTP id k11mr47230220wrx.82.1564814186606;
        Fri, 02 Aug 2019 23:36:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4013:e920:9388:c3ff? ([2001:b07:6468:f312:4013:e920:9388:c3ff])
        by smtp.gmail.com with ESMTPSA id s10sm94948121wmf.8.2019.08.02.23.36.25
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 23:36:25 -0700 (PDT)
Subject: Re: [PATCH v3 1/3] KVM: Fix leak vCPU's VMCS value into other pCPU
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, stable@vger.kernel.org
References: <1564630214-28442-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a2900ee5-61cf-a35b-7ae5-b326052e0a6d@redhat.com>
Date:   Sat, 3 Aug 2019 08:36:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1564630214-28442-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/08/19 05:30, Wanpeng Li wrote:
> +bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
> +{
> +	if (READ_ONCE(vcpu->arch.pv.pv_unhalted))
> +		return true;
> +
> +	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
> +	    (READ_ONCE(vcpu->arch.nmi_pending) &&
> +	     kvm_x86_ops->nmi_allowed(vcpu)))

You cannot check kvm_x86_ops->nmi_allowed(vcpu), so just use
kvm_test_request.

> +		return true;
> +
> +	if (kvm_test_request(KVM_REQ_SMI, vcpu) ||
> +	    (READ_ONCE(vcpu->arch.smi_pending) && !is_smm(vcpu)))
> +		return true;

Same here, if only for simplicity.

> +	if (kvm_test_request(KVM_REQ_EVENT, vcpu))
> +		return true;
> +
> +	if (vcpu->arch.apicv_active && kvm_x86_ops->apicv_test_pi_on(vcpu))
> +		return true;

Let's call it apicv_has_pending_interrupt instead.

Also, please add a comment in kvm_main.c saying that
kvm_arch_dy_runnable is called outside vcpu_load/vcpu_put.

Paolo

> +
> +	return false;
> +}

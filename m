Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5246EC6D
	for <lists+stable@lfdr.de>; Sat, 20 Jul 2019 00:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbfGSWVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 18:21:15 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40001 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728735AbfGSWVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 18:21:14 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so30309928wmj.5
        for <stable@vger.kernel.org>; Fri, 19 Jul 2019 15:21:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XfZI2IictA9ywj61qMdyHTbvTSjjMZtkpdAjeGYYZmc=;
        b=L2rGzqppGq7xqzf/AZfGQZQ/zFJoMcHpVFOARUJ/Y8ZUzprC67YRYay6CS5hOi7Yb4
         +S+j6HmRuJg6exu+wFHRuQPZiFO7X/7fIWSIBkxLsRcchOEcZ3vJ/ob7XNWPaBUHpg5e
         7O6+G8vmGzP5ibqP6Yo1kQVHlIZ7DB3eQ/UA7ffcH7BSos/yQdqu3KGndlX4/aqsX7kg
         3FLQSNuYB062AMA9mcSdJMH3lXbDis9ff151TBK+zt13ohlIlSGPT+viwIFt7yVMbtZg
         UWXLKzIGJgWKTZtPskyg/2K5HC4sVuW6s0KSNIAJLN2D0d8FofEjeMKBlqyVTochnDO+
         dVQQ==
X-Gm-Message-State: APjAAAX6YlMoB+4/sAjFTkhgmpm8IXnyUSNXs7CHeDuUlg7BLeqyxLgi
        e0ytzljdoeyYsofMwf3n9NC+dUz5fhU=
X-Google-Smtp-Source: APXvYqy5oVd/7/CDRw5yonw4KuWruxEHwF2pLcpjrEXK+RAR6MJq27vSv0M3XaTq50ripLuCv0L7eg==
X-Received: by 2002:a1c:d107:: with SMTP id i7mr52433006wmg.92.1563574872817;
        Fri, 19 Jul 2019 15:21:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8501:6b03:f18c:74f8? ([2001:b07:6468:f312:8501:6b03:f18c:74f8])
        by smtp.gmail.com with ESMTPSA id l17sm18454150wrr.94.2019.07.19.15.21.11
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 15:21:12 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: nVMX: do not use dangling shadow VMCS after guest
 reset
To:     Liran Alon <liran.alon@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
References: <1563572390-28823-1-git-send-email-pbonzini@redhat.com>
 <A523C8F1-2A15-4B14-AB83-9D2659A7E78F@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a79fe081-d46a-07a1-7453-2250fac37374@redhat.com>
Date:   Sat, 20 Jul 2019 00:21:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <A523C8F1-2A15-4B14-AB83-9D2659A7E78F@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20/07/19 00:06, Liran Alon wrote:
> 
> 
>> On 20 Jul 2019, at 0:39, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> If a KVM guest is reset while running a nested guest, free_nested will
>> disable the shadow VMCS execution control in the vmcs01.  However,
>> on the next KVM_RUN vmx_vcpu_run would nevertheless try to sync
>> the VMCS12 to the shadow VMCS which has since been freed.
>>
>> This causes a vmptrld of a NULL pointer on my machime, but Jan reports
>> the host to hang altogether.  Let's see how much this trivial patch fixes.
>>
>> Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
>> Cc: Liran Alon <liran.alon@oracle.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> 1) Are we sure we prefer WARN_ON() instead of WARN_ON_ONCE()?

I don't think you can get it to be called in a loop, the calls are
generally guarded by ifs.

> 2) Should we also check for WARN_ON(!vmcs12)? As free_nested() also kfree(vmx->nested.cached_vmcs12).

Well, it doesn't NULL it but it does NULL shadow_vmcs so the extra
warning wouldn't add much.

> In fact, because free_nested() don’t put NULL in cached_vmcs12 after kfree() it, I wonder if we shouldn’t create a separate patch that does:
> (a) Modify free_nested() to put NULL in cached_vmcs12 after kfree().
> (b) Put BUG_ON(!cached_vmcs12) in get_vmcs12() before returning value.

This is useful but a separate improvement (and not a bugfix, I want this
patch to be small so it applies to older trees).

Paolo

> -Liran
> 
>> ---
>> arch/x86/kvm/vmx/nested.c | 8 +++++++-
>> 1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 4f23e34f628b..0f1378789bd0 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -194,6 +194,7 @@ static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
>> {
>> 	secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_SHADOW_VMCS);
>> 	vmcs_write64(VMCS_LINK_POINTER, -1ull);
>> +	vmx->nested.need_vmcs12_to_shadow_sync = false;
>> }
>>
>> static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
>> @@ -1341,6 +1342,9 @@ static void copy_shadow_to_vmcs12(struct vcpu_vmx *vmx)
>> 	unsigned long val;
>> 	int i;
>>
>> +	if (WARN_ON(!shadow_vmcs))
>> +		return;
>> +
>> 	preempt_disable();
>>
>> 	vmcs_load(shadow_vmcs);
>> @@ -1373,6 +1377,9 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
>> 	unsigned long val;
>> 	int i, q;
>>
>> +	if (WARN_ON(!shadow_vmcs))
>> +		return;
>> +
>> 	vmcs_load(shadow_vmcs);
>>
>> 	for (q = 0; q < ARRAY_SIZE(fields); q++) {
>> @@ -4436,7 +4443,6 @@ static inline void nested_release_vmcs12(struct kvm_vcpu *vcpu)
>> 		/* copy to memory all shadowed fields in case
>> 		   they were modified */
>> 		copy_shadow_to_vmcs12(vmx);
>> -		vmx->nested.need_vmcs12_to_shadow_sync = false;
>> 		vmx_disable_shadow_vmcs(vmx);
>> 	}
>> 	vmx->nested.posted_intr_nv = -1;
>> -- 
>> 1.8.3.1
>>
> 


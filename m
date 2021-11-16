Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8586452E4B
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 10:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbhKPJrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 04:47:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39164 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233392AbhKPJrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 04:47:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637055864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TUrHH0FE+UhMCMP4XCeZVHo5kb/MulSzwtpsVjUnBJg=;
        b=CyGV9GHadGyfPP6LdcoqjwY+LcOUqvVQQPU5KieR9npdbq0LGpxnG9drDb25M91oq+cg3Q
        MyEWuSj9WU9RlTXblu7HEXVI+3VS615n1wJBrVYywe4Sy5xMhU5EaMa71jiknyRUtfA+aC
        zCsGiwWlo6a/gmCNl40GrKeYNRKKlcY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-c1rrBeZgMcmwZX0Vqdb2cg-1; Tue, 16 Nov 2021 04:44:21 -0500
X-MC-Unique: c1rrBeZgMcmwZX0Vqdb2cg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1AF601015DA2;
        Tue, 16 Nov 2021 09:44:20 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B30325C1D5;
        Tue, 16 Nov 2021 09:44:18 +0000 (UTC)
Message-ID: <b455d273-ef5e-bc78-ac31-2543499324b6@redhat.com>
Date:   Tue, 16 Nov 2021 10:44:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2] KVM: x86: Fix uninitialized eoi_exit_bitmap usage in
 vcpu_load_eoi_exitmap()
Content-Language: en-US
To:     =?UTF-8?B?6buE5LmQ?= <huangle1@jd.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <62115b277dab49ea97da5633f8522daf@jd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <62115b277dab49ea97da5633f8522daf@jd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/15/21 15:08, 黄乐 wrote:
> In vcpu_load_eoi_exitmap(), currently the eoi_exit_bitmap[4] array is
> initialized only when Hyper-V context is available, in other path it is
> just passed to kvm_x86_ops.load_eoi_exitmap() directly from on the stack,
> which would cause unexpected interrupt delivery/handling issues, e.g. an
> *old* linux kernel that relies on PIT to do clock calibration on KVM might
> randomly fail to boot.
> 
> Fix it by passing ioapic_handled_vectors to load_eoi_exitmap() when Hyper-V
> context is not available.
> 
> Fixes: f2bc14b69c38 ("KVM: x86: hyper-v: Prepare to meet unallocated Hyper-V context")
> Cc: stable@vger.kernel.org
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Huang Le <huangle1@jd.com>
> ---
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index dc7eb5fddfd3..26466f94e31a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9547,12 +9547,16 @@ static void vcpu_load_eoi_exitmap(struct kvm_vcpu *vcpu)
>   	if (!kvm_apic_hw_enabled(vcpu->arch.apic))
>   		return;
>   
> -	if (to_hv_vcpu(vcpu))
> +	if (to_hv_vcpu(vcpu)) {
>   		bitmap_or((ulong *)eoi_exit_bitmap,
>   			  vcpu->arch.ioapic_handled_vectors,
>   			  to_hv_synic(vcpu)->vec_bitmap, 256);
> +		static_call(kvm_x86_load_eoi_exitmap)(vcpu, eoi_exit_bitmap);
> +		return;
> +	}
>   
> -	static_call(kvm_x86_load_eoi_exitmap)(vcpu, eoi_exit_bitmap);
> +	static_call(kvm_x86_load_eoi_exitmap)(
> +		vcpu, (u64 *)vcpu->arch.ioapic_handled_vectors);
>   }
>   
>   void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
> 

Queued, thanks.

Paolo


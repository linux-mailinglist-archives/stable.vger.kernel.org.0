Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7012436E10
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 01:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhJUXQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 19:16:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59246 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232229AbhJUXQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 19:16:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634858078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cxPDL1X1OgS9v8ul3HGTrDy4DlbmSXpo+YI6RD2Ce64=;
        b=Id6UvYr2RZZn9vphFtaDZqpuqA19bxoGhreMywh3NtgNKQ+RNnX28qGvtP/v8hMcyrvRq4
        WkINkz+8oZOMQttynZoZbYzv0yMLxzycOXeSk84PwKIlID3cEpLK8K395gJRgY8yQ3xogk
        r8B1ZdB4d3YvZWWCoMOofZeRG/BFrC0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-Hjyhw812Oiq4pnBKx6b1aQ-1; Thu, 21 Oct 2021 19:14:34 -0400
X-MC-Unique: Hjyhw812Oiq4pnBKx6b1aQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD4AA9126B;
        Thu, 21 Oct 2021 23:14:33 +0000 (UTC)
Received: from starship (unknown [10.40.192.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96A125F4F5;
        Thu, 21 Oct 2021 23:14:30 +0000 (UTC)
Message-ID: <f4126aaae2cc90a2f5874702bff326c4a790ef43.camel@redhat.com>
Subject: Re: [PATCH 5/8] KVM: x86: split the two parts of emulator_pio_in
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     fwilhelm@google.com, seanjc@google.com, oupton@google.com,
        stable@vger.kernel.org
Date:   Fri, 22 Oct 2021 02:14:29 +0300
In-Reply-To: <20211013165616.19846-6-pbonzini@redhat.com>
References: <20211013165616.19846-1-pbonzini@redhat.com>
         <20211013165616.19846-6-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-10-13 at 12:56 -0400, Paolo Bonzini wrote:
> emulator_pio_in handles both the case where the data is pending in
> vcpu->arch.pio.count, and the case where I/O has to be done via either
> an in-kernel device or a userspace exit.  For SEV-ES we would like
> to split these, to identify clearly the moment at which the
> sev_pio_data is consumed.  To this end, create two different
> functions: __emulator_pio_in fills in vcpu->arch.pio.count, while
> complete_emulator_pio_in clears it and releases vcpu->arch.pio.data.
> 
> While at it, remove the void* argument also from emulator_pio_in_out.
s/remove the void* argument/remove the unused 'void* val' argument/ maybe?
> 
> No functional change intended.
> 
> Cc: stable@vger.kernel.org
> Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 42 +++++++++++++++++++++++-------------------
>  1 file changed, 23 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8880dc36a2b4..07d9533b471d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6906,7 +6906,7 @@ static int kernel_pio(struct kvm_vcpu *vcpu, void *pd)
>  }
>  
>  static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
> -			       unsigned short port, void *val,
> +			       unsigned short port,
>  			       unsigned int count, bool in)
>  {
>  	vcpu->arch.pio.port = port;
> @@ -6927,26 +6927,31 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
>  	return 0;
>  }
>  
> -static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
> -			   unsigned short port, void *val, unsigned int count)
> +static int __emulator_pio_in(struct kvm_vcpu *vcpu, int size,
> +			     unsigned short port, unsigned int count)
>  {
> -	int ret;
> -
> -	if (vcpu->arch.pio.count)
> -		goto data_avail;
> -
> +	WARN_ON(vcpu->arch.pio.count);
>  	memset(vcpu->arch.pio_data, 0, size * count);
> +	return emulator_pio_in_out(vcpu, size, port, count, true);
> +}
>  
> -	ret = emulator_pio_in_out(vcpu, size, port, val, count, true);
> -	if (ret) {
> -data_avail:
> -		memcpy(val, vcpu->arch.pio_data, size * count);
> -		trace_kvm_pio(KVM_PIO_IN, port, size, count, vcpu->arch.pio_data);
> -		vcpu->arch.pio.count = 0;
> -		return 1;
> -	}
> +static void complete_emulator_pio_in(struct kvm_vcpu *vcpu, int size,
> +				    unsigned short port, void *val)
> +{
> +	memcpy(val, vcpu->arch.pio_data, size * vcpu->arch.pio.count);
> +	trace_kvm_pio(KVM_PIO_IN, port, size, vcpu->arch.pio.count, vcpu->arch.pio_data);
> +	vcpu->arch.pio.count = 0;
> +}
>  
> -	return 0;
> +static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
> +			   unsigned short port, void *val, unsigned int count)
> +{
> +	if (!vcpu->arch.pio.count && !__emulator_pio_in(vcpu, size, port, count))
> +		return 0;
^^ maybe I would add a comment here about the fact that kernel completed the
emulation when returing here.

> +
> +	WARN_ON(count != vcpu->arch.pio.count);
> +	complete_emulator_pio_in(vcpu, size, port, val);
> +	return 1;
>  }
>  
>  static int emulator_pio_in_emulated(struct x86_emulate_ctxt *ctxt,
> @@ -6965,12 +6970,11 @@ static int emulator_pio_out(struct kvm_vcpu *vcpu, int size,
>  
>  	memcpy(vcpu->arch.pio_data, val, size * count);
>  	trace_kvm_pio(KVM_PIO_OUT, port, size, count, vcpu->arch.pio_data);
> -	ret = emulator_pio_in_out(vcpu, size, port, (void *)val, count, false);
> +	ret = emulator_pio_in_out(vcpu, size, port, count, false);
>  	if (ret)
>                  vcpu->arch.pio.count = 0;
>  
>          return ret;
> -
>  }
>  
>  static int emulator_pio_out_emulated(struct x86_emulate_ctxt *ctxt,



Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



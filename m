Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF96436E1A
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 01:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbhJUXRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 19:17:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58753 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232361AbhJUXRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 19:17:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634858136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IOA+s/1Nf+8zWpX+cZKkzgCkT8RQvyoggZtI9lV9zOI=;
        b=iQAnnfmIt833cr57plaDaoOxW9J87z07lpfjYxYkTx/wfvADS61O8MU0q1vbJ+Pk09XD81
        pjryc7QbrhsEfEwPprR7KbaXPcP2uxx5HzmzWDgiWjflOv64yCv3mX1Pq9Ojzl12gIXhx4
        9D0bUOs4DtD+e50FwxS768HUETpDgBs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-98inMFoGNmi5J-u9SqC73A-1; Thu, 21 Oct 2021 19:15:31 -0400
X-MC-Unique: 98inMFoGNmi5J-u9SqC73A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CE5C10A8E02;
        Thu, 21 Oct 2021 23:15:30 +0000 (UTC)
Received: from starship (unknown [10.40.192.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2442618428;
        Thu, 21 Oct 2021 23:15:27 +0000 (UTC)
Message-ID: <1179443c92488afee6ee462f43a80ca959924a9a.camel@redhat.com>
Subject: Re: [PATCH 8/8] KVM: SEV-ES: go over the sev_pio_data buffer in
 multiple passes if needed
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     fwilhelm@google.com, seanjc@google.com, oupton@google.com,
        stable@vger.kernel.org
Date:   Fri, 22 Oct 2021 02:15:26 +0300
In-Reply-To: <20211013165616.19846-9-pbonzini@redhat.com>
References: <20211013165616.19846-1-pbonzini@redhat.com>
         <20211013165616.19846-9-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-10-13 at 12:56 -0400, Paolo Bonzini wrote:
> The PIO scratch buffer is larger than a single page, and therefore
> it is not possible to copy it in a single step to vcpu->arch/pio_data.
> Bound each call to emulator_pio_in/out to a single page; keep
> track of how many I/O operations are left in vcpu->arch.sev_pio_count,
> so that the operation can be restarted in the complete_userspace_io
> callback.
> 
> For OUT, this means that the previous kvm_sev_es_outs implementation
> becomes an iterator of the loop, and we can consume the sev_pio_data
> buffer before leaving to userspace.
> 
> For IN, instead, consuming the buffer and decreasing sev_pio_count
> is always done in the complete_userspace_io callback, because that
> is when the memcpy is done into sev_pio_data.
> 
> Cc: stable@vger.kernel.org
> Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
> Reported-by: Felix Wilhelm <fwilhelm@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/x86.c              | 73 +++++++++++++++++++++++++--------
>  2 files changed, 57 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6bed6c416c6c..5a0298aa56ba 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -703,6 +703,7 @@ struct kvm_vcpu_arch {
>  	struct kvm_pio_request pio;
>  	void *pio_data;
>  	void *sev_pio_data;
> +	unsigned sev_pio_count;
>  
>  	u8 event_exit_inst_len;
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a485e185ad00..09c1e64495d3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12378,38 +12378,76 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
>  EXPORT_SYMBOL_GPL(kvm_sev_es_mmio_read);
>  
>  static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
> -			   unsigned int port, unsigned int count)
> +			   unsigned int port);
> +
> +static int complete_sev_es_emulated_outs(struct kvm_vcpu *vcpu)
>  {
> -	int ret = emulator_pio_out(vcpu, size, port,
> -				   vcpu->arch.sev_pio_data, count);
> +	vcpu->arch.pio.count = 0;
> +	if (vcpu->arch.sev_pio_count)
> +		return kvm_sev_es_outs(vcpu,
> +				       vcpu->arch.pio.size,
> +				       vcpu->arch.pio.port);
> +	return 1;
> +}
> +
> +static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
> +			   unsigned int port)
> +{
> +	for (;;) {
> +		unsigned int count =
> +			min_t(unsigned int, PAGE_SIZE / size, vcpu->arch.sev_pio_count);
> +		int ret = emulator_pio_out(vcpu, size, port, vcpu->arch.sev_pio_data, count);
> +
> +		/* memcpy done already by emulator_pio_out.  */
> +		vcpu->arch.sev_pio_count -= count;
> +		vcpu->arch.sev_pio_data += count * vcpu->arch.pio.size;
> +		if (!ret)
> +			break;
>  
> -	if (ret) {
>  		/* Emulation done by the kernel.  */
> -		return ret;
> +		vcpu->arch.pio.count = 0;
> +		if (!vcpu->arch.sev_pio_count)
> +			return 1;
>  	}
>  
> -	vcpu->arch.pio.count = 0;
> +	vcpu->arch.complete_userspace_io = complete_sev_es_emulated_outs;
>  	return 0;
>  }
>  
> -static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
> +static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
> +			  unsigned int port);
> +
> +static void __complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
>  {
> -	memcpy(vcpu->arch.sev_pio_data, vcpu->arch.pio_data,
> -	       vcpu->arch.pio.count * vcpu->arch.pio.size);
> -	vcpu->arch.pio.count = 0;
> +	unsigned count = vcpu->arch.pio.count;
> +	complete_emulator_pio_in(vcpu, vcpu->arch.sev_pio_data);
> +	vcpu->arch.sev_pio_count -= count;
> +	vcpu->arch.sev_pio_data += count * vcpu->arch.pio.size;
> +}
>  
> +static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
> +{
> +	__complete_sev_es_emulated_ins(vcpu);
> +	if (vcpu->arch.sev_pio_count)
> +		return kvm_sev_es_ins(vcpu,
> +				      vcpu->arch.pio.size,
> +				      vcpu->arch.pio.port);
>  	return 1;
>  }
>  
>  static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
> -			  unsigned int port, unsigned int count)
> +			  unsigned int port)
>  {
> -	int ret = emulator_pio_in(vcpu, size, port,
> -				  vcpu->arch.sev_pio_data, count);
> +	for (;;) {
> +		unsigned int count =
> +			min_t(unsigned int, PAGE_SIZE / size, vcpu->arch.sev_pio_count);
> +		if (!__emulator_pio_in(vcpu, size, port, count))
> +			break;
>  
> -	if (ret) {
>  		/* Emulation done by the kernel.  */
> -		return ret;
> +		__complete_sev_es_emulated_ins(vcpu);
> +		if (!vcpu->arch.sev_pio_count)
> +			return 1;
>  	}
>  
>  	vcpu->arch.complete_userspace_io = complete_sev_es_emulated_ins;
> @@ -12421,8 +12459,9 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>  			 int in)
>  {
>  	vcpu->arch.sev_pio_data = data;
> -	return in ? kvm_sev_es_ins(vcpu, size, port, count)
> -		  : kvm_sev_es_outs(vcpu, size, port, count);
> +	vcpu->arch.sev_pio_count = count;
> +	return in ? kvm_sev_es_ins(vcpu, size, port)
> +		  : kvm_sev_es_outs(vcpu, size, port);
>  }
>  EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
>  

I might have missed something, but it looks OK to me.
i mostly checked how the code looks after applying this patch.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Note that I haven't run tested the patches as I don't currently test SEV-ES.

Best regards,
	Maxim Levitsky




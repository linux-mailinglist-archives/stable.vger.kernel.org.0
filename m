Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0875B436E0C
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 01:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhJUXQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 19:16:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24594 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229935AbhJUXQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 19:16:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634858057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iofDD8CWYU8TSSLGexX/eY5SZalt9OSL5XJ8kkqgP9M=;
        b=VYlzu7w9IlS172s447M720FV2f83TRkfr+ebZp6wUOD7C4jGhF1Xh6zozsFy/AgZwBXS87
        M++ezPQ2aZHFe1l3OCjw8Ar69mNBwyqj2xroM9RPBX35ECrkklymtjKJK/KGFBUCize9r+
        JkkXdn5dBgfOz1LgJDbbEF9HZbD7E3c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-xRqOTb31PEKQavQaj9lLTw-1; Thu, 21 Oct 2021 19:14:14 -0400
X-MC-Unique: xRqOTb31PEKQavQaj9lLTw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C173802B7E;
        Thu, 21 Oct 2021 23:14:13 +0000 (UTC)
Received: from starship (unknown [10.40.192.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 593F010016FC;
        Thu, 21 Oct 2021 23:14:06 +0000 (UTC)
Message-ID: <1ae6a54626342dd2391d04a3566bd680c6831e93.camel@redhat.com>
Subject: Re: [PATCH 4/8] KVM: SEV-ES: clean up kvm_sev_es_ins/outs
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     fwilhelm@google.com, seanjc@google.com, oupton@google.com,
        stable@vger.kernel.org
Date:   Fri, 22 Oct 2021 02:14:05 +0300
In-Reply-To: <20211013165616.19846-5-pbonzini@redhat.com>
References: <20211013165616.19846-1-pbonzini@redhat.com>
         <20211013165616.19846-5-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-10-13 at 12:56 -0400, Paolo Bonzini wrote:
> Remove the data argument and pull setting vcpu->arch.sev_pio_data into
> the caller; remove unnecessary clearing of vcpu->arch.pio.count when
> emulation is done by the kernel.

You forgot to mention that you inlined the call to emulator_pio_out_emulated/emulator_pio_in_emulated.


> 
> No functional change intended.
> 
> Cc: stable@vger.kernel.org
> Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 31 +++++++++++++++----------------
>  1 file changed, 15 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 218877e297e5..8880dc36a2b4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12382,34 +12382,32 @@ static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
>  }
>  
>  static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
> -			   unsigned int port, void *data,  unsigned int count)
> +			   unsigned int port, unsigned int count)
>  {
> -	int ret;
> +	int ret = emulator_pio_out(vcpu, size, port,
> +				   vcpu->arch.sev_pio_data, count);
>  
> -	ret = emulator_pio_out_emulated(vcpu->arch.emulate_ctxt, size, port,
> -					data, count);
> -	if (ret)
> +	if (ret) {
> +		/* Emulation done by the kernel.  */
^^ This is a very good comment to have here!
>  		return ret;
> +	}
>  
>  	vcpu->arch.pio.count = 0;
^^^
I wonder what the rules are for clearing vcpu->arch.pio.count for userspace PIO vm exits.
Looks like complete_fast_pio_out clears it, but otherwise the only other place
that clears it in this case is x86_emulate_instruction when it restarts the instuction.
Do I miss something?


> -
>  	return 0;
>  }
>  
>  static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
> -			  unsigned int port, void *data, unsigned int count)
> +			  unsigned int port, unsigned int count)
>  {
> -	int ret;
> +	int ret = emulator_pio_in(vcpu, size, port,
> +				  vcpu->arch.sev_pio_data, count);
>  
> -	ret = emulator_pio_in_emulated(vcpu->arch.emulate_ctxt, size, port,
> -				       data, count);
>  	if (ret) {
> -		vcpu->arch.pio.count = 0;
> -	} else {
> -		vcpu->arch.sev_pio_data = data;
> -		vcpu->arch.complete_userspace_io = complete_sev_es_emulated_ins;
> +		/* Emulation done by the kernel.  */
> +		return ret;
>  	}
>  
> +	vcpu->arch.complete_userspace_io = complete_sev_es_emulated_ins;
>  	return 0;
>  }
>  
> @@ -12417,8 +12415,9 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>  			 unsigned int port, void *data,  unsigned int count,
>  			 int in)
>  {
> -	return in ? kvm_sev_es_ins(vcpu, size, port, data, count)
> -		  : kvm_sev_es_outs(vcpu, size, port, data, count);
> +	vcpu->arch.sev_pio_data = data;
> +	return in ? kvm_sev_es_ins(vcpu, size, port, count)
> +		  : kvm_sev_es_outs(vcpu, size, port, count);
>  }
>  EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
>  

Looks OK to me, I might have missed something though.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky



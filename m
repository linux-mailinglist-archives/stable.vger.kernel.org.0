Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784E6436E09
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 01:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbhJUXPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 19:15:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53099 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230280AbhJUXPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 19:15:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634857996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KRKbHMyLQA73yDGwTOIlwI6kX+pQcdkoNgFrVNdndyA=;
        b=byKzE3OlOp+yM1/XRdHjkvEbHfDSV2vNSx3HUBsYXWlw+1lpr5WlJTteGfZt7T1G/PGLEZ
        Iu1t0n4W4LNENSfwesgprC3JkO9ytGXavVEpWXdzn/11tmG74cHnk+/6jOybSyz1Azy/zu
        xlX5ndGTaYPaBAMZAOST6zClHr6JaVk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-XKMFVEv3P5G88pfIQCF5rg-1; Thu, 21 Oct 2021 19:13:11 -0400
X-MC-Unique: XKMFVEv3P5G88pfIQCF5rg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 892B91926DA3;
        Thu, 21 Oct 2021 23:13:10 +0000 (UTC)
Received: from starship (unknown [10.40.192.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 766CD69219;
        Thu, 21 Oct 2021 23:12:56 +0000 (UTC)
Message-ID: <c54c5c8bf1081720d86c0432fed3499798242323.camel@redhat.com>
Subject: Re: [PATCH 3/8] KVM: x86: leave vcpu->arch.pio.count alone in
 emulator_pio_in_out
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     fwilhelm@google.com, seanjc@google.com, oupton@google.com,
        stable@vger.kernel.org
Date:   Fri, 22 Oct 2021 02:12:55 +0300
In-Reply-To: <20211013165616.19846-4-pbonzini@redhat.com>
References: <20211013165616.19846-1-pbonzini@redhat.com>
         <20211013165616.19846-4-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-10-13 at 12:56 -0400, Paolo Bonzini wrote:
> Currently emulator_pio_in clears vcpu->arch.pio.count twice if
> emulator_pio_in_out performs kernel PIO.  Move the clear into
> emulator_pio_out where it is actually necessary.
> 
> No functional change intended.
> 
> Cc: stable@vger.kernel.org
> Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 722f5fcf76e1..218877e297e5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6914,10 +6914,8 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
>  	vcpu->arch.pio.count  = count;
>  	vcpu->arch.pio.size = size;
>  
> -	if (!kernel_pio(vcpu, vcpu->arch.pio_data)) {
> -		vcpu->arch.pio.count = 0;
> +	if (!kernel_pio(vcpu, vcpu->arch.pio_data))
>  		return 1;
> -	}
>  
>  	vcpu->run->exit_reason = KVM_EXIT_IO;
>  	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
> @@ -6963,9 +6961,16 @@ static int emulator_pio_out(struct kvm_vcpu *vcpu, int size,
>  			    unsigned short port, const void *val,
>  			    unsigned int count)
>  {
> +	int ret;
> +
>  	memcpy(vcpu->arch.pio_data, val, size * count);
>  	trace_kvm_pio(KVM_PIO_OUT, port, size, count, vcpu->arch.pio_data);
> -	return emulator_pio_in_out(vcpu, size, port, (void *)val, count, false);
> +	ret = emulator_pio_in_out(vcpu, size, port, (void *)val, count, false);
> +	if (ret)
> +                vcpu->arch.pio.count = 0;
> +
> +        return ret;
> +
>  }
>  
>  static int emulator_pio_out_emulated(struct x86_emulate_ctxt *ctxt,

Makes sense, now that both emulator_pio_in and emulator_pio_out clear the arch.pio.count once.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




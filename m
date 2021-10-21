Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F642436E07
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 01:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhJUXPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 19:15:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60246 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232195AbhJUXO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 19:14:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634857962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oWu1R3GrDi0gM+5dzpCEoUBCMisee9M8TP0ERGEbfAE=;
        b=ANnr9skdmDd3nhCoXsCGt8e4ZvocUR3M90vY2BJYZwXzDJcAR8TzKr691cAqqgifiJZest
        EN92qBxxhUL9u7qynAkjFJjFg3XtLmQnTMn/6qNMLhWUif7/DjW1em2i7RlbMHTOIF0Bcf
        KTx46oPZXq5q/1FiXh3h8QTOGRRp5Vg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-pLl7OHFoNh-TCkmCNn3erg-1; Thu, 21 Oct 2021 19:12:36 -0400
X-MC-Unique: pLl7OHFoNh-TCkmCNn3erg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FE98802B78;
        Thu, 21 Oct 2021 23:12:35 +0000 (UTC)
Received: from starship (unknown [10.40.192.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8999018368;
        Thu, 21 Oct 2021 23:12:33 +0000 (UTC)
Message-ID: <59bba263d0d92eed478e8b50f8e2822b34ad3c63.camel@redhat.com>
Subject: Re: [PATCH 2/8] KVM: SEV-ES: rename guest_ins_data to sev_pio_data
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     fwilhelm@google.com, seanjc@google.com, oupton@google.com,
        stable@vger.kernel.org
Date:   Fri, 22 Oct 2021 02:12:32 +0300
In-Reply-To: <20211013165616.19846-3-pbonzini@redhat.com>
References: <20211013165616.19846-1-pbonzini@redhat.com>
         <20211013165616.19846-3-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-10-13 at 12:56 -0400, Paolo Bonzini wrote:
> Since we will be using this for OUTS emulation as well, change the name to
> something that refers to any kind of PIO.  Also spell out what it is used
> for, namely SEV-ES.
> 
> No functional change intended.
> 
> Cc: stable@vger.kernel.org
> Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  arch/x86/kvm/x86.c              | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f8f48a7ec577..6bed6c416c6c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -702,7 +702,7 @@ struct kvm_vcpu_arch {
>  
>  	struct kvm_pio_request pio;
>  	void *pio_data;
> -	void *guest_ins_data;
> +	void *sev_pio_data;
>  
>  	u8 event_exit_inst_len;
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index aabd3a2ec1bc..722f5fcf76e1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12369,7 +12369,7 @@ EXPORT_SYMBOL_GPL(kvm_sev_es_mmio_read);
>  
>  static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
>  {
> -	memcpy(vcpu->arch.guest_ins_data, vcpu->arch.pio_data,
> +	memcpy(vcpu->arch.sev_pio_data, vcpu->arch.pio_data,
>  	       vcpu->arch.pio.count * vcpu->arch.pio.size);
>  	vcpu->arch.pio.count = 0;
>  
> @@ -12401,7 +12401,7 @@ static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
>  	if (ret) {
>  		vcpu->arch.pio.count = 0;
>  	} else {
> -		vcpu->arch.guest_ins_data = data;
> +		vcpu->arch.sev_pio_data = data;
>  		vcpu->arch.complete_userspace_io = complete_sev_es_emulated_ins;
>  	}
>  

It might be worth to mention here why we will soon need this field for the outs emulation:

INS reads the data from the userspace (or in-kernel) PIO emulation which is provided in vcpu->arch.pio_data
which is then copied to GHCB, but for OUTS, the data is pushed from GHCB to userspace/in-kernel PIO emulation,
so there is no need to do anything SEV specific

But if the data is pushed via outs spans more that one page, next few patches will split it, so there will be a need
to save the data pointer.


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




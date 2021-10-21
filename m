Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5ED1436E15
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 01:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhJUXRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 19:17:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25242 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232310AbhJUXRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 19:17:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634858095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OKrO9YzFcRiGqjjKTmisNjn2sm4kl4HIEvLRafGurGw=;
        b=KPHicJwTsbwgOAh3jxbmYBWD1TSfssbwwBAgxGEEuKgYxv36F/ZdXAbh4v9eF4pFh1ddrF
        SUJ3ylEiK5r+iSLci2p2YVbfmFVTpain5+tDwNJXsEFb3vSRbby9eLflCAI7Lnpibxvqwk
        Hp4UyODHGhAQmt/QEswr7Xt/B45v7yU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-1JLtYFXkOciPSk-m9q_4zQ-1; Thu, 21 Oct 2021 19:14:54 -0400
X-MC-Unique: 1JLtYFXkOciPSk-m9q_4zQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE3C1802B7E;
        Thu, 21 Oct 2021 23:14:52 +0000 (UTC)
Received: from starship (unknown [10.40.192.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96DFA60862;
        Thu, 21 Oct 2021 23:14:50 +0000 (UTC)
Message-ID: <33411fb1d0a98057249ae27a86909b03be21c8e2.camel@redhat.com>
Subject: Re: [PATCH 7/8] KVM: SEV-ES: keep INS functions together
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     fwilhelm@google.com, seanjc@google.com, oupton@google.com,
        stable@vger.kernel.org
Date:   Fri, 22 Oct 2021 02:14:49 +0300
In-Reply-To: <20211013165616.19846-8-pbonzini@redhat.com>
References: <20211013165616.19846-1-pbonzini@redhat.com>
         <20211013165616.19846-8-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-10-13 at 12:56 -0400, Paolo Bonzini wrote:
> Make the diff a little nicer when we actually get to fixing
> the bug.  No functional change intended.
> 
> Cc: stable@vger.kernel.org
> Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ef4d6a0de4d8..a485e185ad00 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12377,15 +12377,6 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
>  }
>  EXPORT_SYMBOL_GPL(kvm_sev_es_mmio_read);
>  
> -static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
> -{
> -	memcpy(vcpu->arch.sev_pio_data, vcpu->arch.pio_data,
> -	       vcpu->arch.pio.count * vcpu->arch.pio.size);
> -	vcpu->arch.pio.count = 0;
> -
> -	return 1;
> -}
> -
>  static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
>  			   unsigned int port, unsigned int count)
>  {
> @@ -12401,6 +12392,15 @@ static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
>  	return 0;
>  }
>  
> +static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
> +{
> +	memcpy(vcpu->arch.sev_pio_data, vcpu->arch.pio_data,
> +	       vcpu->arch.pio.count * vcpu->arch.pio.size);
> +	vcpu->arch.pio.count = 0;
> +
> +	return 1;
> +}
> +
>  static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
>  			  unsigned int port, unsigned int count)
>  {
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Best regards,
	Maxim Levitsky


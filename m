Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691D5436E13
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 01:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbhJUXRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 19:17:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32239 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232296AbhJUXRF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 19:17:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634858087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wKAcohnofU6zZi5xsu6/8lwmIpu9eTsFr7q3/wltn1o=;
        b=e5LqMy/EmWhAUrcR4AZfVJ24frrTeGA7VxE2Xj06OdwORcGcoxjsCT9qfq26NRVfUcAza+
        WIe13tQm6qk8twjt9ACIxXLJy56cLIs5p0yJVr+kQpdNbeUUJEN1pkj3QUTRohR5S3M7DK
        vwxWFS+GjIw2EUzGOjPTBX68knnASes=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-IXnOpwpvOvCCzHdNeTAx8w-1; Thu, 21 Oct 2021 19:14:44 -0400
X-MC-Unique: IXnOpwpvOvCCzHdNeTAx8w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30E251926DA0;
        Thu, 21 Oct 2021 23:14:43 +0000 (UTC)
Received: from starship (unknown [10.40.192.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C8C95F4ED;
        Thu, 21 Oct 2021 23:14:40 +0000 (UTC)
Message-ID: <7762e16e7fe99e09d2b6a52fb382538d03113fe5.camel@redhat.com>
Subject: Re: [PATCH 6/8] KVM: x86: remove unnecessary arguments from
 complete_emulator_pio_in
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     fwilhelm@google.com, seanjc@google.com, oupton@google.com,
        stable@vger.kernel.org
Date:   Fri, 22 Oct 2021 02:14:39 +0300
In-Reply-To: <20211013165616.19846-7-pbonzini@redhat.com>
References: <20211013165616.19846-1-pbonzini@redhat.com>
         <20211013165616.19846-7-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-10-13 at 12:56 -0400, Paolo Bonzini wrote:
> complete_emulator_pio_in can expect that vcpu->arch.pio has been filled in,
> and therefore does not need the size and count arguments.  This makes things
> nicer when the function is called directly from a complete_userspace_io
> callback.
> 
> No functional change intended.
> 
> Cc: stable@vger.kernel.org
> Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 07d9533b471d..ef4d6a0de4d8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6935,11 +6935,12 @@ static int __emulator_pio_in(struct kvm_vcpu *vcpu, int size,
>  	return emulator_pio_in_out(vcpu, size, port, count, true);
>  }
>  
> -static void complete_emulator_pio_in(struct kvm_vcpu *vcpu, int size,
> -				    unsigned short port, void *val)
> +static void complete_emulator_pio_in(struct kvm_vcpu *vcpu, void *val)
>  {
> +	int size = vcpu->arch.pio.size;
>  	memcpy(val, vcpu->arch.pio_data, size * vcpu->arch.pio.count);
> -	trace_kvm_pio(KVM_PIO_IN, port, size, vcpu->arch.pio.count, vcpu->arch.pio_data);
> +	trace_kvm_pio(KVM_PIO_IN, vcpu->arch.pio.port, size,
> +		      vcpu->arch.pio.count, vcpu->arch.pio_data);
>  	vcpu->arch.pio.count = 0;
>  }
>  
> @@ -6950,7 +6951,7 @@ static int emulator_pio_in(struct kvm_vcpu *vcpu, int size,
>  		return 0;
>  
>  	WARN_ON(count != vcpu->arch.pio.count);
> -	complete_emulator_pio_in(vcpu, size, port, val);
> +	complete_emulator_pio_in(vcpu, val);
>  	return 1;
>  }
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


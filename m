Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EACF6462DDE
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 08:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbhK3HyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 02:54:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23087 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234257AbhK3HyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 02:54:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638258643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9RsQxmZyI5Gqgrid0aQxGXidI3U4sKwzoakj0xjP+2Y=;
        b=NKTREG22zlE4gOA8cHXMHkQQZCWonfQYTn0ugtsK4BKxWfN70aM4iRJ6bbpD/itPbm45rR
        VNfFAiDk6t7Djc6srlYhdYvigwfFMQ1cKdN48+gPwaxM+1SoT1fcg667mLxHiLPGTPXDGh
        YXXpo/vlCf9Bq/SWYQX3/xXDTGG1K+U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-401-3xbcep1nPZix5Clbf0Ll6A-1; Tue, 30 Nov 2021 02:50:39 -0500
X-MC-Unique: 3xbcep1nPZix5Clbf0Ll6A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1890E81CCB4;
        Tue, 30 Nov 2021 07:50:38 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5139E50D3F;
        Tue, 30 Nov 2021 07:50:36 +0000 (UTC)
Message-ID: <0e5a281223351f6100a691c4d6157156784c60d1.camel@redhat.com>
Subject: Re: [PATCH 1/4] KVM: x86: ignore APICv if LAPIC is not enabled
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, stable@vger.kernel.org
Date:   Tue, 30 Nov 2021 09:50:35 +0200
In-Reply-To: <20211123004311.2954158-2-pbonzini@redhat.com>
References: <20211123004311.2954158-1-pbonzini@redhat.com>
         <20211123004311.2954158-2-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-11-22 at 19:43 -0500, Paolo Bonzini wrote:
> Synchronize the condition for the two calls to kvm_x86_sync_pir_to_irr.
> The one in the reenter-guest fast path invoked the callback
> unconditionally even if LAPIC is disabled.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5a403d92833f..441f4769173e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9849,7 +9849,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
>  			break;
>  
> -		if (vcpu->arch.apicv_active)
> +		if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
>  			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
>  
>  		if (unlikely(kvm_vcpu_exit_request(vcpu))) {
Reviewed-by: Maxim Levitsky <mlevitk@redhat.com>

Best regards,
	Maxim Levitsky


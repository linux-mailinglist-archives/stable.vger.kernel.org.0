Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F77512403
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 22:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiD0Uou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 16:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiD0Uot (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 16:44:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 421EAE09D
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 13:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651092096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jDMry/O2NH8BA6BgUi4lsHdjt+USMoEBHJPgjeYLkM8=;
        b=UtDnH64fVFww9QWTyF3SrX4hrxUkqb14Th9ww0uuKn00d3sihD4+rIwTgfcaWddS/2a75F
        ZgdNW8OYn96s0iveAUen4Y3nlTg4pFxkyNrhGZgl6E0FmOUwpDApQx0TKtIcPe1MT6AtUO
        qZEcYDDaoDLR+xvhsb/pllFGssO8YE8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-486-MEuxaX4cNrKzL6nGRjSYUg-1; Wed, 27 Apr 2022 16:41:34 -0400
X-MC-Unique: MEuxaX4cNrKzL6nGRjSYUg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2316D3C1588B;
        Wed, 27 Apr 2022 20:41:34 +0000 (UTC)
Received: from starship (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4FC814152FA;
        Wed, 27 Apr 2022 20:41:32 +0000 (UTC)
Message-ID: <faf34223477e71943bb03e5e53efee0298627907.camel@redhat.com>
Subject: Re: [PATCH 2/3] KVM: x86: a vCPU with a pending triple fault is
 runnable
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, stable@vger.kernel.org
Date:   Wed, 27 Apr 2022 23:41:31 +0300
In-Reply-To: <20220427173758.517087-3-pbonzini@redhat.com>
References: <20220427173758.517087-1-pbonzini@redhat.com>
         <20220427173758.517087-3-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-04-27 at 13:37 -0400, Paolo Bonzini wrote:
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0e73607b02bd..d563812ca229 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12187,6 +12187,9 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>  	    kvm_x86_ops.nested_ops->has_events(vcpu))
>  		return true;
>  
> +	if (kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu))
> +		return true;
> +
>  	return false;
>  }
>  

True.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


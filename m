Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112AB4C1469
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 14:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241005AbiBWNlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 08:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241001AbiBWNlJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 08:41:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 25FDCAC05D
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 05:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645623641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rdW/Vnhl8SCwM1k5GnCkUAynoacHPuSD7Amvkwo2DqI=;
        b=DlIkmC4CwK8cNfTcuDG+yfs+Qu1uruJqNZePPAWY3GcLuCbxp+5W2Q3mNgXmIv1KyzetGR
        s7y8l+APMivyaKLZE2XH0WxwRnwR0hsZgVV/jb1G1mhJB7ScbIWG5VBRtUCicWru014+Kz
        72QDKGvfbI3f6KkHBXGZ143CsEwiCTg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-D6l8P-rjOD-hiXsIZlGJFg-1; Wed, 23 Feb 2022 08:40:39 -0500
X-MC-Unique: D6l8P-rjOD-hiXsIZlGJFg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DDAE801AAD;
        Wed, 23 Feb 2022 13:40:38 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E926784978;
        Wed, 23 Feb 2022 13:40:31 +0000 (UTC)
Message-ID: <c337d280825c1e95d9181ab8aeb505a0b074c8d1.camel@redhat.com>
Subject: Re: [PATCH v2 01/18] KVM: x86: host-initiated EFER.LME write
 affects the MMU
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, stable@vger.kernel.org
Date:   Wed, 23 Feb 2022 15:40:30 +0200
In-Reply-To: <20220217210340.312449-2-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
         <20220217210340.312449-2-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2022-02-17 at 16:03 -0500, Paolo Bonzini wrote:
> While the guest runs, EFER.LME cannot change unless CR0.PG is clear, and therefore
> EFER.NX is the only bit that can affect the MMU role.  However, set_efer accepts
> a host-initiated change to EFER.LME even with CR0.PG=1.  In that case, the
> MMU has to be reset.
> 
> Fixes: 11988499e62b ("KVM: x86: Skip EFER vs. guest CPUID checks for host-initiated writes")
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu.h | 1 +
>  arch/x86/kvm/x86.c | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 51faa2c76ca5..a5a50cfeffff 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -48,6 +48,7 @@
>  			       X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE)
>  
>  #define KVM_MMU_CR0_ROLE_BITS (X86_CR0_PG | X86_CR0_WP)
> +#define KVM_MMU_EFER_ROLE_BITS (EFER_LME | EFER_NX)
>  
>  static __always_inline u64 rsvd_bits(int s, int e)
>  {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d3da64106685..99a58c25f5c2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1647,7 +1647,7 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	}
>  
>  	/* Update reserved bits */
> -	if ((efer ^ old_efer) & EFER_NX)
> +	if ((efer ^ old_efer) & KVM_MMU_EFER_ROLE_BITS)
>  		kvm_mmu_reset_context(vcpu);
>  
>  	return 0;

It makes sense.

I am just curios, is there a report of failure
due to this issue? I can imagine something like this breaking
nested migration of 32 bit guests and such and/or smm and such.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


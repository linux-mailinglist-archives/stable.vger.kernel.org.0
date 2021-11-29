Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42EA46284D
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhK2XgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbhK2XgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:36:01 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00F7C061746
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 15:32:43 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id n8so13454671plf.4
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 15:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fMhxAW0T00dvOtfbIMr5O066vKcGP3SQExpqDRyb3WI=;
        b=cffpanKjPtvjrPkkCaMv+twsIVyfexum4ivNlUeJ+sya9EJi1umlnito1t0x1EhPqo
         azxJRxRkVNPksEDt4MmYp8AudkLlOthcsy9YDYQjJ0Ivotfu7TB3gqLTSDQ11Qx+ROO7
         Q2PY+PNIplcM4MO69JFfxGzIGLyGmIweVTE8tuq72errjdAutTLwk1zbyppAD03kwIk2
         VrXMCjjJeJUqfcJiFTYJXmuN0fz5DepO8EG3T1RYagelB5ZhgijsDbQHFhpV6nDjEXoy
         q+v5UJV0j0hr0SzwOwEi94EgkOenG1Ta15bud0u8SgnavglOV9GkXDgfzbkeqOx62tQP
         5GUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fMhxAW0T00dvOtfbIMr5O066vKcGP3SQExpqDRyb3WI=;
        b=7sYelTxxchWUGnjFoIdBX7T0g6f5LfVMsRExhqQU7Fd9uCm9odIav11Tz633VSdQpX
         rZmkBEqOKCPH9UQCJD4hIoIZcLSllP4TdsJzSRNkqGWK69VtcuizrxYkStI43DI4jlVo
         jrWibkqRZ+KXS9upOnFMFlR/bcAzBVaE5tLu1yAq1++Xu9XggeH2RQPPF+btzRVIXuXI
         TD/iMxZPVV3H96DGtISz7LiiwqvPC9ua3RmLajXqAXnFZr8xihOXCqs8jUwkdWlTIhDW
         KbZa824vb57ec2NlmNwCHyqTj3J6Vn7TkUhVZswPgqcStIidbJo2atMHnSW8QMbvZ97v
         dyjA==
X-Gm-Message-State: AOAM533n58yzTLUBjm5WMWqVVnZ4DUEBaM4JBfL9ni/ZLxrph3oO7P2+
        S7ISIvPs7/aIg9reWjpVR4YmMg==
X-Google-Smtp-Source: ABdhPJzwzJuC3gagMd9tSbUh5ZqFZWBAYUO8sRrzlOWFg6qVHh0Z9bIfV0+kv3QC3HmYXb22dRQNTw==
X-Received: by 2002:a17:902:b28b:b0:142:4abc:ac20 with SMTP id u11-20020a170902b28b00b001424abcac20mr64623518plr.88.1638228763144;
        Mon, 29 Nov 2021 15:32:43 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id fs21sm1085316pjb.1.2021.11.29.15.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 15:32:42 -0800 (PST)
Date:   Mon, 29 Nov 2021 23:32:38 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: x86: ignore APICv if LAPIC is not enabled
Message-ID: <YaVjFlTjpoD6XyP3@google.com>
References: <20211123004311.2954158-1-pbonzini@redhat.com>
 <20211123004311.2954158-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123004311.2954158-2-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 22, 2021 at 07:43:08PM -0500, Paolo Bonzini wrote:
> Synchronize the condition for the two calls to kvm_x86_sync_pir_to_irr.
> The one in the reenter-guest fast path invoked the callback
> unconditionally even if LAPIC is disabled.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: David Matlack <dmatlack@google.com>

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
> -- 
> 2.27.0
> 
> 

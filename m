Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF13308ADB
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 18:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhA2RAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 12:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbhA2Q7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 11:59:06 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283B4C061573
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 08:58:21 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d4so5529403plh.5
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 08:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IEk9NbNMjO7h5rflP6rNtXSfouXuSq8Q4eNt49nSuwY=;
        b=F63YQDk3Poqo6G7huaqoQ1fSvxyg6l5KbYQ4I5whx29cPIni2xT+DzwDNiZxaXwICb
         tQRzSEsRG7ztZBQ3UExv4RsQvhP1fvEwURpOzQ4x81YJJADzXfELluRsX2NvlZhMEETR
         w5oyPLRXzAbrmL/6vBmXF9G9/tuI3gi7hUziAmaspvA+1wPcoknbl5R9EbxJuZedIzcB
         NuPYn6Qxa0x7njvsk3/nmtq9Kgnzr2bHN73HbeFRh7sv38UnG9WkZlIMZEc+FpuYtA8j
         pBKQhw2XzVSyPtd3I+PDSgWzHQotAg2q+/Pny7P/yWQl5MWVyLgYt8yHgjwCho6zU0Lv
         IECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IEk9NbNMjO7h5rflP6rNtXSfouXuSq8Q4eNt49nSuwY=;
        b=qPXWf/pEo0Ui78vmAp+Pz4GjTGd/51GrMlU1c+SUEHLVLOJvxhBsG0MRw20QsKYGbg
         jThI7lgu6++AhVidTtdJ4rQJtF6Rdq11jmS3yP5Jw5cKKH0sT3eYs+Bkla8Nmccr4xOC
         xwTDTSfDz2vwiCq3smVe6nMsTxLccyoyKRk+4F3FgY9Eyd7MnsjOxWwqcOLE4MdfPrDU
         o5Ff0LzXqnr8kCSf4ZeSSjQ9pdpoBb85JQpmC0kUacIyb6BNri0OGQMjDGOTwL3jxP65
         dFfzXFTieXhCrUKV50/j4rf/mdgilpQe32HSOEnmKFpPhTOUorNyc9qg/lvm4wP/XKOK
         6f1w==
X-Gm-Message-State: AOAM531TJt1kQX5Mzwx/T+qDwkFugzWf6u+Wb8CUq/Hkd69+LX32T8Zn
        3KJ6I3WUk/VQtn7baJvBuWZEK/sezjJeng==
X-Google-Smtp-Source: ABdhPJwKYVSVJ9bIADbGcmcjCupj10IlJHIcWaq/HnZTkQL+2KhGaDFpDE1UFkyz6IEFkZVd3//Udg==
X-Received: by 2002:a17:90a:448f:: with SMTP id t15mr5454936pjg.159.1611939500573;
        Fri, 29 Jan 2021 08:58:20 -0800 (PST)
Received: from google.com ([2620:15c:f:10:91fd:c415:8a8b:ccc4])
        by smtp.gmail.com with ESMTPSA id z18sm9447971pfj.102.2021.01.29.08.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 08:58:19 -0800 (PST)
Date:   Fri, 29 Jan 2021 08:58:13 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jmattson@google.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: Allow guests to see MSR_IA32_TSX_CTRL even
 if tsx=off
Message-ID: <YBQ+peAEdX2h3tro@google.com>
References: <20210129101912.1857809-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129101912.1857809-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 29, 2021, Paolo Bonzini wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 76bce832cade..15733013b266 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1401,7 +1401,7 @@ static u64 kvm_get_arch_capabilities(void)
>  	 *	  This lets the guest use VERW to clear CPU buffers.


This comment be updated to call out the new TSX_CTRL behavior.

	/*
	 * On TAA affected systems:
	 *      - nothing to do if TSX is disabled on the host.
	 *      - we emulate TSX_CTRL if present on the host.
	 *	  This lets the guest use VERW to clear CPU buffers.
	 */

>  	 */
>  	if (!boot_cpu_has(X86_FEATURE_RTM))
> -		data &= ~(ARCH_CAP_TAA_NO | ARCH_CAP_TSX_CTRL_MSR);
> +		data &= ~ARCH_CAP_TAA_NO;

Hmm, simply clearing TSX_CTRL will only preserve the host value.  Since
ARCH_CAPABILITIES is unconditionally emulated by KVM, wouldn't it make sense to
unconditionally expose TSX_CTRL as well, as opposed to exposing it only if it's
supported in the host?  I.e. allow migrating a TSX-disabled guest to a host
without TSX.  Or am I misunderstanding how TSX_CTRL is checked/used?

>  	else if (!boot_cpu_has_bug(X86_BUG_TAA))
>  		data |= ARCH_CAP_TAA_NO;
>  
> -- 
> 2.26.2
> 

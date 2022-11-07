Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C53E161F7EA
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 16:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbiKGPsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 10:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbiKGPsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 10:48:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926D4766F;
        Mon,  7 Nov 2022 07:48:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 431ECB81217;
        Mon,  7 Nov 2022 15:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46732C433D6;
        Mon,  7 Nov 2022 15:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667836080;
        bh=0VNtcnzTIbK52UYJ3ELf22eWSF2M+cmzTfrg73JHU20=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GAiW6J2W5qL3lgmRHCBNnWvS1bCwVCJHR0RTgIq9wQubGYgyor7reoaYhCORm0WMQ
         Rf/dpBJWOQ23p9KB4gsbjBIeJ3bob/40iw3H5CvEzBI9KMAHDoRphxQ9qxPGqItUBY
         upX36/BJgvLnmrHAoQ8zs+xShCEeFnaal+TTxHTlcZFqbeng1972MmG1i+sHu8IEdv
         4+jiVO4UfX/PvnoXfbKqqHQdapbvwgHSa6FWFawNpRZkSGgTeYiyZRC50Ox56+/87e
         vPGO6lY7sTjg1AY3p9dnYmPMGjn2cOcxQ4Sj68cMkA7zpsRJxFPNdl6DU1tYu/+0Rm
         Jdp/Ys7do+0iw==
Date:   Mon, 7 Nov 2022 17:47:57 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Peter Gonda <pgonda@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Harald Hoyer <harald@profian.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V2] KVM: SVM: Only dump VSMA to klog for debugging
Message-ID: <Y2korUDRIMoseq+V@kernel.org>
References: <20221104142220.469452-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104142220.469452-1-pgonda@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 04, 2022 at 07:22:20AM -0700, Peter Gonda wrote:
> Explicitly print the VMSA dump at KERN_DEBUG log level, KERN_CONT uses
> KERNEL_DEFAULT if the previous log line has a newline, i.e. if there's
> nothing to continuing, and as a result the VMSA gets dumped when it
> shouldn't.
> 
> The KERN_CONT documentation says it defaults back to KERNL_DEFAULT if the
> previous log line has a newline. So switch from KERN_CONT to
> print_hex_dump_debug().
> 
> Jarkko pointed this out in reference to the original patch. See:
> https://lore.kernel.org/all/YuPMeWX4uuR1Tz3M@kernel.org/
> print_hex_dump(KERN_DEBUG, ...) was pointed out there, but
> print_hex_dump_debug() should similar.
> 
> Fixes: 6fac42f127b8 ("KVM: SVM: Dump Virtual Machine Save Area (VMSA) to klog")
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: Harald Hoyer <harald@profian.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: x86@kernel.org
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>  arch/x86/kvm/svm/sev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c0c9ed5e279cb..9b8db157cf773 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -605,7 +605,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>  	save->dr6  = svm->vcpu.arch.dr6;
>  
>  	pr_debug("Virtual Machine Save Area (VMSA):\n");
> -	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
> +	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
>  
>  	return 0;
>  }
> -- 
> 2.38.1.431.g37b22c650d-goog
> 

OK, this was my careless mistake, sorry about that:


Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko

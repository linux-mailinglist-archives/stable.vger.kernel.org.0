Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865B440BA4A
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 23:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbhINVfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 17:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234593AbhINVfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 17:35:15 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FDBC061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 14:33:57 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id g184so547368pgc.6
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 14:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZyjM2wXU6lcczfYiDbbE+nr5M72sF/mBbv9m3C0jSUo=;
        b=BBPcaDizm+ebmiak6LRh4102fNSBmRNhl4+y56Xy2ZoG6QzA2eKAqLu1xvxohYClem
         UYDOdK/PS8+E8SGCISj7wMV0BW0SMNj/qd3gqwq4xV4LyCIfDhIofxM7O3ZCbrj9bTM6
         AiBSpm5AnkHD7DK55QKyv67HyOeMAtBMryUEJCdRYXTXUeiiiGawQPSEU+YEOmzfc4OG
         +cVLqYnv2f2/EV2Nx2RcyJGERu6F/4Lp8o8bVAROm9jRVliNOGKGT9tXaO6ZwrY7F62Q
         I1OmwG/NvCeKXN5z93eojG4S2GjBmgVmTDZ2IyeN4Stdd+GGPp7tmKrb3fei2UwID+o8
         mBuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZyjM2wXU6lcczfYiDbbE+nr5M72sF/mBbv9m3C0jSUo=;
        b=zrQtncidjS/3np/5UgO/U9VHNfeiAiIZ4P3GcA2wnBDeWcP97U2EZN3jcSaIiU4aqI
         HQ1FlIFupDxe4TiWFdqVcW5wY7VbEH77YZ34B6tSnNH5xPElYTHw+PrilKY9/pv9g787
         tv6iJhsxI+dKPOWhuHSCupNAT+dosarft/WA2WW7MmTWtkJPQrCoFFsVLHoNELHIh0cb
         335pWXE8LJeOqCx8vDGnK6S9Js2EcX4r5g/WI7PVWGmdWP3oKRmjVr9Xn2HeQXLsiTfR
         PZngUT09jXRgcn1mIugN8IQ3leEPzvm7srs1Xpejhg5326NSxpvIEQuBKv8uf80QL+vA
         OGUg==
X-Gm-Message-State: AOAM532E23C73OdYMpdo51H7x0jTIoSYNHov47bS7yDc+bUaU99/dl5y
        mo33lo3tsEdp47//ukC3NOMUxA==
X-Google-Smtp-Source: ABdhPJybCI6QSBt4aaOFLxKB+NKlA+WI2FDLU3adUXCAU9W7cHSWjtPA3oc5IWHv9q84jY3U/uhClA==
X-Received: by 2002:aa7:9d02:0:b0:43d:ea96:5882 with SMTP id k2-20020aa79d02000000b0043dea965882mr6882103pfp.23.1631655237051;
        Tue, 14 Sep 2021 14:33:57 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m125sm3448904pfd.174.2021.09.14.14.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 14:33:56 -0700 (PDT)
Date:   Tue, 14 Sep 2021 21:33:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: SEV: Acquire vcpu mutex when updating VMSA
Message-ID: <YUEVQDEvLbdJF+sj@google.com>
References: <20210914200639.3305617-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210914200639.3305617-1-pgonda@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 14, 2021, Peter Gonda wrote:
> Adds mutex guard to the VMSA updating code. Also adds a check to skip a
> vCPU if it has already been LAUNCH_UPDATE_VMSA'd which should allow
> userspace to retry this ioctl until all the vCPUs can be successfully
> LAUNCH_UPDATE_VMSA'd. Because this operation cannot be undone we cannot
> unwind if one vCPU fails.
> 
> Fixes: ad73109ae7ec ("KVM: SVM: Provide support to launch and run an SEV-ES guest")
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: kvm@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/x86/kvm/svm/sev.c | 24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 75e0b21ad07c..9a2ebd0328ca 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -598,22 +598,29 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>  static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -	struct sev_data_launch_update_vmsa vmsa;
> +	struct sev_data_launch_update_vmsa vmsa = {0};
>  	struct kvm_vcpu *vcpu;
>  	int i, ret;
>  
>  	if (!sev_es_guest(kvm))
>  		return -ENOTTY;
>  
> -	vmsa.reserved = 0;
> -

Zeroing all of 'vmsa' is an unrelated chagne and belongs in a separate patch.  I
would even go so far as to say it's unnecessary, even field of the struct is
explicitly written before it's consumed.

>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		struct vcpu_svm *svm = to_svm(vcpu);
>  
> +		ret = mutex_lock_killable(&vcpu->mutex);
> +		if (ret)
> +			goto out_unlock;

Rather than multiple unlock labels, move the guts of the loop to a wrapper.
As discussed off list, this really should be a vCPU-scoped ioctl, but that ship
has sadly sailed :-(  We can at least imitate that by making the VM-scoped ioctl
nothing but a wrapper.

> +
> +		/* Skip to the next vCPU if this one has already be updated. */

s/be/been

Uber nit, there may not be a next vCPU.  It'd be more slightly more accurate to
say something like "Do nothing if this vCPU has already been updated".

> +		ret = sev_es_sync_vmsa(svm);
> +		if (svm->vcpu.arch.guest_state_protected)
> +			goto unlock;

This belongs in a separate patch, too.  It also introduces a bug (arguably two)
in that it adds a duplicate call to sev_es_sync_vmsa().  The second bug is that
if sev_es_sync_vmsa() fails _and_ the vCPU is already protected, this will cause
that failure to be squashed.

In the end, I think the least gross implementation will look something like this,
implemented over two patches (one for the lock, one for the protected check).

static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
				    int *error)
{
	struct sev_data_launch_update_vmsa vmsa;
	struct vcpu_svm *svm = to_svm(vcpu);
	int ret;

	/*
	 * Do nothing if this vCPU has already been updated.  This is allowed
	 * to let userspace retry LAUNCH_UPDATE_VMSA if the command fails on a
	 * later vCPU.
	 */
	if (svm->vcpu.arch.guest_state_protected)
		return 0;

	/* Perform some pre-encryption checks against the VMSA */
	ret = sev_es_sync_vmsa(svm);
	if (ret)
		return ret;

	/*
	 * The LAUNCH_UPDATE_VMSA command will perform in-place
	 * encryption of the VMSA memory content (i.e it will write
	 * the same memory region with the guest's key), so invalidate
	 * it first.
	 */
	clflush_cache_range(svm->vmsa, PAGE_SIZE);

	vmsa.reserved = 0;
	vmsa.handle = to_kvm_svm(kvm)->sev_info.handle;
	vmsa.address = __sme_pa(svm->vmsa);
	vmsa.len = PAGE_SIZE;
	return sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, error);
}

static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
{
	struct kvm_vcpu *vcpu;
	int i, ret;

	if (!sev_es_guest(kvm))
		return -ENOTTY;

	kvm_for_each_vcpu(i, vcpu, kvm) {
		ret = mutex_lock_killable(&vcpu->mutex);
		if (ret)
			return ret;

		ret = __sev_launch_update_vmsa(kvm, vcpu, &argp->error);

		mutex_unlock(&vcpu->mutex);
		if (ret)
			return ret;
	}
	return 0;
}

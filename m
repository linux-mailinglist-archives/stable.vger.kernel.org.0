Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08FC492280
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 10:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345553AbiARJTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 04:19:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240567AbiARJTr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 04:19:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E562FC061574;
        Tue, 18 Jan 2022 01:19:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F9FAB81247;
        Tue, 18 Jan 2022 09:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A077BC340E4;
        Tue, 18 Jan 2022 09:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642497584;
        bh=/Rdu/D+fiOf/x38JO5sE42aJ+q6RYz1CwV95zFg8HXY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uo3DnIwN47etRtaC+bcn9hIw8UTdKtcUC7pPoSr1AYPgOE24HWstDbZrjzH+8ILZA
         W4N/cT120Vt4dChmnKKj2ockfrwn+tCW9CvFK3LgE/AbYXAOtdOETJ7+CJ5udZPxe4
         YBZUW8zi8wQUNZRExVsYl37iHhYkVr4T+C7VR32Q=
Date:   Tue, 18 Jan 2022 10:19:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Wei Wang <wei.w.wang@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH stable] KVM: x86: remove PMU FIXED_CTR3 from
 msrs_to_save_all
Message-ID: <YeaGLM2U74OEPq7Z@kroah.com>
References: <20220118091107.1007603-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118091107.1007603-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 04:11:07AM -0500, Paolo Bonzini wrote:
> From: Wei Wang <wei.w.wang@intel.com>
> 
> [ upstream commit 9fb12fe5b93b94b9e607509ba461e17f4cc6a264 ]
> 
> The fixed counter 3 is used for the Topdown metrics, which hasn't been
> enabled for KVM guests. Userspace accessing to it will fail as it's not
> included in get_fixed_pmc(). This breaks KVM selftests on ICX+ machines,
> which have this counter.
> 
> To reproduce it on ICX+ machines, ./state_test reports:
> ==== Test Assertion Failure ====
> lib/x86_64/processor.c:1078: r == nmsrs
> pid=4564 tid=4564 - Argument list too long
> 1  0x000000000040b1b9: vcpu_save_state at processor.c:1077
> 2  0x0000000000402478: main at state_test.c:209 (discriminator 6)
> 3  0x00007fbe21ed5f92: ?? ??:0
> 4  0x000000000040264d: _start at ??:?
>  Unexpected result from KVM_GET_MSRS, r: 17 (failed MSR was 0x30c)
> 
> With this patch, it works well.
> 
> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> Message-Id: <20211217124934.32893-1-wei.w.wang@intel.com>
> Fixes: e2ada66ec418 ("kvm: x86: Add Intel PMU MSRs to msrs_to_save[]")
> Cc: stable@vger.kernel.org # 5.4.x
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9a2972fdae82..d490b83d640c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1331,7 +1331,7 @@ static const u32 msrs_to_save_all[] = {
>  	MSR_IA32_UMWAIT_CONTROL,
>  
>  	MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
> -	MSR_ARCH_PERFMON_FIXED_CTR0 + 2, MSR_ARCH_PERFMON_FIXED_CTR0 + 3,
> +	MSR_ARCH_PERFMON_FIXED_CTR0 + 2,
>  	MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
>  	MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
>  	MSR_ARCH_PERFMON_PERFCTR0, MSR_ARCH_PERFMON_PERFCTR1,
> -- 
> 2.31.1
> 

Now queued up, thanks.

greg k-h

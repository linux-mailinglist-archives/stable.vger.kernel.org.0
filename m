Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDEF2B09AD
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 17:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbgKLQPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 11:15:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:32922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728685AbgKLQPO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Nov 2020 11:15:14 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32FC62085B;
        Thu, 12 Nov 2020 16:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605197713;
        bh=P3YrRK7PPU6bylYh8eDpPiAw3aNkypC5GFYbzr2TUWY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ms9W98P5GNnAGe6PINuMkaU3wiDd1zQ3zjVm+aiA6q+I0vMOPBZBCLNX6rGRVas4q
         gKlSGJO2A/0pqfooamoYILTDxLxmscgPMTkuOF/S4fW8jCLW85tB8C8IYx0X7hm7v1
         KXjNjMvJWJZL8O/79g9a7uglwBM5QWNc86zTMxi4=
Date:   Thu, 12 Nov 2020 11:15:12 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH stable-5.4] KVM: x86: don't expose
 MSR_IA32_UMWAIT_CONTROL unconditionally
Message-ID: <20201112161512.GF403069@sasha-vm>
References: <20201111132047.64845-1-jinpu.wang@cloud.ionos.com>
 <9cdcac85-3f02-190f-cf4c-296a8eb415de@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <9cdcac85-3f02-190f-cf4c-296a8eb415de@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 11, 2020 at 02:51:12PM +0100, Paolo Bonzini wrote:
>On 11/11/20 14:20, Jack Wang wrote:
>>From: Maxim Levitsky <mlevitsk@redhat.com>
>>
>>This msr is only available when the host supports WAITPKG feature.
>>
>>This breaks a nested guest, if the L1 hypervisor is set to ignore
>>unknown msrs, because the only other safety check that the
>>kernel does is that it attempts to read the msr and
>>rejects it if it gets an exception.
>>
>>Cc: stable@vger.kernel.org
>>Fixes: 6e3ba4abce ("KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL")
>>Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>>Message-Id: <20200523161455.3940-3-mlevitsk@redhat.com>
>>Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>(cherry picked from commit f4cfcd2d5aea4e96c5d483c476f3057b6b7baf6a
>>use boot_cpu_has for checking the feature)
>>Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
>>---
>>  arch/x86/kvm/x86.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>index 708b37274cb5..4cacf4669235 100644
>>--- a/arch/x86/kvm/x86.c
>>+++ b/arch/x86/kvm/x86.c
>>@@ -5226,6 +5226,10 @@ static void kvm_init_msr_list(void)
>>  			if (!kvm_x86_ops->rdtscp_supported())
>>  				continue;
>>  			break;
>>+		case MSR_IA32_UMWAIT_CONTROL:
>>+			if (!boot_cpu_has(X86_FEATURE_WAITPKG))
>>+				continue;
>>+			break;
>>  		case MSR_IA32_RTIT_CTL:
>>  		case MSR_IA32_RTIT_STATUS:
>>  			if (!kvm_x86_ops->pt_supported())
>>
>
>Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Queued up, thanks!

-- 
Thanks,
Sasha

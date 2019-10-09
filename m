Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50378D1BFF
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 00:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732420AbfJIWlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 18:41:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731763AbfJIWlb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 18:41:31 -0400
Received: from localhost (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57856206A1;
        Wed,  9 Oct 2019 22:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570660890;
        bh=luGiKPn3ZU8w68DlafUoK10zfzRgHpkeep6teIAuOgQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rc+irKPrpeqwQXpHSoFE706kLoxQRqfJ4NCeM0WtUSQT+q5uICxdJzogjbqxY5P3j
         JkMocUaDBVj+nyR0jXTypZNF+enLHpy30f3R84LqUesXoViZZzLzsvuR7mK8KX6St2
         5xJzqjsa/nm2GLyP0YOcVKzcyNj0mNo7z2JFWBmg=
Date:   Wed, 9 Oct 2019 18:41:29 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Marc Orr <marcorr@google.com>, Peter Shier <pshier@google.com>,
        Jacob Xu <jacobhxu@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 08/26] kvm: x86: Improve emulation of CPUID
 leaves 0BH and 1FH
Message-ID: <20191009224129.GX1396@sasha-vm>
References: <20191009170558.32517-1-sashal@kernel.org>
 <20191009170558.32517-8-sashal@kernel.org>
 <5fcb0e38-3542-dd39-6a1c-449b4f9f435e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5fcb0e38-3542-dd39-6a1c-449b4f9f435e@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 09, 2019 at 10:58:35PM +0200, Paolo Bonzini wrote:
>On 09/10/19 19:05, Sasha Levin wrote:
>> From: Jim Mattson <jmattson@google.com>
>>
>> [ Upstream commit 43561123ab3759eb6ff47693aec1a307af0aef83 ]
>>
>> For these CPUID leaves, the EDX output is not dependent on the ECX
>> input (i.e. the SIGNIFCANT_INDEX flag doesn't apply to
>> EDX). Furthermore, the low byte of the ECX output is always identical
>> to the low byte of the ECX input. KVM does not produce the correct ECX
>> and EDX outputs for any undefined subleaves beyond the first.
>>
>> Special-case these CPUID leaves in kvm_cpuid, so that the ECX and EDX
>> outputs are properly generated for all undefined subleaves.
>>
>> Fixes: 0771671749b59a ("KVM: Enhance guest cpuid management")
>> Fixes: a87f2d3a6eadab ("KVM: x86: Add Intel CPUID.1F cpuid emulation support")
>> Signed-off-by: Jim Mattson <jmattson@google.com>
>> Reviewed-by: Marc Orr <marcorr@google.com>
>> Reviewed-by: Peter Shier <pshier@google.com>
>> Reviewed-by: Jacob Xu <jacobhxu@google.com>
>> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  arch/x86/kvm/cpuid.c | 83 +++++++++++++++++++++++++-------------------
>>  1 file changed, 47 insertions(+), 36 deletions(-)
>
>This is absolutely not stable material.  Is it possible for KVM to opt
>out of this AUTOSEL nonsense?

Sure, I've opted out KVM and removed all KVM patches from this series:

c1fac4516a61d kvm: vmx: Limit guest PMCs to those supported on the host
75b118586ec81 kvm: x86, powerpc: do not allow clearing largepages debugfs entry
06cd1710feaed KVM: VMX: Set VMENTER_L1D_FLUSH_NOT_REQUIRED if !X86_BUG_L1TF
c89fc5c082aa6 KVM: x86: Expose XSAVEERPTR to the guest
1eec6b4068e2e kvm: x86: Use AMD CPUID semantics for AMD vCPUs
5c56e6ba0afc8 kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH
94a3c6f010bd2 kvm: x86: Fix a spurious -E2BIG in __do_cpuid_func
79a7ad6330bc5 KVM: arm/arm64: vgic: Use the appropriate TRACE_INCLUDE_PATH

--
Thanks,
Sasha

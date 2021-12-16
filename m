Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B89E476C18
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 09:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbhLPInI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 03:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234935AbhLPInH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 03:43:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD49DC061574
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 00:43:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AA3E61CB8
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 08:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F67C36AE2;
        Thu, 16 Dec 2021 08:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639644186;
        bh=yhnCpU/1/OVNF+UrBbgOOFfFgCiXyQYAcfhyyddz3R0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EpNesQ4/Y/RMuVXLaMGSuN1ric9wo+ZRSr8nUPpEsdUZFbpI40ygJmIPNnreOB9Pz
         i1U1ClJr4R0on8NE8rkXrO/oM5dM5XF0Y6UnYP160EWQbvL61Pp6waLBJI5jyYN4ps
         CbuJEBwvZ/Hfi177qtDPLtUd+ArhglECfE8KeSIozKs0hf+lG4fcPDEC1t65+l1LlX
         TaGIUbv4lUQE6QspHAgFieRrfMVpkLpGN7gg3d6m5SN68uomvlBZndfU/sgIFsNs+a
         FSjPle/XTi+qh+w/HsUzIe1lcWeO9XXavnzk/v6XktLFro2cdVKfrZMj0RjV+9YDum
         SUXEfebh4T2OQ==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mxmLw-00CT8P-Dy; Thu, 16 Dec 2021 08:43:04 +0000
MIME-Version: 1.0
Date:   Thu, 16 Dec 2021 08:43:04 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Chris January <Chris.January@arm.com>, stable@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        reg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>
Subject: Re: Bug with KVM: arm64: Avoid setting the upper 32 bits of TCR_EL2
 and CPTR_EL2 to 1
In-Reply-To: <8C04B3CF-4B26-4EA1-B6BD-A7AB30078FCE@goldelico.com>
References: <DB8835B4-8F04-4669-87EA-D348FA47A79D@goldelico.com>
 <8C04B3CF-4B26-4EA1-B6BD-A7AB30078FCE@goldelico.com>
User-Agent: Roundcube Webmail/1.4.12
Message-ID: <be707d0d8fa0419470cb07b47e6f0464@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: hns@goldelico.com, catalin.marinas@arm.com, Chris.January@arm.com, stable@vger.kernel.org, will@kernel.org, gregkh@linuxfoundation.org, letux-kernel@openphoenux.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nikolaus,

On 2021-12-16 06:58, H. Nikolaus Schaller wrote:
> Hi Catalin,
> 
>> Am 15.12.2021 um 19:40 schrieb H. Nikolaus Schaller 
>> <hns@goldelico.com>:
>> 
>> this seems to break build of 5.10.y (and maybe earlier) for me:
>> 
>>  CALL    scripts/checksyscalls.sh - due to target missing
>>  CALL    scripts/atomic/check-atomics.sh - due to target missing
>>  CHK     include/generated/compile.h
>>  AS      arch/arm64/kvm/hyp/nvhe/hyp-init.nvhe.o - due to target 
>> missing
>> arch/arm64/kvm/hyp/nvhe/hyp-init.S: Assembler messages:
>> arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'
>> arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'
>> arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'
>> arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'
>> arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'
>> arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'
>> arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: unexpected characters 
>> following instruction at operand 2 -- `mov x1,#((1U<<31)|(1<<23))'
>> arch/arm64/kvm/hyp/nvhe/Makefile:28: recipe for target 
>> 'arch/arm64/kvm/hyp/nvhe/hyp-init.nvhe.o' failed
>> make[5]: *** [arch/arm64/kvm/hyp/nvhe/hyp-init.nvhe.o] Error 1
>> scripts/Makefile.build:497: recipe for target 
>> 'arch/arm64/kvm/hyp/nvhe' failed
>> make[4]: *** [arch/arm64/kvm/hyp/nvhe] Error 2
>> scripts/Makefile.build:497: recipe for target 'arch/arm64/kvm/hyp' 
>> failed
>> make[3]: *** [arch/arm64/kvm/hyp] Error 2
>> scripts/Makefile.build:497: recipe for target 'arch/arm64/kvm' failed
>> make[2]: *** [arch/arm64/kvm] Error 2
>> Makefile:1822: recipe for target 'arch/arm64' failed
>> make[1]: *** [arch/arm64] Error 2
>> Makefile:336: recipe for target '__build_one_by_one' failed
>> make: *** [__build_one_by_one] Error 2
>> 
>> Looking at the problematic line 87 of hyp-init.S shows that
>> there is a macro expansion:
>> 
>>      mov     x1, #TCR_EL2_RES1
>> 
>> This macro was modified by the $subject patch
>> (commit c71b5f37b5ff1a673b2e4a91d1b34ea027546e23 in v5.10.y)
>> and reverting the patch makes the compile succeed.
>> 
>> Now: why does it build for me for v5.15.y and v5.16-rc5?
>> I think it is because my build system switches to gcc 6.3
>> instead of gcc 4.9 depending on scripts/min-tool-version.sh.
> 
> I have run the cross-check and it
> - fails with gcc 4.9.2 + binutils 2.25 (compatible to jessie)
> - works with gcc 6.3.0 + binutils 2.28.1 (compatible to stretch)
> 
>> 
>> So I assume that the fix is not compatible with the minimum
>> requirement for 5.10.y of gcc 4.9 (or even less - I don't know 
>> exactly).
>> Earlier kernels may also be affected if $subject patch was also
>> backported there, but I have not tested.
>> 
>> This should somehow be fixed so that arch/arm64/include/asm/kvm_arm.h
>> can be included by older assemblers.

GCC versions prior to 5.1 are known to miscompile the kernel,
and the minimal GCC version was bumped in dca5244d2f5b.

I am surprised this requirement wasn't backported to 5.10-stable,
as this results in all sorts of terrible bugs that are hard to
diagnose (see the horror story in the commit message).

As for the issue you describe, does the following help?

Thanks,

         M.

diff --git a/arch/arm64/include/asm/kvm_arm.h 
b/arch/arm64/include/asm/kvm_arm.h
index 01d47c5886dc..d03087308ab5 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -91,7 +91,7 @@
  #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)

  /* TCR_EL2 Registers bits */
-#define TCR_EL2_RES1		((1U << 31) | (1 << 23))
+#define TCR_EL2_RES1		((UL(1) << 31) | (UL(1) << 23))
  #define TCR_EL2_TBI		(1 << 20)
  #define TCR_EL2_PS_SHIFT	16
  #define TCR_EL2_PS_MASK		(7 << TCR_EL2_PS_SHIFT)

-- 
Jazz is not dead. It just smells funny...

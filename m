Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA3A134414
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 14:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbgAHNnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 08:43:35 -0500
Received: from foss.arm.com ([217.140.110.172]:44708 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726931AbgAHNnf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jan 2020 08:43:35 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D0DBC31B;
        Wed,  8 Jan 2020 05:43:34 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4A7833F703;
        Wed,  8 Jan 2020 05:43:33 -0800 (PST)
From:   Mark Rutland <mark.rutland@arm.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        maz@kernel.org, alexandru.elisei@arm.com
Cc:     drjones@redhat.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, mark.rutland@arm.com,
        peter.maydell@linaro.org, stable@vger.kernel.org,
        suzuki.poulose@arm.com, will@kernel.org
Subject: [PATCHv2 0/3] KVM: arm/arm64: exception injection fixes
Date:   Wed,  8 Jan 2020 13:43:21 +0000
Message-Id: <20200108134324.46500-1-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

While looking at the KVM code, I realised that our exception injection handling
isn't quite right, as it generates the target PSTATE/CPSR from scratch, and
doesn't handle all bits which need to be (conditionally) cleared or set upon
taking an exception.

The first two patches address this for injecting exceptions into AArch64 and
AArch32 contexts respectively. I've tried to organise the code so that it can
easily be audited against the ARM ARM, and/or extended in future if/when new
bits are added to the SPSRs.

While writing the AArch32 portion I also realised that on an AArch64 host we
don't correctly synthesize the SPSR_{abt,und} seen by the guest, as we copy the
value of SPSR_EL2, and the layouts of those SPSRs differ. The third patch
addresses this by explicitly moving bits into the SPSR_{abt,und} layout.

I'd appreciate any testing people could offer, especially for AArch32 guests
and/or AArch32 hosts, which I'm currently ill equipped to test. Ideally we'd
have some unit tests for this.

These issues don't seem to upset contemporary guests, but they do mean that KVM
isn't providing an architecturally compliant environment in all cases, which is
liable to cause issues in future. Given that, and that the patches are fairly
self-contained, I've marked all three patches for stable.

All three patches can be found on my kvm/exception-state branch [1].

Since v1 [2]:
* Fix host_spsr_to_spsr32() bit preservation
* Fix SPAN polarity; tested with a modified arm64 guest
* Fix DIT preservation on 32-bit hosts
* Add Alex's Reviewed-by to patch 3

Thanks,
Mark.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=kvm/exception-state

Mark Rutland (3):
  KVM: arm64: correct PSTATE on exception entry
  KVM: arm/arm64: correct CPSR on exception entry
  KVM: arm/arm64: correct AArch32 SPSR on exception entry

 arch/arm/include/asm/kvm_emulate.h   |  17 +++++
 arch/arm64/include/asm/kvm_emulate.h |  32 ++++++++++
 arch/arm64/include/asm/ptrace.h      |   1 +
 arch/arm64/include/uapi/asm/ptrace.h |   1 +
 arch/arm64/kvm/inject_fault.c        |  70 +++++++++++++++++++--
 virt/kvm/arm/aarch32.c               | 117 +++++++++++++++++++++++++++++++----
 6 files changed, 220 insertions(+), 18 deletions(-)

-- 
2.11.0


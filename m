Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C208025D746
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 13:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbgIDL3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 07:29:39 -0400
Received: from foss.arm.com ([217.140.110.172]:48870 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729897AbgIDL3I (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 07:29:08 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 966201063;
        Fri,  4 Sep 2020 04:29:07 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C635C3F71F;
        Fri,  4 Sep 2020 04:29:06 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH stable v4.9 0/4] KVM: arm64: Fix AT instruction handling
Date:   Fri,  4 Sep 2020 12:28:56 +0100
Message-Id: <20200904112900.230831-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In some architectural corner cases, AT instructions can generate an
exception, which KVM is not really ready to handle properly.
Teach the code to handle this situation gracefully.

This is a backport of the respective upstream patches to v4.9(.235).
James prepared and tested these already, but we were lacking the upstream
commit IDs so far.
I am sending this on his behalf, since he is off this week.

The original patches contained stable tags, but with a prerequisite
patch in v5.3. Patch 2/4 is a backport of this one (removing ARMv8.2 RAS
barriers, which are not supported in v4.9), patches 1/4 and 3/4
needed some massaging to apply and work on 4.9.

Cheers,
Andre.

James Morse (4):
  KVM: arm64: Add kvm_extable for vaxorcism code
  KVM: arm64: Defer guest entry when an asynchronous exception is pending
  KVM: arm64: Survive synchronous exceptions caused by AT instructions
  KVM: arm64: Set HCR_EL2.PTW to prevent AT taking synchronous exception

 arch/arm64/include/asm/kvm_arm.h |  3 +-
 arch/arm64/include/asm/kvm_asm.h | 43 ++++++++++++++++++++++
 arch/arm64/kernel/vmlinux.lds.S  |  8 ++++
 arch/arm64/kvm/hyp/entry.S       | 26 ++++++++++---
 arch/arm64/kvm/hyp/hyp-entry.S   | 63 +++++++++++++++++++++-----------
 arch/arm64/kvm/hyp/switch.c      | 39 ++++++++++++++++++--
 6 files changed, 150 insertions(+), 32 deletions(-)

-- 
2.17.1


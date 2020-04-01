Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E89719B380
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388905AbgDAQg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:36:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388900AbgDAQg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:36:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 452D620658;
        Wed,  1 Apr 2020 16:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759016;
        bh=JVZfJY6/5ALNIW2gEhKmn1RI1T33U9c2/ocITbeMS4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qv0OYuAg95qks8AoVilkFDDtTtOjvypmvisXDuWOUXFY4zyIYVFHeq5TN0S+hN07i
         nbxSTnXsPUnIVf4WKV7oQxT1MqBZFdAA4d/PN8BgCcKdgSkanMj0iwC17SwPHgbMlY
         9LEJ2/v0d+Vu5ohEQUg+rK7PoVKrUwEWpUjD5rYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 050/102] KVM: VMX: Do not allow reexecute_instruction() when skipping MMIO instr
Date:   Wed,  1 Apr 2020 18:17:53 +0200
Message-Id: <20200401161542.437929623@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
References: <20200401161530.451355388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

[ Upstream commit c4409905cd6eb42cfd06126e9226b0150e05a715 ]

Re-execution after an emulation decode failure is only intended to
handle a case where two or vCPUs race to write a shadowed page, i.e.
we should never re-execute an instruction as part of MMIO emulation.
As handle_ept_misconfig() is only used for MMIO emulation, it should
pass EMULTYPE_NO_REEXECUTE when using the emulator to skip an instr
in the fast-MMIO case where VM_EXIT_INSTRUCTION_LEN is invalid.

And because the cr2 value passed to x86_emulate_instruction() is only
destined for use when retrying or reexecuting, we can simply call
emulate_instruction().

Fixes: d391f1207067 ("x86/kvm/vmx: do not use vm-exit instruction length
                      for fast MMIO when running nested")
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 8bd336651de52..1fa4545c55e35 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -6564,8 +6564,8 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 			return 1;
 		}
 		else
-			return x86_emulate_instruction(vcpu, gpa, EMULTYPE_SKIP,
-						       NULL, 0) == EMULATE_DONE;
+			return emulate_instruction(vcpu, EMULTYPE_SKIP) ==
+								EMULATE_DONE;
 	}
 
 	ret = kvm_mmu_page_fault(vcpu, gpa, PFERR_RSVD_MASK, NULL, 0);
-- 
2.20.1




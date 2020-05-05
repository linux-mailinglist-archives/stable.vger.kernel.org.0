Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99AF1C4B7A
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 03:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgEEBXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 21:23:51 -0400
Received: from mga07.intel.com ([134.134.136.100]:22407 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726516AbgEEBXv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 21:23:51 -0400
IronPort-SDR: sunHmm+kiGumHcZf9ajMrfRs7nKkGdpMiDTlUNrV5tY9j85bg5fEpn26+A/ZdLczaoL2bTqo4k
 6WJUwC3a7MuA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 18:23:50 -0700
IronPort-SDR: 4vpPMRE6u3zAj2xA5lVwirll6SiYnhFEoN9EnQ9bsPkIXfQ3NOGjz9eRpRCdH3vtB7gi6ca927
 Njn5U3VDZ3aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,354,1583222400"; 
   d="scan'208";a="406663375"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga004.jf.intel.com with ESMTP; 04 May 2020 18:23:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Tobias Urdin <tobias.urdin@binero.com>
Subject: [PATCH 4.19 STABLE 2/2] KVM: VMX: Mark RCX, RDX and RSI as clobbered in vmx_vcpu_run()'s asm blob
Date:   Mon,  4 May 2020 18:23:48 -0700
Message-Id: <20200505012348.17099-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200505012348.17099-1-sean.j.christopherson@intel.com>
References: <20200505012348.17099-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Save RCX, RDX and RSI to fake outputs to coerce the compiler into
treating them as clobbered.  RCX in particular is likely to be reused by
the compiler to dereference the 'struct vcpu_vmx' pointer, which will
result in a null pointer dereference now that RCX is zeroed by the asm
blob.

Add ASM_CALL_CONSTRAINT to fudge around an issue where <something>
during modpost can't find vmx_return when specifying output constraints.

Reported-by: Tobias Urdin <tobias.urdin@binero.com>
Fixes: b4be98039a92 ("KVM: VMX: Zero out *all* general purpose registers after VM-Exit")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 5b06a98ffd4c..54c8b4dc750d 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -10882,7 +10882,8 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		".global vmx_return \n\t"
 		"vmx_return: " _ASM_PTR " 2b \n\t"
 		".popsection"
-	      : : "c"(vmx), "d"((unsigned long)HOST_RSP), "S"(evmcs_rsp),
+	      : ASM_CALL_CONSTRAINT, "=c"((int){0}), "=d"((int){0}), "=S"((int){0})
+	      : "c"(vmx), "d"((unsigned long)HOST_RSP), "S"(evmcs_rsp),
 		[launched]"i"(offsetof(struct vcpu_vmx, __launched)),
 		[fail]"i"(offsetof(struct vcpu_vmx, fail)),
 		[host_rsp]"i"(offsetof(struct vcpu_vmx, host_rsp)),
-- 
2.26.0


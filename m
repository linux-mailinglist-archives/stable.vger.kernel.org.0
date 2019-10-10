Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E145D256A
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388375AbfJJI7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:59:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388759AbfJJIng (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:43:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13BB121929;
        Thu, 10 Oct 2019 08:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697015;
        bh=PMFljwLuGJXhVsdndEYQp6wTHEoqjTGybZ1dfjdUdx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UlXBi0+PshpIOsY47HeXwVPFf7ddqJ2g9JV1XA0UDoj9KfYyx7zFNCNVbeg9alO6G
         wJ2zoRsFU6QkGomy2snUMkxEqm8+4J/shePvs1zuvi4FbwVNz0WOZVj5wu+HXNkzDd
         kEUGlPM58+I2XrjIG2LDo2JtYiVc64aCNmF0+uQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 137/148] KVM: nVMX: Fix consistency check on injected exception error code
Date:   Thu, 10 Oct 2019 10:36:38 +0200
Message-Id: <20191010083620.661115143@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

[ Upstream commit 567926cca99ba1750be8aae9c4178796bf9bb90b ]

Current versions of Intel's SDM incorrectly state that "bits 31:15 of
the VM-Entry exception error-code field" must be zero.  In reality, bits
31:16 must be zero, i.e. error codes are 16-bit values.

The bogus error code check manifests as an unexpected VM-Entry failure
due to an invalid code field (error number 7) in L1, e.g. when injecting
a #GP with error_code=0x9f00.

Nadav previously reported the bug[*], both to KVM and Intel, and fixed
the associated kvm-unit-test.

[*] https://patchwork.kernel.org/patch/11124749/

Reported-by: Nadav Amit <namit@vmware.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a3cba321b5c5d..61aa9421e27af 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2584,7 +2584,7 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 
 		/* VM-entry exception error code */
 		if (has_error_code &&
-		    vmcs12->vm_entry_exception_error_code & GENMASK(31, 15))
+		       vmcs12->vm_entry_exception_error_code & GENMASK(31, 16))
 			return -EINVAL;
 
 		/* VM-entry interruption-info field: reserved bits */
-- 
2.20.1




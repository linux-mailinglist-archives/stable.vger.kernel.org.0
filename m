Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81FC24F63D
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730716AbgHXI5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:57:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730208AbgHXI5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:57:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81EBD20FC3;
        Mon, 24 Aug 2020 08:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259468;
        bh=eHzawvg6Qqnr+ywSc/BhwWvuuYh7k/ZcjcKLX3gMZtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTrXLUsU8RUq5kReYrLVhGqsb3OCkQ1WE0P3j6S4JwSeeeUsuAgUS/USptrIOhN31
         ORsGeIrmETuQHaU1/dT20j97EcYYuWErSGwK1/JbkH7nXTyRosGd87rV9ZA9CfGZ4S
         GebQLx+ZOL0EjOJQeaH+Oa9/Hk6RTI8/4lvy1Cbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 52/71] kvm: x86: Toggling CR4.SMAP does not load PDPTEs in PAE mode
Date:   Mon, 24 Aug 2020 10:31:43 +0200
Message-Id: <20200824082358.503737106@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082355.848475917@linuxfoundation.org>
References: <20200824082355.848475917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

[ Upstream commit 427890aff8558eb4326e723835e0eae0e6fe3102 ]

See the SDM, volume 3, section 4.4.1:

If PAE paging would be in use following an execution of MOV to CR0 or
MOV to CR4 (see Section 4.1.1) and the instruction is modifying any of
CR0.CD, CR0.NW, CR0.PG, CR4.PAE, CR4.PGE, CR4.PSE, or CR4.SMEP; then
the PDPTEs are loaded from the address in CR3.

Fixes: 0be0226f07d14 ("KVM: MMU: fix SMAP virtualization")
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Message-Id: <20200817181655.3716509-2-jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5b2440e591fc1..ff1f764c4709a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -857,7 +857,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	unsigned long old_cr4 = kvm_read_cr4(vcpu);
 	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
-				   X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE;
+				   X86_CR4_SMEP | X86_CR4_PKE;
 
 	if (kvm_valid_cr4(vcpu, cr4))
 		return 1;
-- 
2.25.1




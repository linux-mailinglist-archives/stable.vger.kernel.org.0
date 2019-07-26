Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5D376A58
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbfGZN6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbfGZNkv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:40:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AAA722BE8;
        Fri, 26 Jul 2019 13:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148450;
        bh=KUv6mWvMSFQNA76Oz4rKb7K3b927nL2D1ipU8GAI5XQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/SPEYJuEbEZx6RNYzA8OTv0jHDxZ9n2EP5XIt62Gz3cjP75iv/miu/1ttg9bWKCX
         NGitYih94FYnPSpGOFYtQcejQTVTSR9Cmi6rVmOzyMoOf9epc2vjYo+Cn/YW5+pAVT
         plPhHwR56mprUqJ16GdmjMOJDEqbt5TtT98L3mQM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liran Alon <liran.alon@oracle.com>,
        Maxime Villard <max@m00nbsd.net>,
        Joao Martins <joao.m.martins@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 46/85] KVM: nVMX: Ignore segment base for VMX memory operand when segment not FS or GS
Date:   Fri, 26 Jul 2019 09:38:56 -0400
Message-Id: <20190726133936.11177-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liran Alon <liran.alon@oracle.com>

[ Upstream commit 6694e48012826351036fd10fc506ca880023e25f ]

As reported by Maxime at
https://bugzilla.kernel.org/show_bug.cgi?id=204175:

In vmx/nested.c::get_vmx_mem_address(), when the guest runs in long mode,
the base address of the memory operand is computed with a simple:
    *ret = s.base + off;

This is incorrect, the base applies only to FS and GS, not to the others.
Because of that, if the guest uses a VMX instruction based on DS and has
a DS.base that is non-zero, KVM wrongfully adds the base to the
resulting address.

Reported-by: Maxime Villard <max@m00nbsd.net>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 46af3a5e9209..aa949ab7850c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4068,7 +4068,10 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 		 * mode, e.g. a 32-bit address size can yield a 64-bit virtual
 		 * address when using FS/GS with a non-zero base.
 		 */
-		*ret = s.base + off;
+		if (seg_reg == VCPU_SREG_FS || seg_reg == VCPU_SREG_GS)
+			*ret = s.base + off;
+		else
+			*ret = off;
 
 		/* Long mode: #GP(0)/#SS(0) if the memory address is in a
 		 * non-canonical form. This is the only check on the memory
-- 
2.20.1


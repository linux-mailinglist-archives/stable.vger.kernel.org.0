Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D53A181CFA
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730608AbfHENXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730807AbfHENXY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:23:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 318392087B;
        Mon,  5 Aug 2019 13:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011403;
        bh=HHXGhJKti16845K2WGW8y8pgKz43cuRHFDvkze4Ljx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jWK0nsPP1D3NCVEfU64N2LwCfvjiqRahTobDDAoE90AJ/xUUDG6J7WQfl1nFXGeRn
         IpEoddnYL0y/v0TkcYHHJ+fyX7efeBqYbkVhJc6187fvhP2tkQsIu6T8HvH9gk+zzM
         3/9dls1TASCjiVq1IsH9o4E0CuDa3MrV2m4/uoAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Villard <max@m00nbsd.net>,
        Joao Martins <joao.m.martins@oracle.com>,
        Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 044/131] KVM: nVMX: Ignore segment base for VMX memory operand when segment not FS or GS
Date:   Mon,  5 Aug 2019 15:02:11 +0200
Message-Id: <20190805124954.389758698@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index ef6575ab60edc..b96723294b2f3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4087,7 +4087,10 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
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




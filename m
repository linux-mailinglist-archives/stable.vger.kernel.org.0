Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7D8333E1B
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbhCJNZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:46406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233116AbhCJNY4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DD2F64FDC;
        Wed, 10 Mar 2021 13:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382695;
        bh=SepQaMUdyw+wXVXxQkT2aGfO9aqL0FWamdd103kuQ4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lzXZt1nBvMHuiebGYbRNaZIsX/IY7RorLQQtUQx3Jm/b+eAkLmP622BszHiM0KnAA
         zerb44aSqKsHJvXi74LTKpSAuGNhwBEgcaQaXBhTppQyzmCeyuKxY9NVTFdsO3jwa+
         MbzktzBRr4kJJLmCuYN/6Xup/stBsCJyG3U2HnkA=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 34/36] KVM: SVM: Clear the CR4 register on reset
Date:   Wed, 10 Mar 2021 14:23:47 +0100
Message-Id: <20210310132321.596264492@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
References: <20210310132320.510840709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Babu Moger <babu.moger@amd.com>

[ Upstream commit 9e46f6c6c959d9bb45445c2e8f04a75324a0dfd0 ]

This problem was reported on a SVM guest while executing kexec.
Kexec fails to load the new kernel when the PCID feature is enabled.

When kexec starts loading the new kernel, it starts the process by
resetting the vCPU's and then bringing each vCPU online one by one.
The vCPU reset is supposed to reset all the register states before the
vCPUs are brought online. However, the CR4 register is not reset during
this process. If this register is already setup during the last boot,
all the flags can remain intact. The X86_CR4_PCIDE bit can only be
enabled in long mode. So, it must be enabled much later in SMP
initialization.  Having the X86_CR4_PCIDE bit set during SMP boot can
cause a boot failures.

Fix the issue by resetting the CR4 register in init_vmcb().

Signed-off-by: Babu Moger <babu.moger@amd.com>
Message-Id: <161471109108.30811.6392805173629704166.stgit@bmoger-ubuntu>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 825ef6d281c9..6a0670548125 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1205,6 +1205,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	init_sys_seg(&save->ldtr, SEG_TYPE_LDT);
 	init_sys_seg(&save->tr, SEG_TYPE_BUSY_TSS16);
 
+	svm_set_cr4(&svm->vcpu, 0);
 	svm_set_efer(&svm->vcpu, 0);
 	save->dr6 = 0xffff0ff0;
 	kvm_set_rflags(&svm->vcpu, 2);
-- 
2.30.1




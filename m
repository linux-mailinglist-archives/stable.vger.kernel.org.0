Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E117333E94
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbhCJN0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:47564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233416AbhCJNZf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3437F65022;
        Wed, 10 Mar 2021 13:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382729;
        bh=Cs4qcLhhVfzQ3eIwmM7Eq/ZqOm3G1leQKz8IcEFb7Ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dN62ONUAGDma70ioj2szrul8F+XChUk0n5sJ4VNHDyqGVl8etr+Rrpz4KeAPRFTyG
         jSVHEaF3ohHZu/kAHqHRT4SI/S10/HcI1QqD8plrWViCkhhqVjBx1iO3EvGLEY5Qd5
         x5Wj6W6XplmgOABfXD31H+Bcr7VmnYVLf1PQAI6c=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 47/49] KVM: SVM: Clear the CR4 register on reset
Date:   Wed, 10 Mar 2021 14:23:58 +0100
Message-Id: <20210310132323.425631742@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
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
index 76ab1ee0784a..642f0da31ac4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1192,6 +1192,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	init_sys_seg(&save->ldtr, SEG_TYPE_LDT);
 	init_sys_seg(&save->tr, SEG_TYPE_BUSY_TSS16);
 
+	svm_set_cr4(&svm->vcpu, 0);
 	svm_set_efer(&svm->vcpu, 0);
 	save->dr6 = 0xffff0ff0;
 	kvm_set_rflags(&svm->vcpu, 2);
-- 
2.30.1




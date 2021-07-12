Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7B73C4BDB
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238855AbhGLHAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239832AbhGLG6a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:58:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A39B7611C1;
        Mon, 12 Jul 2021 06:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072942;
        bh=jkvrJ9JJB+8IeYJsAfh6cOEFd8g4QNfThvYQZ3Jxse8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xwn8A6l195SU5j1SCn6gvdor10J6wwLAF0kRHHeOf7vRT/9JkNZg/RB0xdbIaDpl2
         3TlckaNyLJBIUXus+UCWhTEJAkvDnxwfvfi4gtoF90XqzO3DET9Grm/pUVndzzdPcZ
         4uY87LYRwfWz3y2AF0/ojgnUdTSnr3plcsBHH7XI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.12 071/700] KVM: PPC: Book3S HV: Workaround high stack usage with clang
Date:   Mon, 12 Jul 2021 08:02:34 +0200
Message-Id: <20210712060934.745734647@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 51696f39cbee5bb684e7959c0c98b5f54548aa34 upstream.

LLVM does not emit optimal byteswap assembly, which results in high
stack usage in kvmhv_enter_nested_guest() due to the inlining of
byteswap_pt_regs(). With LLVM 12.0.0:

arch/powerpc/kvm/book3s_hv_nested.c:289:6: error: stack frame size of
2512 bytes in function 'kvmhv_enter_nested_guest' [-Werror,-Wframe-larger-than=]
long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
     ^
1 error generated.

While this gets fixed in LLVM, mark byteswap_pt_regs() as
noinline_for_stack so that it does not get inlined and break the build
due to -Werror by default in arch/powerpc/. Not inlining saves
approximately 800 bytes with LLVM 12.0.0:

arch/powerpc/kvm/book3s_hv_nested.c:290:6: warning: stack frame size of
1728 bytes in function 'kvmhv_enter_nested_guest' [-Wframe-larger-than=]
long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
     ^
1 warning generated.

Cc: stable@vger.kernel.org # v4.20+
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://github.com/ClangBuiltLinux/linux/issues/1292
Link: https://bugs.llvm.org/show_bug.cgi?id=49610
Link: https://lore.kernel.org/r/202104031853.vDT0Qjqj-lkp@intel.com/
Link: https://gist.github.com/ba710e3703bf45043a31e2806c843ffd
Link: https://lore.kernel.org/r/20210621182440.990242-1-nathan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_hv_nested.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -53,7 +53,8 @@ void kvmhv_save_hv_regs(struct kvm_vcpu
 	hr->dawrx1 = vcpu->arch.dawrx1;
 }
 
-static void byteswap_pt_regs(struct pt_regs *regs)
+/* Use noinline_for_stack due to https://bugs.llvm.org/show_bug.cgi?id=49610 */
+static noinline_for_stack void byteswap_pt_regs(struct pt_regs *regs)
 {
 	unsigned long *addr = (unsigned long *) regs;
 



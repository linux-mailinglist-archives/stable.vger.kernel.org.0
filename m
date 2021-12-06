Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633A9469C66
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244631AbhLFPWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:22:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38864 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347589AbhLFPTx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:19:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CABC061309;
        Mon,  6 Dec 2021 15:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE86CC341C2;
        Mon,  6 Dec 2021 15:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803784;
        bh=Zk6/9XuCf/K0JxTpJ+5v6VZOuZ8NaXYzm3bEJP6sulc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRUv20zd7Haj+dso5HPuojtZRcNOYLWdeZnuDY5XRmxjE+ZoajV5Vyw618kOYmhK/
         6vcndQ8L5X1tcSVN0UUt/AZ8Ba+bqUCnb+3jlnXUo8qXnvfjtZq0FSRCF3Q+PE9lXI
         0jjRs5bBprjm0VJM4pJ9NM79/C/ankopzV2Mu9Ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 046/130] KVM: X86: Use vcpu->arch.walk_mmu for kvm_mmu_invlpg()
Date:   Mon,  6 Dec 2021 15:56:03 +0100
Message-Id: <20211206145601.270247478@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

commit 05b29633c7a956d5675f5fbba70db0d26aa5e73e upstream.

INVLPG operates on guest virtual address, which are represented by
vcpu->arch.walk_mmu.  In nested virtualization scenarios,
kvm_mmu_invlpg() was using the wrong MMU structure; if L2's invlpg were
emulated by L0 (in practice, it hardly happen) when nested two-dimensional
paging is enabled, the call to ->tlb_flush_gva() would be skipped and
the hardware TLB entry would not be invalidated.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Message-Id: <20211124122055.64424-5-jiangshanlai@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5152,7 +5152,7 @@ EXPORT_SYMBOL_GPL(kvm_mmu_invalidate_gva
 
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 {
-	kvm_mmu_invalidate_gva(vcpu, vcpu->arch.mmu, gva, INVALID_PAGE);
+	kvm_mmu_invalidate_gva(vcpu, vcpu->arch.walk_mmu, gva, INVALID_PAGE);
 	++vcpu->stat.invlpg;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_invlpg);



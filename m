Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 614E1167767
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730366AbgBUHzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:55:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:55010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730396AbgBUHzx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:55:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5933220578;
        Fri, 21 Feb 2020 07:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271752;
        bh=tO4IK6qaQxYUSnNMvJsU3p6KHsQXd6nqqTonDg5LQMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BqeVTRZvO1JExQHk+bmIAknu10zmiMvy6j8TawXO5+SGtdIR45hhD2Qe1VGF8Ot6o
         F5s1SvF0njh/AI0AgJm/OLRU+4n3ZId74TnF5rEqE++svYVg0R0lklioVn7KFSF850
         h2yVi/fAnrfPFulNL6c3n3liqENsQiY2VAD7y7bM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        zhengbin <zhengbin13@huawei.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 286/399] KVM: PPC: Remove set but not used variable ra, rs, rt
Date:   Fri, 21 Feb 2020 08:40:11 +0100
Message-Id: <20200221072429.676540281@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

[ Upstream commit 4de0a8355463e068e443b48eb5ae32370155368b ]

Fixes gcc '-Wunused-but-set-variable' warning:

arch/powerpc/kvm/emulate_loadstore.c: In function kvmppc_emulate_loadstore:
arch/powerpc/kvm/emulate_loadstore.c:87:6: warning: variable ra set but not used [-Wunused-but-set-variable]
arch/powerpc/kvm/emulate_loadstore.c: In function kvmppc_emulate_loadstore:
arch/powerpc/kvm/emulate_loadstore.c:87:10: warning: variable rs set but not used [-Wunused-but-set-variable]
arch/powerpc/kvm/emulate_loadstore.c: In function kvmppc_emulate_loadstore:
arch/powerpc/kvm/emulate_loadstore.c:87:14: warning: variable rt set but not used [-Wunused-but-set-variable]

They are not used since commit 2b33cb585f94 ("KVM: PPC: Reimplement
LOAD_FP/STORE_FP instruction mmio emulation with analyse_instr() input")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/emulate_loadstore.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/powerpc/kvm/emulate_loadstore.c b/arch/powerpc/kvm/emulate_loadstore.c
index 2e496eb86e94a..1139bc56e0045 100644
--- a/arch/powerpc/kvm/emulate_loadstore.c
+++ b/arch/powerpc/kvm/emulate_loadstore.c
@@ -73,7 +73,6 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
 	u32 inst;
-	int ra, rs, rt;
 	enum emulation_result emulated = EMULATE_FAIL;
 	int advance = 1;
 	struct instruction_op op;
@@ -85,10 +84,6 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
 	if (emulated != EMULATE_DONE)
 		return emulated;
 
-	ra = get_ra(inst);
-	rs = get_rs(inst);
-	rt = get_rt(inst);
-
 	vcpu->arch.mmio_vsx_copy_nums = 0;
 	vcpu->arch.mmio_vsx_offset = 0;
 	vcpu->arch.mmio_copy_type = KVMPPC_VSX_COPY_NONE;
-- 
2.20.1




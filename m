Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47852690764
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbjBIL2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbjBIL1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:27:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86E565649;
        Thu,  9 Feb 2023 03:20:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8843361A27;
        Thu,  9 Feb 2023 11:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110E7C433EF;
        Thu,  9 Feb 2023 11:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941652;
        bh=uUkQEsr+Rdp2Pn4ydEpr+sNK4XpANd+CHj0yGVJe8qM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WtKBZlDpQ/QbPLHfsyb3M9/Z3DDPEL2xj6xjsFP/lAcf7ofZrimSnHjC2B2UJlyZR
         6YJdYCy2BNdPmZiU4eAlusUhNGiVgUjv1ozCP8p5bXGhCd11FqFKkQv6qnO0LqENe+
         qiEdqAA5UCXxDLH2aFet4S+IIDEu/2y2YJBpkuVATt4NjXMZ9+GjtbR1gJb2oBiG4Z
         4MBrO3Z89VwrolqJ1MTM4icumtcrSMLS0nsbUgUy4HiE3hn7dUS9njUgLv22owFILY
         5VSNjCgwbfHMhMJSSvrcR3DQZGODUSo+WfQtebpkNhxMfk4HbZpm9hswEDoCW3kFjD
         zpWzLtZptCU6g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sathvika Vasireddy <sv@linux.ibm.com>,
        kernel test robot <lkp@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, pbonzini@redhat.com,
        maz@kernel.org, npiggin@gmail.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 4/5] powerpc/kvm: Fix unannotated intra-function call warning
Date:   Thu,  9 Feb 2023 06:20:26 -0500
Message-Id: <20230209112042.1893375-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209112042.1893375-1-sashal@kernel.org>
References: <20230209112042.1893375-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sathvika Vasireddy <sv@linux.ibm.com>

[ Upstream commit fe6de81b610e5d0b9d2231acff2de74a35482e7d ]

objtool throws the following warning:
  arch/powerpc/kvm/booke.o: warning: objtool: kvmppc_fill_pt_regs+0x30:
  unannotated intra-function call

Fix the warning by setting the value of 'nip' using the _THIS_IP_ macro,
without using an assembly bl/mflr sequence to save the instruction
pointer.

Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sathvika Vasireddy <sv@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230128124158.1066251-1-sv@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/booke.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 071b87ee682f8..8a202636676f9 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -888,16 +888,15 @@ static int kvmppc_handle_debug(struct kvm_run *run, struct kvm_vcpu *vcpu)
 
 static void kvmppc_fill_pt_regs(struct pt_regs *regs)
 {
-	ulong r1, ip, msr, lr;
+	ulong r1, msr, lr;
 
 	asm("mr %0, 1" : "=r"(r1));
 	asm("mflr %0" : "=r"(lr));
 	asm("mfmsr %0" : "=r"(msr));
-	asm("bl 1f; 1: mflr %0" : "=r"(ip));
 
 	memset(regs, 0, sizeof(*regs));
 	regs->gpr[1] = r1;
-	regs->nip = ip;
+	regs->nip = _THIS_IP_;
 	regs->msr = msr;
 	regs->link = lr;
 }
-- 
2.39.0


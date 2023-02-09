Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09CC69068A
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjBILSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjBILRR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:17:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E945ACD7;
        Thu,  9 Feb 2023 03:16:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89355B82100;
        Thu,  9 Feb 2023 11:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DD6C433EF;
        Thu,  9 Feb 2023 11:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941378;
        bh=JxdWKWPLHiNRk+4uiOKNM9sRYrkNNNAb49VAHKAv23U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qXONRxFS8dFnzHOeI02GYVqr52vBNvw+CGIum9fXq4LJDBenP8AXKRK0xjYVOK0W1
         3rdPv67NYPxOyEMZ0GCQW3llzyqsazhexwA7wIy0wOt1oMMF2yLxsC75IQuoFefW6Z
         h9Cz4pSHhCMZ7LKj601I7rqdtK/yZUqHTRL0qFza4w2CPKYsglI6Vj32Vb+5dfPa+7
         FCNvUsQQr50Ox2q6z1g+oetz7TmQk8lDWBM5OeOZEK2+gK95Ye6OR5AeldJn5GCl8V
         gOG9N0RrjW8iMMTXI0zmtc6EiKxUM/2+VFMCBgURuIE3ISZcNmHdK7hg3Ueu8eKiJ2
         6vFkOO3jGnSuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sathvika Vasireddy <sv@linux.ibm.com>,
        kernel test robot <lkp@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, pbonzini@redhat.com,
        seanjc@google.com, npiggin@gmail.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.1 18/38] powerpc/kvm: Fix unannotated intra-function call warning
Date:   Thu,  9 Feb 2023 06:14:37 -0500
Message-Id: <20230209111459.1891941-18-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111459.1891941-1-sashal@kernel.org>
References: <20230209111459.1891941-1-sashal@kernel.org>
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
index 7b4920e9fd263..3852209989f04 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -912,16 +912,15 @@ static int kvmppc_handle_debug(struct kvm_vcpu *vcpu)
 
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


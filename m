Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E29F6906F6
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjBILWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbjBILVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:21:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B945ACF2;
        Thu,  9 Feb 2023 03:18:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 94841CE246E;
        Thu,  9 Feb 2023 11:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3014CC4339B;
        Thu,  9 Feb 2023 11:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941489;
        bh=UT29xroFmNA4NXgchhR/19LZ6IaWIrpB7tNSnEi/wCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HXxmp1XDpE029/aC2rjrt5i565U8xs1/d0AJ86y2dN9AkkoG4zgzc4JhL8Da063QK
         pKs3q+4NPOBNo45fujLUniqAQoFPOV/WAMyYcQNWtSjslNHiiq27J1YlDclDSCjHEO
         05PxP2eAF5CvmVnvQkohPv6HbwaxUMk40Dpx4nQ27ApiR0IQfnFLEuuXUlWXs8R3f9
         NWpEqiK4m5oSC02MIV7H3jqaZ7zAAOstyUS0KNdhXeRG/+fPKDtdGyETJRu4VBNwGv
         kzhDon3N2aU5n0oNWsy3M4Vsamm1Kdwzu+fP3hRR6mqtToFdAJ7RlWCRVMKjgo22Cb
         oE/yEzotbcQvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sathvika Vasireddy <sv@linux.ibm.com>,
        kernel test robot <lkp@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, christophe.leroy@csgroup.eu,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.15 09/17] powerpc/85xx: Fix unannotated intra-function call warning
Date:   Thu,  9 Feb 2023 06:17:21 -0500
Message-Id: <20230209111731.1892569-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111731.1892569-1-sashal@kernel.org>
References: <20230209111731.1892569-1-sashal@kernel.org>
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

[ Upstream commit 8afffce6aa3bddc940ac1909627ff1e772b6cbf1 ]

objtool throws the following warning:
  arch/powerpc/kernel/head_85xx.o: warning: objtool: .head.text+0x1a6c:
  unannotated intra-function call

Fix the warning by annotating KernelSPE symbol with SYM_FUNC_START_LOCAL
and SYM_FUNC_END macros.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sathvika Vasireddy <sv@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230128124138.1066176-1-sv@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/head_fsl_booke.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/head_fsl_booke.S b/arch/powerpc/kernel/head_fsl_booke.S
index 0a9a0f301474d..5cb599c42b597 100644
--- a/arch/powerpc/kernel/head_fsl_booke.S
+++ b/arch/powerpc/kernel/head_fsl_booke.S
@@ -849,7 +849,7 @@ _GLOBAL(load_up_spe)
  * SPE unavailable trap from kernel - print a message, but let
  * the task use SPE in the kernel until it returns to user mode.
  */
-KernelSPE:
+SYM_FUNC_START_LOCAL(KernelSPE)
 	lwz	r3,_MSR(r1)
 	oris	r3,r3,MSR_SPE@h
 	stw	r3,_MSR(r1)	/* enable use of SPE after return */
@@ -866,6 +866,7 @@ KernelSPE:
 #endif
 	.align	4,0
 
+SYM_FUNC_END(KernelSPE)
 #endif /* CONFIG_SPE */
 
 /*
-- 
2.39.0


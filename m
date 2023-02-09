Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83942690771
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbjBIL3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjBIL2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:28:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67236ADCC;
        Thu,  9 Feb 2023 03:21:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD35661A2F;
        Thu,  9 Feb 2023 11:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533F7C43442;
        Thu,  9 Feb 2023 11:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941623;
        bh=W6MQMq/vWq0GqHIEotcX2c7hywazkBraHo3opyqlDqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ikl/e6iJI5eto30aujHwdC9yy4sGw3SOF57y4AfThbFlnPaLCSghuWnRvu/p5I2YI
         y2cgxpdvzdHXA8UR9uic1T1Juv7eSkIqxkyh63pqaNqfx5eQm9YFRSFQpne2HbDW48
         +oTquLTWBCnFPSjhqdTXSDu+Thb+MGkQqPGSuVg3szXzg3u2d+UxMO4OIB98bpZTVm
         kjuTyhY3Uav1XgBb5KMV7rDJYr3R7FeWUxgOIUidGF42W9xcN35a6DvdeG61Z86dhq
         5kHyliTdVaei2BeIFGfW1Gl9fXrnRZZ1NTuWcRGsDLojCYaIIp2Lz6QHqhxOrp6M8r
         vypIjuxJvN8wQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sathvika Vasireddy <sv@linux.ibm.com>,
        kernel test robot <lkp@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, christophe.leroy@csgroup.eu,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 4/6] powerpc/85xx: Fix unannotated intra-function call warning
Date:   Thu,  9 Feb 2023 06:19:57 -0500
Message-Id: <20230209111959.1893269-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111959.1893269-1-sashal@kernel.org>
References: <20230209111959.1893269-1-sashal@kernel.org>
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
index 2386ce2a9c6e4..1c8097fc75fff 100644
--- a/arch/powerpc/kernel/head_fsl_booke.S
+++ b/arch/powerpc/kernel/head_fsl_booke.S
@@ -889,7 +889,7 @@ _GLOBAL(load_up_spe)
  * SPE unavailable trap from kernel - print a message, but let
  * the task use SPE in the kernel until it returns to user mode.
  */
-KernelSPE:
+SYM_FUNC_START_LOCAL(KernelSPE)
 	lwz	r3,_MSR(r1)
 	oris	r3,r3,MSR_SPE@h
 	stw	r3,_MSR(r1)	/* enable use of SPE after return */
@@ -906,6 +906,7 @@ KernelSPE:
 #endif
 	.align	4,0
 
+SYM_FUNC_END(KernelSPE)
 #endif /* CONFIG_SPE */
 
 /*
-- 
2.39.0


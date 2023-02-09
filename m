Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C9769072D
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjBILZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjBILXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:23:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0A47683;
        Thu,  9 Feb 2023 03:19:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2B80B82104;
        Thu,  9 Feb 2023 11:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0942C433EF;
        Thu,  9 Feb 2023 11:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941545;
        bh=nwqLXU+aWd9ElT10Bp8VzjvqLJbXYNf+MZBprxRS75I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXLjNJC5h2t/j4Q9cIwmZLAmXUjI7CnIVFKm7TzYa8CGzQs4xl4DPXxv+HyUlarci
         F2kekaZO43wwhjGEjqBqkwYLDWE83tk4XmOU3HdidCb9FH2T29JCH0DluK7tk2UVYn
         MdbyO8NSs18NO5uB1i6RR8Y57hrzBuubBcToSkCKo3jF+IMmbO7eaIKT2rcWhHZCLW
         2PP6dDiW9uwD3w8ypHEd9TrBkToYO3g1jNsuQ+czZ5VZfkCRE85Col2WR0dlDE1wmW
         dA7NL4kZ9C95j3C1GvRrS/gaZj2Uv8eyv1WC/A90iJCpmMTvGREXG5nD4IDYS2YQt9
         SUXjdA/mpPWNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sathvika Vasireddy <sv@linux.ibm.com>,
        kernel test robot <lkp@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, christophe.leroy@csgroup.eu,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 07/13] powerpc/85xx: Fix unannotated intra-function call warning
Date:   Thu,  9 Feb 2023 06:18:25 -0500
Message-Id: <20230209111833.1892896-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111833.1892896-1-sashal@kernel.org>
References: <20230209111833.1892896-1-sashal@kernel.org>
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
index 586a6ac501e97..f8ad833506c9e 100644
--- a/arch/powerpc/kernel/head_fsl_booke.S
+++ b/arch/powerpc/kernel/head_fsl_booke.S
@@ -883,7 +883,7 @@ _GLOBAL(load_up_spe)
  * SPE unavailable trap from kernel - print a message, but let
  * the task use SPE in the kernel until it returns to user mode.
  */
-KernelSPE:
+SYM_FUNC_START_LOCAL(KernelSPE)
 	lwz	r3,_MSR(r1)
 	oris	r3,r3,MSR_SPE@h
 	stw	r3,_MSR(r1)	/* enable use of SPE after return */
@@ -900,6 +900,7 @@ KernelSPE:
 #endif
 	.align	4,0
 
+SYM_FUNC_END(KernelSPE)
 #endif /* CONFIG_SPE */
 
 /*
-- 
2.39.0


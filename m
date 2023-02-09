Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB81690687
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjBILR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjBILRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:17:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA156F219;
        Thu,  9 Feb 2023 03:16:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 006B261A24;
        Thu,  9 Feb 2023 11:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CFEC433D2;
        Thu,  9 Feb 2023 11:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941375;
        bh=hQMzHQye1dp7hTkzVYaYvChEqpgrVfmuVlzE9kYeWX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eKUoJ3yB5eW+z5zrttLCk8UCPppGGyl/eAaB6S234Wn9guqjH30V9GYKLJmbQxM42
         mr6j2bDy8UeqFeNHTWmi14epGLyh2Uhmw9PYz08KpRbOWXrppuiGAToU0JHFcivpI1
         NgH5Vl6zvgmSKrkXSfP+N7y7P8daldnJea8QzckdPDIelx86cC0O+XkHBg/blYyZtP
         Y2avLd3IaF2NU1ohTmzjYuQfTAeLz64IaloHD4L0qOC3qhecRwSWKEbejd1zJ3svs9
         swT0HeG5HjJ7KZGNI0tY9zBGy0vM0q/s98dy4MAcY8lqcXNN4B54Bw56ucIWjE/7HY
         lShXsmmSHKX2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sathvika Vasireddy <sv@linux.ibm.com>,
        kernel test robot <lkp@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, christophe.leroy@csgroup.eu,
        npiggin@gmail.com, naveen.n.rao@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.1 17/38] powerpc/85xx: Fix unannotated intra-function call warning
Date:   Thu,  9 Feb 2023 06:14:36 -0500
Message-Id: <20230209111459.1891941-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111459.1891941-1-sashal@kernel.org>
References: <20230209111459.1891941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
 arch/powerpc/kernel/head_85xx.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/head_85xx.S b/arch/powerpc/kernel/head_85xx.S
index 52c0ab416326a..d3939849f4550 100644
--- a/arch/powerpc/kernel/head_85xx.S
+++ b/arch/powerpc/kernel/head_85xx.S
@@ -862,7 +862,7 @@ _GLOBAL(load_up_spe)
  * SPE unavailable trap from kernel - print a message, but let
  * the task use SPE in the kernel until it returns to user mode.
  */
-KernelSPE:
+SYM_FUNC_START_LOCAL(KernelSPE)
 	lwz	r3,_MSR(r1)
 	oris	r3,r3,MSR_SPE@h
 	stw	r3,_MSR(r1)	/* enable use of SPE after return */
@@ -879,6 +879,7 @@ KernelSPE:
 #endif
 	.align	4,0
 
+SYM_FUNC_END(KernelSPE)
 #endif /* CONFIG_SPE */
 
 /*
-- 
2.39.0


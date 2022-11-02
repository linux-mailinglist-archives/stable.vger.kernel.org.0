Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8B0615838
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiKBCr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbiKBCrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:47:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32F42182D
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:47:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C79EB8206C
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258A8C433D6;
        Wed,  2 Nov 2022 02:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357240;
        bh=PrPjAuot/Me1QKPS4+hqJUcN0kqV5mapkhkXWbOIwWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2sMfzzFPnQXVzIp0JgaVoD1IP4yatFOoOY8eVZorYI2G5kELknoh3fR1F4taR7Tl
         cL4vS4P1gE9X7ErobWJAy8CaSYxBFqgoTesfXfriYuRXpigVJWTqaMFnBZlK+01qha
         6k1ztzv7OwPOgOBeWUTH+w9HJZT+CFp8AlFo1CA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, neelnatu@google.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 137/240] x86/fpu: Configure init_fpstate attributes orderly
Date:   Wed,  2 Nov 2022 03:31:52 +0100
Message-Id: <20221102022114.477692651@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chang S. Bae <chang.seok.bae@intel.com>

[ Upstream commit c32d7cab57e3a77af8ecc17cde7a5761a26483b8 ]

The init_fpstate setup code is spread out and out of order. The init image
is recorded before its scoped features and the buffer size are determined.

Determine the scope of init_fpstate components and its size before
recording the init state. Also move the relevant code together.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: neelnatu@google.com
Link: https://lore.kernel.org/r/20220824191223.1248-2-chang.seok.bae@intel.com
Stable-dep-of: d3e021adac7c ("x86/fpu: Fix the init_fpstate size check with the actual size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/fpu/init.c   | 8 --------
 arch/x86/kernel/fpu/xstate.c | 6 +++++-
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 621f4b6cac4a..8946f89761cc 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -210,13 +210,6 @@ static void __init fpu__init_system_xstate_size_legacy(void)
 	fpstate_reset(&current->thread.fpu);
 }
 
-static void __init fpu__init_init_fpstate(void)
-{
-	/* Bring init_fpstate size and features up to date */
-	init_fpstate.size		= fpu_kernel_cfg.max_size;
-	init_fpstate.xfeatures		= fpu_kernel_cfg.max_features;
-}
-
 /*
  * Called on the boot CPU once per system bootup, to set up the initial
  * FPU state that is later cloned into all processes:
@@ -236,5 +229,4 @@ void __init fpu__init_system(struct cpuinfo_x86 *c)
 	fpu__init_system_xstate_size_legacy();
 	fpu__init_system_xstate(fpu_kernel_cfg.max_size);
 	fpu__init_task_struct_size();
-	fpu__init_init_fpstate();
 }
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index c8340156bfd2..f0ce10620ab0 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -360,7 +360,7 @@ static void __init setup_init_fpu_buf(void)
 
 	print_xstate_features();
 
-	xstate_init_xcomp_bv(&init_fpstate.regs.xsave, fpu_kernel_cfg.max_features);
+	xstate_init_xcomp_bv(&init_fpstate.regs.xsave, init_fpstate.xfeatures);
 
 	/*
 	 * Init all the features state with header.xfeatures being 0x0
@@ -875,6 +875,10 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 	update_regset_xstate_info(fpu_user_cfg.max_size,
 				  fpu_user_cfg.max_features);
 
+	/* Bring init_fpstate size and features up to date */
+	init_fpstate.size		= fpu_kernel_cfg.max_size;
+	init_fpstate.xfeatures		= fpu_kernel_cfg.max_features;
+
 	setup_init_fpu_buf();
 
 	/*
-- 
2.35.1




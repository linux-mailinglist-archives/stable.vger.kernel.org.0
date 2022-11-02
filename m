Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F74615839
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbiKBCrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiKBCra (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:47:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC3821822
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:47:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94993B8206C
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F5AC433D6;
        Wed,  2 Nov 2022 02:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357247;
        bh=tCf5rG/h/6/aUqsXCcJal3Vnhg3LW1thM2ItTkEteA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLC5BkokQYyuBXDjMmny05xOBs4R9djOhKbdJhmh/rBKqd2YWha4jhxW1jnb/fdzl
         wVdquXmRmFAoNXX7xFgED63jmwc7DWJbtW8skwcxQIoLEp6bCMadi5raWcaC+kefIS
         uTdnMzvzy+/ueMn1oSLvOnEThLUZlF/ZwsQKkqw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 138/240] x86/fpu: Fix the init_fpstate size check with the actual size
Date:   Wed,  2 Nov 2022 03:31:53 +0100
Message-Id: <20221102022114.499640069@linuxfoundation.org>
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

[ Upstream commit d3e021adac7c51a26d9ede167c789fcc1b878467 ]

The init_fpstate buffer is statically allocated. Thus, the sanity test was
established to check whether the pre-allocated buffer is enough for the
calculated size or not.

The currently measured size is not strictly relevant. Fix to validate the
calculated init_fpstate size with the pre-allocated area.

Also, replace the sanity check function with open code for clarity. The
abstraction itself and the function naming do not tend to represent simply
what it does.

Fixes: 2ae996e0c1a3 ("x86/fpu: Calculate the default sizes independently")
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20220824191223.1248-3-chang.seok.bae@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/fpu/xstate.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index f0ce10620ab0..f5ef78633b4c 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -678,20 +678,6 @@ static unsigned int __init get_xsave_size_user(void)
 	return ebx;
 }
 
-/*
- * Will the runtime-enumerated 'xstate_size' fit in the init
- * task's statically-allocated buffer?
- */
-static bool __init is_supported_xstate_size(unsigned int test_xstate_size)
-{
-	if (test_xstate_size <= sizeof(init_fpstate.regs))
-		return true;
-
-	pr_warn("x86/fpu: xstate buffer too small (%zu < %d), disabling xsave\n",
-			sizeof(init_fpstate.regs), test_xstate_size);
-	return false;
-}
-
 static int __init init_xstate_size(void)
 {
 	/* Recompute the context size for enabled features: */
@@ -717,10 +703,6 @@ static int __init init_xstate_size(void)
 	kernel_default_size =
 		xstate_calculate_size(fpu_kernel_cfg.default_features, compacted);
 
-	/* Ensure we have the space to store all default enabled features. */
-	if (!is_supported_xstate_size(kernel_default_size))
-		return -EINVAL;
-
 	if (!paranoid_xstate_size_valid(kernel_size))
 		return -EINVAL;
 
@@ -879,6 +861,12 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 	init_fpstate.size		= fpu_kernel_cfg.max_size;
 	init_fpstate.xfeatures		= fpu_kernel_cfg.max_features;
 
+	if (init_fpstate.size > sizeof(init_fpstate.regs)) {
+		pr_warn("x86/fpu: init_fpstate buffer too small (%zu < %d), disabling XSAVE\n",
+			sizeof(init_fpstate.regs), init_fpstate.size);
+		goto out_disable;
+	}
+
 	setup_init_fpu_buf();
 
 	/*
-- 
2.35.1




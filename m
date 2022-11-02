Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3FF61583C
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiKBCrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbiKBCrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:47:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AC62180D
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:47:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D10A617A9
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4399CC433D6;
        Wed,  2 Nov 2022 02:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357259;
        bh=c5Al9X0yf22zZXheUJCy4tdEcOG/qOUoEDDG9Jhzu6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZRew/509StWsLwemphFbjYAMu0tpC+DG5fpKQoDdr3rlvP0DQSjTFHkPfKG9I7tMt
         PaXssIM8ejjhIxIfVcMTN7YkxKUx0HSLqdBFoO3bo5moh9k3az3IxZSDHI6/fWoEGp
         zAzcEdwSumKuEoISAZzfLdjjk1FPoX3sAC3l3H6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lin X Wang <lin.x.wang@intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 139/240] x86/fpu: Exclude dynamic states from init_fpstate
Date:   Wed,  2 Nov 2022 03:31:54 +0100
Message-Id: <20221102022114.521546203@linuxfoundation.org>
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

[ Upstream commit a401f45e38754953c9d402f8b3bc965707eecc91 ]

== Background ==

The XSTATE init code initializes all enabled and supported components.
Then, the init states are saved in the init_fpstate buffer that is
statically allocated in about one page.

The AMX TILE_DATA state is large (8KB) but its init state is zero. And the
feature comes only with the compacted format with these established
dependencies: AMX->XFD->XSAVES. So this state is excludable from
init_fpstate.

== Problem ==

But the buffer is formatted to include that large state. Then, this can be
the cause of a noisy splat like the below.

This came from XRSTORS for the task with init_fpstate in its XSAVE buffer.
It is reproducible on AMX systems when the running kernel is built with
CONFIG_DEBUG_PAGEALLOC=y and CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT=y:

 Bad FPU state detected at restore_fpregs_from_fpstate+0x57/0xd0, reinitializing FPU registers.
 ...
 RIP: 0010:restore_fpregs_from_fpstate+0x57/0xd0
  ? restore_fpregs_from_fpstate+0x45/0xd0
  switch_fpu_return+0x4e/0xe0
  exit_to_user_mode_prepare+0x17b/0x1b0
  syscall_exit_to_user_mode+0x29/0x40
  do_syscall_64+0x67/0x80
  ? do_syscall_64+0x67/0x80
  ? exc_page_fault+0x86/0x180
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

== Solution ==

Adjust init_fpstate to exclude dynamic states. XRSTORS from init_fpstate
still initializes those states when their bits are set in the
requested-feature bitmap.

Fixes: 2308ee57d93d ("x86/fpu/amx: Enable the AMX feature in 64-bit mode")
Reported-by: Lin X Wang <lin.x.wang@intel.com>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Lin X Wang <lin.x.wang@intel.com>
Link: https://lore.kernel.org/r/20220824191223.1248-4-chang.seok.bae@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/fpu/xstate.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index f5ef78633b4c..e77cabfa802f 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -857,9 +857,12 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 	update_regset_xstate_info(fpu_user_cfg.max_size,
 				  fpu_user_cfg.max_features);
 
-	/* Bring init_fpstate size and features up to date */
-	init_fpstate.size		= fpu_kernel_cfg.max_size;
-	init_fpstate.xfeatures		= fpu_kernel_cfg.max_features;
+	/*
+	 * init_fpstate excludes dynamic states as they are large but init
+	 * state is zero.
+	 */
+	init_fpstate.size		= fpu_kernel_cfg.default_size;
+	init_fpstate.xfeatures		= fpu_kernel_cfg.default_features;
 
 	if (init_fpstate.size > sizeof(init_fpstate.regs)) {
 		pr_warn("x86/fpu: init_fpstate buffer too small (%zu < %d), disabling XSAVE\n",
-- 
2.35.1




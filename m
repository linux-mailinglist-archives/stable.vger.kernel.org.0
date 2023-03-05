Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F4F6AB028
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 14:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjCENx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 08:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjCENxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 08:53:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C4D1588F;
        Sun,  5 Mar 2023 05:52:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE1A660B0D;
        Sun,  5 Mar 2023 13:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FAF7C433D2;
        Sun,  5 Mar 2023 13:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678024362;
        bh=XXhWnAJ1mPexiyOnY6ivwMe4/AfJL2NSd6aZbOxjhik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KwNdJU+s2jOo6rkPmPWbwrqnwXNi5KXKV1EjC0H4x8DzyTQBIdfBTOYepnns0Y6T/
         +XLSKmH8DjoiX/ediDp5qQMnH2nXxS6BFSjarJYGulZ/NDnlbgYxw6hFhizOyJQBAN
         uwFNh1WKLAqz4YE6ztWlcNYh0gophhmewsR/IOKiI2BPvY1vUg+msTQe8XPstIAaX7
         oNGfGUIZF9GU49uVo6fdvQtJ515nMKKiNnXm4G0aJAt5qhpEFmMNZl+2OQv0uZnvnH
         9/bpT3x4GT28lr/lsMVaodzWXygd85EbB4fCTMhTxU0LkvyEn982zt/aP5D4Mcf/FI
         IZF0WAyQHOOcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, christophe.leroy@csgroup.eu,
        pmladek@suse.com, mbenes@suse.cz, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.2 10/16] powerpc/64: Fix task_cpu in early boot when booting non-zero cpuid
Date:   Sun,  5 Mar 2023 08:52:01 -0500
Message-Id: <20230305135207.1793266-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305135207.1793266-1-sashal@kernel.org>
References: <20230305135207.1793266-1-sashal@kernel.org>
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

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 9fa24404f5044967753a6cd3e5e36f57686bec6e ]

powerpc/64 can boot on a non-zero SMP processor id. Initially, the boot
CPU is said to be "assumed to be 0" until early_init_devtree() discovers
the id from the device tree. That is not a good description because the
assumption can be wrong and that has to be handled, the better
description is that 0 is used as a placeholder, and things are fixed
after the real id is discovered.

smp_processor_id() is set to the boot cpuid, but task_cpu(current) is
not, which causes the smp_processor_id() == task_cpu(current) invariant
to be broken until init_idle() in sched_init().

This is quite fragile and could lead to subtle bugs in future. One bug
is that validate_sp_size uses task_cpu() to get the process stack, so
any stack trace from the booting CPU between early_init_devtree()
and sched_init() will have problems. Early on paca_ptrs[0] will be
poisoned, so that can cause machine checks dereferencing that memory
in real mode. Later, validating the current stack pointer against the
idle task of a different secondary will probably cause no stack trace
to be printed.

Fix this by setting thread_info->cpu right after smp_processor_id() is
set to the boot cpuid.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
[mpe: Fix SMP=n build as reported by sfr]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221216115930.2667772-3-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/setup_64.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index a0dee7354fe6b..a43865e0fb4bf 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -396,6 +396,11 @@ void __init early_setup(unsigned long dt_ptr)
 	}
 	fixup_boot_paca(paca_ptrs[boot_cpuid]);
 	setup_paca(paca_ptrs[boot_cpuid]); /* install the paca into registers */
+	// smp_processor_id() now reports boot_cpuid
+
+#ifdef CONFIG_SMP
+	task_thread_info(current)->cpu = boot_cpuid; // fix task_cpu(current)
+#endif
 
 	/*
 	 * Configure exception handlers. This include setting up trampolines
-- 
2.39.2


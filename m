Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1736BB365
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbjCOMoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbjCOMn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:43:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D5EA4B3C
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:42:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E1BAB81E05
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB874C4339B;
        Wed, 15 Mar 2023 12:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884155;
        bh=XXhWnAJ1mPexiyOnY6ivwMe4/AfJL2NSd6aZbOxjhik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WGQWvF/HpZtbP/5r+dh9VtFtEnxNlRAul3UAJ7phbrDqof3UF5Jip4l1miwijwlcn
         DoP5FZF2A0sf/A6+Bvvzq0zb8sxQzSwMSmUecPUn/3QHjnohG6xnipcbkc+3OnZBOG
         TR1HUEMIbcpIymQkS7WyjfQzeV70H54oGR8JpGsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 126/141] powerpc/64: Fix task_cpu in early boot when booting non-zero cpuid
Date:   Wed, 15 Mar 2023 13:13:49 +0100
Message-Id: <20230315115743.826453024@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D7347AD31
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236258AbhLTOuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:50:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38042 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236463AbhLTOtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:49:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74467611A4;
        Mon, 20 Dec 2021 14:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C952C36AEA;
        Mon, 20 Dec 2021 14:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011755;
        bh=1+ZTRF3+8NGjaT7/hkS3eY+fxbWr4+MMtKRkyA50sUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jhlff5uQEZtgVMqTv75+G5rRxyNTipuaSOEpBmkTSHz17CA7RzVYJAoVjHxpeLSTj
         cLdDPFpzLryRkVu3ahZnHlNB6Ar8s2yMcJ5k4iG0Sf5X0BxnQZhfQK5c/N6tiaSc0V
         Q1TLQFb2+gDJ2apjl4K8gYMY2WJUEB2YCrpp2auY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Kennedy <hurricos@gmail.com>,
        Xiaoming Ni <nixiaoming@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 63/99] powerpc/85xx: Fix oops when CONFIG_FSL_PMC=n
Date:   Mon, 20 Dec 2021 15:34:36 +0100
Message-Id: <20211220143031.515548548@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoming Ni <nixiaoming@huawei.com>

[ Upstream commit 3dc709e518b47386e6af937eaec37bb36539edfd ]

When CONFIG_FSL_PMC is set to n, no value is assigned to cpu_up_prepare
in the mpc85xx_pm_ops structure. As a result, oops is triggered in
smp_85xx_start_cpu().

  smp: Bringing up secondary CPUs ...
  kernel tried to execute user page (0) - exploit attempt? (uid: 0)
  BUG: Unable to handle kernel instruction fetch (NULL pointer?)
  Faulting instruction address: 0x00000000
  Oops: Kernel access of bad area, sig: 11 [#1]
  ...
  NIP [00000000] 0x0
  LR [c0021d2c] smp_85xx_kick_cpu+0xe8/0x568
  Call Trace:
  [c1051da8] [c0021cb8] smp_85xx_kick_cpu+0x74/0x568 (unreliable)
  [c1051de8] [c0011460] __cpu_up+0xc0/0x228
  [c1051e18] [c0031bbc] bringup_cpu+0x30/0x224
  [c1051e48] [c0031f3c] cpu_up.constprop.0+0x180/0x33c
  [c1051e88] [c00322e8] bringup_nonboot_cpus+0x88/0xc8
  [c1051eb8] [c07e67bc] smp_init+0x30/0x78
  [c1051ed8] [c07d9e28] kernel_init_freeable+0x118/0x2a8
  [c1051f18] [c00032d8] kernel_init+0x14/0x124
  [c1051f38] [c0010278] ret_from_kernel_thread+0x14/0x1c

Fixes: c45361abb918 ("powerpc/85xx: fix timebase sync issue when CONFIG_HOTPLUG_CPU=n")
Reported-by: Martin Kennedy <hurricos@gmail.com>
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Tested-by: Martin Kennedy <hurricos@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211126041153.16926-1-nixiaoming@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/85xx/smp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/85xx/smp.c b/arch/powerpc/platforms/85xx/smp.c
index 83f4a6389a282..d7081e9af65c7 100644
--- a/arch/powerpc/platforms/85xx/smp.c
+++ b/arch/powerpc/platforms/85xx/smp.c
@@ -220,7 +220,7 @@ static int smp_85xx_start_cpu(int cpu)
 	local_irq_save(flags);
 	hard_irq_disable();
 
-	if (qoriq_pm_ops)
+	if (qoriq_pm_ops && qoriq_pm_ops->cpu_up_prepare)
 		qoriq_pm_ops->cpu_up_prepare(cpu);
 
 	/* if cpu is not spinning, reset it */
@@ -292,7 +292,7 @@ static int smp_85xx_kick_cpu(int nr)
 		booting_thread_hwid = cpu_thread_in_core(nr);
 		primary = cpu_first_thread_sibling(nr);
 
-		if (qoriq_pm_ops)
+		if (qoriq_pm_ops && qoriq_pm_ops->cpu_up_prepare)
 			qoriq_pm_ops->cpu_up_prepare(nr);
 
 		/*
-- 
2.34.1




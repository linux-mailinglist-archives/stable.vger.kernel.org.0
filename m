Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F45490E8E
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242473AbiAQRLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:11:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57762 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242906AbiAQRHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:07:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7675C61284;
        Mon, 17 Jan 2022 17:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83374C36AE3;
        Mon, 17 Jan 2022 17:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439255;
        bh=FWikH7Ue5U2AmBBJHD/wrnCX9gAjKiiBLs4NTXotUXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J6y2x0/9Z0a0ZEi6V4MaPD4aW3jNtvotAsesoRqPsJSAaXCv4BHKytdwtC/bpA9Nz
         jc6kfPTpq1eM+STdYn9dB0aZKmMirQNjaEIc8QNjJlPLbQ/k50TtBfup5dqkV8N3kF
         5Nw1oE9vdb+72R3a2ravcB/dTM/tPMZOSBtCRJnFPelb1zFNM7ZkbWA3e1OgHq20Gc
         mfmdCoQZNx/25EPoNfYIFyg6GLpergbaqiZVW+Uu6upx3QDJuP9wHYgxdxUkrGDZlO
         gkh3vJHO6b8TCVvKfLsSr6m+NZPUSo0AC71vXFofp9+5QClcwY+WfOJsbkCe5U3Nrd
         AQFtr8xw5wuHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, srikar@linux.vnet.ibm.com,
        ego@linux.vnet.ibm.com, parth@linux.ibm.com,
        valentin.schneider@arm.com, clg@kaod.org, hbathini@linux.ibm.com,
        npiggin@gmail.com, robh@kernel.org, yukuai3@huawei.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 06/13] powerpc/smp: Move setup_profiling_timer() under CONFIG_PROFILING
Date:   Mon, 17 Jan 2022 12:07:14 -0500
Message-Id: <20220117170722.1473137-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170722.1473137-1-sashal@kernel.org>
References: <20220117170722.1473137-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit a4ac0d249a5db80e79d573db9e4ad29354b643a8 ]

setup_profiling_timer() is only needed when CONFIG_PROFILING is enabled.

Fixes the following W=1 warning when CONFIG_PROFILING=n:
  linux/arch/powerpc/kernel/smp.c:1638:5: error: no previous prototype for ‘setup_profiling_timer’

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211124093254.1054750-5-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/smp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 9c6f3fd580597..31675c1d678b6 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -759,10 +759,12 @@ void start_secondary(void *unused)
 	BUG();
 }
 
+#ifdef CONFIG_PROFILING
 int setup_profiling_timer(unsigned int multiplier)
 {
 	return 0;
 }
+#endif
 
 #ifdef CONFIG_SCHED_SMT
 /* cpumask of CPUs with asymetric SMT dependancy */
-- 
2.34.1


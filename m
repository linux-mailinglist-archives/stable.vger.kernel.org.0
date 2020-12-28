Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5A72E3B5A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406021AbgL1Ns4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:48:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405981AbgL1Nsz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:48:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C29792063A;
        Mon, 28 Dec 2020 13:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163320;
        bh=2fe5uT9KEneNCTSSaG1epWrlmrWDDsGDQDg1DmXlT6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PxMY9cokmAifCO89sm+0yyQrhcU5IE/fIXM0FTB1M8kQODYYOmZmt9+yBDmdyuXQU
         y6vBbiB63/pE0hz0ZD6nbdkf5NePuQbzC4Bu2bLmKNJz8D7L+RmmYnzI+4uH7Kj1Fn
         nAlxvIZyEHJdVh2D83A8C0LSVy8EX5qhsYV/wqME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 246/453] powerpc/pseries/hibernation: remove redundant cacheinfo update
Date:   Mon, 28 Dec 2020 13:48:02 +0100
Message-Id: <20201228124949.064658270@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit b866459489fe8ef0e92cde3cbd6bbb1af6c4e99b ]

Partitions with cache nodes in the device tree can encounter the
following warning on resume:

CPU 0 already accounted in PowerPC,POWER9@0(Data)
WARNING: CPU: 0 PID: 3177 at arch/powerpc/kernel/cacheinfo.c:197 cacheinfo_cpu_online+0x640/0x820

These calls to cacheinfo_cpu_offline/online have been redundant since
commit e610a466d16a ("powerpc/pseries/mobility: rebuild cacheinfo
hierarchy post-migration").

Fixes: e610a466d16a ("powerpc/pseries/mobility: rebuild cacheinfo hierarchy post-migration")
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201207215200.1785968-25-nathanl@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/suspend.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/suspend.c b/arch/powerpc/platforms/pseries/suspend.c
index 0749ccb994002..e5ecadfb5dea2 100644
--- a/arch/powerpc/platforms/pseries/suspend.c
+++ b/arch/powerpc/platforms/pseries/suspend.c
@@ -13,7 +13,6 @@
 #include <asm/mmu.h>
 #include <asm/rtas.h>
 #include <asm/topology.h>
-#include "../../kernel/cacheinfo.h"
 
 static u64 stream_id;
 static struct device suspend_dev;
@@ -78,9 +77,7 @@ static void pseries_suspend_enable_irqs(void)
 	 * Update configuration which can be modified based on device tree
 	 * changes during resume.
 	 */
-	cacheinfo_cpu_offline(smp_processor_id());
 	post_mobility_fixup();
-	cacheinfo_cpu_online(smp_processor_id());
 }
 
 /**
-- 
2.27.0




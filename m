Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF592E6708
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732449AbgL1NOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:14:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:41832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732440AbgL1NOO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:14:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C51AC22BEF;
        Mon, 28 Dec 2020 13:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161238;
        bh=aHGF5GRRwAoFtRgVjPWdmlpM/DCLHAZJp3duD7olTO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=haEzEkfOHaQfkMZkknNTpynlp00bPZoQw7npoDEMYd+nUMj6DaaJEeIXYc3I2X2ry
         XfNQ9p8MZyPdLoto8nfjVq+I0LhzMPUYhtkJHhR9pS+HVzWt/ROWsl9pce4K/Jsehh
         NZ2bBh4CuBS2amQW7K3XcA6r17Wj4yFo0COlVagA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 149/242] powerpc/pseries/hibernation: remove redundant cacheinfo update
Date:   Mon, 28 Dec 2020 13:49:14 +0100
Message-Id: <20201228124912.042221843@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
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
index 33077ad106cf0..b7cdad95584da 100644
--- a/arch/powerpc/platforms/pseries/suspend.c
+++ b/arch/powerpc/platforms/pseries/suspend.c
@@ -26,7 +26,6 @@
 #include <asm/mmu.h>
 #include <asm/rtas.h>
 #include <asm/topology.h>
-#include "../../kernel/cacheinfo.h"
 
 static u64 stream_id;
 static struct device suspend_dev;
@@ -91,9 +90,7 @@ static void pseries_suspend_enable_irqs(void)
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




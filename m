Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A236328FF8
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241849AbhCAUAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:00:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241195AbhCATtu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:49:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65CA4650E0;
        Mon,  1 Mar 2021 17:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621106;
        bh=f0f5MoV+E4GGsAVVNkiKJ+DvzOSX9AwVOyBSBDdyNa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vAlecOBuObiKNCYYpzWi7ep0EEkVsIaHNy9dTnDBCfneW3Xh9NXYIRW/fjXGq0qzl
         uD5uU2DLQqONFTbWlvwrtqttD0SXTmCPH5eEow0TuP0TWZ4ig4/qJv0EVAdKe+y3Q1
         1EmaMYUNTylJ6aWVcXSovXcqmPte9JB8usfUfklI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pingfan Liu <kernelfans@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 394/775] powerpc/time: Enable sched clock for irqtime
Date:   Mon,  1 Mar 2021 17:09:22 +0100
Message-Id: <20210301161221.071888130@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pingfan Liu <kernelfans@gmail.com>

[ Upstream commit b709e32ef570b8b91dfbcb63cffac4324c87799f ]

When CONFIG_IRQ_TIME_ACCOUNTING and CONFIG_VIRT_CPU_ACCOUNTING_GEN, powerpc
does not enable "sched_clock_irqtime" and can not utilize irq time
accounting.

Like x86, powerpc does not use the sched_clock_register() interface. So it
needs an dedicated call to enable_sched_clock_irqtime() to enable irq time
accounting.

Fixes: 518470fe962e ("powerpc: Add HAVE_IRQ_TIME_ACCOUNTING")
Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
[mpe: Add fixes tag]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1603349479-26185-1-git-send-email-kernelfans@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/time.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 67feb35244606..83633a24ce788 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -53,6 +53,7 @@
 #include <linux/of_clk.h>
 #include <linux/suspend.h>
 #include <linux/sched/cputime.h>
+#include <linux/sched/clock.h>
 #include <linux/processor.h>
 #include <asm/trace.h>
 
@@ -1030,6 +1031,7 @@ void __init time_init(void)
 	tick_setup_hrtimer_broadcast();
 
 	of_clk_init(NULL);
+	enable_sched_clock_irqtime();
 }
 
 /*
-- 
2.27.0




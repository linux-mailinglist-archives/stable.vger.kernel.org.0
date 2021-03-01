Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8C0328AF3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239656AbhCAS0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:26:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:38270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239207AbhCASUQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:20:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 761B3651E6;
        Mon,  1 Mar 2021 17:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619164;
        bh=TQfOEE7tHcF0NZEsxUfloE6qadS41L7BFzDJ5CB0FUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h+8NwmvWKAeuCL6fgqVB46zwf5W9MVbk5vGNCtdHHOQsvg2tI996A7yudqG5xq7aJ
         UxZCZZoj/S9ooulqCDtFEuF1+7t0Aj64i6gZ0D2n7RmNW1b/18UBW+B3cyA+VTBgGT
         8iYL0JBAI53wcxd0X/7YWFmC+RC1odLDOguzQreM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pingfan Liu <kernelfans@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 328/663] powerpc/time: Enable sched clock for irqtime
Date:   Mon,  1 Mar 2021 17:09:36 +0100
Message-Id: <20210301161158.080790896@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index 7d372ff3504b2..1d20f0f77a920 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -53,6 +53,7 @@
 #include <linux/of_clk.h>
 #include <linux/suspend.h>
 #include <linux/sched/cputime.h>
+#include <linux/sched/clock.h>
 #include <linux/processor.h>
 #include <asm/trace.h>
 
@@ -1095,6 +1096,7 @@ void __init time_init(void)
 	tick_setup_hrtimer_broadcast();
 
 	of_clk_init(NULL);
+	enable_sched_clock_irqtime();
 }
 
 /*
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D390E2E4102
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440127AbgL1ONR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:13:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:48172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440126AbgL1ONR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:13:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E942F205CB;
        Mon, 28 Dec 2020 14:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164756;
        bh=sPBo56PnpmPEgFttFhFe+Y3njLhQr4aBpRxLiclgDFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncVEj7N7MYKVRiGGF5Oe1XQU8Z0rBQMIyRyfS3zYLdtWGPFj3OSsifr4H4gQ59Nvq
         q76u0mUj8Rx/3ZeQNsTnZzMXLObZqIWopcgsyJy3w86bhrkNCH5lno08aF6FmihA2O
         qWappdRw6i35/8r1HOV8r+EjGZMpQOXG0mADjgv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 288/717] clocksource/drivers/riscv: Make RISCV_TIMER depends on RISCV_SBI
Date:   Mon, 28 Dec 2020 13:44:46 +0100
Message-Id: <20201228125034.829402172@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit ab3105446f1ec4e98fadfc998ee24feec271c16c ]

The riscv timer is set via SBI timer call, let's make RISCV_TIMER
depends on RISCV_SBI, and it also fixes some build issue.

Fixes: d5be89a8d118 ("RISC-V: Resurrect the MMIO timer implementation for M-mode systems")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20201028131230.72907-1-wangkefeng.wang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 68b087bff59cc..2be849bb794ac 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -654,7 +654,7 @@ config ATCPIT100_TIMER
 
 config RISCV_TIMER
 	bool "Timer for the RISC-V platform" if COMPILE_TEST
-	depends on GENERIC_SCHED_CLOCK && RISCV
+	depends on GENERIC_SCHED_CLOCK && RISCV && RISCV_SBI
 	select TIMER_PROBE
 	select TIMER_OF
 	help
-- 
2.27.0




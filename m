Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1092FC8DE
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 04:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732128AbhATCaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:30:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:46628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730552AbhATB26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E17CA23381;
        Wed, 20 Jan 2021 01:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106033;
        bh=B16VwjtU/uK42xprLih02I1hGdHlO+34NmRSj06vrrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RFd14uikwbn8MyNZfClU/3+4QZ3T4Xu8bPnzxG9ErKZg9rrYlq/9UCIxJhJNts5nR
         9WZGndej4RczwjO7uQcpjKPe80A1yxWz0DgW9aJE1K9ZWQLuNRzKw2EEwMKo8Q6UGb
         gu9KNdHTcEgMMY/xFtzoEZfQ6JBp9tzgqU7B5mty4n6oGOsiYJt1HSsGWGfGA5uB5s
         xKbjSAzHiT12+lJyPG0MdRA4OglaBJC/QIdtJfjQIluOs9y6pjuSR9hYQM+KUXaKT4
         pthGINliQMDhzWyF/5QMq2rVRi6fVRUTkCACIpVOf5r9j+zigz3u/l0HzarcP4PLT3
         Eu30b3sJ1YBLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 07/26] riscv: Fix kernel time_init()
Date:   Tue, 19 Jan 2021 20:26:44 -0500
Message-Id: <20210120012704.770095-7-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012704.770095-1-sashal@kernel.org>
References: <20210120012704.770095-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

[ Upstream commit 11f4c2e940e2f317c9d8fb5a79702f2a4a02ff98 ]

If of_clk_init() is not called in time_init(), clock providers defined
in the system device tree are not initialized, resulting in failures for
other devices to initialize due to missing clocks.
Similarly to other architectures and to the default kernel time_init()
implementation, call of_clk_init() before executing timer_probe() in
time_init().

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/time.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/kernel/time.c b/arch/riscv/kernel/time.c
index 6a53c02e9c734..8aa70b519e04f 100644
--- a/arch/riscv/kernel/time.c
+++ b/arch/riscv/kernel/time.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2017 SiFive
  */
 
+#include <linux/of_clk.h>
 #include <linux/clocksource.h>
 #include <linux/delay.h>
 #include <asm/sbi.h>
@@ -24,5 +25,7 @@ void __init time_init(void)
 	riscv_timebase = prop;
 
 	lpj_fine = riscv_timebase / HZ;
+
+	of_clk_init(NULL);
 	timer_probe();
 }
-- 
2.27.0


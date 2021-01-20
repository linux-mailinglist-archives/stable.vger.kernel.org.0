Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD512FC990
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 04:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731289AbhATC2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:28:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729919AbhATB2I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4607C2313C;
        Wed, 20 Jan 2021 01:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611105981;
        bh=rF/943KhXezfdgbCMm4/HFxCfE2Bb3ZbRhYMEJrffP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tePpvyy25iYttGPl+WJ989/ZrUmDukBEXZEcqiXAoKDQuR+p7fF5hyIQqm9iCHEuG
         v7+XifcDyogYrXmY7TiH+XA2CzUmlOi/5IzolebVIjNXt+XQENvDK7rnDcDoA5byVl
         Vdi60cARudHC2bk/fFV5z1FhIcahZH280j3BVnVj4T/+vJ39Ow+jUNuibJDlx2PKkl
         /HNEurwluJqOcL57ATpHgyP1IAiF2fZaQhGzkUmi4NigMOxM4fwvh02svCbg+n7s+q
         2ByNr/pWMb7Fs3+Hg8FEkdcHhn3o2Ag9EbB/WCG+7pBZJNlNQtiOgrhaNG2fbfr9Zd
         kzlYDOooQG74g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 14/45] riscv: Fix kernel time_init()
Date:   Tue, 19 Jan 2021 20:25:31 -0500
Message-Id: <20210120012602.769683-14-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
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
index 4d3a1048ad8b1..8a5cf99c07762 100644
--- a/arch/riscv/kernel/time.c
+++ b/arch/riscv/kernel/time.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2017 SiFive
  */
 
+#include <linux/of_clk.h>
 #include <linux/clocksource.h>
 #include <linux/delay.h>
 #include <asm/sbi.h>
@@ -24,6 +25,8 @@ void __init time_init(void)
 	riscv_timebase = prop;
 
 	lpj_fine = riscv_timebase / HZ;
+
+	of_clk_init(NULL);
 	timer_probe();
 }
 
-- 
2.27.0


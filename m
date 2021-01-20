Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369DB2FC809
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732794AbhATCbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:31:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:47444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730751AbhATB3Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:29:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EB902343B;
        Wed, 20 Jan 2021 01:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106068;
        bh=fh3hSnC/5iIHOmyQW3B6HvCww7SFVWDNsbfQNMfehvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PoFq0WUnCvgT8v6y08vYB6rc7rLqMDMQ8d6AsGwOdUC6LI0eoJrPsJpBKY6omTc0W
         2tgWLFvPfwhvRdg777AWrp7EDO/HfR/Y6sezke94W4g6lURerGAIMd4CVaGouAR1Md
         nI7YheT6dUJjNVNjpcr5HG1NmSLq29dBT59hHD5cFjBrm+IEZyxSD5xlWX/rZO833G
         G5BnxfbWa48LYv3cRvVx0G9wvG/UvYc/cbWw0rblR5LsQdzpS6Vq9MjrcOMOdb+4bF
         aUkM8XiDu9A8uPX0aXbEVfZjISIBQMc8EQRf+/B4PI8U6liovi5WsRbO1+Jp5+cDhV
         wNND5DsacRcKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 05/15] riscv: Fix kernel time_init()
Date:   Tue, 19 Jan 2021 20:27:30 -0500
Message-Id: <20210120012740.770354-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012740.770354-1-sashal@kernel.org>
References: <20210120012740.770354-1-sashal@kernel.org>
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
index 1911c8f6b8a69..15f4ab40e2221 100644
--- a/arch/riscv/kernel/time.c
+++ b/arch/riscv/kernel/time.c
@@ -12,6 +12,7 @@
  *   GNU General Public License for more details.
  */
 
+#include <linux/of_clk.h>
 #include <linux/clocksource.h>
 #include <linux/delay.h>
 #include <asm/sbi.h>
@@ -29,5 +30,7 @@ void __init time_init(void)
 	riscv_timebase = prop;
 
 	lpj_fine = riscv_timebase / HZ;
+
+	of_clk_init(NULL);
 	timer_probe();
 }
-- 
2.27.0


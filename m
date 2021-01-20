Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E2A2FC8DD
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 04:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732113AbhATCaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:30:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728883AbhATB26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2767E233A1;
        Wed, 20 Jan 2021 01:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106035;
        bh=g6IpG4eWGbmWOQ1Y69WDY67vRJiXh3rDqu11EkXtRAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CVs31EpxD05GZkmMpyhzgtxBBIdZvJpRI7OVNtUtkWTybGX0d6QIUQ2qSmt+fM74F
         CDcNCxR9xt1la7QnkG9tw5cfZ/yCh11u9emdg2RrLPN64zAEbsE0ezPW6GIS1vGZIx
         62c3s+3UJjh8lZIy4eK6JeF5zv6GrlcuFCbU5BkOFLZwBLSpIlxVn4kPeXdp5Ha1f+
         I9MG98qpMq79ydVPNlNvViylzzrJ7uFRcgR3+U4tGoGO/PA8ACfhaAqB5RB2TU7ZzK
         tbHwffPwyKUWyj0LzjK9YN1zBw75x+gPBzj3VkTy3e4CKpUf4/8ebZmF+ze4QlS8ul
         gYY1O6eVMimdw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 08/26] riscv: Fix sifive serial driver
Date:   Tue, 19 Jan 2021 20:26:45 -0500
Message-Id: <20210120012704.770095-8-sashal@kernel.org>
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

[ Upstream commit 1f1496a923b6ba16679074fe77100e1b53cdb880 ]

Setup the port uartclk in sifive_serial_probe() so that the base baud
rate is correctly printed during device probe instead of always showing
"0".  I.e. the probe message is changed from

38000000.serial: ttySIF0 at MMIO 0x38000000 (irq = 1,
base_baud = 0) is a SiFive UART v0

to the correct:

38000000.serial: ttySIF0 at MMIO 0x38000000 (irq = 1,
base_baud = 115200) is a SiFive UART v0

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sifive.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/sifive.c b/drivers/tty/serial/sifive.c
index b4343c6aa6512..6a2dc823ea828 100644
--- a/drivers/tty/serial/sifive.c
+++ b/drivers/tty/serial/sifive.c
@@ -973,6 +973,7 @@ static int sifive_serial_probe(struct platform_device *pdev)
 	/* Set up clock divider */
 	ssp->clkin_rate = clk_get_rate(ssp->clk);
 	ssp->baud_rate = SIFIVE_DEFAULT_BAUD_RATE;
+	ssp->port.uartclk = ssp->baud_rate * 16;
 	__ssp_update_div(ssp);
 
 	platform_set_drvdata(pdev, ssp);
-- 
2.27.0


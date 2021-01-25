Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B773031BF
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 03:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbhAYSou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:44:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:60730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727974AbhAYSoh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:44:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D95C220719;
        Mon, 25 Jan 2021 18:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600234;
        bh=B16VwjtU/uK42xprLih02I1hGdHlO+34NmRSj06vrrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ME/Aw3SjjMI6fcwSo/XfIlysgAUpWZYlINLUUo6eANImAkMTHfBPJc/E/LXqjPU8p
         ZIPBOxyGWvrN+gRMA3Ot+Yr+zCTg51++rFxK5ErYlEyxCe4aSb811DfcAp52BYPYFi
         AEqBVUIONq1kfzZEbh7HG7SQ2Si/x70VX5KywPXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 24/86] riscv: Fix kernel time_init()
Date:   Mon, 25 Jan 2021 19:39:06 +0100
Message-Id: <20210125183202.068401417@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14B9F13F572
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388848AbgAPRHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:07:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389142AbgAPRHT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:07:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4473B217F4;
        Thu, 16 Jan 2020 17:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194438;
        bh=fto6auODjSObhV4dyVgUD2pgW/Kn8GTtAltYPsvBTbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YB8+BWK4k9qbUwLF5udjoGvu+QfsLG3hOJoe+lztIxMigh52Oq+qYdOUZ6vSg0HU6
         tQ6NaPHaiYc3e3KPvGl7nITihYsT0jh9Vht25b1Wh9VH96qo/jYkdu+tMnTdWvPwI7
         F+JhZGdLtfnH+CZ7vO4k4//Uj0k+7qpZ7aB2WApc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 352/671] ARM: riscpc: fix lack of keyboard interrupts after irq conversion
Date:   Thu, 16 Jan 2020 11:59:50 -0500
Message-Id: <20200116170509.12787-89-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 63a0666bca9311f35017be454587f3ba903644b8 ]

Fix lack of keyboard interrupts for RiscPC due to incorrect conversion.

Fixes: e8d36d5dbb6a ("ARM: kill off set_irq_flags usage")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-rpc/irq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-rpc/irq.c b/arch/arm/mach-rpc/irq.c
index b8a61cb11207..7f0f40178634 100644
--- a/arch/arm/mach-rpc/irq.c
+++ b/arch/arm/mach-rpc/irq.c
@@ -118,7 +118,7 @@ extern unsigned char rpc_default_fiq_start, rpc_default_fiq_end;
 
 void __init rpc_init_irq(void)
 {
-	unsigned int irq, clr, set = 0;
+	unsigned int irq, clr, set;
 
 	iomd_writeb(0, IOMD_IRQMASKA);
 	iomd_writeb(0, IOMD_IRQMASKB);
@@ -130,6 +130,7 @@ void __init rpc_init_irq(void)
 
 	for (irq = 0; irq < NR_IRQS; irq++) {
 		clr = IRQ_NOREQUEST;
+		set = 0;
 
 		if (irq <= 6 || (irq >= 9 && irq <= 15))
 			clr |= IRQ_NOPROBE;
-- 
2.20.1


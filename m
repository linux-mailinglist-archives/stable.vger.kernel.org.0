Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB423CA849
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241757AbhGOTA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241114AbhGOS6u (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:58:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91843610C7;
        Thu, 15 Jul 2021 18:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375350;
        bh=lFRZNA2axd6y0gh1OLNz3qNQ8ml1pC4bSsvWlDJIezE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qiDbD5rRpysRkTYtmiwyGBF+vXhE6FUBH95o/j8sud32Z9K6KqtYFWpxmJzB1bdY4
         qjDTgavdGMbmOluc4nYaVkF4MsMqx1/3HZl6mKyNWcSKcnQZyJemDGQ3yKW5nnaYcL
         2GWd2O5lor/SS/NUvKNcpZe2NBXZti13Amp3p4vQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 049/242] MIPS: ingenic: Select CPU_SUPPORTS_CPUFREQ && MIPS_EXTERNAL_TIMER
Date:   Thu, 15 Jul 2021 20:36:51 +0200
Message-Id: <20210715182600.838155220@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit eb3849370ae32b571e1f9a63ba52c61adeaf88f7 ]

The clock driving the XBurst CPUs in Ingenic SoCs is integer divided
from the main PLL. As such, it is possible to control the frequency of
the CPU, either by changing the divider, or by changing the rate of the
main PLL.

The XBurst CPUs also lack the CP0 timer; the TCU, a separate piece of
hardware in the SoC, provides this functionality.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index e89d63cd92d1..ab73622b14dd 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -425,6 +425,8 @@ config MACH_INGENIC_SOC
 	select MIPS_GENERIC
 	select MACH_INGENIC
 	select SYS_SUPPORTS_ZBOOT_UART16550
+	select CPU_SUPPORTS_CPUFREQ
+	select MIPS_EXTERNAL_TIMER
 
 config LANTIQ
 	bool "Lantiq based platforms"
-- 
2.30.2




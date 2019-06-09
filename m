Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5D43AA09
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732663AbfFIQyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:54:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732683AbfFIQyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:54:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96BBC205ED;
        Sun,  9 Jun 2019 16:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099284;
        bh=ZelLAq095nPzT9U+ik2QCM4aygITCEP6x05Ax+TYATc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wln66yJHN6atG1uw+LkuY9I1JBnmEgUGXrYUiRYPBqpjSwHloa7dcU7/viJXZSdJP
         wW0enRIu3p+e8lHAWXvh9COPUl85Uj3BzbuSKOmLYkuQn3SWDbqQzG+Wc5hFQu4O8q
         2bRN9xaYZ5WtrHqK9h0TO5ljrydI1YmjUS2M/Yso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        Kevin ldir Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        John Crispin <john@phrozen.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 76/83] Revert "MIPS: perf: ath79: Fix perfcount IRQ assignment"
Date:   Sun,  9 Jun 2019 18:42:46 +0200
Message-Id: <20190609164134.390310228@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit f9b1baac265600a61d36ebaf9ba657119303b5b5 which is
commit a1e8783db8e0d58891681bc1e6d9ada66eae8e20 upstream.

Petr writes:
	Karl has reported to me today, that he's experiencing weird
	reboot hang on his devices with 4.9.180 kernel and that he has
	bisected it down to my backported patch.

	I would like to kindly ask you for removal of this patch.  This
	patch should be reverted from all stable kernels up to 5.1,
	because perf counters were not broken on those kernels, and this
	patch won't work on the ath79 legacy IRQ code anyway, it needs
	new irqchip driver which was enabled on ath79 with commit
	51fa4f8912c0 ("MIPS: ath79: drop legacy IRQ code").

Reported-by: Petr Štetiar <ynezz@true.cz>
Cc: Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc: John Crispin <john@phrozen.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Paul Burton <paul.burton@mips.com>
Cc: linux-mips@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/ath79/setup.c          |    6 ++++++
 drivers/irqchip/irq-ath79-misc.c |   11 -----------
 2 files changed, 6 insertions(+), 11 deletions(-)

--- a/arch/mips/ath79/setup.c
+++ b/arch/mips/ath79/setup.c
@@ -183,6 +183,12 @@ const char *get_system_type(void)
 	return ath79_sys_type;
 }
 
+int get_c0_perfcount_int(void)
+{
+	return ATH79_MISC_IRQ(5);
+}
+EXPORT_SYMBOL_GPL(get_c0_perfcount_int);
+
 unsigned int get_c0_compare_int(void)
 {
 	return CP0_LEGACY_COMPARE_IRQ;
--- a/drivers/irqchip/irq-ath79-misc.c
+++ b/drivers/irqchip/irq-ath79-misc.c
@@ -22,15 +22,6 @@
 #define AR71XX_RESET_REG_MISC_INT_ENABLE	4
 
 #define ATH79_MISC_IRQ_COUNT			32
-#define ATH79_MISC_PERF_IRQ			5
-
-static int ath79_perfcount_irq;
-
-int get_c0_perfcount_int(void)
-{
-	return ath79_perfcount_irq;
-}
-EXPORT_SYMBOL_GPL(get_c0_perfcount_int);
 
 static void ath79_misc_irq_handler(struct irq_desc *desc)
 {
@@ -122,8 +113,6 @@ static void __init ath79_misc_intc_domai
 {
 	void __iomem *base = domain->host_data;
 
-	ath79_perfcount_irq = irq_create_mapping(domain, ATH79_MISC_PERF_IRQ);
-
 	/* Disable and clear all interrupts */
 	__raw_writel(0, base + AR71XX_RESET_REG_MISC_INT_ENABLE);
 	__raw_writel(0, base + AR71XX_RESET_REG_MISC_INT_STATUS);



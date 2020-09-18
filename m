Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E10626F337
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727676AbgIRDFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:05:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726348AbgIRCEb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:04:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E670B23741;
        Fri, 18 Sep 2020 02:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394670;
        bh=lCmNF/bJl1nytvv2s1UVQv6Cg4ZFuMUODfcoBieSl0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zlfJHH7I4VyJyWdHBnTDSbmwjDDbdopgavKB8ARSHKy74fYFfOfSu+RxoNOLXnqby
         ZMjjPF55O1/s9t5UWB1IP/fd9Vt1V4xWLNa2JR/EuGDD/Qig/OVcCV8g1gc7REJfv6
         KoIZniqO5PmRPgqDH1NpnQCen6pLFHdDP5Lq6DvY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     afzal mohammed <afzal.mohd.ma@gmail.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 163/330] s390/irq: replace setup_irq() by request_irq()
Date:   Thu, 17 Sep 2020 21:58:23 -0400
Message-Id: <20200918020110.2063155-163-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: afzal mohammed <afzal.mohd.ma@gmail.com>

[ Upstream commit 8719b6d29d2851fa84c4074bb2e5adc022911ab8 ]

request_irq() is preferred over setup_irq(). Invocations of setup_irq()
occur after memory allocators are ready.

Per tglx[1], setup_irq() existed in olden days when allocators were not
ready by the time early interrupts were initialized.

Hence replace setup_irq() by request_irq().

[1] https://lkml.kernel.org/r/alpine.DEB.2.20.1710191609480.1971@nanos

Signed-off-by: afzal mohammed <afzal.mohd.ma@gmail.com>
Message-Id: <20200304005049.5291-1-afzal.mohd.ma@gmail.com>
[heiko.carstens@de.ibm.com: replace pr_err with panic]
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/irq.c  | 8 ++------
 drivers/s390/cio/airq.c | 8 ++------
 drivers/s390/cio/cio.c  | 8 ++------
 3 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index 8371855042dc2..da550cb8b31bd 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -294,11 +294,6 @@ static irqreturn_t do_ext_interrupt(int irq, void *dummy)
 	return IRQ_HANDLED;
 }
 
-static struct irqaction external_interrupt = {
-	.name	 = "EXT",
-	.handler = do_ext_interrupt,
-};
-
 void __init init_ext_interrupts(void)
 {
 	int idx;
@@ -308,7 +303,8 @@ void __init init_ext_interrupts(void)
 
 	irq_set_chip_and_handler(EXT_INTERRUPT,
 				 &dummy_irq_chip, handle_percpu_irq);
-	setup_irq(EXT_INTERRUPT, &external_interrupt);
+	if (request_irq(EXT_INTERRUPT, do_ext_interrupt, 0, "EXT", NULL))
+		panic("Failed to register EXT interrupt\n");
 }
 
 static DEFINE_SPINLOCK(irq_subclass_lock);
diff --git a/drivers/s390/cio/airq.c b/drivers/s390/cio/airq.c
index 427b2e24a8cea..cb466ed7eb5ef 100644
--- a/drivers/s390/cio/airq.c
+++ b/drivers/s390/cio/airq.c
@@ -105,16 +105,12 @@ static irqreturn_t do_airq_interrupt(int irq, void *dummy)
 	return IRQ_HANDLED;
 }
 
-static struct irqaction airq_interrupt = {
-	.name	 = "AIO",
-	.handler = do_airq_interrupt,
-};
-
 void __init init_airq_interrupts(void)
 {
 	irq_set_chip_and_handler(THIN_INTERRUPT,
 				 &dummy_irq_chip, handle_percpu_irq);
-	setup_irq(THIN_INTERRUPT, &airq_interrupt);
+	if (request_irq(THIN_INTERRUPT, do_airq_interrupt, 0, "AIO", NULL))
+		panic("Failed to register AIO interrupt\n");
 }
 
 static inline unsigned long iv_size(unsigned long bits)
diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index 18f5458f90e8f..6d716db2a46ab 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -563,16 +563,12 @@ static irqreturn_t do_cio_interrupt(int irq, void *dummy)
 	return IRQ_HANDLED;
 }
 
-static struct irqaction io_interrupt = {
-	.name	 = "I/O",
-	.handler = do_cio_interrupt,
-};
-
 void __init init_cio_interrupts(void)
 {
 	irq_set_chip_and_handler(IO_INTERRUPT,
 				 &dummy_irq_chip, handle_percpu_irq);
-	setup_irq(IO_INTERRUPT, &io_interrupt);
+	if (request_irq(IO_INTERRUPT, do_cio_interrupt, 0, "I/O", NULL))
+		panic("Failed to register I/O interrupt\n");
 }
 
 #ifdef CONFIG_CCW_CONSOLE
-- 
2.25.1


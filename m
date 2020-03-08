Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1322417D32B
	for <lists+stable@lfdr.de>; Sun,  8 Mar 2020 11:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgCHKOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Mar 2020 06:14:35 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56467 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgCHKOf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Mar 2020 06:14:35 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jAsx6-0004o6-AT; Sun, 08 Mar 2020 11:14:32 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 42D3A1C2215;
        Sun,  8 Mar 2020 11:14:31 +0100 (CET)
Date:   Sun, 08 Mar 2020 10:14:31 -0000
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/core] genirq/debugfs: Add missing sanity checks to
 interrupt injection
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200306130623.500019114@linutronix.de>
References: <20200306130623.500019114@linutronix.de>
MIME-Version: 1.0
Message-ID: <158366247101.28353.9070665399389100228.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/core branch of tip:

Commit-ID:     a740a423c36932695b01a3e920f697bc55b05fec
Gitweb:        https://git.kernel.org/tip/a740a423c36932695b01a3e920f697bc55b05fec
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Fri, 06 Mar 2020 14:03:42 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Sun, 08 Mar 2020 11:06:40 +01:00

genirq/debugfs: Add missing sanity checks to interrupt injection

Interrupts cannot be injected when the interrupt is not activated and when
a replay is already in progress.

Fixes: 536e2e34bd00 ("genirq/debugfs: Triggering of interrupts from userspace")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200306130623.500019114@linutronix.de

---
 kernel/irq/debugfs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/debugfs.c b/kernel/irq/debugfs.c
index a949bd3..d44c8fd 100644
--- a/kernel/irq/debugfs.c
+++ b/kernel/irq/debugfs.c
@@ -206,8 +206,15 @@ static ssize_t irq_debug_write(struct file *file, const char __user *user_buf,
 		chip_bus_lock(desc);
 		raw_spin_lock_irqsave(&desc->lock, flags);
 
-		if (irq_settings_is_level(desc) || desc->istate & IRQS_NMI) {
-			/* Can't do level nor NMIs, sorry */
+		/*
+		 * Don't allow injection when the interrupt is:
+		 *  - Level or NMI type
+		 *  - not activated
+		 *  - replaying already
+		 */
+		if (irq_settings_is_level(desc) ||
+		    !irqd_is_activated(&desc->irq_data) ||
+		    (desc->istate & (IRQS_NMI | IRQS_REPLAY))) {
 			err = -EINVAL;
 		} else {
 			desc->istate |= IRQS_PENDING;

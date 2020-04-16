Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C341AC3B0
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898633AbgDPNqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:32792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392224AbgDPNqt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:46:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AA1F21744;
        Thu, 16 Apr 2020 13:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044809;
        bh=QmB29ly0Y71X/FgMW4b306XefznnlZC+fnySE+kruPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x3/7YHNJ9PUGwGCfqvceUqQNRR3m7BQRfzu57hMlHqJafuh+hlG4Ztvz5PWZFFRIT
         ul8ebFOYvIOH8v5Fzl+wb0qnsMHWMl5d1ogO1JJhzTbkNNsUy5z7M7EdrKIVJMBdnn
         SVzDQfG4pdvW+uma38BgG7iLaaVuBhEklYqTU+FU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 110/232] genirq/debugfs: Add missing sanity checks to interrupt injection
Date:   Thu, 16 Apr 2020 15:23:24 +0200
Message-Id: <20200416131328.910035848@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit a740a423c36932695b01a3e920f697bc55b05fec upstream.

Interrupts cannot be injected when the interrupt is not activated and when
a replay is already in progress.

Fixes: 536e2e34bd00 ("genirq/debugfs: Triggering of interrupts from userspace")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200306130623.500019114@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/irq/debugfs.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/kernel/irq/debugfs.c
+++ b/kernel/irq/debugfs.c
@@ -206,8 +206,15 @@ static ssize_t irq_debug_write(struct fi
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



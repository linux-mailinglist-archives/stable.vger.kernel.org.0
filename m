Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E956724B6AB
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731522AbgHTKja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:39:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729358AbgHTKR6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:17:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3624420738;
        Thu, 20 Aug 2020 10:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918677;
        bh=An8rfrtl2kc96SZkWhF6Ux9sc4/KRpyOvQhPLtfCEFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fvLEP49Q4p54o8ATD3QGFiEdFcPVPugvLrybN74ptqbE0RGo96GJOIe43pJac42s9
         8OP6+bQx1PAWOlLcE9kB0NV0KrD+vZifyrsr3UXn7k87tts+9XeTimq7ies7gsk+3E
         Sbr406DIeDBMUS3mYUJVyP75Cg262zxMBjEUPWjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.4 026/149] x86/i8259: Use printk_deferred() to prevent deadlock
Date:   Thu, 20 Aug 2020 11:21:43 +0200
Message-Id: <20200820092126.988641157@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit bdd65589593edd79b6a12ce86b3b7a7c6dae5208 upstream.

0day reported a possible circular locking dependency:

Chain exists of:
  &irq_desc_lock_class --> console_owner --> &port_lock_key

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&port_lock_key);
                               lock(console_owner);
                               lock(&port_lock_key);
  lock(&irq_desc_lock_class);

The reason for this is a printk() in the i8259 interrupt chip driver
which is invoked with the irq descriptor lock held, which reverses the
lock operations vs. printk() from arbitrary contexts.

Switch the printk() to printk_deferred() to avoid that.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87365abt2v.fsf@nanos.tec.linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/i8259.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -204,7 +204,7 @@ spurious_8259A_irq:
 		 * lets ACK and report it. [once per IRQ]
 		 */
 		if (!(spurious_irq_mask & irqmask)) {
-			printk(KERN_DEBUG
+			printk_deferred(KERN_DEBUG
 			       "spurious 8259A interrupt: IRQ%d.\n", irq);
 			spurious_irq_mask |= irqmask;
 		}



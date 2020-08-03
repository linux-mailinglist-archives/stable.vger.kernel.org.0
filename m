Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10B923A5E9
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgHCMm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:42:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729046AbgHCMa2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:30:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DD372054F;
        Mon,  3 Aug 2020 12:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457826;
        bh=+3EfgGtmCKrNepVQ0cjyTDgJi1Grs6bidEQ5QqtEGDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0l9nhzv2n4K6u/KdcZ86E+ePxcrT7vhR+oahdV2DtbGz2xbN36DYK/SMNfkwBbZJO
         i4+yyH8gadtS4y9rQ3Nh0uoFTCRc2fkmST7BtKBkFyGdvrPLFPhHYsFtwXXQqeaiGo
         xUluiK8W5I3PKxV0Odrq+tFhKUciNB0aX8lFg+hw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.4 87/90] x86/i8259: Use printk_deferred() to prevent deadlock
Date:   Mon,  3 Aug 2020 14:19:49 +0200
Message-Id: <20200803121901.795797428@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
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
@@ -207,7 +207,7 @@ spurious_8259A_irq:
 		 * lets ACK and report it. [once per IRQ]
 		 */
 		if (!(spurious_irq_mask & irqmask)) {
-			printk(KERN_DEBUG
+			printk_deferred(KERN_DEBUG
 			       "spurious 8259A interrupt: IRQ%d.\n", irq);
 			spurious_irq_mask |= irqmask;
 		}



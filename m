Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40CF6B5C7F
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbfIRG06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:26:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729598AbfIRG0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:26:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0193F21925;
        Wed, 18 Sep 2019 06:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568788014;
        bh=SleRud0PGUTD2fZfmYkNDJ7w5SHW52VvA1/PzL+j33k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TVWaKaXCuLloGUKTDbDi1Kz72AUF7bZ1c4rD9gXZmtp075u+b1SATxdONRrORV7DU
         mKdVQp9hdv5FpRx3vDhQNJrbVqB/bd4WFLvRyDybTZO/Z5+WNmvG/tI28THK1o+szg
         J7oZzHmY5yQAbLxMiNjz5yEo3YL7yX4JafbYyynA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunfeng Ye <yeyunfeng@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH 5.2 41/85] genirq: Prevent NULL pointer dereference in resend_irqs()
Date:   Wed, 18 Sep 2019 08:18:59 +0200
Message-Id: <20190918061235.442181547@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunfeng Ye <yeyunfeng@huawei.com>

commit eddf3e9c7c7e4d0707c68d1bb22cc6ec8aef7d4a upstream.

The following crash was observed:

  Unable to handle kernel NULL pointer dereference at 0000000000000158
  Internal error: Oops: 96000004 [#1] SMP
  pc : resend_irqs+0x68/0xb0
  lr : resend_irqs+0x64/0xb0
  ...
  Call trace:
   resend_irqs+0x68/0xb0
   tasklet_action_common.isra.6+0x84/0x138
   tasklet_action+0x2c/0x38
   __do_softirq+0x120/0x324
   run_ksoftirqd+0x44/0x60
   smpboot_thread_fn+0x1ac/0x1e8
   kthread+0x134/0x138
   ret_from_fork+0x10/0x18

The reason for this is that the interrupt resend mechanism happens in soft
interrupt context, which is a asynchronous mechanism versus other
operations on interrupts. free_irq() does not take resend handling into
account. Thus, the irq descriptor might be already freed before the resend
tasklet is executed. resend_irqs() does not check the return value of the
interrupt descriptor lookup and derefences the return value
unconditionally.

  1):
  __setup_irq
    irq_startup
      check_irq_resend  // activate softirq to handle resend irq
  2):
  irq_domain_free_irqs
    irq_free_descs
      free_desc
        call_rcu(&desc->rcu, delayed_free_desc)
  3):
  __do_softirq
    tasklet_action
      resend_irqs
        desc = irq_to_desc(irq)
        desc->handle_irq(desc)  // desc is NULL --> Ooops

Fix this by adding a NULL pointer check in resend_irqs() before derefencing
the irq descriptor.

Fixes: a4633adcdbc1 ("[PATCH] genirq: add genirq sw IRQ-retrigger")
Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1630ae13-5c8e-901e-de09-e740b6a426a7@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/irq/resend.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -36,6 +36,8 @@ static void resend_irqs(unsigned long ar
 		irq = find_first_bit(irqs_resend, nr_irqs);
 		clear_bit(irq, irqs_resend);
 		desc = irq_to_desc(irq);
+		if (!desc)
+			continue;
 		local_irq_disable();
 		desc->handle_irq(desc);
 		local_irq_enable();



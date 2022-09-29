Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969ED5EFF0B
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 23:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiI2VII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 17:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiI2VID (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 17:08:03 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864DE1B95D8;
        Thu, 29 Sep 2022 14:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664485682; x=1696021682;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1IsYayCedSM7HTg012kpgo5cTqRFAoi1LY9Aznp7xag=;
  b=B+M1q30OkiucmDtdW6IZDiElb2j9QqnZrnkD3f2uPwIXa6hLdjzybc7g
   SgRzMWDjKjxsGaxQDo9fUbC57ZHBtHVPgsAx504vepXWgpRjPQkw05z4c
   DAr8DMUzpIGgj/Aurf9Hjby52m/1Y370Kaz9EE4Eb6mL8F/RhKbkwvR54
   g=;
X-IronPort-AV: E=Sophos;i="5.93,356,1654560000"; 
   d="scan'208";a="264663829"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-2dbf0206.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 21:08:01 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-2dbf0206.us-west-2.amazon.com (Postfix) with ESMTPS id 9E1A5A28CB;
        Thu, 29 Sep 2022 21:08:00 +0000 (UTC)
Received: from EX19D002UWC003.ant.amazon.com (10.13.138.183) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 29 Sep 2022 21:08:00 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX19D002UWC003.ant.amazon.com (10.13.138.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 29 Sep 2022 21:07:54 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.38 via Frontend Transport; Thu, 29 Sep 2022 21:07:53
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 2371826E8; Thu, 29 Sep 2022 21:07:52 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>, <benh@amazon.com>,
        <mbacco@amazon.com>, Lukas Wunner <lukas@wunner.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        <linux-pci@vger.kernel.org>, Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 1/6] genirq: Update code comments wrt recycled thread_mask
Date:   Thu, 29 Sep 2022 21:06:46 +0000
Message-ID: <20220929210651.12308-2-risbhat@amazon.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220929210651.12308-1-risbhat@amazon.com>
References: <20220929210651.12308-1-risbhat@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-14.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 836557bd58e5e65c05c73af9f6ebed885dbfccfc upstream.

Previously a race existed between __free_irq() and __setup_irq() wherein
the thread_mask of a just removed action could be handed out to a newly
added action and the freed irq thread would then tread on the oneshot
mask bit of the newly added irq thread in irq_finalize_oneshot():

time
 |  __free_irq()
 |    raw_spin_lock_irqsave(&desc->lock, flags);
 |    <remove action from linked list>
 |    raw_spin_unlock_irqrestore(&desc->lock, flags);
 |
 |  __setup_irq()
 |    raw_spin_lock_irqsave(&desc->lock, flags);
 |    <traverse linked list to determine oneshot mask bit>
 |    raw_spin_unlock_irqrestore(&desc->lock, flags);
 |
 |  irq_thread() of freed irq (__free_irq() waits in synchronize_irq())
 |    irq_thread_fn()
 |      irq_finalize_oneshot()
 |        raw_spin_lock_irq(&desc->lock);
 |        desc->threads_oneshot &= ~action->thread_mask;
 |        raw_spin_unlock_irq(&desc->lock);
 v

The race was known at least since 2012 when it was documented in a code
comment by commit e04268b0effc ("genirq: Remove paranoid warnons and bogus
fixups"). The race itself is harmless as nothing touches any of the
potentially freed data after synchronize_irq().

In 2017 the race was close by commit 9114014cf4e6 ("genirq: Add mutex to
irq desc to serialize request/free_irq()"), apparently inadvertantly so
because the race is neither mentioned in the commit message nor was the
code comment updated.  Make up for that.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-pci@vger.kernel.org
Link: https://lkml.kernel.org/r/32fc25aa35ecef4b2692f57687bb7fc2a57230e2.1529828292.git.lukas@wunner.de
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
---
 kernel/irq/manage.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 914b43f2255b..cb35db00fdf4 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1030,10 +1030,7 @@ static int irq_thread(void *data)
 	 * This is the regular exit path. __free_irq() is stopping the
 	 * thread via kthread_stop() after calling
 	 * synchronize_irq(). So neither IRQTF_RUNTHREAD nor the
-	 * oneshot mask bit can be set. We cannot verify that as we
-	 * cannot touch the oneshot mask at this point anymore as
-	 * __setup_irq() might have given out currents thread_mask
-	 * again.
+	 * oneshot mask bit can be set.
 	 */
 	task_work_cancel(current, irq_thread_dtor);
 	return 0;
@@ -1257,7 +1254,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	/*
 	 * Protects against a concurrent __free_irq() call which might wait
 	 * for synchronize_irq() to complete without holding the optional
-	 * chip bus lock and desc->lock.
+	 * chip bus lock and desc->lock. Also protects against handing out
+	 * a recycled oneshot thread_mask bit while it's still in use by
+	 * its previous owner.
 	 */
 	mutex_lock(&desc->request_mutex);
 
-- 
2.37.1


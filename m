Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319735EFF14
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 23:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiI2VI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 17:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiI2VIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 17:08:11 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCE91BB213;
        Thu, 29 Sep 2022 14:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664485685; x=1696021685;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4xFMemv5wCjE62FCtGJkFdiowS6Gw4GSqimCpZEcgns=;
  b=E95M34jRbkVL5ubNVFaW+TQnc4gO2pjYgBc4qalUGTlq53b+w6863VBV
   tWDQNdCOj+lulfL/McYd8svvmFqe5g9Fg8db0bkFfLIkAoEp+9Rj2c7Wy
   BTRYlA9Mb+JzzqVSsBhJLn1UDtnDzzTtTmF9XIN5d/xMoR8biqtnJ77Bo
   w=;
X-IronPort-AV: E=Sophos;i="5.93,356,1654560000"; 
   d="scan'208";a="229640955"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-2dbf0206.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 21:08:02 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-2dbf0206.us-west-2.amazon.com (Postfix) with ESMTPS id DD88BA291E;
        Thu, 29 Sep 2022 21:08:00 +0000 (UTC)
Received: from EX19D012UWC002.ant.amazon.com (10.13.138.165) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 29 Sep 2022 21:08:00 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX19D012UWC002.ant.amazon.com (10.13.138.165) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.12; Thu, 29 Sep 2022 21:07:54 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1497.38 via Frontend Transport; Thu, 29 Sep 2022 21:07:53
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 21D38286F; Thu, 29 Sep 2022 21:07:52 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>, <benh@amazon.com>,
        <mbacco@amazon.com>, Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 0/6] IRQ handling patches backport to 4.14 stable
Date:   Thu, 29 Sep 2022 21:06:45 +0000
Message-ID: <20220929210651.12308-1-risbhat@amazon.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-12.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch series backports a bunch of patches related IRQ handling
with respect to freeing the irq line while IRQ is in flight at CPU
or at the hardware level.
Recently we saw this issue in serial 8250 driver where the IRQ was being
freed while the irq was in flight or not yet delivered to the CPU. As a
result the irqchip was going into a wedged state and IRQ was not getting
delivered to the cpu. These patches helped fixed the issue in 4.14
kernel.
Let us know if more patches need backporting.

Lukas Wunner (2):
  genirq: Update code comments wrt recycled thread_mask
  genirq: Synchronize only with single thread on free_irq()

Thomas Gleixner (4):
  genirq: Delay deactivation in free_irq()
  genirq: Fix misleading synchronize_irq() documentation
  genirq: Add optional hardware synchronization for shutdown
  x86/ioapic: Implement irq_get_irqchip_state() callback

 arch/x86/kernel/apic/io_apic.c |  46 ++++++++++++++
 kernel/irq/autoprobe.c         |   6 +-
 kernel/irq/chip.c              |   6 ++
 kernel/irq/cpuhotplug.c        |   2 +-
 kernel/irq/internals.h         |   5 ++
 kernel/irq/manage.c            | 106 ++++++++++++++++++++++-----------
 6 files changed, 133 insertions(+), 38 deletions(-)

-- 
2.37.1


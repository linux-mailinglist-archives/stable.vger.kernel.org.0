Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD885EFF10
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 23:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiI2VIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 17:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiI2VH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 17:07:58 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2801B913E;
        Thu, 29 Sep 2022 14:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664485678; x=1696021678;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v8KVjT5ZmAl7RwJ1fGyjblYqJA7VSALImmUraMpoDow=;
  b=TAcyANuBNjsIwTaMk2LXsaOSMjXDZzbXYgLID4PcGTj9h5JNGyFwckXp
   hX2x798dy8Cw2R3cLOIz+XYOy4jLpdbVt8dTdBVGhtC8Fh5uhgl8QrgEf
   96cnrjMUB/ocRmjhYn4R8YzZd5GB1vikEC31Q6CHpGTmsCZDbO7PA8mIY
   I=;
X-IronPort-AV: E=Sophos;i="5.93,356,1654560000"; 
   d="scan'208";a="135465330"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-388992e0.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 21:07:56 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-388992e0.us-west-2.amazon.com (Postfix) with ESMTPS id C51A6A0A66;
        Thu, 29 Sep 2022 21:07:54 +0000 (UTC)
Received: from EX19D012UWB002.ant.amazon.com (10.13.138.53) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 29 Sep 2022 21:07:53 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX19D012UWB002.ant.amazon.com (10.13.138.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.12; Thu, 29 Sep 2022 21:07:53 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server id 15.0.1497.38 via Frontend Transport; Thu, 29 Sep 2022 21:07:53
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 24CE42868; Thu, 29 Sep 2022 21:07:52 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>, <benh@amazon.com>,
        <mbacco@amazon.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 4/6] genirq: Fix misleading synchronize_irq() documentation
Date:   Thu, 29 Sep 2022 21:06:49 +0000
Message-ID: <20220929210651.12308-5-risbhat@amazon.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220929210651.12308-1-risbhat@amazon.com>
References: <20220929210651.12308-1-risbhat@amazon.com>
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

From: Thomas Gleixner <tglx@linutronix.de>

commit 1d21f2af8571c6a6a44e7c1911780614847b0253 upstream.

The function might sleep, so it cannot be called from interrupt
context. Not even with care.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Link: https://lkml.kernel.org/r/20190628111440.189241552@linutronix.de
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
---
 kernel/irq/manage.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 4e4fc7879307..a72d7ae0418b 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -96,7 +96,8 @@ EXPORT_SYMBOL(synchronize_hardirq);
  *	to complete before returning. If you use this function while
  *	holding a resource the IRQ handler may need you will deadlock.
  *
- *	This function may be called - with care - from IRQ context.
+ *	Can only be called from preemptible code as it might sleep when
+ *	an interrupt thread is associated to @irq.
  */
 void synchronize_irq(unsigned int irq)
 {
-- 
2.37.1


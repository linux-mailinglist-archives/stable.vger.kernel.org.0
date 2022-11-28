Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026EC63AE93
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiK1RKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbiK1RJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:09:30 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86581114
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 09:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1669655349; x=1701191349;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IuJ6Srx6V/7keuIIxJXP8v+5xgj7B3MKV7Bft4yp1/g=;
  b=bnhGMasHyVF2kFjDwCAvdGzj3yydX3uCrl5ZhMm7vk9xxvwoFJ3ATpvd
   HiN+XzW+xs+y++2pwvQy8PyjEAFNsujoGTpb4Hcsr8wBL2R9JtaVNtEcY
   7qIBf006wksb0ra2wXmT8pihQFCjqCjInkrZKS31ltGthziX/pPDxbGT6
   A=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-f05d30a1.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 17:09:08 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-f05d30a1.us-east-1.amazon.com (Postfix) with ESMTPS id A1E368591D;
        Mon, 28 Nov 2022 17:09:07 +0000 (UTC)
Received: from EX19D028UEC003.ant.amazon.com (10.252.137.159) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 28 Nov 2022 17:09:06 +0000
Received: from dev-dsk-luizcap-1d-af6a6fef.us-east-1.amazon.com
 (10.43.160.223) by EX19D028UEC003.ant.amazon.com (10.252.137.159) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.20; Mon, 28 Nov
 2022 17:09:05 +0000
From:   Luiz Capitulino <luizcap@amazon.com>
To:     <stable@vger.kernel.org>, <maz@kernel.org>
CC:     <tglx@linutronix.de>, <lcapitulino@gmail.com>,
        Luiz Capitulino <luizcap@amazon.com>
Subject: [PATH stable 5.15,5.10 3/4] irqchip/gic-v3: Always trust the managed affinity provided by the core code
Date:   Mon, 28 Nov 2022 17:08:34 +0000
Message-ID: <c5c925684a4f35e61e75581ec0e8c64cc4cf683a.1669655291.git.luizcap@amazon.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1669655291.git.luizcap@amazon.com>
References: <cover.1669655291.git.luizcap@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D31UWC002.ant.amazon.com (10.43.162.220) To
 EX19D028UEC003.ant.amazon.com (10.252.137.159)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 3f893a5962d31c0164efdbf6174ed0784f1d7603 upstream.

Now that the core code has been fixed to always give us an affinity
that only includes online CPUs, directly use this affinity when
computing a target CPU.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20220405185040.206297-4-maz@kernel.org

Signed-off-by: Luiz Capitulino <luizcap@amazon.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index fc1bfffc468f..59a5d06b2d3e 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1620,7 +1620,7 @@ static int its_select_cpu(struct irq_data *d,
 
 		cpu = cpumask_pick_least_loaded(d, tmpmask);
 	} else {
-		cpumask_and(tmpmask, irq_data_get_affinity_mask(d), cpu_online_mask);
+		cpumask_copy(tmpmask, aff_mask);
 
 		/* If we cannot cross sockets, limit the search to that node */
 		if ((its_dev->its->flags & ITS_FLAGS_WORKAROUND_CAVIUM_23144) &&
-- 
2.37.1


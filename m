Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E7F63AE8B
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbiK1RJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbiK1RJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:09:29 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D071275C2
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 09:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1669655349; x=1701191349;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m7jccjQDK22hJQjvIBVSy+gXx3FWq7E32RsrW7B8V+c=;
  b=HcB5JOUZXuRtry6ckQBHQPNmqQ4WO5FePNc1v2MkC/dMn//BORUIJwAe
   OGRYYS7A98ZWZjUlQUtXovnqo3gglhPENnLvvLIWFaAXt1uleesz5+WA3
   ogWXFEr2NprOstENaGJvrIV+3/KH2CkKD82HGxnFGkS9JD/brBDrifo2+
   I=;
X-IronPort-AV: E=Sophos;i="5.96,200,1665446400"; 
   d="scan'208";a="284759792"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-6e7a78d7.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 17:09:07 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-6e7a78d7.us-east-1.amazon.com (Postfix) with ESMTPS id EF772815FE;
        Mon, 28 Nov 2022 17:09:04 +0000 (UTC)
Received: from EX19D028UEC003.ant.amazon.com (10.252.137.159) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 28 Nov 2022 17:09:03 +0000
Received: from dev-dsk-luizcap-1d-af6a6fef.us-east-1.amazon.com
 (10.43.160.223) by EX19D028UEC003.ant.amazon.com (10.252.137.159) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.20; Mon, 28 Nov
 2022 17:09:02 +0000
From:   Luiz Capitulino <luizcap@amazon.com>
To:     <stable@vger.kernel.org>, <maz@kernel.org>
CC:     <tglx@linutronix.de>, <lcapitulino@gmail.com>,
        John Garry <john.garry@huawei.com>,
        David Decotigny <ddecotig@google.com>,
        "Luiz Capitulino" <luizcap@amazon.com>
Subject: [PATH stable 5.15,5.10 1/4] genirq/msi: Shutdown managed interrupts with unsatifiable affinities
Date:   Mon, 28 Nov 2022 17:08:32 +0000
Message-ID: <987f78b332076edcf0b05d169bcd2694edee7c05.1669655291.git.luizcap@amazon.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1669655291.git.luizcap@amazon.com>
References: <cover.1669655291.git.luizcap@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D31UWC002.ant.amazon.com (10.43.162.220) To
 EX19D028UEC003.ant.amazon.com (10.252.137.159)
X-Spam-Status: No, score=-14.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit d802057c7c553ad426520a053da9f9fe08e2c35a upstream.

[ This commit is almost a rewrite because it conflicts with Thomas
  Gleixner's refactoring of this code in v5.17-rc1. I wasn't sure if
  I should drop all the s-o-bs (including Mark's), but decided
  to keep as the original commit ]

When booting with maxcpus=<small number>, interrupt controllers
such as the GICv3 ITS may not be able to satisfy the affinity of
some managed interrupts, as some of the HW resources are simply
not available.

The same thing happens when loading a driver using managed interrupts
while CPUs are offline.

In order to deal with this, do not try to activate such interrupt
if there is no online CPU capable of handling it. Instead, place
it in shutdown state. Once a capable CPU shows up, it will be
activated.

Reported-by: John Garry <john.garry@huawei.com>
Reported-by: David Decotigny <ddecotig@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: John Garry <john.garry@huawei.com>
Link: https://lore.kernel.org/r/20220405185040.206297-2-maz@kernel.org

Signed-off-by: Luiz Capitulino <luizcap@amazon.com>
---
 kernel/irq/msi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 7f350ae59c5f..d75586dc584f 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -596,6 +596,13 @@ int __msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 			irqd_clr_can_reserve(irq_data);
 			if (domain->flags & IRQ_DOMAIN_MSI_NOMASK_QUIRK)
 				irqd_set_msi_nomask_quirk(irq_data);
+			if ((info->flags & MSI_FLAG_ACTIVATE_EARLY) &&
+				irqd_affinity_is_managed(irq_data) &&
+				!cpumask_intersects(irq_data_get_affinity_mask(irq_data),
+						    cpu_online_mask)) {
+				irqd_set_managed_shutdown(irq_data);
+				continue;
+			}
 		}
 		ret = irq_domain_activate_irq(irq_data, can_reserve);
 		if (ret)
-- 
2.37.1


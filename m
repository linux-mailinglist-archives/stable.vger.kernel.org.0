Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A627163AE92
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiK1RKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232688AbiK1RJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:09:36 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD95427B11
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 09:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1669655350; x=1701191350;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0mt2Omqkad23ADO64tmu+t9xP+SpCKirgM13ek68e8s=;
  b=vhcg0By8Ped+VJp5RxXRAkJzGpaNw9SmYmujQEvaUixEy6BRr79pnd3I
   nrdPW6dfYeVGtlCeRGtJrNgMtZ5kJZe6+iGCGuN8LDtaCHQvKtPLiifJG
   2std2DcHD36AOVlzdAecBEwCx4RRKTv+mp2KbP8eTFM/Y4/d0njQf7tlQ
   M=;
X-IronPort-AV: E=Sophos;i="5.96,200,1665446400"; 
   d="scan'208";a="155562109"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-f05d30a1.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 17:09:09 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-f05d30a1.us-east-1.amazon.com (Postfix) with ESMTPS id 4230D8591E;
        Mon, 28 Nov 2022 17:09:08 +0000 (UTC)
Received: from EX19D028UEC003.ant.amazon.com (10.252.137.159) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 28 Nov 2022 17:09:07 +0000
Received: from dev-dsk-luizcap-1d-af6a6fef.us-east-1.amazon.com
 (10.43.160.223) by EX19D028UEC003.ant.amazon.com (10.252.137.159) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.20; Mon, 28 Nov
 2022 17:09:06 +0000
From:   Luiz Capitulino <luizcap@amazon.com>
To:     <stable@vger.kernel.org>, <maz@kernel.org>
CC:     <tglx@linutronix.de>, <lcapitulino@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Luiz Capitulino <luizcap@amazon.com>
Subject: [PATH stable 5.15,5.10 4/4] genirq: Take the proposed affinity at face value if force==true
Date:   Mon, 28 Nov 2022 17:08:35 +0000
Message-ID: <56bb8afbb97c6ed2364ba49dd0695ce7681aa3ec.1669655291.git.luizcap@amazon.com>
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
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit c48c8b829d2b966a6649827426bcdba082ccf922 upstream.

Although setting the affinity of an interrupt to a set of CPUs that doesn't
have any online CPU is generally frowned apon, there are a few limited
cases where such affinity is set from a CPUHP notifier, setting the
affinity to a CPU that isn't online yet.

The saving grace is that this is always done using the 'force' attribute,
which gives a hint that the affinity setting can be outside of the online
CPU mask and the callsite set this flag with the knowledge that the
underlying interrupt controller knows to handle it.

This restores the expected behaviour on Marek's system.

Fixes: 33de0aa4bae9 ("genirq: Always limit the affinity to online CPUs")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/4b7fc13c-887b-a664-26e8-45aed13f048a@samsung.com
Link: https://lore.kernel.org/r/20220414140011.541725-1-maz@kernel.org

Signed-off-by: Luiz Capitulino <luizcap@amazon.com>
---
 kernel/irq/manage.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index a1727cdaebed..9862372e0f01 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -266,10 +266,16 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
 		prog_mask = mask;
 	}
 
-	/* Make sure we only provide online CPUs to the irqchip */
+	/*
+	 * Make sure we only provide online CPUs to the irqchip,
+	 * unless we are being asked to force the affinity (in which
+	 * case we do as we are told).
+	 */
 	cpumask_and(&tmp_mask, prog_mask, cpu_online_mask);
-	if (!cpumask_empty(&tmp_mask))
+	if (!force && !cpumask_empty(&tmp_mask))
 		ret = chip->irq_set_affinity(data, &tmp_mask, force);
+	else if (force)
+		ret = chip->irq_set_affinity(data, mask, force);
 	else
 		ret = -EINVAL;
 
-- 
2.37.1


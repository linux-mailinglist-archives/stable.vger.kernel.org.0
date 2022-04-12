Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27C34FD9AC
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351717AbiDLHVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351880AbiDLHNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:13:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1839AE42;
        Mon, 11 Apr 2022 23:54:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81F4CB81B44;
        Tue, 12 Apr 2022 06:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAECDC385AA;
        Tue, 12 Apr 2022 06:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746439;
        bh=e9O41xtZGrmCpXGoo/uLMcFr7AIxfezKsEgG2L32/xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROKdipe2sUvSFRqUlxrdTsIK2SpPyvI//mSZAiVdvju1INn9+GRaEqEy1FqhRlW22
         kDqx5Ng2ngZmjhd/Y3cLp3JbhhW2mxoikjFdrU4Wp+NVlCf/wQGfi1WeJjhH44DAQC
         w3Gnw4zcN+A7HPYlm6KMxE0Im9Wxk6hAyNP9TAIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.15 274/277] irqchip/gic, gic-v3: Prevent GSI to SGI translations
Date:   Tue, 12 Apr 2022 08:31:17 +0200
Message-Id: <20220412062949.970457710@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

commit 544808f7e21cb9ccdb8f3aa7de594c05b1419061 upstream.

At the moment the GIC IRQ domain translation routine happily converts
ACPI table GSI numbers below 16 to GIC SGIs (Software Generated
Interrupts aka IPIs). On the Devicetree side we explicitly forbid this
translation, actually the function will never return HWIRQs below 16 when
using a DT based domain translation.

We expect SGIs to be handled in the first part of the function, and any
further occurrence should be treated as a firmware bug, so add a check
and print to report this explicitly and avoid lengthy debug sessions.

Fixes: 64b499d8df40 ("irqchip/gic-v3: Configure SGIs as standard interrupts")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220404110842.2882446-1-andre.przywara@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3.c |    6 ++++++
 drivers/irqchip/irq-gic.c    |    6 ++++++
 2 files changed, 12 insertions(+)

--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -1466,6 +1466,12 @@ static int gic_irq_domain_translate(stru
 		if(fwspec->param_count != 2)
 			return -EINVAL;
 
+		if (fwspec->param[0] < 16) {
+			pr_err(FW_BUG "Illegal GSI%d translation request\n",
+			       fwspec->param[0]);
+			return -EINVAL;
+		}
+
 		*hwirq = fwspec->param[0];
 		*type = fwspec->param[1];
 
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -1085,6 +1085,12 @@ static int gic_irq_domain_translate(stru
 		if(fwspec->param_count != 2)
 			return -EINVAL;
 
+		if (fwspec->param[0] < 16) {
+			pr_err(FW_BUG "Illegal GSI%d translation request\n",
+			       fwspec->param[0]);
+			return -EINVAL;
+		}
+
 		*hwirq = fwspec->param[0];
 		*type = fwspec->param[1];
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337B44FD102
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350722AbiDLG4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351447AbiDLGxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:53:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9666537A02;
        Mon, 11 Apr 2022 23:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3269D6066C;
        Tue, 12 Apr 2022 06:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44291C385A6;
        Tue, 12 Apr 2022 06:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745644;
        bh=y2DNNVBx5SWbbmfK9tHTVRVLPLpPxg3WP4QUXKjhOXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqbbaiRzD8qoEXKHrRVwj3VpsCU+Vs8Oq8WVJvCTD709NNGM7H/4apnogzE3SlRN9
         zxA68/V+2dPRx6RnabbPkIDQ8aIzxcFPGqzyJjy4SndxCK1bMX32u8jceVW5aI8c7c
         Map+xl580hXTgvlzpC8R9jeTkkd1ErnJrYNy31UM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.10 169/171] irqchip/gic, gic-v3: Prevent GSI to SGI translations
Date:   Tue, 12 Apr 2022 08:31:00 +0200
Message-Id: <20220412062932.790182051@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
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
@@ -1467,6 +1467,12 @@ static int gic_irq_domain_translate(stru
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
@@ -1094,6 +1094,12 @@ static int gic_irq_domain_translate(stru
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
 



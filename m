Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310E367FF5D
	for <lists+stable@lfdr.de>; Sun, 29 Jan 2023 14:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234900AbjA2N35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Jan 2023 08:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjA2N34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Jan 2023 08:29:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F094359F6
        for <stable@vger.kernel.org>; Sun, 29 Jan 2023 05:29:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA1F7B80C98
        for <stable@vger.kernel.org>; Sun, 29 Jan 2023 13:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF49FC433D2;
        Sun, 29 Jan 2023 13:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674998993;
        bh=IcseuIr1U1DQBs2by3V/TD0qcJ1qhZ+vQTHAFukKzwI=;
        h=Subject:To:Cc:From:Date:From;
        b=FDDZpjOipa02SdWBfwt7ysylPr1sXNjqY7IThhcrTDNv9ydtTk0OragubyMWa0nBh
         1yg1PGtV/OTZvjC4MszmAEQ9rAq5OgpGMxvOpPlKSsLNCL9UMmDDrY+q6Frd9oePz9
         0J0RMUwJZ5ISqe1M6y4/5fFgjE0aUctbGGumeJ28=
Subject: FAILED: patch "[PATCH] net: mana: Fix IRQ name - add PCI and queue number" failed to apply to 5.15-stable tree
To:     haiyangz@microsoft.com, jesse.brandeburg@intel.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Jan 2023 14:29:42 +0100
Message-ID: <1674998982450@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

20e3028c39a5 ("net: mana: Fix IRQ name - add PCI and queue number")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 20e3028c39a5bf882e91e717da96d14f1acec40e Mon Sep 17 00:00:00 2001
From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Thu, 19 Jan 2023 12:59:10 -0800
Subject: [PATCH] net: mana: Fix IRQ name - add PCI and queue number

The PCI and queue number info is missing in IRQ names.

Add PCI and queue number to IRQ names, to allow CPU affinity
tuning scripts to work.

Cc: stable@vger.kernel.org
Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Link: https://lore.kernel.org/r/1674161950-19708-1-git-send-email-haiyangz@microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index e708c2d04983..b144f2237748 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1259,13 +1259,20 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 		gic->handler = NULL;
 		gic->arg = NULL;
 
+		if (!i)
+			snprintf(gic->name, MANA_IRQ_NAME_SZ, "mana_hwc@pci:%s",
+				 pci_name(pdev));
+		else
+			snprintf(gic->name, MANA_IRQ_NAME_SZ, "mana_q%d@pci:%s",
+				 i - 1, pci_name(pdev));
+
 		irq = pci_irq_vector(pdev, i);
 		if (irq < 0) {
 			err = irq;
 			goto free_mask;
 		}
 
-		err = request_irq(irq, mana_gd_intr, 0, "mana_intr", gic);
+		err = request_irq(irq, mana_gd_intr, 0, gic->name, gic);
 		if (err)
 			goto free_mask;
 		irq_set_affinity_and_hint(irq, req_mask);
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index b3ba04615caa..56189e4252da 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -336,9 +336,12 @@ struct gdma_queue_spec {
 	};
 };
 
+#define MANA_IRQ_NAME_SZ 32
+
 struct gdma_irq_context {
 	void (*handler)(void *arg);
 	void *arg;
+	char name[MANA_IRQ_NAME_SZ];
 };
 
 struct gdma_context {


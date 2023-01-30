Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D42C6810B5
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237072AbjA3OFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237075AbjA3OFx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:05:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FA913D5C
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:05:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5C1C61025
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39ECC433D2;
        Mon, 30 Jan 2023 14:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087551;
        bh=4TDDO4gslvH0QlCL6gOlFERQW1wrBhzV6t4Olgknzgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Acq7Pak5ax9+dIZ9H77C58YgmylNYWkUxf7nmKzOuzVCWkz94jm63/nHp2ouTr3xi
         OZgKBYKWAJJnUDTPw5izkCabyKEM6XyB4JwiX1Zv9hb8UgJ25tFbUvou1kH2Zf0zRT
         6qnIgkSeiS/jiv6Px0INY/CT8y65roH+M/CGzsCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Haiyang Zhang <haiyangz@microsoft.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 246/313] net: mana: Fix IRQ name - add PCI and queue number
Date:   Mon, 30 Jan 2023 14:51:21 +0100
Message-Id: <20230130134348.161750663@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

[ Upstream commit 20e3028c39a5bf882e91e717da96d14f1acec40e ]

The PCI and queue number info is missing in IRQ names.

Add PCI and queue number to IRQ names, to allow CPU affinity
tuning scripts to work.

Cc: stable@vger.kernel.org
Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Link: https://lore.kernel.org/r/1674161950-19708-1-git-send-email-haiyangz@microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/gdma.h      | 3 +++
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 9 ++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma.h b/drivers/net/ethernet/microsoft/mana/gdma.h
index 65c24ee49efd..48b0ab56bdb0 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma.h
+++ b/drivers/net/ethernet/microsoft/mana/gdma.h
@@ -324,9 +324,12 @@ struct gdma_queue_spec {
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
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index a6f99b4344d9..d674ebda2053 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1233,13 +1233,20 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
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
 			goto free_irq;
 		}
 
-		err = request_irq(irq, mana_gd_intr, 0, "mana_intr", gic);
+		err = request_irq(irq, mana_gd_intr, 0, gic->name, gic);
 		if (err)
 			goto free_irq;
 	}
-- 
2.39.0




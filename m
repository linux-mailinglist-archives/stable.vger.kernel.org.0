Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC894568DE7
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 17:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbiGFPiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 11:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234666AbiGFPhl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 11:37:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3513126573;
        Wed,  6 Jul 2022 08:34:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7BE161FE9;
        Wed,  6 Jul 2022 15:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6824DC3411C;
        Wed,  6 Jul 2022 15:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121650;
        bh=cbhrjjI2ACYwPNg073yABjQun3/N+aYHZNnGJjt2v9c=;
        h=From:To:Cc:Subject:Date:From;
        b=VLJzcbSmMAhJI/m+aHd7tML4IizARznknPAlKKqZMvFZiE7wFqxzLKEhGm7yjTk1Z
         l6KZzCmsOQM6711DYN0WScIuHhHNO08cEsV+gyMsJeG2KqGFnrx9tpcAzY0KhtT5TE
         0JkdkJ5KBJ3gS465DRrlWXAEndjn55L54VxCI+aGOpsCF6NHrT5RaendN+7rHbnm2I
         dJ1I0yjFimjqKcB7bGD+EsdXPUbgOpiYP82xPw66rgjKGDHy8uH/D0jXo4bReWCCFO
         H2atW5qMt24b3WHD9mQpfr6VIPEStAO7f3GtmCe823Cv5aic5qLsQeUdjYUm3muvBF
         hdTU28akTJ9/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephan Gerhold <stephan.gerhold@kernkonzept.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.9 1/5] virtio_mmio: Add missing PM calls to freeze/restore
Date:   Wed,  6 Jul 2022 11:34:03 -0400
Message-Id: <20220706153407.1598915-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan.gerhold@kernkonzept.com>

[ Upstream commit ed7ac37fde33ccd84e4bd2b9363c191f925364c7 ]

Most virtio drivers provide freeze/restore callbacks to finish up
device usage before suspend and to reinitialize the virtio device after
resume. However, these callbacks are currently only called when using
virtio_pci. virtio_mmio does not have any PM ops defined.

This causes problems for example after suspend to disk (hibernation),
since the virtio devices might lose their state after the VMM is
restarted. Calling virtio_device_freeze()/restore() ensures that
the virtio devices are re-initialized correctly.

Fix this by implementing the dev_pm_ops for virtio_mmio,
similar to virtio_pci_common.

Signed-off-by: Stephan Gerhold <stephan.gerhold@kernkonzept.com>
Message-Id: <20220621110621.3638025-2-stephan.gerhold@kernkonzept.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_mmio.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index f62da3b7c27b..d69f0c5135ff 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -66,6 +66,7 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/virtio.h>
@@ -489,6 +490,25 @@ static const struct virtio_config_ops virtio_mmio_config_ops = {
 	.bus_name	= vm_bus_name,
 };
 
+#ifdef CONFIG_PM_SLEEP
+static int virtio_mmio_freeze(struct device *dev)
+{
+	struct virtio_mmio_device *vm_dev = dev_get_drvdata(dev);
+
+	return virtio_device_freeze(&vm_dev->vdev);
+}
+
+static int virtio_mmio_restore(struct device *dev)
+{
+	struct virtio_mmio_device *vm_dev = dev_get_drvdata(dev);
+
+	return virtio_device_restore(&vm_dev->vdev);
+}
+
+static const struct dev_pm_ops virtio_mmio_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(virtio_mmio_freeze, virtio_mmio_restore)
+};
+#endif
 
 
 /* Platform device */
@@ -730,6 +750,9 @@ static struct platform_driver virtio_mmio_driver = {
 		.name	= "virtio-mmio",
 		.of_match_table	= virtio_mmio_match,
 		.acpi_match_table = ACPI_PTR(virtio_mmio_acpi_match),
+#ifdef CONFIG_PM_SLEEP
+		.pm	= &virtio_mmio_pm_ops,
+#endif
 	},
 };
 
-- 
2.35.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA702579B2A
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbiGSMZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239649AbiGSMYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:24:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F11A4F66B;
        Tue, 19 Jul 2022 05:08:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D01ABB81B13;
        Tue, 19 Jul 2022 12:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35022C341C6;
        Tue, 19 Jul 2022 12:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232496;
        bh=c/4PWi9uW7ks+TPO9bvDxMl2pN9E6hNEXRQhKN88tuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQSblhKQBCtxOPp3VhX+QbCimpITyizIGckvJql1N7o+Otu4sb1PZgQaU1uN8mJ5B
         gsbQXgDJoaDNRxRP3rsRiQ1EYVdeqej32F9J/08qCc0m+VD0nC+JLzEraZSdthRfce
         6uJfTLxOAYCvecNlbCQtXJB/YoBnVhsPuGEjjq70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephan Gerhold <stephan.gerhold@kernkonzept.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/112] virtio_mmio: Add missing PM calls to freeze/restore
Date:   Tue, 19 Jul 2022 13:54:10 +0200
Message-Id: <20220719114633.956609800@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 5c970e6f664c..7dec1418bf7c 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -62,6 +62,7 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/virtio.h>
@@ -543,6 +544,25 @@ static const struct virtio_config_ops virtio_mmio_config_ops = {
 	.get_shm_region = vm_get_shm_region,
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
 
 static void virtio_mmio_release_dev(struct device *_d)
 {
@@ -787,6 +807,9 @@ static struct platform_driver virtio_mmio_driver = {
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




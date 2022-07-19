Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9275257999C
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237847AbiGSMFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238230AbiGSMEN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:04:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E34624B;
        Tue, 19 Jul 2022 05:00:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A5AAB81A2E;
        Tue, 19 Jul 2022 12:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F79C341C6;
        Tue, 19 Jul 2022 12:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232004;
        bh=hpgqN9gPyrD+s6Zv2Qf9lSxoie1Cst3YbDw+RW+CBV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/F4RGCZyImEakWivxdfTOGDPqEq6R+H1mpXUQZrh0NGspxILS4cHH0RqZDYvSqB5
         S0ZHK2NPF0GOSc3b/GvAM9nybwWIIokhoZXMmDnqp+3N+0LfVk4F3ka5f7CBGODXJv
         km1LZYAQllcz9qLXlZKhtk9lDGFcuIm3mPHoej0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephan Gerhold <stephan.gerhold@kernkonzept.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/48] virtio_mmio: Add missing PM calls to freeze/restore
Date:   Tue, 19 Jul 2022 13:54:04 +0200
Message-Id: <20220719114522.337428737@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114518.915546280@linuxfoundation.org>
References: <20220719114518.915546280@linuxfoundation.org>
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
index c69c755bf553..79474bd0c52c 100644
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
@@ -508,6 +509,25 @@ static const struct virtio_config_ops virtio_mmio_config_ops = {
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
 
 static void virtio_mmio_release_dev(struct device *_d)
 {
@@ -761,6 +781,9 @@ static struct platform_driver virtio_mmio_driver = {
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




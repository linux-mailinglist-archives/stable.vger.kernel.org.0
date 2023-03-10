Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A696B42D1
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbjCJOHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbjCJOHE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:07:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFD011A2F0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:06:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F3AF618B8
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AB0C433EF;
        Fri, 10 Mar 2023 14:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457194;
        bh=2EJoXkG/mgcjNmYybyvetNkvumVNb3MELmkzViU2M8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FX2yyrmr3daXUcrzm5mA4BvWb09dDgAtTGY7jPBMmtM7igW7BVjM3dpjQsQ+lPcqe
         Gda+20+vUXfPpNDYB7NVLfbSbOU32Cg+U9iRYQW2Hb5d0XhP+9VhSPDXDxcPVMtb3g
         R2ER7w43fEu9XmP3yUGRbdzcSlxYIC2ZD8IiVS5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Benjamin Berg <benjamin.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/200] um: virt-pci: properly remove PCI device from bus
Date:   Fri, 10 Mar 2023 14:37:39 +0100
Message-Id: <20230310133718.706400692@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 339b84dcd7113dd076419ea2a47128cc53450305 ]

Triggering a bus rescan will not cause the PCI device to be removed. It
is required to explicitly stop and remove the device from the bus.

Fixes: 68f5d3f3b654 ("um: add PCI over virtio emulation driver")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/virt-pci.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/um/drivers/virt-pci.c b/arch/um/drivers/virt-pci.c
index 3b637ad75ec81..5472b1a0a0398 100644
--- a/arch/um/drivers/virt-pci.c
+++ b/arch/um/drivers/virt-pci.c
@@ -626,22 +626,33 @@ static void um_pci_virtio_remove(struct virtio_device *vdev)
 	struct um_pci_device *dev = vdev->priv;
 	int i;
 
-        /* Stop all virtqueues */
-        virtio_reset_device(vdev);
-        vdev->config->del_vqs(vdev);
-
 	device_set_wakeup_enable(&vdev->dev, false);
 
 	mutex_lock(&um_pci_mtx);
 	for (i = 0; i < MAX_DEVICES; i++) {
 		if (um_pci_devices[i].dev != dev)
 			continue;
+
 		um_pci_devices[i].dev = NULL;
 		irq_free_desc(dev->irq);
+
+		break;
 	}
 	mutex_unlock(&um_pci_mtx);
 
-	um_pci_rescan();
+	if (i < MAX_DEVICES) {
+		struct pci_dev *pci_dev;
+
+		pci_dev = pci_get_slot(bridge->bus, i);
+		if (pci_dev)
+			pci_stop_and_remove_bus_device_locked(pci_dev);
+	}
+
+	/* Stop all virtqueues */
+	virtio_reset_device(vdev);
+	dev->cmd_vq = NULL;
+	dev->irq_vq = NULL;
+	vdev->config->del_vqs(vdev);
 
 	kfree(dev);
 }
-- 
2.39.2




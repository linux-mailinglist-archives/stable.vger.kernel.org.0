Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA0E359DBC4
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352981AbiHWKMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352940AbiHWKJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:09:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD037DF7D;
        Tue, 23 Aug 2022 01:55:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C0BF614E7;
        Tue, 23 Aug 2022 08:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A53C433C1;
        Tue, 23 Aug 2022 08:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244951;
        bh=zuynUB4qvXHwuhHt93KM7PDIxN+C9d44hf1QyZClopY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/GCJMRK0Pi6ARBTWxM2yvIZkgBiQMYcKaO5wfsPR+kvBOEZx2nkCwD3Zs6zouNQQ
         7bXDWGP/aaki3nuCkHg4bjQ2XTTmIxrP0emLlVVUQtY+dPxc+lnBKjtZtJA9/vzDOC
         4TutkhPQmZ94/HxDPL7XNzZoHh5fCEjz4spX6Ql4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Pascal Terjan <pterjan@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 177/244] vboxguest: Do not use devm for irq
Date:   Tue, 23 Aug 2022 10:25:36 +0200
Message-Id: <20220823080105.199528364@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Pascal Terjan <pterjan@google.com>

[ Upstream commit 6169525b76764acb81918aa387ac168fb9a55575 ]

When relying on devm it doesn't get freed early enough which causes the
following warning when unloading the module:

[249348.837181] remove_proc_entry: removing non-empty directory 'irq/20', leaking at least 'vboxguest'
[249348.837219] WARNING: CPU: 0 PID: 6708 at fs/proc/generic.c:715 remove_proc_entry+0x119/0x140

[249348.837379] Call Trace:
[249348.837385]  unregister_irq_proc+0xbd/0xe0
[249348.837392]  free_desc+0x23/0x60
[249348.837396]  irq_free_descs+0x4a/0x70
[249348.837401]  irq_domain_free_irqs+0x160/0x1a0
[249348.837452]  mp_unmap_irq+0x5c/0x60
[249348.837458]  acpi_unregister_gsi_ioapic+0x29/0x40
[249348.837463]  acpi_unregister_gsi+0x17/0x30
[249348.837467]  acpi_pci_irq_disable+0xbf/0xe0
[249348.837473]  pcibios_disable_device+0x20/0x30
[249348.837478]  pci_disable_device+0xef/0x120
[249348.837482]  vbg_pci_remove+0x6c/0x70 [vboxguest]

Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Pascal Terjan <pterjan@google.com>
Link: https://lore.kernel.org/r/20220612133744.4030602-1-pterjan@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virt/vboxguest/vboxguest_linux.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/virt/vboxguest/vboxguest_linux.c b/drivers/virt/vboxguest/vboxguest_linux.c
index 73eb34849eab..4ccfd30c2a30 100644
--- a/drivers/virt/vboxguest/vboxguest_linux.c
+++ b/drivers/virt/vboxguest/vboxguest_linux.c
@@ -356,8 +356,8 @@ static int vbg_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 		goto err_vbg_core_exit;
 	}
 
-	ret = devm_request_irq(dev, pci->irq, vbg_core_isr, IRQF_SHARED,
-			       DEVICE_NAME, gdev);
+	ret = request_irq(pci->irq, vbg_core_isr, IRQF_SHARED, DEVICE_NAME,
+			  gdev);
 	if (ret) {
 		vbg_err("vboxguest: Error requesting irq: %d\n", ret);
 		goto err_vbg_core_exit;
@@ -367,7 +367,7 @@ static int vbg_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	if (ret) {
 		vbg_err("vboxguest: Error misc_register %s failed: %d\n",
 			DEVICE_NAME, ret);
-		goto err_vbg_core_exit;
+		goto err_free_irq;
 	}
 
 	ret = misc_register(&gdev->misc_device_user);
@@ -403,6 +403,8 @@ static int vbg_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	misc_deregister(&gdev->misc_device_user);
 err_unregister_misc_device:
 	misc_deregister(&gdev->misc_device);
+err_free_irq:
+	free_irq(pci->irq, gdev);
 err_vbg_core_exit:
 	vbg_core_exit(gdev);
 err_disable_pcidev:
@@ -419,6 +421,7 @@ static void vbg_pci_remove(struct pci_dev *pci)
 	vbg_gdev = NULL;
 	mutex_unlock(&vbg_gdev_mutex);
 
+	free_irq(pci->irq, gdev);
 	device_remove_file(gdev->dev, &dev_attr_host_features);
 	device_remove_file(gdev->dev, &dev_attr_host_version);
 	misc_deregister(&gdev->misc_device_user);
-- 
2.35.1




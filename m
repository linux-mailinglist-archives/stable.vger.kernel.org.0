Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D75B59E043
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241539AbiHWK5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357146AbiHWK4l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:56:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECFE67176;
        Tue, 23 Aug 2022 02:13:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2001A60F85;
        Tue, 23 Aug 2022 09:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11115C433D6;
        Tue, 23 Aug 2022 09:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246016;
        bh=qUqsgPOy6zQU4YreXQqm2KXQli+UFswEmunZtLyK6aA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1A6OYAgj+8GkETzNjiFYpzV3MY0rgP/rM7KzW8jB18cc35zxZ5ieRy2TSewD2Bes
         iCwwjlod5VRToOQqOvamriZ2k7kmtKYne2Kz6X8xtS/yNjSmkJoITIYm7xZ0WNedhn
         V91m9L2IMkuyJ47pZ9qqaM1Bomr0QMiYEBW8alv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Pascal Terjan <pterjan@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 262/287] vboxguest: Do not use devm for irq
Date:   Tue, 23 Aug 2022 10:27:11 +0200
Message-Id: <20220823080110.120124284@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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
index 94e055ee7ad6..aa65b20883ef 100644
--- a/drivers/virt/vboxguest/vboxguest_linux.c
+++ b/drivers/virt/vboxguest/vboxguest_linux.c
@@ -341,8 +341,8 @@ static int vbg_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 		goto err_vbg_core_exit;
 	}
 
-	ret = devm_request_irq(dev, pci->irq, vbg_core_isr, IRQF_SHARED,
-			       DEVICE_NAME, gdev);
+	ret = request_irq(pci->irq, vbg_core_isr, IRQF_SHARED, DEVICE_NAME,
+			  gdev);
 	if (ret) {
 		vbg_err("vboxguest: Error requesting irq: %d\n", ret);
 		goto err_vbg_core_exit;
@@ -352,7 +352,7 @@ static int vbg_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	if (ret) {
 		vbg_err("vboxguest: Error misc_register %s failed: %d\n",
 			DEVICE_NAME, ret);
-		goto err_vbg_core_exit;
+		goto err_free_irq;
 	}
 
 	ret = misc_register(&gdev->misc_device_user);
@@ -388,6 +388,8 @@ static int vbg_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	misc_deregister(&gdev->misc_device_user);
 err_unregister_misc_device:
 	misc_deregister(&gdev->misc_device);
+err_free_irq:
+	free_irq(pci->irq, gdev);
 err_vbg_core_exit:
 	vbg_core_exit(gdev);
 err_disable_pcidev:
@@ -404,6 +406,7 @@ static void vbg_pci_remove(struct pci_dev *pci)
 	vbg_gdev = NULL;
 	mutex_unlock(&vbg_gdev_mutex);
 
+	free_irq(pci->irq, gdev);
 	device_remove_file(gdev->dev, &dev_attr_host_features);
 	device_remove_file(gdev->dev, &dev_attr_host_version);
 	misc_deregister(&gdev->misc_device_user);
-- 
2.35.1




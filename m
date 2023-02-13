Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBEEE6948E0
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjBMOyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjBMOyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:54:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89641C7F2
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:53:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BB866106F
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352E7C4339C;
        Mon, 13 Feb 2023 14:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300036;
        bh=tp1Pij4XYd9ZGGiHTEn+7OUhJmyuHRBx1cRhKe6liT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q7zBsp9g1lQ0Kqgx8l1mQmdW3iWsxu+y/1vb0eBdj2s/4miqk/GCln6x22G8Ww9yj
         KOenM4IrhbajJ4SLixsiQQCg9PLNhSAXeBMkd/2aGicBZuJyshpoawkD7JQxGz/Jb2
         S5gcXTi35GXi++2r28kj2hsSBiA/C1I71wPXWRdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zeno Davatz <zdavatz@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Dave Airlie <airlied@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/114] nvidiafb: detect the hardware support before removing console.
Date:   Mon, 13 Feb 2023 15:47:54 +0100
Message-Id: <20230213144744.157001447@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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

From: Dave Airlie <airlied@redhat.com>

[ Upstream commit 04119ab1a49fc41cb70f0472be5455af268fa260 ]

This driver removed the console, but hasn't yet decided if it could
take over the console yet. Instead of doing that, probe the hw for
support and then remove the console afterwards.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216859
Fixes: 145eed48de27 ("fbdev: Remove conflicting devices on PCI bus")
Reported-by: Zeno Davatz <zdavatz@gmail.com>
Tested-by: Zeno Davatz <zdavatz@gmail.com>
Tested-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230205210751.3842103-1-airlied@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/nvidia/nvidia.c | 81 +++++++++++++++--------------
 1 file changed, 42 insertions(+), 39 deletions(-)

diff --git a/drivers/video/fbdev/nvidia/nvidia.c b/drivers/video/fbdev/nvidia/nvidia.c
index 329e2e8133c69..a6c3bc2222463 100644
--- a/drivers/video/fbdev/nvidia/nvidia.c
+++ b/drivers/video/fbdev/nvidia/nvidia.c
@@ -1197,17 +1197,17 @@ static int nvidia_set_fbinfo(struct fb_info *info)
 	return nvidiafb_check_var(&info->var, info);
 }
 
-static u32 nvidia_get_chipset(struct fb_info *info)
+static u32 nvidia_get_chipset(struct pci_dev *pci_dev,
+			      volatile u32 __iomem *REGS)
 {
-	struct nvidia_par *par = info->par;
-	u32 id = (par->pci_dev->vendor << 16) | par->pci_dev->device;
+	u32 id = (pci_dev->vendor << 16) | pci_dev->device;
 
 	printk(KERN_INFO PFX "Device ID: %x \n", id);
 
 	if ((id & 0xfff0) == 0x00f0 ||
 	    (id & 0xfff0) == 0x02e0) {
 		/* pci-e */
-		id = NV_RD32(par->REGS, 0x1800);
+		id = NV_RD32(REGS, 0x1800);
 
 		if ((id & 0x0000ffff) == 0x000010DE)
 			id = 0x10DE0000 | (id >> 16);
@@ -1220,12 +1220,11 @@ static u32 nvidia_get_chipset(struct fb_info *info)
 	return id;
 }
 
-static u32 nvidia_get_arch(struct fb_info *info)
+static u32 nvidia_get_arch(u32 Chipset)
 {
-	struct nvidia_par *par = info->par;
 	u32 arch = 0;
 
-	switch (par->Chipset & 0x0ff0) {
+	switch (Chipset & 0x0ff0) {
 	case 0x0100:		/* GeForce 256 */
 	case 0x0110:		/* GeForce2 MX */
 	case 0x0150:		/* GeForce2 */
@@ -1278,16 +1277,44 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 	struct fb_info *info;
 	unsigned short cmd;
 	int ret;
+	volatile u32 __iomem *REGS;
+	int Chipset;
+	u32 Architecture;
 
 	NVTRACE_ENTER();
 	assert(pd != NULL);
 
+	if (pci_enable_device(pd)) {
+		printk(KERN_ERR PFX "cannot enable PCI device\n");
+		return -ENODEV;
+	}
+
+	/* enable IO and mem if not already done */
+	pci_read_config_word(pd, PCI_COMMAND, &cmd);
+	cmd |= (PCI_COMMAND_IO | PCI_COMMAND_MEMORY);
+	pci_write_config_word(pd, PCI_COMMAND, cmd);
+
+	nvidiafb_fix.mmio_start = pci_resource_start(pd, 0);
+	nvidiafb_fix.mmio_len = pci_resource_len(pd, 0);
+
+	REGS = ioremap(nvidiafb_fix.mmio_start, nvidiafb_fix.mmio_len);
+	if (!REGS) {
+		printk(KERN_ERR PFX "cannot ioremap MMIO base\n");
+		return -ENODEV;
+	}
+
+	Chipset = nvidia_get_chipset(pd, REGS);
+	Architecture = nvidia_get_arch(Chipset);
+	if (Architecture == 0) {
+		printk(KERN_ERR PFX "unknown NV_ARCH\n");
+		goto err_out;
+	}
+
 	ret = aperture_remove_conflicting_pci_devices(pd, "nvidiafb");
 	if (ret)
-		return ret;
+		goto err_out;
 
 	info = framebuffer_alloc(sizeof(struct nvidia_par), &pd->dev);
-
 	if (!info)
 		goto err_out;
 
@@ -1298,11 +1325,6 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 	if (info->pixmap.addr == NULL)
 		goto err_out_kfree;
 
-	if (pci_enable_device(pd)) {
-		printk(KERN_ERR PFX "cannot enable PCI device\n");
-		goto err_out_enable;
-	}
-
 	if (pci_request_regions(pd, "nvidiafb")) {
 		printk(KERN_ERR PFX "cannot request PCI regions\n");
 		goto err_out_enable;
@@ -1318,34 +1340,17 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 	par->paneltweak = paneltweak;
 	par->reverse_i2c = reverse_i2c;
 
-	/* enable IO and mem if not already done */
-	pci_read_config_word(pd, PCI_COMMAND, &cmd);
-	cmd |= (PCI_COMMAND_IO | PCI_COMMAND_MEMORY);
-	pci_write_config_word(pd, PCI_COMMAND, cmd);
-
-	nvidiafb_fix.mmio_start = pci_resource_start(pd, 0);
 	nvidiafb_fix.smem_start = pci_resource_start(pd, 1);
-	nvidiafb_fix.mmio_len = pci_resource_len(pd, 0);
-
-	par->REGS = ioremap(nvidiafb_fix.mmio_start, nvidiafb_fix.mmio_len);
 
-	if (!par->REGS) {
-		printk(KERN_ERR PFX "cannot ioremap MMIO base\n");
-		goto err_out_free_base0;
-	}
+	par->REGS = REGS;
 
-	par->Chipset = nvidia_get_chipset(info);
-	par->Architecture = nvidia_get_arch(info);
-
-	if (par->Architecture == 0) {
-		printk(KERN_ERR PFX "unknown NV_ARCH\n");
-		goto err_out_arch;
-	}
+	par->Chipset = Chipset;
+	par->Architecture = Architecture;
 
 	sprintf(nvidiafb_fix.id, "NV%x", (pd->device & 0x0ff0) >> 4);
 
 	if (NVCommonSetup(info))
-		goto err_out_arch;
+		goto err_out_free_base0;
 
 	par->FbAddress = nvidiafb_fix.smem_start;
 	par->FbMapSize = par->RamAmountKBytes * 1024;
@@ -1401,7 +1406,6 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 		goto err_out_iounmap_fb;
 	}
 
-
 	printk(KERN_INFO PFX
 	       "PCI nVidia %s framebuffer (%dMB @ 0x%lX)\n",
 	       info->fix.id,
@@ -1415,15 +1419,14 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 err_out_free_base1:
 	fb_destroy_modedb(info->monspecs.modedb);
 	nvidia_delete_i2c_busses(par);
-err_out_arch:
-	iounmap(par->REGS);
- err_out_free_base0:
+err_out_free_base0:
 	pci_release_regions(pd);
 err_out_enable:
 	kfree(info->pixmap.addr);
 err_out_kfree:
 	framebuffer_release(info);
 err_out:
+	iounmap(REGS);
 	return -ENODEV;
 }
 
-- 
2.39.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2333A1676DE
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbgBUH6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:58:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:58840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730690AbgBUH6y (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:58:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3B79206ED;
        Fri, 21 Feb 2020 07:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271933;
        bh=qJtzzRSq0bJUJ5ErhIHkEOBEL3M28que+pa3FEb7QrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hovx/YbQwj9eWN08Y8/aQUoEabLDG/RTzkMc8kwUvOvNhoQSHo8vxXd311P2ORwWp
         faZtMWSX3hFaD6Thib+SdeEqDSw81gTeHN9wp+Cuyxb9+s6x15JyF6xnSB9pf7+HZh
         nxll28stJi3/EkymW0E+WomaWDRVXwkZ9zye6q6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Wei Hu <weh@microsoft.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 352/399] video: hyperv: hyperv_fb: Use physical memory for fb on HyperV Gen 1 VMs.
Date:   Fri, 21 Feb 2020 08:41:17 +0100
Message-Id: <20200221072435.220970055@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Hu <weh@microsoft.com>

[ Upstream commit 3a6fb6c4255c3893ab61e2bd4e9ae01ca6bbcd94 ]

On Hyper-V, Generation 1 VMs can directly use VM's physical memory for
their framebuffers. This can improve the efficiency of framebuffer and
overall performence for VM. The physical memory assigned to framebuffer
must be contiguous. We use CMA allocator to get contiguouse physicial
memory when the framebuffer size is greater than 4MB. For size under
4MB, we use alloc_pages to achieve this.

To enable framebuffer memory allocation from CMA, supply a kernel
parameter to give enough space to CMA allocator at boot time. For
example:
    cma=130m
This gives 130MB memory to CAM allocator that can be allocated to
framebuffer. If this fails, we fall back to the old way of using
mmio for framebuffer.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/Kconfig     |   1 +
 drivers/video/fbdev/hyperv_fb.c | 182 +++++++++++++++++++++++++-------
 2 files changed, 144 insertions(+), 39 deletions(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index aa9541bf964b9..f65991a67af28 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -2215,6 +2215,7 @@ config FB_HYPERV
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	select FB_DEFERRED_IO
+	select DMA_CMA if HAVE_DMA_CONTIGUOUS && CMA
 	help
 	  This framebuffer driver supports Microsoft Hyper-V Synthetic Video.
 
diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index 4cd27e5172a16..8cf39d98b2bdf 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -31,6 +31,16 @@
  * "set-vmvideo" command. For example
  *     set-vmvideo -vmname name -horizontalresolution:1920 \
  * -verticalresolution:1200 -resolutiontype single
+ *
+ * Gen 1 VMs also support direct using VM's physical memory for framebuffer.
+ * It could improve the efficiency and performance for framebuffer and VM.
+ * This requires to allocate contiguous physical memory from Linux kernel's
+ * CMA memory allocator. To enable this, supply a kernel parameter to give
+ * enough memory space to CMA allocator for framebuffer. For example:
+ *    cma=130m
+ * This gives 130MB memory to CMA allocator that can be allocated to
+ * framebuffer. For reference, 8K resolution (7680x4320) takes about
+ * 127MB memory.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -228,7 +238,6 @@ struct synthvid_msg {
 } __packed;
 
 
-
 /* FB driver definitions and structures */
 #define HVFB_WIDTH 1152 /* default screen width */
 #define HVFB_HEIGHT 864 /* default screen height */
@@ -258,12 +267,15 @@ struct hvfb_par {
 	/* If true, the VSC notifies the VSP on every framebuffer change */
 	bool synchronous_fb;
 
+	/* If true, need to copy from deferred IO mem to framebuffer mem */
+	bool need_docopy;
+
 	struct notifier_block hvfb_panic_nb;
 
 	/* Memory for deferred IO and frame buffer itself */
 	unsigned char *dio_vp;
 	unsigned char *mmio_vp;
-	unsigned long mmio_pp;
+	phys_addr_t mmio_pp;
 
 	/* Dirty rectangle, protected by delayed_refresh_lock */
 	int x1, y1, x2, y2;
@@ -434,7 +446,7 @@ static void synthvid_deferred_io(struct fb_info *p,
 		maxy = max_t(int, maxy, y2);
 
 		/* Copy from dio space to mmio address */
-		if (par->fb_ready)
+		if (par->fb_ready && par->need_docopy)
 			hvfb_docopy(par, start, PAGE_SIZE);
 	}
 
@@ -751,12 +763,12 @@ static void hvfb_update_work(struct work_struct *w)
 		return;
 
 	/* Copy the dirty rectangle to frame buffer memory */
-	for (j = y1; j < y2; j++) {
-		hvfb_docopy(par,
-			    j * info->fix.line_length +
-			    (x1 * screen_depth / 8),
-			    (x2 - x1) * screen_depth / 8);
-	}
+	if (par->need_docopy)
+		for (j = y1; j < y2; j++)
+			hvfb_docopy(par,
+				    j * info->fix.line_length +
+				    (x1 * screen_depth / 8),
+				    (x2 - x1) * screen_depth / 8);
 
 	/* Refresh */
 	if (par->fb_ready && par->update)
@@ -801,7 +813,8 @@ static int hvfb_on_panic(struct notifier_block *nb,
 	par = container_of(nb, struct hvfb_par, hvfb_panic_nb);
 	par->synchronous_fb = true;
 	info = par->info;
-	hvfb_docopy(par, 0, dio_fb_size);
+	if (par->need_docopy)
+		hvfb_docopy(par, 0, dio_fb_size);
 	synthvid_update(info, 0, 0, INT_MAX, INT_MAX);
 
 	return NOTIFY_DONE;
@@ -940,6 +953,62 @@ static void hvfb_get_option(struct fb_info *info)
 	return;
 }
 
+/*
+ * Allocate enough contiguous physical memory.
+ * Return physical address if succeeded or -1 if failed.
+ */
+static phys_addr_t hvfb_get_phymem(struct hv_device *hdev,
+				   unsigned int request_size)
+{
+	struct page *page = NULL;
+	dma_addr_t dma_handle;
+	void *vmem;
+	phys_addr_t paddr = 0;
+	unsigned int order = get_order(request_size);
+
+	if (request_size == 0)
+		return -1;
+
+	if (order < MAX_ORDER) {
+		/* Call alloc_pages if the size is less than 2^MAX_ORDER */
+		page = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
+		if (!page)
+			return -1;
+
+		paddr = (page_to_pfn(page) << PAGE_SHIFT);
+	} else {
+		/* Allocate from CMA */
+		hdev->device.coherent_dma_mask = DMA_BIT_MASK(64);
+
+		vmem = dma_alloc_coherent(&hdev->device,
+					  round_up(request_size, PAGE_SIZE),
+					  &dma_handle,
+					  GFP_KERNEL | __GFP_NOWARN);
+
+		if (!vmem)
+			return -1;
+
+		paddr = virt_to_phys(vmem);
+	}
+
+	return paddr;
+}
+
+/* Release contiguous physical memory */
+static void hvfb_release_phymem(struct hv_device *hdev,
+				phys_addr_t paddr, unsigned int size)
+{
+	unsigned int order = get_order(size);
+
+	if (order < MAX_ORDER)
+		__free_pages(pfn_to_page(paddr >> PAGE_SHIFT), order);
+	else
+		dma_free_coherent(&hdev->device,
+				  round_up(size, PAGE_SIZE),
+				  phys_to_virt(paddr),
+				  paddr);
+}
+
 
 /* Get framebuffer memory from Hyper-V video pci space */
 static int hvfb_getmem(struct hv_device *hdev, struct fb_info *info)
@@ -949,22 +1018,61 @@ static int hvfb_getmem(struct hv_device *hdev, struct fb_info *info)
 	void __iomem *fb_virt;
 	int gen2vm = efi_enabled(EFI_BOOT);
 	resource_size_t pot_start, pot_end;
+	phys_addr_t paddr;
 	int ret;
 
-	dio_fb_size =
-		screen_width * screen_height * screen_depth / 8;
+	info->apertures = alloc_apertures(1);
+	if (!info->apertures)
+		return -ENOMEM;
 
-	if (gen2vm) {
-		pot_start = 0;
-		pot_end = -1;
-	} else {
+	if (!gen2vm) {
 		pdev = pci_get_device(PCI_VENDOR_ID_MICROSOFT,
-			      PCI_DEVICE_ID_HYPERV_VIDEO, NULL);
+			PCI_DEVICE_ID_HYPERV_VIDEO, NULL);
 		if (!pdev) {
 			pr_err("Unable to find PCI Hyper-V video\n");
+			kfree(info->apertures);
 			return -ENODEV;
 		}
 
+		info->apertures->ranges[0].base = pci_resource_start(pdev, 0);
+		info->apertures->ranges[0].size = pci_resource_len(pdev, 0);
+
+		/*
+		 * For Gen 1 VM, we can directly use the contiguous memory
+		 * from VM. If we succeed, deferred IO happens directly
+		 * on this allocated framebuffer memory, avoiding extra
+		 * memory copy.
+		 */
+		paddr = hvfb_get_phymem(hdev, screen_fb_size);
+		if (paddr != (phys_addr_t) -1) {
+			par->mmio_pp = paddr;
+			par->mmio_vp = par->dio_vp = __va(paddr);
+
+			info->fix.smem_start = paddr;
+			info->fix.smem_len = screen_fb_size;
+			info->screen_base = par->mmio_vp;
+			info->screen_size = screen_fb_size;
+
+			par->need_docopy = false;
+			goto getmem_done;
+		}
+		pr_info("Unable to allocate enough contiguous physical memory on Gen 1 VM. Using MMIO instead.\n");
+	} else {
+		info->apertures->ranges[0].base = screen_info.lfb_base;
+		info->apertures->ranges[0].size = screen_info.lfb_size;
+	}
+
+	/*
+	 * Cannot use the contiguous physical memory.
+	 * Allocate mmio space for framebuffer.
+	 */
+	dio_fb_size =
+		screen_width * screen_height * screen_depth / 8;
+
+	if (gen2vm) {
+		pot_start = 0;
+		pot_end = -1;
+	} else {
 		if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM) ||
 		    pci_resource_len(pdev, 0) < screen_fb_size) {
 			pr_err("Resource not available or (0x%lx < 0x%lx)\n",
@@ -993,20 +1101,6 @@ static int hvfb_getmem(struct hv_device *hdev, struct fb_info *info)
 	if (par->dio_vp == NULL)
 		goto err3;
 
-	info->apertures = alloc_apertures(1);
-	if (!info->apertures)
-		goto err4;
-
-	if (gen2vm) {
-		info->apertures->ranges[0].base = screen_info.lfb_base;
-		info->apertures->ranges[0].size = screen_info.lfb_size;
-		remove_conflicting_framebuffers(info->apertures,
-						KBUILD_MODNAME, false);
-	} else {
-		info->apertures->ranges[0].base = pci_resource_start(pdev, 0);
-		info->apertures->ranges[0].size = pci_resource_len(pdev, 0);
-	}
-
 	/* Physical address of FB device */
 	par->mmio_pp = par->mem->start;
 	/* Virtual address of FB device */
@@ -1017,13 +1111,15 @@ static int hvfb_getmem(struct hv_device *hdev, struct fb_info *info)
 	info->screen_base = par->dio_vp;
 	info->screen_size = dio_fb_size;
 
+getmem_done:
+	remove_conflicting_framebuffers(info->apertures,
+					KBUILD_MODNAME, false);
 	if (!gen2vm)
 		pci_dev_put(pdev);
+	kfree(info->apertures);
 
 	return 0;
 
-err4:
-	vfree(par->dio_vp);
 err3:
 	iounmap(fb_virt);
 err2:
@@ -1032,18 +1128,25 @@ err2:
 err1:
 	if (!gen2vm)
 		pci_dev_put(pdev);
+	kfree(info->apertures);
 
 	return -ENOMEM;
 }
 
 /* Release the framebuffer */
-static void hvfb_putmem(struct fb_info *info)
+static void hvfb_putmem(struct hv_device *hdev, struct fb_info *info)
 {
 	struct hvfb_par *par = info->par;
 
-	vfree(par->dio_vp);
-	iounmap(info->screen_base);
-	vmbus_free_mmio(par->mem->start, screen_fb_size);
+	if (par->need_docopy) {
+		vfree(par->dio_vp);
+		iounmap(info->screen_base);
+		vmbus_free_mmio(par->mem->start, screen_fb_size);
+	} else {
+		hvfb_release_phymem(hdev, info->fix.smem_start,
+				    screen_fb_size);
+	}
+
 	par->mem = NULL;
 }
 
@@ -1062,6 +1165,7 @@ static int hvfb_probe(struct hv_device *hdev,
 	par = info->par;
 	par->info = info;
 	par->fb_ready = false;
+	par->need_docopy = true;
 	init_completion(&par->wait);
 	INIT_DELAYED_WORK(&par->dwork, hvfb_update_work);
 
@@ -1147,7 +1251,7 @@ static int hvfb_probe(struct hv_device *hdev,
 
 error:
 	fb_deferred_io_cleanup(info);
-	hvfb_putmem(info);
+	hvfb_putmem(hdev, info);
 error2:
 	vmbus_close(hdev->channel);
 error1:
@@ -1177,7 +1281,7 @@ static int hvfb_remove(struct hv_device *hdev)
 	vmbus_close(hdev->channel);
 	hv_set_drvdata(hdev, NULL);
 
-	hvfb_putmem(info);
+	hvfb_putmem(hdev, info);
 	framebuffer_release(info);
 
 	return 0;
-- 
2.20.1




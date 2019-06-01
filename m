Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 379F931D48
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbfFAN2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:28:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729944AbfFAN10 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:27:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CF8922387;
        Sat,  1 Jun 2019 13:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395645;
        bh=IAcLolur0s/FFdJNYaNpQtzY56PRhPlK7SeSIWJIMy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VG7EN7IVPvr47R1jOsOTpLF9Y+zB3fV4nC09N9a/cjA6l1xkppVFZ7RlMrs07fGmm
         aa5buuBBOcfoBx80elpNRfxWeC7D2piYOHW+u7JYiCmChRNvCQBFYEEzKN8cpDo/1f
         XW4210a3D7L03boBlV2/H65bQILI47H2xt5i5ybw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yifeng Li <tomli@tomli.me>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Teddy Wang <teddy.wang@siliconmotion.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.4 48/56] fbdev: sm712fb: fix crashes during framebuffer writes by correctly mapping VRAM
Date:   Sat,  1 Jun 2019 09:25:52 -0400
Message-Id: <20190601132600.27427-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132600.27427-1-sashal@kernel.org>
References: <20190601132600.27427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifeng Li <tomli@tomli.me>

[ Upstream commit 9e0e59993df0601cddb95c4f6c61aa3d5e753c00 ]

On a Thinkpad s30 (Pentium III / i440MX, Lynx3DM), running fbtest or X
will crash the machine instantly, because the VRAM/framebuffer is not
mapped correctly.

On SM712, the framebuffer starts at the beginning of address space, but
SM720's framebuffer starts at the 1 MiB offset from the beginning. However,
sm712fb fails to take this into account, as a result, writing to the
framebuffer will destroy all the registers and kill the system immediately.
Another problem is the driver assumes 8 MiB of VRAM for SM720, but some
SM720 system, such as this IBM Thinkpad, only has 4 MiB of VRAM.

Fix this problem by removing the hardcoded VRAM size, adding a function to
query the amount of VRAM from register MCR76 on SM720, and adding proper
framebuffer offset.

Please note that the memory map may have additional problems on Big-Endian
system, which is not available for testing by myself. But I highly suspect
that the original code is also broken on Big-Endian machines for SM720, so
at least we are not making the problem worse. More, the driver also assumed
SM710/SM712 has 4 MiB of VRAM, but it has a 2 MiB version as well, and used
in earlier laptops, such as IBM Thinkpad 240X, the driver would probably
crash on them. I've never seen one of those machines and cannot fix it, but
I have documented these problems in the comments.

Signed-off-by: Yifeng Li <tomli@tomli.me>
Tested-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Teddy Wang <teddy.wang@siliconmotion.com>
Cc: <stable@vger.kernel.org>  # v4.4+
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sm712.h   |  5 ----
 drivers/video/fbdev/sm712fb.c | 48 ++++++++++++++++++++++++++++++++---
 2 files changed, 44 insertions(+), 9 deletions(-)

diff --git a/drivers/video/fbdev/sm712.h b/drivers/video/fbdev/sm712.h
index aad1cc4be34a9..2cba1e73ed24f 100644
--- a/drivers/video/fbdev/sm712.h
+++ b/drivers/video/fbdev/sm712.h
@@ -19,11 +19,6 @@
 #define SCREEN_Y_RES      600
 #define SCREEN_BPP        16
 
-/*Assume SM712 graphics chip has 4MB VRAM */
-#define SM712_VIDEOMEMORYSIZE	  0x00400000
-/*Assume SM722 graphics chip has 8MB VRAM */
-#define SM722_VIDEOMEMORYSIZE	  0x00800000
-
 #define dac_reg	(0x3c8)
 #define dac_val	(0x3c9)
 
diff --git a/drivers/video/fbdev/sm712fb.c b/drivers/video/fbdev/sm712fb.c
index 5148765f007cf..62ddd7792ad20 100644
--- a/drivers/video/fbdev/sm712fb.c
+++ b/drivers/video/fbdev/sm712fb.c
@@ -1338,6 +1338,11 @@ static int smtc_map_smem(struct smtcfb_info *sfb,
 {
 	sfb->fb->fix.smem_start = pci_resource_start(pdev, 0);
 
+	if (sfb->chip_id == 0x720)
+		/* on SM720, the framebuffer starts at the 1 MB offset */
+		sfb->fb->fix.smem_start += 0x00200000;
+
+	/* XXX: is it safe for SM720 on Big-Endian? */
 	if (sfb->fb->var.bits_per_pixel == 32)
 		sfb->fb->fix.smem_start += big_addr;
 
@@ -1375,12 +1380,45 @@ static inline void sm7xx_init_hw(void)
 	outb_p(0x11, 0x3c5);
 }
 
+static u_long sm7xx_vram_probe(struct smtcfb_info *sfb)
+{
+	u8 vram;
+
+	switch (sfb->chip_id) {
+	case 0x710:
+	case 0x712:
+		/*
+		 * Assume SM712 graphics chip has 4MB VRAM.
+		 *
+		 * FIXME: SM712 can have 2MB VRAM, which is used on earlier
+		 * laptops, such as IBM Thinkpad 240X. This driver would
+		 * probably crash on those machines. If anyone gets one of
+		 * those and is willing to help, run "git blame" and send me
+		 * an E-mail.
+		 */
+		return 0x00400000;
+	case 0x720:
+		outb_p(0x76, 0x3c4);
+		vram = inb_p(0x3c5) >> 6;
+
+		if (vram == 0x00)
+			return 0x00800000;  /* 8 MB */
+		else if (vram == 0x01)
+			return 0x01000000;  /* 16 MB */
+		else if (vram == 0x02)
+			return 0x00400000;  /* illegal, fallback to 4 MB */
+		else if (vram == 0x03)
+			return 0x00400000;  /* 4 MB */
+	}
+	return 0;  /* unknown hardware */
+}
+
 static int smtcfb_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *ent)
 {
 	struct smtcfb_info *sfb;
 	struct fb_info *info;
-	u_long smem_size = 0x00800000;	/* default 8MB */
+	u_long smem_size;
 	int err;
 	unsigned long mmio_base;
 
@@ -1437,12 +1475,15 @@ static int smtcfb_pci_probe(struct pci_dev *pdev,
 	mmio_base = pci_resource_start(pdev, 0);
 	pci_read_config_byte(pdev, PCI_REVISION_ID, &sfb->chip_rev_id);
 
+	smem_size = sm7xx_vram_probe(sfb);
+	dev_info(&pdev->dev, "%lu MiB of VRAM detected.\n",
+					smem_size / 1048576);
+
 	switch (sfb->chip_id) {
 	case 0x710:
 	case 0x712:
 		sfb->fb->fix.mmio_start = mmio_base + 0x00400000;
 		sfb->fb->fix.mmio_len = 0x00400000;
-		smem_size = SM712_VIDEOMEMORYSIZE;
 		sfb->lfb = ioremap(mmio_base, mmio_addr);
 		if (!sfb->lfb) {
 			dev_err(&pdev->dev,
@@ -1474,8 +1515,7 @@ static int smtcfb_pci_probe(struct pci_dev *pdev,
 	case 0x720:
 		sfb->fb->fix.mmio_start = mmio_base;
 		sfb->fb->fix.mmio_len = 0x00200000;
-		smem_size = SM722_VIDEOMEMORYSIZE;
-		sfb->dp_regs = ioremap(mmio_base, 0x00a00000);
+		sfb->dp_regs = ioremap(mmio_base, 0x00200000 + smem_size);
 		sfb->lfb = sfb->dp_regs + 0x00200000;
 		sfb->mmio = (smtc_regbaseaddress =
 		    sfb->dp_regs + 0x000c0000);
-- 
2.20.1


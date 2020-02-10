Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 600A1157541
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbgBJMjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:39:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:38300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729512AbgBJMjq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:46 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 764922465D;
        Mon, 10 Feb 2020 12:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338385;
        bh=nWYtyob+OlXyt0+FZ+agtsBloZfYAOYUudSesyQvxp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5VWjP8nvjvRMViBn9GfPW8kKZEyK8QIchMXkYwPeHBSU6Qsd3iw+OZEE3xpg/UWv
         eaq7XI06PQgoX9xeOh5n7fXr21znYxM497osbTrPdHuS5tQK+sDPHnmk/twRcTxmTN
         sZgO7QF8XIfihp0h4WjHhd/INafILwO17tdr10cY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.5 068/367] ALSA: hda: Apply aligned MMIO access only conditionally
Date:   Mon, 10 Feb 2020 04:29:41 -0800
Message-Id: <20200210122430.392602027@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 4d024fe8f806e20e577cc934204c5784c7063293 upstream.

It turned out that the recent simplification of HD-audio bus access
helpers caused a regression on the virtual HD-audio device on QEMU
with ARM platforms.  The driver got a CORB/RIRB timeout and couldn't
probe any codecs.

The essential difference that caused a problem was the enforced
aligned MMIO accesses by simplification.  Since snd-hda-tegra driver
is enabled on ARM, it enables CONFIG_SND_HDA_ALIGNED_MMIO, which makes
the all HD-audio drivers using the aligned MMIO accesses.  While this
is mandatory for snd-hda-tegra, it seems that snd-hda-intel on ARM
gets broken by this access pattern.

For addressing the regression, this patch introduces a new flag,
aligned_mmio, to hdac_bus object, and applies the aligned MMIO only
when this flag is set.  This change affects only platforms with
CONFIG_SND_HDA_ALIGNED_MMIO set, i.e. mostly only for ARM platforms.

Unfortunately the patch became a big bigger than it should be, just
because the former calls didn't take hdac_bus object in the argument,
hence we had to extend the call patterns.

Fixes: 19abfefd4c76 ("ALSA: hda: Direct MMIO accesses")
BugLink: https://bugzilla.opensuse.org/show_bug.cgi?id=1161152
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200120104127.28985-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/sound/hdaudio.h   |   77 +++++++++++++++++++++++++++++++---------------
 sound/pci/hda/hda_tegra.c |    1 
 2 files changed, 54 insertions(+), 24 deletions(-)

--- a/include/sound/hdaudio.h
+++ b/include/sound/hdaudio.h
@@ -8,6 +8,7 @@
 
 #include <linux/device.h>
 #include <linux/interrupt.h>
+#include <linux/io.h>
 #include <linux/pm_runtime.h>
 #include <linux/timecounter.h>
 #include <sound/core.h>
@@ -330,6 +331,7 @@ struct hdac_bus {
 	bool chip_init:1;		/* h/w initialized */
 
 	/* behavior flags */
+	bool aligned_mmio:1;		/* aligned MMIO access */
 	bool sync_write:1;		/* sync after verb write */
 	bool use_posbuf:1;		/* use position buffer */
 	bool snoop:1;			/* enable snooping */
@@ -405,34 +407,61 @@ void snd_hdac_bus_free_stream_pages(stru
 unsigned int snd_hdac_aligned_read(void __iomem *addr, unsigned int mask);
 void snd_hdac_aligned_write(unsigned int val, void __iomem *addr,
 			    unsigned int mask);
-#define snd_hdac_reg_writeb(v, addr)	snd_hdac_aligned_write(v, addr, 0xff)
-#define snd_hdac_reg_writew(v, addr)	snd_hdac_aligned_write(v, addr, 0xffff)
-#define snd_hdac_reg_readb(addr)	snd_hdac_aligned_read(addr, 0xff)
-#define snd_hdac_reg_readw(addr)	snd_hdac_aligned_read(addr, 0xffff)
-#else /* CONFIG_SND_HDA_ALIGNED_MMIO */
-#define snd_hdac_reg_writeb(val, addr)	writeb(val, addr)
-#define snd_hdac_reg_writew(val, addr)	writew(val, addr)
-#define snd_hdac_reg_readb(addr)	readb(addr)
-#define snd_hdac_reg_readw(addr)	readw(addr)
-#endif /* CONFIG_SND_HDA_ALIGNED_MMIO */
-#define snd_hdac_reg_writel(val, addr)	writel(val, addr)
-#define snd_hdac_reg_readl(addr)	readl(addr)
+#define snd_hdac_aligned_mmio(bus)	(bus)->aligned_mmio
+#else
+#define snd_hdac_aligned_mmio(bus)	false
+#define snd_hdac_aligned_read(addr, mask)	0
+#define snd_hdac_aligned_write(val, addr, mask) do {} while (0)
+#endif
+
+static inline void snd_hdac_reg_writeb(struct hdac_bus *bus, void __iomem *addr,
+				       u8 val)
+{
+	if (snd_hdac_aligned_mmio(bus))
+		snd_hdac_aligned_write(val, addr, 0xff);
+	else
+		writeb(val, addr);
+}
+
+static inline void snd_hdac_reg_writew(struct hdac_bus *bus, void __iomem *addr,
+				       u16 val)
+{
+	if (snd_hdac_aligned_mmio(bus))
+		snd_hdac_aligned_write(val, addr, 0xffff);
+	else
+		writew(val, addr);
+}
+
+static inline u8 snd_hdac_reg_readb(struct hdac_bus *bus, void __iomem *addr)
+{
+	return snd_hdac_aligned_mmio(bus) ?
+		snd_hdac_aligned_read(addr, 0xff) : readb(addr);
+}
+
+static inline u16 snd_hdac_reg_readw(struct hdac_bus *bus, void __iomem *addr)
+{
+	return snd_hdac_aligned_mmio(bus) ?
+		snd_hdac_aligned_read(addr, 0xffff) : readw(addr);
+}
+
+#define snd_hdac_reg_writel(bus, addr, val)	writel(val, addr)
+#define snd_hdac_reg_readl(bus, addr)	readl(addr)
 
 /*
  * macros for easy use
  */
 #define _snd_hdac_chip_writeb(chip, reg, value) \
-	snd_hdac_reg_writeb(value, (chip)->remap_addr + (reg))
+	snd_hdac_reg_writeb(chip, (chip)->remap_addr + (reg), value)
 #define _snd_hdac_chip_readb(chip, reg) \
-	snd_hdac_reg_readb((chip)->remap_addr + (reg))
+	snd_hdac_reg_readb(chip, (chip)->remap_addr + (reg))
 #define _snd_hdac_chip_writew(chip, reg, value) \
-	snd_hdac_reg_writew(value, (chip)->remap_addr + (reg))
+	snd_hdac_reg_writew(chip, (chip)->remap_addr + (reg), value)
 #define _snd_hdac_chip_readw(chip, reg) \
-	snd_hdac_reg_readw((chip)->remap_addr + (reg))
+	snd_hdac_reg_readw(chip, (chip)->remap_addr + (reg))
 #define _snd_hdac_chip_writel(chip, reg, value) \
-	snd_hdac_reg_writel(value, (chip)->remap_addr + (reg))
+	snd_hdac_reg_writel(chip, (chip)->remap_addr + (reg), value)
 #define _snd_hdac_chip_readl(chip, reg) \
-	snd_hdac_reg_readl((chip)->remap_addr + (reg))
+	snd_hdac_reg_readl(chip, (chip)->remap_addr + (reg))
 
 /* read/write a register, pass without AZX_REG_ prefix */
 #define snd_hdac_chip_writel(chip, reg, value) \
@@ -540,17 +569,17 @@ int snd_hdac_get_stream_stripe_ctl(struc
  */
 /* read/write a register, pass without AZX_REG_ prefix */
 #define snd_hdac_stream_writel(dev, reg, value) \
-	snd_hdac_reg_writel(value, (dev)->sd_addr + AZX_REG_ ## reg)
+	snd_hdac_reg_writel((dev)->bus, (dev)->sd_addr + AZX_REG_ ## reg, value)
 #define snd_hdac_stream_writew(dev, reg, value) \
-	snd_hdac_reg_writew(value, (dev)->sd_addr + AZX_REG_ ## reg)
+	snd_hdac_reg_writew((dev)->bus, (dev)->sd_addr + AZX_REG_ ## reg, value)
 #define snd_hdac_stream_writeb(dev, reg, value) \
-	snd_hdac_reg_writeb(value, (dev)->sd_addr + AZX_REG_ ## reg)
+	snd_hdac_reg_writeb((dev)->bus, (dev)->sd_addr + AZX_REG_ ## reg, value)
 #define snd_hdac_stream_readl(dev, reg) \
-	snd_hdac_reg_readl((dev)->sd_addr + AZX_REG_ ## reg)
+	snd_hdac_reg_readl((dev)->bus, (dev)->sd_addr + AZX_REG_ ## reg)
 #define snd_hdac_stream_readw(dev, reg) \
-	snd_hdac_reg_readw((dev)->sd_addr + AZX_REG_ ## reg)
+	snd_hdac_reg_readw((dev)->bus, (dev)->sd_addr + AZX_REG_ ## reg)
 #define snd_hdac_stream_readb(dev, reg) \
-	snd_hdac_reg_readb((dev)->sd_addr + AZX_REG_ ## reg)
+	snd_hdac_reg_readb((dev)->bus, (dev)->sd_addr + AZX_REG_ ## reg)
 
 /* update a register, pass without AZX_REG_ prefix */
 #define snd_hdac_stream_updatel(dev, reg, mask, val) \
--- a/sound/pci/hda/hda_tegra.c
+++ b/sound/pci/hda/hda_tegra.c
@@ -398,6 +398,7 @@ static int hda_tegra_create(struct snd_c
 		return err;
 
 	chip->bus.needs_damn_long_delay = 1;
+	chip->bus.core.aligned_mmio = 1;
 
 	err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops);
 	if (err < 0) {



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBAE28908
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392121AbfEWTaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392109AbfEWTaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:30:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24FEB217D7;
        Thu, 23 May 2019 19:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639820;
        bh=Wrox4qTEQPbr5+6ELzZ2IUMc6lAtK5/Gm7lshHxMJB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mdIVpwYJES/EPHa1Hq3FAw/ZSKeqNUrsD7PqSfg/K50dvCdHtvSfYkiSFuO7Une43
         9aRqi3WePfznkqECnyG+KOqNv8nim4ILm0swThgBLMlkbKnTT1I49CWdf/h8h+Fx+u
         FyFe+fV43kdlAPp4tAFr7easI4mZvmSJ9y/bZtr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Karol Herbst <kherbst@redhat.com>,
        Ben Skeggs <skeggsb@gmail.com>
Subject: [PATCH 5.1 096/122] PCI: Reset Lenovo ThinkPad P50 nvgpu at boot if necessary
Date:   Thu, 23 May 2019 21:06:58 +0200
Message-Id: <20190523181717.889796516@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit e0547c81bfcfad01cbbfa93a5e66bb98ab932f80 upstream.

On ThinkPad P50 SKUs with an Nvidia Quadro M1000M instead of the M2000M
variant, the BIOS does not always reset the secondary Nvidia GPU during
reboot if the laptop is configured in Hybrid Graphics mode.  The reason is
unknown, but the following steps and possibly a good bit of patience will
reproduce the issue:

  1. Boot up the laptop normally in Hybrid Graphics mode
  2. Make sure nouveau is loaded and that the GPU is awake
  3. Allow the Nvidia GPU to runtime suspend itself after being idle
  4. Reboot the machine, the more sudden the better (e.g. sysrq-b may help)
  5. If nouveau loads up properly, reboot the machine again and go back to
     step 2 until you reproduce the issue

This results in some very strange behavior: the GPU will be left in exactly
the same state it was in when the previously booted kernel started the
reboot.  This has all sorts of bad side effects: for starters, this
completely breaks nouveau starting with a mysterious EVO channel failure
that happens well before we've actually used the EVO channel for anything:

  nouveau 0000:01:00.0: disp: chid 0 mthd 0000 data 00000400 00001000 00000002

This causes a timeout trying to bring up the GR ctx:

  nouveau 0000:01:00.0: timeout
  WARNING: CPU: 0 PID: 12 at drivers/gpu/drm/nouveau/nvkm/engine/gr/ctxgf100.c:1547 gf100_grctx_generate+0x7b2/0x850 [nouveau]
  Hardware name: LENOVO 20EQS64N0B/20EQS64N0B, BIOS N1EET82W (1.55 ) 12/18/2018
  Workqueue: events_long drm_dp_mst_link_probe_work [drm_kms_helper]
  ...
  nouveau 0000:01:00.0: gr: wait for idle timeout (en: 1, ctxsw: 0, busy: 1)
  nouveau 0000:01:00.0: gr: wait for idle timeout (en: 1, ctxsw: 0, busy: 1)
  nouveau 0000:01:00.0: fifo: fault 01 [WRITE] at 0000000000008000 engine 00 [GR] client 15 [HUB/SCC_NB] reason c4 [] on channel -1 [0000000000 unknown]

The GPU never manages to recover.  Booting without loading nouveau causes
issues as well, since the GPU starts sending spurious interrupts that cause
other device's IRQs to get disabled by the kernel:

  irq 16: nobody cared (try booting with the "irqpoll" option)
  ...
  handlers:
  [<000000007faa9e99>] i801_isr [i2c_i801]
  Disabling IRQ #16
  ...
  serio: RMI4 PS/2 pass-through port at rmi4-00.fn03
  i801_smbus 0000:00:1f.4: Timeout waiting for interrupt!
  i801_smbus 0000:00:1f.4: Transaction timeout
  rmi4_f03 rmi4-00.fn03: rmi_f03_pt_write: Failed to write to F03 TX register (-110).
  i801_smbus 0000:00:1f.4: Timeout waiting for interrupt!
  i801_smbus 0000:00:1f.4: Transaction timeout
  rmi4_physical rmi4-00: rmi_driver_set_irq_bits: Failed to change enabled interrupts!

This causes the touchpad and sometimes other things to get disabled.

Since this happens without nouveau, we can't fix this problem from nouveau
itself.

Add a PCI quirk for the specific P50 variant of this GPU.  Make sure the
GPU is advertising NoReset- so we don't reset the GPU when the machine is
in Dedicated graphics mode (where the GPU being initialized by the BIOS is
normal and expected).  Map the GPU MMIO space and read the magic 0x2240c
register, which will have bit 1 set if the device was POSTed during a
previous boot.  Once we've confirmed all of this, reset the GPU and
re-disable it - bringing it back to a healthy state.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=203003
Link: https://lore.kernel.org/lkml/20190212220230.1568-1-lyude@redhat.com
Signed-off-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: nouveau@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Ben Skeggs <skeggsb@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/quirks.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5124,3 +5124,61 @@ SWITCHTEC_QUIRK(0x8573);  /* PFXI 48XG3
 SWITCHTEC_QUIRK(0x8574);  /* PFXI 64XG3 */
 SWITCHTEC_QUIRK(0x8575);  /* PFXI 80XG3 */
 SWITCHTEC_QUIRK(0x8576);  /* PFXI 96XG3 */
+
+/*
+ * On Lenovo Thinkpad P50 SKUs with a Nvidia Quadro M1000M, the BIOS does
+ * not always reset the secondary Nvidia GPU between reboots if the system
+ * is configured to use Hybrid Graphics mode.  This results in the GPU
+ * being left in whatever state it was in during the *previous* boot, which
+ * causes spurious interrupts from the GPU, which in turn causes us to
+ * disable the wrong IRQ and end up breaking the touchpad.  Unsurprisingly,
+ * this also completely breaks nouveau.
+ *
+ * Luckily, it seems a simple reset of the Nvidia GPU brings it back to a
+ * clean state and fixes all these issues.
+ *
+ * When the machine is configured in Dedicated display mode, the issue
+ * doesn't occur.  Fortunately the GPU advertises NoReset+ when in this
+ * mode, so we can detect that and avoid resetting it.
+ */
+static void quirk_reset_lenovo_thinkpad_p50_nvgpu(struct pci_dev *pdev)
+{
+	void __iomem *map;
+	int ret;
+
+	if (pdev->subsystem_vendor != PCI_VENDOR_ID_LENOVO ||
+	    pdev->subsystem_device != 0x222e ||
+	    !pdev->reset_fn)
+		return;
+
+	if (pci_enable_device_mem(pdev))
+		return;
+
+	/*
+	 * Based on nvkm_device_ctor() in
+	 * drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
+	 */
+	map = pci_iomap(pdev, 0, 0x23000);
+	if (!map) {
+		pci_err(pdev, "Can't map MMIO space\n");
+		goto out_disable;
+	}
+
+	/*
+	 * Make sure the GPU looks like it's been POSTed before resetting
+	 * it.
+	 */
+	if (ioread32(map + 0x2240c) & 0x2) {
+		pci_info(pdev, FW_BUG "GPU left initialized by EFI, resetting\n");
+		ret = pci_reset_function(pdev);
+		if (ret < 0)
+			pci_err(pdev, "Failed to reset GPU: %d\n", ret);
+	}
+
+	iounmap(map);
+out_disable:
+	pci_disable_device(pdev);
+}
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA, 0x13b1,
+			      PCI_CLASS_DISPLAY_VGA, 8,
+			      quirk_reset_lenovo_thinkpad_p50_nvgpu);



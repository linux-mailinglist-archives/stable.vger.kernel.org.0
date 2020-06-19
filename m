Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8B1201710
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390308AbgFSQde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:33:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389457AbgFSOvc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:51:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7CD521841;
        Fri, 19 Jun 2020 14:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578290;
        bh=MsoMEXGUekUn53+AInla0jrftTOH5itw/MPK2wdjQ58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GdpMudMQFiinVLdlDVWzX7vriWhjgocXrMzO85ubPdYaQ9dcuy/WDXuKvu2XxhWS0
         XvFklSgZbSERHtPNH7SE4QpLHSFBTTcJjUQwy16K15HxjeHDCvlz5nslSD3mnzdHCb
         cP2LyduhNWmHVTV1TV0mBA3GylXSGynrsSUJpNSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Takashi Iwai <tiwai@suse.de>, Peter Wu <peter@lekensteyn.nl>,
        Lukas Wunner <lukas@wunner.de>,
        Sasha Levin <sashal@kernel.org>,
        Kai Heng Feng <kai.heng.feng@canonical.com>,
        Mike Lothian <mike@fireburn.co.uk>,
        Denis Lisov <dennis.lissov@gmail.com>
Subject: [PATCH 4.14 155/190] vga_switcheroo: Use device link for HDA controller
Date:   Fri, 19 Jun 2020 16:33:20 +0200
Message-Id: <20200619141641.475936236@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 07f4f97d7b4bf325d9f558c5b58230387e4e57e0 ]

Back in 2013, runtime PM for GPUs with integrated HDA controller was
introduced with commits 0d69704ae348 ("gpu/vga_switcheroo: add driver
control power feature. (v3)") and 246efa4a072f ("snd/hda: add runtime
suspend/resume on optimus support (v4)").

Briefly, the idea was that the HDA controller is forced on and off in
unison with the GPU.

The original code is mostly still in place even though it was never a
100% perfect solution:  E.g. on access to the HDA controller, the GPU
is powered up via vga_switcheroo_runtime_resume_hdmi_audio() but there
are no provisions to keep it resumed until access to the HDA controller
has ceased:  The GPU autosuspends after 5 seconds, rendering the HDA
controller inaccessible.

Additionally, a kludge is required when hda_intel.c probes:  It has to
check whether the GPU is powered down (check_hdmi_disabled()) and defer
probing if so.

However in the meantime (in v4.10) the driver core has gained a feature
called device links which promises to solve such issues in a clean way:
It allows us to declare a dependency from the HDA controller (consumer)
to the GPU (supplier).  The PM core then automagically ensures that the
GPU is runtime resumed as long as the HDA controller's ->probe hook is
executed and whenever the HDA controller is accessed.

By default, the HDA controller has a dependency on its parent, a PCIe
Root Port.  Adding a device link creates another dependency on its
sibling:

                            PCIe Root Port
                             ^          ^
                             |          |
                             |          |
                            HDA  ===>  GPU

The device link is not only used for runtime PM, it also guarantees that
on system sleep, the HDA controller suspends before the GPU and resumes
after the GPU, and on system shutdown the HDA controller's ->shutdown
hook is executed before the one of the GPU.  It is a complete solution.

Using this functionality is as simple as calling device_link_add(),
which results in a dmesg entry like this:

        pci 0000:01:00.1: Linked as a consumer to 0000:01:00.0

The code for the GPU-governed audio power management can thus be removed
(except where it's still needed for legacy manual power control).

The device link is added in a PCI quirk rather than in hda_intel.c.
It is therefore legal for the GPU to runtime suspend to D3cold even if
the HDA controller is not bound to a driver or if CONFIG_SND_HDA_INTEL
is not enabled, for accesses to the HDA controller will cause the GPU to
wake up regardless if they're occurring outside of hda_intel.c (think
config space readout via sysfs).

Contrary to the previous implementation, the HDA controller's power
state is now self-governed, rather than GPU-governed, whereas the GPU's
power state is no longer fully self-governed.  (The HDA controller needs
to runtime suspend before the GPU can.)

It is thus crucial that runtime PM is always activated on the HDA
controller even if CONFIG_SND_HDA_POWER_SAVE_DEFAULT is set to 0 (which
is the default), lest the GPU stays awake.  This is achieved by setting
the auto_runtime_pm flag on every codec and the AZX_DCAPS_PM_RUNTIME
flag on the HDA controller.

A side effect is that power consumption might be reduced if the GPU is
in use but the HDA controller is not, because the HDA controller is now
allowed to go to D3hot.  Before, it was forced to stay in D0 as long as
the GPU was in use.  (There is no reduction in power consumption on my
Nvidia GK107, but there might be on other chips.)

The code paths for legacy manual power control are adjusted such that
runtime PM is disabled during power off, thereby preventing the PM core
from resuming the HDA controller.

Note that the device link is not only added on vga_switcheroo capable
systems, but for *any* GPU with integrated HDA controller.  The idea is
that the HDA controller streams audio via connectors located on the GPU,
so the GPU needs to be on for the HDA controller to do anything useful.

This commit implicitly fixes an unbalanced runtime PM ref upon unbind of
hda_intel.c:  On ->probe, a runtime PM ref was previously released under
the condition "azx_has_pm_runtime(chip) || hda->use_vga_switcheroo", but
on ->remove a runtime PM ref was only acquired under the first of those
conditions.  Thus, binding and unbinding the driver twice on a
vga_switcheroo capable system caused the runtime PM refcount to drop
below zero.  The issue is resolved because the AZX_DCAPS_PM_RUNTIME flag
is now always set if use_vga_switcheroo is true.

For more information on device links please refer to:
https://www.kernel.org/doc/html/latest/driver-api/device_link.html
Documentation/driver-api/device_link.rst

Cc: Dave Airlie <airlied@redhat.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Peter Wu <peter@lekensteyn.nl>
Tested-by: Kai Heng Feng <kai.heng.feng@canonical.com> # AMD PowerXpress
Tested-by: Mike Lothian <mike@fireburn.co.uk>          # AMD PowerXpress
Tested-by: Denis Lisov <dennis.lissov@gmail.com>       # Nvidia Optimus
Tested-by: Peter Wu <peter@lekensteyn.nl>              # Nvidia Optimus
Tested-by: Lukas Wunner <lukas@wunner.de>              # MacBook Pro
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://patchwork.freedesktop.org/patch/msgid/51bd38360ff502a8c42b1ebf4405ee1d3f27118d.1520068884.git.lukas@wunner.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |   2 -
 drivers/gpu/drm/nouveau/nouveau_drm.c   |   2 -
 drivers/gpu/drm/radeon/radeon_drv.c     |   2 -
 drivers/gpu/vga/vga_switcheroo.c        | 115 ++----------------------
 drivers/pci/quirks.c                    |  39 ++++++++
 include/linux/pci_ids.h                 |   1 +
 include/linux/vga_switcheroo.h          |   6 --
 include/sound/hdaudio.h                 |   3 -
 sound/pci/hda/hda_intel.c               |  35 +++++---
 sound/pci/hda/hda_intel.h               |   3 -
 10 files changed, 72 insertions(+), 136 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 4894d8a87c04..ae23f7e0290c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -728,7 +728,6 @@ static int amdgpu_pmops_runtime_suspend(struct device *dev)
 
 	drm_dev->switch_power_state = DRM_SWITCH_POWER_CHANGING;
 	drm_kms_helper_poll_disable(drm_dev);
-	vga_switcheroo_set_dynamic_switch(pdev, VGA_SWITCHEROO_OFF);
 
 	ret = amdgpu_device_suspend(drm_dev, false, false);
 	pci_save_state(pdev);
@@ -765,7 +764,6 @@ static int amdgpu_pmops_runtime_resume(struct device *dev)
 
 	ret = amdgpu_device_resume(drm_dev, false, false);
 	drm_kms_helper_poll_enable(drm_dev);
-	vga_switcheroo_set_dynamic_switch(pdev, VGA_SWITCHEROO_ON);
 	drm_dev->switch_power_state = DRM_SWITCH_POWER_ON;
 	return 0;
 }
diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index 70a8d0b0c4f1..d00524a5d7f0 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -754,7 +754,6 @@ nouveau_pmops_runtime_suspend(struct device *dev)
 	}
 
 	drm_kms_helper_poll_disable(drm_dev);
-	vga_switcheroo_set_dynamic_switch(pdev, VGA_SWITCHEROO_OFF);
 	nouveau_switcheroo_optimus_dsm();
 	ret = nouveau_do_suspend(drm_dev, true);
 	pci_save_state(pdev);
@@ -789,7 +788,6 @@ nouveau_pmops_runtime_resume(struct device *dev)
 
 	/* do magic */
 	nvif_mask(&device->object, 0x088488, (1 << 25), (1 << 25));
-	vga_switcheroo_set_dynamic_switch(pdev, VGA_SWITCHEROO_ON);
 	drm_dev->switch_power_state = DRM_SWITCH_POWER_ON;
 
 	/* Monitors may have been connected / disconnected during suspend */
diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index f4becad0a78c..f6908e2f9e55 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -424,7 +424,6 @@ static int radeon_pmops_runtime_suspend(struct device *dev)
 
 	drm_dev->switch_power_state = DRM_SWITCH_POWER_CHANGING;
 	drm_kms_helper_poll_disable(drm_dev);
-	vga_switcheroo_set_dynamic_switch(pdev, VGA_SWITCHEROO_OFF);
 
 	ret = radeon_suspend_kms(drm_dev, false, false, false);
 	pci_save_state(pdev);
@@ -461,7 +460,6 @@ static int radeon_pmops_runtime_resume(struct device *dev)
 
 	ret = radeon_resume_kms(drm_dev, false, false);
 	drm_kms_helper_poll_enable(drm_dev);
-	vga_switcheroo_set_dynamic_switch(pdev, VGA_SWITCHEROO_ON);
 	drm_dev->switch_power_state = DRM_SWITCH_POWER_ON;
 	return 0;
 }
diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index 5da45325621c..f188c85b3b7a 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -105,8 +105,7 @@
  * @list: client list
  *
  * Registered client. A client can be either a GPU or an audio device on a GPU.
- * For audio clients, the @fb_info, @active and @driver_power_control members
- * are bogus.
+ * For audio clients, the @fb_info and @active members are bogus.
  */
 struct vga_switcheroo_client {
 	struct pci_dev *pdev;
@@ -332,8 +331,8 @@ EXPORT_SYMBOL(vga_switcheroo_register_client);
  * @ops: client callbacks
  * @id: client identifier
  *
- * Register audio client (audio device on a GPU). The power state of the
- * client is assumed to be ON. Beforehand, vga_switcheroo_client_probe_defer()
+ * Register audio client (audio device on a GPU). The client is assumed
+ * to use runtime PM. Beforehand, vga_switcheroo_client_probe_defer()
  * shall be called to ensure that all prerequisites are met.
  *
  * Return: 0 on success, -ENOMEM on memory allocation error.
@@ -342,7 +341,7 @@ int vga_switcheroo_register_audio_client(struct pci_dev *pdev,
 			const struct vga_switcheroo_client_ops *ops,
 			enum vga_switcheroo_client_id id)
 {
-	return register_client(pdev, ops, id | ID_BIT_AUDIO, false, false);
+	return register_client(pdev, ops, id | ID_BIT_AUDIO, false, true);
 }
 EXPORT_SYMBOL(vga_switcheroo_register_audio_client);
 
@@ -655,10 +654,8 @@ static void set_audio_state(enum vga_switcheroo_client_id id,
 	struct vga_switcheroo_client *client;
 
 	client = find_client_from_id(&vgasr_priv.clients, id | ID_BIT_AUDIO);
-	if (client) {
+	if (client)
 		client->ops->set_gpu_state(client->pdev, state);
-		client->pwr_state = state;
-	}
 }
 
 /* stage one happens before delay */
@@ -953,10 +950,6 @@ EXPORT_SYMBOL(vga_switcheroo_process_delayed_switch);
  * Specifying nouveau.runpm=0, radeon.runpm=0 or amdgpu.runpm=0 on the kernel
  * command line disables it.
  *
- * When the driver decides to power up or down, it notifies vga_switcheroo
- * thereof so that it can power the audio device on the GPU up or down.
- * This is achieved by vga_switcheroo_set_dynamic_switch().
- *
  * After the GPU has been suspended, the handler needs to be called to cut
  * power to the GPU. Likewise it needs to reinstate power before the GPU
  * can resume. This is achieved by vga_switcheroo_init_domain_pm_ops(),
@@ -964,8 +957,9 @@ EXPORT_SYMBOL(vga_switcheroo_process_delayed_switch);
  * calls to the handler.
  *
  * When the audio device resumes, the GPU needs to be woken. This is achieved
- * by vga_switcheroo_init_domain_pm_optimus_hdmi_audio(), which augments the
- * audio device's resume function.
+ * by a PCI quirk which calls device_link_add() to declare a dependency on the
+ * GPU. That way, the GPU is kept awake whenever and as long as the audio
+ * device is in use.
  *
  * On muxed machines, if the mux is initially switched to the discrete GPU,
  * the user ends up with a black screen when the GPU powers down after boot.
@@ -991,33 +985,6 @@ static void vga_switcheroo_power_switch(struct pci_dev *pdev,
 	vgasr_priv.handler->power_state(client->id, state);
 }
 
-/**
- * vga_switcheroo_set_dynamic_switch() - helper for driver power control
- * @pdev: client pci device
- * @dynamic: new power state
- *
- * Helper for GPUs whose power state is controlled by the driver's runtime pm.
- * When the driver decides to power up or down, it notifies vga_switcheroo
- * thereof using this helper so that it can power the audio device on the GPU
- * up or down.
- */
-void vga_switcheroo_set_dynamic_switch(struct pci_dev *pdev,
-				       enum vga_switcheroo_state dynamic)
-{
-	struct vga_switcheroo_client *client;
-
-	mutex_lock(&vgasr_mutex);
-	client = find_client_from_pci(&vgasr_priv.clients, pdev);
-	if (!client || !client->driver_power_control) {
-		mutex_unlock(&vgasr_mutex);
-		return;
-	}
-
-	set_audio_state(client->id, dynamic);
-	mutex_unlock(&vgasr_mutex);
-}
-EXPORT_SYMBOL(vga_switcheroo_set_dynamic_switch);
-
 /* switcheroo power domain */
 static int vga_switcheroo_runtime_suspend(struct device *dev)
 {
@@ -1087,69 +1054,3 @@ void vga_switcheroo_fini_domain_pm_ops(struct device *dev)
 	dev_pm_domain_set(dev, NULL);
 }
 EXPORT_SYMBOL(vga_switcheroo_fini_domain_pm_ops);
-
-static int vga_switcheroo_runtime_resume_hdmi_audio(struct device *dev)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct vga_switcheroo_client *client;
-	struct device *video_dev = NULL;
-	int ret;
-
-	/* we need to check if we have to switch back on the video
-	 * device so the audio device can come back
-	 */
-	mutex_lock(&vgasr_mutex);
-	list_for_each_entry(client, &vgasr_priv.clients, list) {
-		if (PCI_SLOT(client->pdev->devfn) == PCI_SLOT(pdev->devfn) &&
-		    client_is_vga(client)) {
-			video_dev = &client->pdev->dev;
-			break;
-		}
-	}
-	mutex_unlock(&vgasr_mutex);
-
-	if (video_dev) {
-		ret = pm_runtime_get_sync(video_dev);
-		if (ret && ret != 1)
-			return ret;
-	}
-	ret = dev->bus->pm->runtime_resume(dev);
-
-	/* put the reference for the gpu */
-	if (video_dev) {
-		pm_runtime_mark_last_busy(video_dev);
-		pm_runtime_put_autosuspend(video_dev);
-	}
-	return ret;
-}
-
-/**
- * vga_switcheroo_init_domain_pm_optimus_hdmi_audio() - helper for driver
- *	power control
- * @dev: audio client device
- * @domain: power domain
- *
- * Helper for GPUs whose power state is controlled by the driver's runtime pm.
- * When the audio device resumes, the GPU needs to be woken. This helper
- * augments the audio device's resume function to do that.
- *
- * Return: 0 on success, -EINVAL if no power management operations are
- * defined for this device.
- */
-int
-vga_switcheroo_init_domain_pm_optimus_hdmi_audio(struct device *dev,
-						 struct dev_pm_domain *domain)
-{
-	/* copy over all the bus versions */
-	if (dev->bus && dev->bus->pm) {
-		domain->ops = *dev->bus->pm;
-		domain->ops.runtime_resume =
-			vga_switcheroo_runtime_resume_hdmi_audio;
-
-		dev_pm_domain_set(dev, domain);
-		return 0;
-	}
-	dev_pm_domain_set(dev, NULL);
-	return -EINVAL;
-}
-EXPORT_SYMBOL(vga_switcheroo_init_domain_pm_optimus_hdmi_audio);
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 44be840dac0d..6af7fc0be21d 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -27,6 +27,7 @@
 #include <linux/ktime.h>
 #include <linux/mm.h>
 #include <linux/platform_data/x86/apple.h>
+#include <linux/pm_runtime.h>
 #include <asm/dma.h>	/* isa_dma_bridge_buggy */
 #include "pci.h"
 
@@ -4952,3 +4953,41 @@ static void quirk_fsl_no_msi(struct pci_dev *pdev)
 		pdev->no_msi = 1;
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_FREESCALE, PCI_ANY_ID, quirk_fsl_no_msi);
+
+/*
+ * GPUs with integrated HDA controller for streaming audio to attached displays
+ * need a device link from the HDA controller (consumer) to the GPU (supplier)
+ * so that the GPU is powered up whenever the HDA controller is accessed.
+ * The GPU and HDA controller are functions 0 and 1 of the same PCI device.
+ * The device link stays in place until shutdown (or removal of the PCI device
+ * if it's hotplugged).  Runtime PM is allowed by default on the HDA controller
+ * to prevent it from permanently keeping the GPU awake.
+ */
+static void quirk_gpu_hda(struct pci_dev *hda)
+{
+	struct pci_dev *gpu;
+
+	if (PCI_FUNC(hda->devfn) != 1)
+		return;
+
+	gpu = pci_get_domain_bus_and_slot(pci_domain_nr(hda->bus),
+					  hda->bus->number,
+					  PCI_DEVFN(PCI_SLOT(hda->devfn), 0));
+	if (!gpu || (gpu->class >> 16) != PCI_BASE_CLASS_DISPLAY) {
+		pci_dev_put(gpu);
+		return;
+	}
+
+	if (!device_link_add(&hda->dev, &gpu->dev,
+			     DL_FLAG_STATELESS | DL_FLAG_PM_RUNTIME))
+		pci_err(hda, "cannot link HDA to GPU %s\n", pci_name(gpu));
+
+	pm_runtime_allow(&hda->dev);
+	pci_dev_put(gpu);
+}
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_ATI, PCI_ANY_ID,
+			      PCI_CLASS_MULTIMEDIA_HD_AUDIO, 8, quirk_gpu_hda);
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_AMD, PCI_ANY_ID,
+			      PCI_CLASS_MULTIMEDIA_HD_AUDIO, 8, quirk_gpu_hda);
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
+			      PCI_CLASS_MULTIMEDIA_HD_AUDIO, 8, quirk_gpu_hda);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index bd882f51fb5f..2d036930a3cd 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -45,6 +45,7 @@
 #define PCI_CLASS_MULTIMEDIA_VIDEO	0x0400
 #define PCI_CLASS_MULTIMEDIA_AUDIO	0x0401
 #define PCI_CLASS_MULTIMEDIA_PHONE	0x0402
+#define PCI_CLASS_MULTIMEDIA_HD_AUDIO	0x0403
 #define PCI_CLASS_MULTIMEDIA_OTHER	0x0480
 
 #define PCI_BASE_CLASS_MEMORY		0x05
diff --git a/include/linux/vga_switcheroo.h b/include/linux/vga_switcheroo.h
index 960bedbdec87..77f0f0af3a71 100644
--- a/include/linux/vga_switcheroo.h
+++ b/include/linux/vga_switcheroo.h
@@ -168,11 +168,8 @@ int vga_switcheroo_process_delayed_switch(void);
 bool vga_switcheroo_client_probe_defer(struct pci_dev *pdev);
 enum vga_switcheroo_state vga_switcheroo_get_client_state(struct pci_dev *dev);
 
-void vga_switcheroo_set_dynamic_switch(struct pci_dev *pdev, enum vga_switcheroo_state dynamic);
-
 int vga_switcheroo_init_domain_pm_ops(struct device *dev, struct dev_pm_domain *domain);
 void vga_switcheroo_fini_domain_pm_ops(struct device *dev);
-int vga_switcheroo_init_domain_pm_optimus_hdmi_audio(struct device *dev, struct dev_pm_domain *domain);
 #else
 
 static inline void vga_switcheroo_unregister_client(struct pci_dev *dev) {}
@@ -192,11 +189,8 @@ static inline int vga_switcheroo_process_delayed_switch(void) { return 0; }
 static inline bool vga_switcheroo_client_probe_defer(struct pci_dev *pdev) { return false; }
 static inline enum vga_switcheroo_state vga_switcheroo_get_client_state(struct pci_dev *dev) { return VGA_SWITCHEROO_ON; }
 
-static inline void vga_switcheroo_set_dynamic_switch(struct pci_dev *pdev, enum vga_switcheroo_state dynamic) {}
-
 static inline int vga_switcheroo_init_domain_pm_ops(struct device *dev, struct dev_pm_domain *domain) { return -EINVAL; }
 static inline void vga_switcheroo_fini_domain_pm_ops(struct device *dev) {}
-static inline int vga_switcheroo_init_domain_pm_optimus_hdmi_audio(struct device *dev, struct dev_pm_domain *domain) { return -EINVAL; }
 
 #endif
 #endif /* _LINUX_VGA_SWITCHEROO_H_ */
diff --git a/include/sound/hdaudio.h b/include/sound/hdaudio.h
index 926ea701cdc4..5d0bf1688eba 100644
--- a/include/sound/hdaudio.h
+++ b/include/sound/hdaudio.h
@@ -228,9 +228,6 @@ struct hdac_io_ops {
 #define HDA_UNSOL_QUEUE_SIZE	64
 #define HDA_MAX_CODECS		8	/* limit by controller side */
 
-/* HD Audio class code */
-#define PCI_CLASS_MULTIMEDIA_HD_AUDIO	0x0403
-
 /*
  * CORB/RIRB
  *
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 7779f5460715..e399c5718ee6 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1282,6 +1282,7 @@ static void azx_vs_set_state(struct pci_dev *pci,
 	struct snd_card *card = pci_get_drvdata(pci);
 	struct azx *chip = card->private_data;
 	struct hda_intel *hda = container_of(chip, struct hda_intel, chip);
+	struct hda_codec *codec;
 	bool disabled;
 
 	wait_for_completion(&hda->probe_wait);
@@ -1306,8 +1307,12 @@ static void azx_vs_set_state(struct pci_dev *pci,
 		dev_info(chip->card->dev, "%s via vga_switcheroo\n",
 			 disabled ? "Disabling" : "Enabling");
 		if (disabled) {
-			pm_runtime_put_sync_suspend(card->dev);
-			azx_suspend(card->dev);
+			list_for_each_codec(codec, &chip->bus) {
+				pm_runtime_suspend(hda_codec_dev(codec));
+				pm_runtime_disable(hda_codec_dev(codec));
+			}
+			pm_runtime_suspend(card->dev);
+			pm_runtime_disable(card->dev);
 			/* when we get suspended by vga_switcheroo we end up in D3cold,
 			 * however we have no ACPI handle, so pci/acpi can't put us there,
 			 * put ourselves there */
@@ -1318,9 +1323,12 @@ static void azx_vs_set_state(struct pci_dev *pci,
 					 "Cannot lock devices!\n");
 		} else {
 			snd_hda_unlock_devices(&chip->bus);
-			pm_runtime_get_noresume(card->dev);
 			chip->disabled = false;
-			azx_resume(card->dev);
+			pm_runtime_enable(card->dev);
+			list_for_each_codec(codec, &chip->bus) {
+				pm_runtime_enable(hda_codec_dev(codec));
+				pm_runtime_resume(hda_codec_dev(codec));
+			}
 		}
 	}
 }
@@ -1350,6 +1358,7 @@ static void init_vga_switcheroo(struct azx *chip)
 		dev_info(chip->card->dev,
 			 "Handle vga_switcheroo audio client\n");
 		hda->use_vga_switcheroo = 1;
+		chip->driver_caps |= AZX_DCAPS_PM_RUNTIME;
 		pci_dev_put(p);
 	}
 }
@@ -1375,9 +1384,6 @@ static int register_vga_switcheroo(struct azx *chip)
 		return err;
 	hda->vga_switcheroo_registered = 1;
 
-	/* register as an optimus hdmi audio power domain */
-	vga_switcheroo_init_domain_pm_optimus_hdmi_audio(chip->card->dev,
-							 &hda->hdmi_pm_domain);
 	return 0;
 }
 #else
@@ -1406,10 +1412,8 @@ static int azx_free(struct azx *chip)
 	if (use_vga_switcheroo(hda)) {
 		if (chip->disabled && hda->probe_continued)
 			snd_hda_unlock_devices(&chip->bus);
-		if (hda->vga_switcheroo_registered) {
+		if (hda->vga_switcheroo_registered)
 			vga_switcheroo_unregister_client(chip->pci);
-			vga_switcheroo_fini_domain_pm_ops(chip->card->dev);
-		}
 	}
 
 	if (bus->chip_init) {
@@ -2301,6 +2305,7 @@ static int azx_probe_continue(struct azx *chip)
 	struct hda_intel *hda = container_of(chip, struct hda_intel, chip);
 	struct hdac_bus *bus = azx_bus(chip);
 	struct pci_dev *pci = chip->pci;
+	struct hda_codec *codec;
 	int dev = chip->dev_index;
 	int val;
 	int err;
@@ -2385,6 +2390,14 @@ static int azx_probe_continue(struct azx *chip)
 	chip->running = 1;
 	azx_add_card_list(chip);
 
+	/*
+	 * The discrete GPU cannot power down unless the HDA controller runtime
+	 * suspends, so activate runtime PM on codecs even if power_save == 0.
+	 */
+	if (use_vga_switcheroo(hda))
+		list_for_each_codec(codec, &chip->bus)
+			codec->auto_runtime_pm = 1;
+
 	val = power_save;
 #ifdef CONFIG_PM
 	if (pm_blacklist) {
@@ -2399,7 +2412,7 @@ static int azx_probe_continue(struct azx *chip)
 	}
 #endif /* CONFIG_PM */
 	snd_hda_set_power_save(&chip->bus, val * 1000);
-	if (azx_has_pm_runtime(chip) || hda->use_vga_switcheroo)
+	if (azx_has_pm_runtime(chip))
 		pm_runtime_put_autosuspend(&pci->dev);
 
 out_free:
diff --git a/sound/pci/hda/hda_intel.h b/sound/pci/hda/hda_intel.h
index ff0c4d617bc1..e3a3d318d2e5 100644
--- a/sound/pci/hda/hda_intel.h
+++ b/sound/pci/hda/hda_intel.h
@@ -40,9 +40,6 @@ struct hda_intel {
 	unsigned int vga_switcheroo_registered:1;
 	unsigned int init_failed:1; /* delayed init failed */
 
-	/* secondary power domain for hdmi audio under vga device */
-	struct dev_pm_domain hdmi_pm_domain;
-
 	bool need_i915_power:1; /* the hda controller needs i915 power */
 };
 
-- 
2.25.1




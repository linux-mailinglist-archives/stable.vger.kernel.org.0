Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F5B321781
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbhBVMtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:49:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:36550 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231436AbhBVMoO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:44:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 92BBFB113;
        Mon, 22 Feb 2021 12:43:31 +0000 (UTC)
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     daniel@ffwll.ch, airlied@linux.ie,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        yuq825@gmail.com, robh@kernel.org, tomeu.vizoso@collabora.com,
        steven.price@arm.com, alyssa.rosenzweig@collabora.com,
        eric@anholt.net, sumit.semwal@linaro.org, christian.koenig@amd.com,
        stern@rowland.harvard.edu
Cc:     dri-devel@lists.freedesktop.org, lima@lists.freedesktop.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Felipe Balbi <balbi@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 1/3] drm: Support importing dmabufs into drivers without DMA
Date:   Mon, 22 Feb 2021 13:43:26 +0100
Message-Id: <20210222124328.27340-2-tzimmermann@suse.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222124328.27340-1-tzimmermann@suse.de>
References: <20210222124328.27340-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB devices cannot perform DMA and hence have no dma_mask set in their
device structure. Importing dmabuf into a USB-based driver fails, which
break joining and mirroring of display in X11. A corresponding error
message is shown below.

[   60.050199] ------------[ cut here ]------------
[   60.055092] WARNING: CPU: 0 PID: 1403 at kernel/dma/mapping.c:190 dma_map_sg_attrs+0x8f/0xc0
[   60.064331] Modules linked in: af_packet(E) rfkill(E) dmi_sysfs(E) intel_rapl_msr(E) intel_rapl_common(E) snd_hda_codec_realtek(E) snd_hda_codec_generic(E) ledtrig_audio(E) snd_hda_codec_hdmi(E) x86_pkg_temp_thermal(E) intel_powerclam)
[   60.064801]  wmi(E) video(E) btrfs(E) blake2b_generic(E) libcrc32c(E) crc32c_intel(E) xor(E) raid6_pq(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) msr(E) efivarfs(E)
[   60.170778] CPU: 0 PID: 1403 Comm: Xorg.bin Tainted: G            E    5.11.0-rc5-1-default+ #747
[   60.179841] Hardware name: Dell Inc. OptiPlex 9020/0N4YC8, BIOS A24 10/24/2018
[   60.187145] RIP: 0010:dma_map_sg_attrs+0x8f/0xc0
[   60.191822] Code: 4d 85 ff 75 2b 49 89 d8 44 89 e1 44 89 f2 4c 89 ee 48 89 ef e8 62 30 00 00 85 c0 78 36 5b 5d 41 5c 41 5d 41 5e 41 5f c3 0f 0b <0f> 0b 31 c0 eb ed 49 8d 7f 50 e8 72 f5 2a 00 49 8b 47 50 49 89 d8
[   60.210770] RSP: 0018:ffffc90001d6fc18 EFLAGS: 00010246
[   60.216062] RAX: 0000000000000000 RBX: 0000000000000020 RCX: ffffffffb31e677b
[   60.223274] RDX: dffffc0000000000 RSI: ffff888212c10600 RDI: ffff8881b08a9488
[   60.230501] RBP: ffff8881b08a9030 R08: 0000000000000020 R09: ffff888212c10600
[   60.237710] R10: ffffed10425820df R11: 0000000000000001 R12: 0000000000000000
[   60.244939] R13: ffff888212c10600 R14: 0000000000000008 R15: 0000000000000000
[   60.252155] FS:  00007f08ac2b2f00(0000) GS:ffff8887cbe00000(0000) knlGS:0000000000000000
[   60.260333] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   60.266150] CR2: 000055831c899be8 CR3: 000000015372e006 CR4: 00000000001706f0
[   60.273369] Call Trace:
[   60.275845]  drm_gem_map_dma_buf+0xb4/0x120
[   60.280089]  dma_buf_map_attachment+0x15d/0x1e0
[   60.284688]  drm_gem_prime_import_dev.part.0+0x5d/0x140
[   60.289984]  drm_gem_prime_fd_to_handle+0x213/0x280
[   60.294931]  ? drm_prime_destroy_file_private+0x30/0x30
[   60.300224]  drm_ioctl_kernel+0x131/0x180
[   60.304291]  ? drm_setversion+0x230/0x230
[   60.308366]  ? drm_prime_destroy_file_private+0x30/0x30
[   60.313659]  drm_ioctl+0x2f1/0x500
[   60.317118]  ? drm_version+0x150/0x150
[   60.320903]  ? lock_downgrade+0xa0/0xa0
[   60.324806]  ? do_vfs_ioctl+0x5f4/0x680
[   60.328694]  ? __fget_files+0x13e/0x210
[   60.332591]  ? ioctl_fiemap.isra.0+0x1a0/0x1a0
[   60.337102]  ? __fget_files+0x15d/0x210
[   60.340990]  __x64_sys_ioctl+0xb9/0xf0
[   60.344795]  do_syscall_64+0x33/0x80
[   60.348427]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   60.353542] RIP: 0033:0x7f08ac7b53cb
[   60.357168] Code: 89 d8 49 8d 3c 1c 48 f7 d8 49 39 c4 72 b5 e8 1c ff ff ff 85 c0 78 ba 4c 89 e0 5b 5d 41 5c c3 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 75 ba 0c 00 f7 d8 64 89 01 48
[   60.376108] RSP: 002b:00007ffeabc89fc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   60.383758] RAX: ffffffffffffffda RBX: 00007ffeabc8a00c RCX: 00007f08ac7b53cb
[   60.390970] RDX: 00007ffeabc8a00c RSI: 00000000c00c642e RDI: 000000000000000d
[   60.398221] RBP: 00000000c00c642e R08: 000055831c691d00 R09: 000055831b2ec010
[   60.405446] R10: 00007f08acf6ada0 R11: 0000000000000246 R12: 000055831c691d00
[   60.412667] R13: 000000000000000d R14: 00000000007e9000 R15: 0000000000000000
[   60.419903] irq event stamp: 672893
[   60.423441] hardirqs last  enabled at (672913): [<ffffffffb31b796d>] console_unlock+0x44d/0x500
[   60.432230] hardirqs last disabled at (672922): [<ffffffffb31b7963>] console_unlock+0x443/0x500
[   60.441021] softirqs last  enabled at (672940): [<ffffffffb46003dd>] __do_softirq+0x3dd/0x554
[   60.449634] softirqs last disabled at (672931): [<ffffffffb44010f2>] asm_call_irq_on_stack+0x12/0x20
[   60.458871] ---[ end trace f2f88696eb17806c ]---

This patch introduces struct drm_driver.gem_prime_create_object, which
creates a GEM object during the import. Drivers should implement this
callback and handle DMA S/G table support by themselves. For USB-based
drivers, the patch adds an implementation without DMA-related code.

The original interface struct drm_driver.gem_prime_import_sg_table
is deprecated. All drivers should switch over.

Tested by joining/mirroring displays of udl and radeon un der Gnome/X11.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB devices")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Johan Hovold <johan@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: "Ahmed S. Darwish" <a.darwish@linutronix.de>
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: <stable@vger.kernel.org> # v5.10+
---
 drivers/gpu/drm/drm_prime.c     | 43 +++++++++++++++++++++------------
 drivers/gpu/drm/tiny/gm12u320.c |  7 ++++++
 drivers/gpu/drm/udl/udl_drv.c   |  7 ++++++
 include/drm/drm_drv.h           | 12 +++++++++
 4 files changed, 54 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index 2a54f86856af..9bb30e843a44 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -923,7 +923,8 @@ struct drm_gem_object *drm_gem_prime_import_dev(struct drm_device *dev,
 		}
 	}
 
-	if (!dev->driver->gem_prime_import_sg_table)
+	if (!dev->driver->gem_prime_import_sg_table &&
+	    !dev->driver->gem_prime_create_object)
 		return ERR_PTR(-EINVAL);
 
 	attach = dma_buf_attach(dma_buf, attach_dev);
@@ -932,25 +933,37 @@ struct drm_gem_object *drm_gem_prime_import_dev(struct drm_device *dev,
 
 	get_dma_buf(dma_buf);
 
-	sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
-	if (IS_ERR(sgt)) {
-		ret = PTR_ERR(sgt);
-		goto fail_detach;
-	}
+	if (dev->driver->gem_prime_create_object) {
+		obj = dev->driver->gem_prime_create_object(dev, attach);
+		if (IS_ERR(obj)) {
+			ret = PTR_ERR(obj);
+			goto fail_detach;
+		}
 
-	obj = dev->driver->gem_prime_import_sg_table(dev, attach, sgt);
-	if (IS_ERR(obj)) {
-		ret = PTR_ERR(obj);
-		goto fail_unmap;
-	}
+		if (!obj->import_attach)
+			obj->import_attach = attach;
+		if (!obj->resv)
+			obj->resv = dma_buf->resv;
+	} else {
+		sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
+		if (IS_ERR(sgt)) {
+			ret = PTR_ERR(sgt);
+			goto fail_detach;
+		}
 
-	obj->import_attach = attach;
-	obj->resv = dma_buf->resv;
+		obj = dev->driver->gem_prime_import_sg_table(dev, attach, sgt);
+		if (IS_ERR(obj)) {
+			ret = PTR_ERR(obj);
+			dma_buf_unmap_attachment(attach, sgt, DMA_BIDIRECTIONAL);
+			goto fail_detach;
+		}
+
+		obj->import_attach = attach;
+		obj->resv = dma_buf->resv;
+	}
 
 	return obj;
 
-fail_unmap:
-	dma_buf_unmap_attachment(attach, sgt, DMA_BIDIRECTIONAL);
 fail_detach:
 	dma_buf_detach(dma_buf, attach);
 	dma_buf_put(dma_buf);
diff --git a/drivers/gpu/drm/tiny/gm12u320.c b/drivers/gpu/drm/tiny/gm12u320.c
index 0b4f4f2af1ef..9f13a7c7c2da 100644
--- a/drivers/gpu/drm/tiny/gm12u320.c
+++ b/drivers/gpu/drm/tiny/gm12u320.c
@@ -601,6 +601,12 @@ static const uint64_t gm12u320_pipe_modifiers[] = {
 
 DEFINE_DRM_GEM_FOPS(gm12u320_fops);
 
+static struct drm_gem_object *gm12u320_gem_prime_create_object(struct drm_device *dev,
+							       struct dma_buf_attachment *attach)
+{
+	return drm_gem_shmem_prime_import_sg_table(dev, attach, NULL);
+}
+
 static const struct drm_driver gm12u320_drm_driver = {
 	.driver_features = DRIVER_MODESET | DRIVER_GEM | DRIVER_ATOMIC,
 
@@ -612,6 +618,7 @@ static const struct drm_driver gm12u320_drm_driver = {
 
 	.fops		 = &gm12u320_fops,
 	DRM_GEM_SHMEM_DRIVER_OPS,
+	.gem_prime_create_object = gm12u320_gem_prime_create_object,
 };
 
 static const struct drm_mode_config_funcs gm12u320_mode_config_funcs = {
diff --git a/drivers/gpu/drm/udl/udl_drv.c b/drivers/gpu/drm/udl/udl_drv.c
index 9269092697d8..fdf37b44a956 100644
--- a/drivers/gpu/drm/udl/udl_drv.c
+++ b/drivers/gpu/drm/udl/udl_drv.c
@@ -34,12 +34,19 @@ static int udl_usb_resume(struct usb_interface *interface)
 
 DEFINE_DRM_GEM_FOPS(udl_driver_fops);
 
+static struct drm_gem_object *udl_gem_prime_create_object(struct drm_device *dev,
+							  struct dma_buf_attachment *attach)
+{
+	return drm_gem_shmem_prime_import_sg_table(dev, attach, NULL);
+}
+
 static const struct drm_driver driver = {
 	.driver_features = DRIVER_ATOMIC | DRIVER_GEM | DRIVER_MODESET,
 
 	/* GEM hooks */
 	.fops = &udl_driver_fops,
 	DRM_GEM_SHMEM_DRIVER_OPS,
+	.gem_prime_create_object = udl_gem_prime_create_object,
 
 	.name = DRIVER_NAME,
 	.desc = DRIVER_DESC,
diff --git a/include/drm/drm_drv.h b/include/drm/drm_drv.h
index 827838e0a97e..77657d649ca6 100644
--- a/include/drm/drm_drv.h
+++ b/include/drm/drm_drv.h
@@ -369,11 +369,23 @@ struct drm_driver {
 	 */
 	struct drm_gem_object * (*gem_prime_import)(struct drm_device *dev,
 				struct dma_buf *dma_buf);
+	/**
+	 * @gem_prime_create_object:
+	 *
+	 * Optional hook used by the PRIME helper functions
+	 * drm_gem_prime_import() respectively drm_gem_prime_import_dev().
+	 */
+	struct drm_gem_object *(*gem_prime_create_object)(
+				struct drm_device *dev,
+				struct dma_buf_attachment *attach);
 	/**
 	 * @gem_prime_import_sg_table:
 	 *
 	 * Optional hook used by the PRIME helper functions
 	 * drm_gem_prime_import() respectively drm_gem_prime_import_dev().
+	 *
+	 * TODO: This function is deprecated in favor of @drm_driver.gem_prime_create_object.
+	 * Drivers should switch over and implement SG-table support by themselves.
 	 */
 	struct drm_gem_object *(*gem_prime_import_sg_table)(
 				struct drm_device *dev,
-- 
2.30.1


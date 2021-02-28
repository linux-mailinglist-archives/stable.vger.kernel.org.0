Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8205327356
	for <lists+stable@lfdr.de>; Sun, 28 Feb 2021 17:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhB1Q2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 11:28:24 -0500
Received: from nikam.ms.mff.cuni.cz ([195.113.20.16]:39146 "EHLO
        nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbhB1Q2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 11:28:23 -0500
X-Greylist: delayed 613 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Feb 2021 11:28:21 EST
Received: from kamenik.kam.mff.cuni.cz (kamenik.kam.mff.cuni.cz [195.113.17.143])
        by nikam.ms.mff.cuni.cz (Postfix) with ESMTP id C34032802D8;
        Sun, 28 Feb 2021 17:17:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kam.mff.cuni.cz;
        s=gen1; t=1614529045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aK5ZoS32pJiAKEM6xQBi1lZJbHspQKOhSLufWe8dQsA=;
        b=WGP2riujtAQtPn21GM4TXHHdyOkcXLLb/iXeCZ4nE3tLV8H49C8k7cOWMzKQI9RGlN7+W8
        JBUJFN9oa35dxclrJNEeZUIwpDLfIk45UsPmUI1IRSJSFlqN2p1Au4MWMUXEjWrRQeLM8e
        m7JRobso0GvoUvJ+yZK6ZeX6951KPW0=
Received: by kamenik.kam.mff.cuni.cz (Postfix, from userid 3165)
        id BC8142400B1; Sun, 28 Feb 2021 17:17:25 +0100 (CET)
From:   =?UTF-8?q?Pavel=20Turinsk=C3=BD?= <ledoian@kam.mff.cuni.cz>
To:     tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch
Cc:     dri-devel@lists.freedesktop.org,
        =?UTF-8?q?Pavel=20Turinsk=C3=BD?= <ledoian@kam.mff.cuni.cz>,
        stable@vger.kernel.org
Subject: [PATCH] drm/gem: add checks of drm_gem_object->funcs
Date:   Sun, 28 Feb 2021 17:10:22 +0100
Message-Id: <20210228161022.53468-1-ledoian@kam.mff.cuni.cz>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The checks were removed in commit d693def4fd1c ("drm: Remove obsolete GEM
and PRIME callbacks from struct drm_driver") and can lead to following
kernel oops:

[  139.449098] BUG: kernel NULL pointer dereference, address: 0000000000000008
[  139.449110] #PF: supervisor read access in kernel mode
[  139.449113] #PF: error_code(0x0000) - not-present page
[  139.449116] PGD 0 P4D 0
[  139.449121] Oops: 0000 [#1] PREEMPT SMP PTI
[  139.449126] CPU: 4 PID: 1181 Comm: Xorg Not tainted 5.11.2LEdoian #2
[  139.449130] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z77-DS3H, BIOS F4 04/25/2012
[  139.449133] RIP: 0010:drm_gem_handle_create_tail+0xcb/0x190 [drm]
[  139.449185] Code: 00 48 89 ef e8 06 b4 49 f7 45 85 e4 78 77 48 8d 6b 18 4c 89 ee 48 89 ef e8 c2 f5 00 00 89 c2 85 c0 75 3e 48 8b 83 40 01 00 00 <48> 8b 40 0
8 48 85 c0 74 0f 4c 89 ee 48 89 df e8 71 5d 87 f7 85 c0
[  139.449190] RSP: 0018:ffffbe21c194bd28 EFLAGS: 00010246
[  139.449194] RAX: 0000000000000000 RBX: ffff9da9b3caf078 RCX: 0000000000000000
[  139.449197] RDX: 0000000000000000 RSI: ffffffffc039b893 RDI: 0000000000000000
[  139.449199] RBP: ffff9da9b3caf090 R08: 0000000000000040 R09: ffff9da983b911c0
[  139.449202] R10: ffff9da984749e00 R11: ffff9da9859bfc38 R12: 0000000000000007
[  139.449204] R13: ffff9da9859bfc00 R14: ffff9da9859bfc50 R15: ffff9da9859bfc38
[  139.449207] FS:  00007f6332a56900(0000) GS:ffff9daea7b00000(0000) knlGS:0000000000000000
[  139.449211] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  139.449214] CR2: 0000000000000008 CR3: 00000001319b8005 CR4: 00000000001706e0
[  139.449217] Call Trace:
[  139.449224]  drm_gem_prime_fd_to_handle+0xff/0x1d0 [drm]
[  139.449274]  ? drm_prime_destroy_file_private+0x20/0x20 [drm]
[  139.449323]  drm_ioctl_kernel+0xac/0xf0 [drm]
[  139.449363]  drm_ioctl+0x20f/0x3b0 [drm]
[  139.449403]  ? drm_prime_destroy_file_private+0x20/0x20 [drm]
[  139.449454]  radeon_drm_ioctl+0x49/0x80 [radeon]
[  139.449500]  __x64_sys_ioctl+0x84/0xc0
[  139.449507]  do_syscall_64+0x33/0x40
[  139.449514]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  139.449522] RIP: 0033:0x7f63330fbe6b
[  139.449526] Code: ff ff ff 85 c0 79 8b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f
0 ff ff 73 01 c3 48 8b 0d d5 af 0c 00 f7 d8 64 89 01 48
[  139.449529] RSP: 002b:00007fff1e9c4438 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  139.449534] RAX: ffffffffffffffda RBX: 00007fff1e9c447c RCX: 00007f63330fbe6b
[  139.449537] RDX: 00007fff1e9c447c RSI: 00000000c00c642e RDI: 0000000000000012
[  139.449539] RBP: 00000000c00c642e R08: 00007fff1e9c4520 R09: 00007f63331c7a60
[  139.449542] R10: 00007f6329fb9ab0 R11: 0000000000000246 R12: 000055f69810ad40
[  139.449544] R13: 0000000000000012 R14: 0000000000100000 R15: 00007fff1e9c4c20
[  139.449549] Modules linked in: 8021q garp mrp bridge stp llc nls_iso8859_1 vfat fat fuse btrfs blake2b_generic xor raid6_pq libcrc32c crypto_user tun i2c_de
v it87 hwmon_vid snd_seq snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio sg snd_hda_codec_hdmi virtio_balloon snd_hda_intel virtio_console snd_intel_
dspcfg soundwire_intel virtio_pci soundwire_generic_allocation soundwire_cadence virtio_blk snd_hda_codec intel_rapl_msr btusb intel_rapl_common virtio_net btr
tl net_failover uvcvideo snd_usb_audio snd_hda_core btbcm x86_pkg_temp_thermal failover soundwire_bus btintel intel_powerclamp snd_soc_core coretemp snd_usbmid
i_lib iTCO_wdt videobuf2_vmalloc bluetooth intel_pmc_bxt snd_hwdep kvm_intel videobuf2_memops snd_rawmidi snd_compress videobuf2_v4l2 ac97_bus snd_pcm_dmaengin
e iTCO_vendor_support crct10dif_pclmul at24 crc32_pclmul videobuf2_common snd_seq_device mei_hdcp snd_pcm ghash_clmulni_intel kvm videodev aesni_intel crypto_s
imd snd_timer snd cryptd mc ecdh_generic
[  139.449642]  glue_helper rfkill soundcore joydev mousedev rapl ecc intel_cstate r8169 i2c_i801 intel_uncore atl1c realtek irqbypass mdio_devres mei_me libph
y i2c_smbus mei mac_hid lpc_ich ext4 crc32c_generic crc16 mbcache jbd2 dm_mod ata_generic pata_acpi uas usb_storage sr_mod crc32c_intel serio_raw cdrom xhci_pc
i pata_jmicron xhci_pci_renesas radeon usbhid i915 intel_gtt nouveau mxm_wmi wmi video i2c_algo_bit drm_ttm_helper ttm drm_kms_helper syscopyarea sysfillrect s
ysimgblt fb_sys_fops cec drm agpgart
[  139.449707] CR2: 0000000000000008
[  139.449710] ---[ end trace f5ce5774498d18e1 ]---

Signed-off-by: Pavel Turinský <ledoian@kam.mff.cuni.cz>
Fixes: d693def4fd1c ("drm: Remove obsolete GEM and PRIME callbacks from struct drm_driver")
Cc: stable@vger.kernel.org
---

This is a very symptomatic patch around issue I ran into. I do not know if the
funcs property should ever be NULL. I basically restored all the checks that
were removed in the mentioned commit. Unfortunately, I do not understand drm
nor will I have time to delve into it in forseeable future.

 drivers/gpu/drm/drm_gem.c   | 20 ++++++++++----------
 drivers/gpu/drm/drm_prime.c |  2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 92f89cee213e..451f290c737c 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -249,7 +249,7 @@ drm_gem_object_release_handle(int id, void *ptr, void *data)
 	struct drm_file *file_priv = data;
 	struct drm_gem_object *obj = ptr;
 
-	if (obj->funcs->close)
+	if (obj->funcs && obj->funcs->close)
 		obj->funcs->close(obj, file_priv);
 
 	drm_gem_remove_prime_handles(obj, file_priv);
@@ -401,7 +401,7 @@ drm_gem_handle_create_tail(struct drm_file *file_priv,
 	if (ret)
 		goto err_remove;
 
-	if (obj->funcs->open) {
+	if (obj->funcs && obj->funcs->open) {
 		ret = obj->funcs->open(obj, file_priv);
 		if (ret)
 			goto err_revoke;
@@ -977,7 +977,7 @@ drm_gem_object_free(struct kref *kref)
 	struct drm_gem_object *obj =
 		container_of(kref, struct drm_gem_object, refcount);
 
-	if (WARN_ON(!obj->funcs->free))
+	if (!obj->funcs || WARN_ON(!obj->funcs->free))
 		return;
 
 	obj->funcs->free(obj);
@@ -1079,7 +1079,7 @@ int drm_gem_mmap_obj(struct drm_gem_object *obj, unsigned long obj_size,
 
 	vma->vm_private_data = obj;
 
-	if (obj->funcs->mmap) {
+	if (obj->funcs && obj->funcs->mmap) {
 		ret = obj->funcs->mmap(obj, vma);
 		if (ret) {
 			drm_gem_object_put(obj);
@@ -1087,7 +1087,7 @@ int drm_gem_mmap_obj(struct drm_gem_object *obj, unsigned long obj_size,
 		}
 		WARN_ON(!(vma->vm_flags & VM_DONTEXPAND));
 	} else {
-		if (obj->funcs->vm_ops)
+		if (obj->funcs && obj->funcs->vm_ops)
 			vma->vm_ops = obj->funcs->vm_ops;
 		else {
 			drm_gem_object_put(obj);
@@ -1188,13 +1188,13 @@ void drm_gem_print_info(struct drm_printer *p, unsigned int indent,
 	drm_printf_indent(p, indent, "imported=%s\n",
 			  obj->import_attach ? "yes" : "no");
 
-	if (obj->funcs->print_info)
+	if (obj->funcs && obj->funcs->print_info)
 		obj->funcs->print_info(p, indent, obj);
 }
 
 int drm_gem_pin(struct drm_gem_object *obj)
 {
-	if (obj->funcs->pin)
+	if (obj->funcs && obj->funcs->pin)
 		return obj->funcs->pin(obj);
 	else
 		return 0;
@@ -1202,7 +1202,7 @@ int drm_gem_pin(struct drm_gem_object *obj)
 
 void drm_gem_unpin(struct drm_gem_object *obj)
 {
-	if (obj->funcs->unpin)
+	if (obj->funcs && obj->funcs->unpin)
 		obj->funcs->unpin(obj);
 }
 
@@ -1210,7 +1210,7 @@ int drm_gem_vmap(struct drm_gem_object *obj, struct dma_buf_map *map)
 {
 	int ret;
 
-	if (!obj->funcs->vmap)
+	if (!obj->funcs || !obj->funcs->vmap)
 		return -EOPNOTSUPP;
 
 	ret = obj->funcs->vmap(obj, map);
@@ -1227,7 +1227,7 @@ void drm_gem_vunmap(struct drm_gem_object *obj, struct dma_buf_map *map)
 	if (dma_buf_map_is_null(map))
 		return;
 
-	if (obj->funcs->vunmap)
+	if (obj->funcs && obj->funcs->vunmap)
 		obj->funcs->vunmap(obj, map);
 
 	/* Always set the mapping to NULL. Callers may rely on this. */
diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index 7db55fce35d8..1566dcf417e2 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -620,7 +620,7 @@ struct sg_table *drm_gem_map_dma_buf(struct dma_buf_attachment *attach,
 	if (WARN_ON(dir == DMA_NONE))
 		return ERR_PTR(-EINVAL);
 
-	if (WARN_ON(!obj->funcs->get_sg_table))
+	if (!obj->funcs || WARN_ON(!obj->funcs->get_sg_table))
 		return ERR_PTR(-ENOSYS);
 
 	sgt = obj->funcs->get_sg_table(obj);
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D885B3EC8FE
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 14:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238167AbhHOMaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 08:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238145AbhHOMaS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Aug 2021 08:30:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 868BC60EB5;
        Sun, 15 Aug 2021 12:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629030589;
        bh=S7kHbQ/cuEeb5Mo+90GW69XHMRdKEaGg76Uf1Tiw7h4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lpgOA/jD0PVh2vknxfS8crotNuCsbU3LR4Rdmzf7Tc21xIsoAeclavoHbcA8i0A2h
         FfudV+lC8k7w33pShUG8LzmSINBo5klNuI8vS2Nh8p7/H6aZaiiDCCWfk2iuDe/2+5
         IvcnXDM3tUfpbXTNXI6SNcCHUqmlfcdDNPC2Dn/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.13.11
Date:   Sun, 15 Aug 2021 14:29:35 +0200
Message-Id: <162903057414027@kroah.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1629030574212136@kroah.com>
References: <1629030574212136@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 4e9f877f513f..eaf1df54ad12 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 13
-SUBLEVEL = 10
+SUBLEVEL = 11
 EXTRAVERSION =
 NAME = Opossums on Parade
 
diff --git a/drivers/firmware/broadcom/tee_bnxt_fw.c b/drivers/firmware/broadcom/tee_bnxt_fw.c
index ed10da5313e8..a5bf4c3f6dc7 100644
--- a/drivers/firmware/broadcom/tee_bnxt_fw.c
+++ b/drivers/firmware/broadcom/tee_bnxt_fw.c
@@ -212,10 +212,9 @@ static int tee_bnxt_fw_probe(struct device *dev)
 
 	pvt_data.dev = dev;
 
-	fw_shm_pool = tee_shm_alloc(pvt_data.ctx, MAX_SHM_MEM_SZ,
-				    TEE_SHM_MAPPED | TEE_SHM_DMA_BUF);
+	fw_shm_pool = tee_shm_alloc_kernel_buf(pvt_data.ctx, MAX_SHM_MEM_SZ);
 	if (IS_ERR(fw_shm_pool)) {
-		dev_err(pvt_data.dev, "tee_shm_alloc failed\n");
+		dev_err(pvt_data.dev, "tee_shm_alloc_kernel_buf failed\n");
 		err = PTR_ERR(fw_shm_pool);
 		goto out_sess;
 	}
@@ -242,6 +241,14 @@ static int tee_bnxt_fw_remove(struct device *dev)
 	return 0;
 }
 
+static void tee_bnxt_fw_shutdown(struct device *dev)
+{
+	tee_shm_free(pvt_data.fw_shm_pool);
+	tee_client_close_session(pvt_data.ctx, pvt_data.session_id);
+	tee_client_close_context(pvt_data.ctx);
+	pvt_data.ctx = NULL;
+}
+
 static const struct tee_client_device_id tee_bnxt_fw_id_table[] = {
 	{UUID_INIT(0x6272636D, 0x2019, 0x0716,
 		    0x42, 0x43, 0x4D, 0x5F, 0x53, 0x43, 0x48, 0x49)},
@@ -257,6 +264,7 @@ static struct tee_client_driver tee_bnxt_fw_driver = {
 		.bus		= &tee_bus_type,
 		.probe		= tee_bnxt_fw_probe,
 		.remove		= tee_bnxt_fw_remove,
+		.shutdown	= tee_bnxt_fw_shutdown,
 	},
 };
 
diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 930e49ef15f6..b9dd47bd597f 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -284,7 +284,7 @@ static struct channel *ppp_find_channel(struct ppp_net *pn, int unit);
 static int ppp_connect_channel(struct channel *pch, int unit);
 static int ppp_disconnect_channel(struct channel *pch);
 static void ppp_destroy_channel(struct channel *pch);
-static int unit_get(struct idr *p, void *ptr);
+static int unit_get(struct idr *p, void *ptr, int min);
 static int unit_set(struct idr *p, void *ptr, int n);
 static void unit_put(struct idr *p, int n);
 static void *unit_find(struct idr *p, int n);
@@ -1155,9 +1155,20 @@ static int ppp_unit_register(struct ppp *ppp, int unit, bool ifname_is_set)
 	mutex_lock(&pn->all_ppp_mutex);
 
 	if (unit < 0) {
-		ret = unit_get(&pn->units_idr, ppp);
+		ret = unit_get(&pn->units_idr, ppp, 0);
 		if (ret < 0)
 			goto err;
+		if (!ifname_is_set) {
+			while (1) {
+				snprintf(ppp->dev->name, IFNAMSIZ, "ppp%i", ret);
+				if (!__dev_get_by_name(ppp->ppp_net, ppp->dev->name))
+					break;
+				unit_put(&pn->units_idr, ret);
+				ret = unit_get(&pn->units_idr, ppp, ret + 1);
+				if (ret < 0)
+					goto err;
+			}
+		}
 	} else {
 		/* Caller asked for a specific unit number. Fail with -EEXIST
 		 * if unavailable. For backward compatibility, return -EEXIST
@@ -3552,9 +3563,9 @@ static int unit_set(struct idr *p, void *ptr, int n)
 }
 
 /* get new free unit number and associate pointer with it */
-static int unit_get(struct idr *p, void *ptr)
+static int unit_get(struct idr *p, void *ptr, int min)
 {
-	return idr_alloc(p, ptr, 0, 0, GFP_KERNEL);
+	return idr_alloc(p, ptr, min, 0, GFP_KERNEL);
 }
 
 /* put unit number back to a pool */
diff --git a/fs/namespace.c b/fs/namespace.c
index c3f1a78ba369..caad091fb204 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1938,6 +1938,20 @@ void drop_collected_mounts(struct vfsmount *mnt)
 	namespace_unlock();
 }
 
+static bool has_locked_children(struct mount *mnt, struct dentry *dentry)
+{
+	struct mount *child;
+
+	list_for_each_entry(child, &mnt->mnt_mounts, mnt_child) {
+		if (!is_subdir(child->mnt_mountpoint, dentry))
+			continue;
+
+		if (child->mnt.mnt_flags & MNT_LOCKED)
+			return true;
+	}
+	return false;
+}
+
 /**
  * clone_private_mount - create a private clone of a path
  * @path: path to clone
@@ -1953,10 +1967,19 @@ struct vfsmount *clone_private_mount(const struct path *path)
 	struct mount *old_mnt = real_mount(path->mnt);
 	struct mount *new_mnt;
 
+	down_read(&namespace_sem);
 	if (IS_MNT_UNBINDABLE(old_mnt))
-		return ERR_PTR(-EINVAL);
+		goto invalid;
+
+	if (!check_mnt(old_mnt))
+		goto invalid;
+
+	if (has_locked_children(old_mnt, path->dentry))
+		goto invalid;
 
 	new_mnt = clone_mnt(old_mnt, path->dentry, CL_PRIVATE);
+	up_read(&namespace_sem);
+
 	if (IS_ERR(new_mnt))
 		return ERR_CAST(new_mnt);
 
@@ -1964,6 +1987,10 @@ struct vfsmount *clone_private_mount(const struct path *path)
 	new_mnt->mnt_ns = MNT_NS_INTERNAL;
 
 	return &new_mnt->mnt;
+
+invalid:
+	up_read(&namespace_sem);
+	return ERR_PTR(-EINVAL);
 }
 EXPORT_SYMBOL_GPL(clone_private_mount);
 
@@ -2315,19 +2342,6 @@ static int do_change_type(struct path *path, int ms_flags)
 	return err;
 }
 
-static bool has_locked_children(struct mount *mnt, struct dentry *dentry)
-{
-	struct mount *child;
-	list_for_each_entry(child, &mnt->mnt_mounts, mnt_child) {
-		if (!is_subdir(child->mnt_mountpoint, dentry))
-			continue;
-
-		if (child->mnt.mnt_flags & MNT_LOCKED)
-			return true;
-	}
-	return false;
-}
-
 static struct mount *__do_loopback(struct path *old_path, int recurse)
 {
 	struct mount *mnt = ERR_PTR(-EINVAL), *old = real_mount(old_path->mnt);
diff --git a/include/linux/security.h b/include/linux/security.h
index 06f7c50ce77f..0acd1b68bf30 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -120,6 +120,7 @@ enum lockdown_reason {
 	LOCKDOWN_MMIOTRACE,
 	LOCKDOWN_DEBUGFS,
 	LOCKDOWN_XMON_WR,
+	LOCKDOWN_BPF_WRITE_USER,
 	LOCKDOWN_INTEGRITY_MAX,
 	LOCKDOWN_KCORE,
 	LOCKDOWN_KPROBES,
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index f0568b3d6bd1..77a0d0fb97a9 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -990,12 +990,13 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_numa_node_id_proto;
 	case BPF_FUNC_perf_event_read:
 		return &bpf_perf_event_read_proto;
-	case BPF_FUNC_probe_write_user:
-		return bpf_get_probe_write_proto();
 	case BPF_FUNC_current_task_under_cgroup:
 		return &bpf_current_task_under_cgroup_proto;
 	case BPF_FUNC_get_prandom_u32:
 		return &bpf_get_prandom_u32_proto;
+	case BPF_FUNC_probe_write_user:
+		return security_locked_down(LOCKDOWN_BPF_WRITE_USER) < 0 ?
+		       NULL : bpf_get_probe_write_proto();
 	case BPF_FUNC_probe_read_user:
 		return &bpf_probe_read_user_proto;
 	case BPF_FUNC_probe_read_kernel:
diff --git a/security/security.c b/security/security.c
index b38155b2de83..0d626c0dafcc 100644
--- a/security/security.c
+++ b/security/security.c
@@ -58,6 +58,7 @@ const char *const lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
 	[LOCKDOWN_MMIOTRACE] = "unsafe mmio",
 	[LOCKDOWN_DEBUGFS] = "debugfs access",
 	[LOCKDOWN_XMON_WR] = "xmon write access",
+	[LOCKDOWN_BPF_WRITE_USER] = "use of bpf to write user RAM",
 	[LOCKDOWN_INTEGRITY_MAX] = "integrity",
 	[LOCKDOWN_KCORE] = "/proc/kcore access",
 	[LOCKDOWN_KPROBES] = "use of kprobes",
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 2b3c164d21f1..cb795135ffc2 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -251,7 +251,10 @@ static bool hw_support_mmap(struct snd_pcm_substream *substream)
 
 	switch (substream->dma_buffer.dev.type) {
 	case SNDRV_DMA_TYPE_UNKNOWN:
-		return false;
+		/* we can't know the device, so just assume that the driver does
+		 * everything right
+		 */
+		return true;
 	case SNDRV_DMA_TYPE_CONTINUOUS:
 	case SNDRV_DMA_TYPE_VMALLOC:
 		return true;
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index c92d9b9cf944..6d8c4dedfe0f 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8371,6 +8371,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x87f4, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f5, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f7, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
+	SND_PCI_QUIRK(0x103c, 0x8805, "HP ProBook 650 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x880d, "HP EliteBook 830 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8846, "HP EliteBook 850 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8847, "HP EliteBook x360 830 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
@@ -8405,6 +8406,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x16e3, "ASUS UX50", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x1740, "ASUS UX430UA", ALC295_FIXUP_ASUS_DACS),
 	SND_PCI_QUIRK(0x1043, 0x17d1, "ASUS UX431FL", ALC294_FIXUP_ASUS_DUAL_SPK),
+	SND_PCI_QUIRK(0x1043, 0x1662, "ASUS GV301QH", ALC294_FIXUP_ASUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1881, "ASUS Zephyrus S/M", ALC294_FIXUP_ASUS_GX502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x18b1, "Asus MJ401TA", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x18f1, "Asus FX505DT", ALC256_FIXUP_ASUS_HEADSET_MIC),

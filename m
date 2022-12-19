Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8116650AD8
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 12:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbiLSLmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 06:42:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiLSLmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 06:42:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE6D60E8;
        Mon, 19 Dec 2022 03:42:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06727B80D88;
        Mon, 19 Dec 2022 11:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A52C433D2;
        Mon, 19 Dec 2022 11:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671450153;
        bh=Ec+d0YSGMFmmJTbBSkl9rkh3z+jKS6NAB5HiYEnq0M4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PiRtNutLxpeiLUO4LAbxrMj7T6YJr27AEHBAvTNC52Wj+UhsGMVrUf8GKLu37OHoZ
         ocNhAkZKZ6PB4YE87M4EHRdHtYUcigi+EU1xhIEUCl/x67VyfD0NXQoSuQy7jUSllu
         oVq0gAbB7kDMPUYEruDqvQ/wy0TwnQ1tFhuDBrcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.160
Date:   Mon, 19 Dec 2022 12:42:22 +0100
Message-Id: <167145014294227@kroah.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <1671450141212208@kroah.com>
References: <1671450141212208@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index bb9fab281555..6f7dae2f1a4e 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 159
+SUBLEVEL = 160
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.c b/arch/x86/kernel/cpu/mtrr/mtrr.c
index 6a80f36b5d59..5f436cb4f7c4 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.c
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.c
@@ -794,8 +794,6 @@ void mtrr_ap_init(void)
 	if (!use_intel() || mtrr_aps_delayed_init)
 		return;
 
-	rcu_cpu_starting(smp_processor_id());
-
 	/*
 	 * Ideally we should hold mtrr_mutex here to avoid mtrr entries
 	 * changed, but this routine will be called in cpu boot time,
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 8baff500914e..e8e5515fb7e9 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -229,6 +229,7 @@ static void notrace start_secondary(void *unused)
 #endif
 	cpu_init_exception_handling();
 	cpu_init();
+	rcu_cpu_starting(raw_smp_processor_id());
 	x86_cpuinit.early_percpu_clock_init();
 	smp_callin();
 
diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 21063335ab59..c07e327929ba 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -47,6 +47,10 @@
 #define MCBA_VER_REQ_USB 1
 #define MCBA_VER_REQ_CAN 2
 
+/* Drive the CAN_RES signal LOW "0" to activate R24 and R25 */
+#define MCBA_VER_TERMINATION_ON 0
+#define MCBA_VER_TERMINATION_OFF 1
+
 #define MCBA_SIDL_EXID_MASK 0x8
 #define MCBA_DLC_MASK 0xf
 #define MCBA_DLC_RTR_MASK 0x40
@@ -469,7 +473,7 @@ static void mcba_usb_process_ka_usb(struct mcba_priv *priv,
 		priv->usb_ka_first_pass = false;
 	}
 
-	if (msg->termination_state)
+	if (msg->termination_state == MCBA_VER_TERMINATION_ON)
 		priv->can.termination = MCBA_TERMINATION_ENABLED;
 	else
 		priv->can.termination = MCBA_TERMINATION_DISABLED;
@@ -789,9 +793,9 @@ static int mcba_set_termination(struct net_device *netdev, u16 term)
 	};
 
 	if (term == MCBA_TERMINATION_ENABLED)
-		usb_msg.termination = 1;
+		usb_msg.termination = MCBA_VER_TERMINATION_ON;
 	else
-		usb_msg.termination = 0;
+		usb_msg.termination = MCBA_VER_TERMINATION_OFF;
 
 	mcba_usb_xmit_cmd(priv, (struct mcba_usb_msg *)&usb_msg);
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
index 6ef48eb3a77d..b163489489e9 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
@@ -874,7 +874,6 @@ area_cache_get(struct nfp_cpp *cpp, u32 id,
 	}
 
 	/* Adjust the start address to be cache size aligned */
-	cache->id = id;
 	cache->addr = addr & ~(u64)(cache->size - 1);
 
 	/* Re-init to the new ID and address */
@@ -894,6 +893,8 @@ area_cache_get(struct nfp_cpp *cpp, u32 id,
 		return NULL;
 	}
 
+	cache->id = id;
+
 exit:
 	/* Adjust offset */
 	*offset = addr - cache->addr;
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 089f39103584..c222d7bf6ce1 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -817,6 +817,8 @@ static blk_status_t nvme_setup_prp_simple(struct nvme_dev *dev,
 	cmnd->dptr.prp1 = cpu_to_le64(iod->first_dma);
 	if (bv->bv_len > first_prp_len)
 		cmnd->dptr.prp2 = cpu_to_le64(iod->first_dma + first_prp_len);
+	else
+		cmnd->dptr.prp2 = 0;
 	return BLK_STS_OK;
 }
 
diff --git a/drivers/pinctrl/mediatek/mtk-eint.c b/drivers/pinctrl/mediatek/mtk-eint.c
index 22736f60c16c..64a32d3ca481 100644
--- a/drivers/pinctrl/mediatek/mtk-eint.c
+++ b/drivers/pinctrl/mediatek/mtk-eint.c
@@ -278,12 +278,15 @@ static struct irq_chip mtk_eint_irq_chip = {
 
 static unsigned int mtk_eint_hw_init(struct mtk_eint *eint)
 {
-	void __iomem *reg = eint->base + eint->regs->dom_en;
+	void __iomem *dom_en = eint->base + eint->regs->dom_en;
+	void __iomem *mask_set = eint->base + eint->regs->mask_set;
 	unsigned int i;
 
 	for (i = 0; i < eint->hw->ap_num; i += 32) {
-		writel(0xffffffff, reg);
-		reg += 4;
+		writel(0xffffffff, dom_en);
+		writel(0xffffffff, mask_set);
+		dom_en += 4;
+		mask_set += 4;
 	}
 
 	return 0;
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 8e95a75a4559..80a9e50392a0 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -205,7 +205,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 	if (inode && fuse_is_bad(inode))
 		goto invalid;
 	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64()) ||
-		 (flags & LOOKUP_REVAL)) {
+		 (flags & (LOOKUP_EXCL | LOOKUP_REVAL))) {
 		struct fuse_entry_out outarg;
 		FUSE_ARGS(args);
 		struct fuse_forget_link *forget;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index c5c22b067cd8..84758e512a04 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -936,7 +936,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
-		.work_flags		= IO_WQ_WORK_BLKCG,
+		.work_flags		= IO_WQ_WORK_BLKCG | IO_WQ_WORK_FILES,
 	},
 	[IORING_OP_PROVIDE_BUFFERS] = {},
 	[IORING_OP_REMOVE_BUFFERS] = {},
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index a4ae1fcd2ab1..b09ead06a249 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -570,6 +570,7 @@ __be32 nfsd4_clone_file_range(struct nfsd_file *nf_src, u64 src_pos,
 ssize_t nfsd_copy_file_range(struct file *src, u64 src_pos, struct file *dst,
 			     u64 dst_pos, u64 count)
 {
+	ssize_t ret;
 
 	/*
 	 * Limit copy to 4MB to prevent indefinitely blocking an nfsd
@@ -580,7 +581,12 @@ ssize_t nfsd_copy_file_range(struct file *src, u64 src_pos, struct file *dst,
 	 * limit like this and pipeline multiple COPY requests.
 	 */
 	count = min_t(u64, count, 1 << 22);
-	return vfs_copy_file_range(src, src_pos, dst, dst_pos, count, 0);
+	ret = vfs_copy_file_range(src, src_pos, dst, dst_pos, count, 0);
+
+	if (ret == -EOPNOTSUPP || ret == -EXDEV)
+		ret = vfs_copy_file_range(src, src_pos, dst, dst_pos, count,
+					  COPY_FILE_SPLICE);
+	return ret;
 }
 
 __be32 nfsd4_vfs_fallocate(struct svc_rqst *rqstp, struct svc_fh *fhp,
diff --git a/fs/read_write.c b/fs/read_write.c
index 75f764b43418..0066acb6b380 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1388,28 +1388,6 @@ ssize_t generic_copy_file_range(struct file *file_in, loff_t pos_in,
 }
 EXPORT_SYMBOL(generic_copy_file_range);
 
-static ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
-				  struct file *file_out, loff_t pos_out,
-				  size_t len, unsigned int flags)
-{
-	/*
-	 * Although we now allow filesystems to handle cross sb copy, passing
-	 * a file of the wrong filesystem type to filesystem driver can result
-	 * in an attempt to dereference the wrong type of ->private_data, so
-	 * avoid doing that until we really have a good reason.  NFS defines
-	 * several different file_system_type structures, but they all end up
-	 * using the same ->copy_file_range() function pointer.
-	 */
-	if (file_out->f_op->copy_file_range &&
-	    file_out->f_op->copy_file_range == file_in->f_op->copy_file_range)
-		return file_out->f_op->copy_file_range(file_in, pos_in,
-						       file_out, pos_out,
-						       len, flags);
-
-	return generic_copy_file_range(file_in, pos_in, file_out, pos_out, len,
-				       flags);
-}
-
 /*
  * Performs necessary checks before doing a file copy
  *
@@ -1431,6 +1409,26 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
 	if (ret)
 		return ret;
 
+	/*
+	 * We allow some filesystems to handle cross sb copy, but passing
+	 * a file of the wrong filesystem type to filesystem driver can result
+	 * in an attempt to dereference the wrong type of ->private_data, so
+	 * avoid doing that until we really have a good reason.
+	 *
+	 * nfs and cifs define several different file_system_type structures
+	 * and several different sets of file_operations, but they all end up
+	 * using the same ->copy_file_range() function pointer.
+	 */
+	if (flags & COPY_FILE_SPLICE) {
+		/* cross sb splice is allowed */
+	} else if (file_out->f_op->copy_file_range) {
+		if (file_in->f_op->copy_file_range !=
+		    file_out->f_op->copy_file_range)
+			return -EXDEV;
+	} else if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb) {
+		return -EXDEV;
+	}
+
 	/* Don't touch certain kinds of inodes */
 	if (IS_IMMUTABLE(inode_out))
 		return -EPERM;
@@ -1473,8 +1471,9 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 			    size_t len, unsigned int flags)
 {
 	ssize_t ret;
+	bool splice = flags & COPY_FILE_SPLICE;
 
-	if (flags != 0)
+	if (flags & ~COPY_FILE_SPLICE)
 		return -EINVAL;
 
 	ret = generic_copy_file_checks(file_in, pos_in, file_out, pos_out, &len,
@@ -1496,26 +1495,43 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	file_start_write(file_out);
 
 	/*
-	 * Try cloning first, this is supported by more file systems, and
-	 * more efficient if both clone and copy are supported (e.g. NFS).
+	 * Cloning is supported by more file systems, so we implement copy on
+	 * same sb using clone, but for filesystems where both clone and copy
+	 * are supported (e.g. nfs,cifs), we only call the copy method.
 	 */
-	if (file_in->f_op->remap_file_range &&
-	    file_inode(file_in)->i_sb == file_inode(file_out)->i_sb) {
-		loff_t cloned;
+	if (!splice && file_out->f_op->copy_file_range) {
+		ret = file_out->f_op->copy_file_range(file_in, pos_in,
+						      file_out, pos_out,
+						      len, flags);
+		goto done;
+	}
 
-		cloned = file_in->f_op->remap_file_range(file_in, pos_in,
+	if (!splice && file_in->f_op->remap_file_range &&
+	    file_inode(file_in)->i_sb == file_inode(file_out)->i_sb) {
+		ret = file_in->f_op->remap_file_range(file_in, pos_in,
 				file_out, pos_out,
 				min_t(loff_t, MAX_RW_COUNT, len),
 				REMAP_FILE_CAN_SHORTEN);
-		if (cloned > 0) {
-			ret = cloned;
+		if (ret > 0)
 			goto done;
-		}
 	}
 
-	ret = do_copy_file_range(file_in, pos_in, file_out, pos_out, len,
-				flags);
-	WARN_ON_ONCE(ret == -EOPNOTSUPP);
+	/*
+	 * We can get here for same sb copy of filesystems that do not implement
+	 * ->copy_file_range() in case filesystem does not support clone or in
+	 * case filesystem supports clone but rejected the clone request (e.g.
+	 * because it was not block aligned).
+	 *
+	 * In both cases, fall back to kernel copy so we are able to maintain a
+	 * consistent story about which filesystems support copy_file_range()
+	 * and which filesystems do not, that will allow userspace tools to
+	 * make consistent desicions w.r.t using copy_file_range().
+	 *
+	 * We also get here if caller (e.g. nfsd) requested COPY_FILE_SPLICE.
+	 */
+	ret = generic_copy_file_range(file_in, pos_in, file_out, pos_out, len,
+				      flags);
+
 done:
 	if (ret > 0) {
 		fsnotify_access(file_in);
@@ -1566,6 +1582,10 @@ SYSCALL_DEFINE6(copy_file_range, int, fd_in, loff_t __user *, off_in,
 		pos_out = f_out.file->f_pos;
 	}
 
+	ret = -EINVAL;
+	if (flags != 0)
+		goto out;
+
 	ret = vfs_copy_file_range(f_in.file, pos_in, f_out.file, pos_out, len,
 				  flags);
 	if (ret > 0) {
diff --git a/include/linux/can/platform/sja1000.h b/include/linux/can/platform/sja1000.h
index 5755ae5a4712..6a869682c120 100644
--- a/include/linux/can/platform/sja1000.h
+++ b/include/linux/can/platform/sja1000.h
@@ -14,7 +14,7 @@
 #define OCR_MODE_TEST     0x01
 #define OCR_MODE_NORMAL   0x02
 #define OCR_MODE_CLOCK    0x03
-#define OCR_MODE_MASK     0x07
+#define OCR_MODE_MASK     0x03
 #define OCR_TX0_INVERT    0x04
 #define OCR_TX0_PULLDOWN  0x08
 #define OCR_TX0_PULLUP    0x10
diff --git a/include/linux/fs.h b/include/linux/fs.h
index df54acdd3554..ebfc0b2b4969 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1817,6 +1817,14 @@ struct dir_context {
  */
 #define REMAP_FILE_ADVISORY		(REMAP_FILE_CAN_SHORTEN)
 
+/*
+ * These flags control the behavior of vfs_copy_file_range().
+ * They are not available to the user via syscall.
+ *
+ * COPY_FILE_SPLICE: call splice direct instead of fs clone/copy ops
+ */
+#define COPY_FILE_SPLICE		(1 << 0)
+
 struct iov_iter;
 
 struct file_operations {
diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index fc6a2bc311b4..c61b17dc2af8 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -146,7 +146,7 @@ static const struct snd_kcontrol_new cs42l51_snd_controls[] = {
 			0, 0xA0, 96, adc_att_tlv),
 	SOC_DOUBLE_R_SX_TLV("PGA Volume",
 			CS42L51_ALC_PGA_CTL, CS42L51_ALC_PGB_CTL,
-			0, 0x19, 30, pga_tlv),
+			0, 0x1A, 30, pga_tlv),
 	SOC_SINGLE("Playback Deemphasis Switch", CS42L51_DAC_CTL, 3, 1, 0),
 	SOC_SINGLE("Auto-Mute Switch", CS42L51_DAC_CTL, 2, 1, 0),
 	SOC_SINGLE("Soft Ramp Switch", CS42L51_DAC_CTL, 1, 1, 0),
diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index efc5daf53bba..6c794605e33c 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -190,6 +190,25 @@ static int fsl_micfil_reset(struct device *dev)
 		return ret;
 	}
 
+	/*
+	 * SRES is self-cleared bit, but REG_MICFIL_CTRL1 is defined
+	 * as non-volatile register, so SRES still remain in regmap
+	 * cache after set, that every update of REG_MICFIL_CTRL1,
+	 * software reset happens. so clear it explicitly.
+	 */
+	ret = regmap_clear_bits(micfil->regmap, REG_MICFIL_CTRL1,
+				MICFIL_CTRL1_SRES);
+	if (ret)
+		return ret;
+
+	/*
+	 * Set SRES should clear CHnF flags, But even add delay here
+	 * the CHnF may not be cleared sometimes, so clear CHnF explicitly.
+	 */
+	ret = regmap_write_bits(micfil->regmap, REG_MICFIL_STAT, 0xFF, 0xFF);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index 5fdd96e77ef3..daecd386d5ec 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -445,8 +445,15 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
 		return err;
 
 	if (snd_soc_volsw_is_stereo(mc)) {
+		val2 = ucontrol->value.integer.value[1];
+
+		if (mc->platform_max && val2 > mc->platform_max)
+			return -EINVAL;
+		if (val2 > max)
+			return -EINVAL;
+
 		val_mask = mask << rshift;
-		val2 = (ucontrol->value.integer.value[1] + min) & mask;
+		val2 = (val2 + min) & mask;
 		val2 = val2 << rshift;
 
 		err = snd_soc_component_update_bits(component, reg2, val_mask,
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index d38284a3aaf0..13393f0eab25 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -244,7 +244,7 @@ bool bpf_probe_map_type(enum bpf_map_type map_type, __u32 ifindex)
 	case BPF_MAP_TYPE_RINGBUF:
 		key_size = 0;
 		value_size = 0;
-		max_entries = 4096;
+		max_entries = sysconf(_SC_PAGE_SIZE);
 		break;
 	case BPF_MAP_TYPE_UNSPEC:
 	case BPF_MAP_TYPE_HASH:

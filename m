Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C866BE27B
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 09:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjCQIES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 04:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbjCQIER (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 04:04:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285B895BC5;
        Fri, 17 Mar 2023 01:04:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A115E6220B;
        Fri, 17 Mar 2023 08:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8FEC4339C;
        Fri, 17 Mar 2023 08:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679040252;
        bh=7Qxt7bz8TcF93fq5ZZDfvsisNYtywek0aeBj/q25wXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCR8M88AwgWo8Wf5PHleSvditC7eEV00TiQkKPkPUqpZTfiBz3klynjrVU7FJkso8
         +d+r7g1fVdVxTrUcnN18m3ZJ8Ty+DNFp4SLTKqktgo+rRYoQPts/JtJfW8ikMFthcW
         QldqpEVJH1MRgsWnVks+HGMGj8GfBv3u49mSXfCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.278
Date:   Fri, 17 Mar 2023 09:04:02 +0100
Message-Id: <16790402417128@kroah.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <1679040241149209@kroah.com>
References: <1679040241149209@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index e00f4bbcd737..a8104c8024a4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 277
+SUBLEVEL = 278
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/arch/alpha/kernel/module.c b/arch/alpha/kernel/module.c
index 47632fa8c24e..b169dc9a9ac1 100644
--- a/arch/alpha/kernel/module.c
+++ b/arch/alpha/kernel/module.c
@@ -158,10 +158,8 @@ apply_relocate_add(Elf64_Shdr *sechdrs, const char *strtab,
 	base = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr;
 	symtab = (Elf64_Sym *)sechdrs[symindex].sh_addr;
 
-	/* The small sections were sorted to the end of the segment.
-	   The following should definitely cover them.  */
-	gp = (u64)me->core_layout.base + me->core_layout.size - 0x8000;
 	got = sechdrs[me->arch.gotsecindex].sh_addr;
+	gp = got + 0x8000;
 
 	for (i = 0; i < n; i++) {
 		unsigned long r_sym = ELF64_R_SYM (rela[i].r_info);
diff --git a/arch/mips/include/asm/mach-rc32434/pci.h b/arch/mips/include/asm/mach-rc32434/pci.h
index 6f40d1515580..1ff8a987025c 100644
--- a/arch/mips/include/asm/mach-rc32434/pci.h
+++ b/arch/mips/include/asm/mach-rc32434/pci.h
@@ -377,7 +377,7 @@ struct pci_msu {
 				 PCI_CFG04_STAT_SSE | \
 				 PCI_CFG04_STAT_PE)
 
-#define KORINA_CNFG1		((KORINA_STAT<<16)|KORINA_CMD)
+#define KORINA_CNFG1		(KORINA_STAT | KORINA_CMD)
 
 #define KORINA_REVID		0
 #define KORINA_CLASS_CODE	0
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index e017f64e09d6..c8979f8cbce5 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -199,6 +199,15 @@ static void init_amd_k6(struct cpuinfo_x86 *c)
 		return;
 	}
 #endif
+	/*
+	 * Work around Erratum 1386.  The XSAVES instruction malfunctions in
+	 * certain circumstances on Zen1/2 uarch, and not all parts have had
+	 * updated microcode at the time of writing (March 2023).
+	 *
+	 * Affected parts all have no supervisor XSAVE states, meaning that
+	 * the XSAVEC instruction (which works fine) is equivalent.
+	 */
+	clear_cpu_cap(c, X86_FEATURE_XSAVES);
 }
 
 static void init_amd_k7(struct cpuinfo_x86 *c)
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 3b8218dd9bb1..979d130b24c4 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -1083,7 +1083,7 @@ int intel_ring_pin(struct intel_ring *ring,
 	if (unlikely(ret))
 		return ret;
 
-	if (i915_vma_is_map_and_fenceable(vma))
+	if (i915_vma_is_map_and_fenceable(vma) && !HAS_LLC(vma->vm->i915))
 		addr = (void __force *)i915_vma_pin_iomap(vma);
 	else
 		addr = i915_gem_object_pin_map(vma->obj, map);
@@ -1118,7 +1118,7 @@ void intel_ring_unpin(struct intel_ring *ring)
 	/* Discard any unused bytes beyond that submitted to hw. */
 	intel_ring_reset(ring, ring->tail);
 
-	if (i915_vma_is_map_and_fenceable(ring->vma))
+	if (i915_vma_is_map_and_fenceable(ring->vma) && !HAS_LLC(ring->vma->vm->i915))
 		i915_vma_unpin_iomap(ring->vma);
 	else
 		i915_gem_object_unpin_map(ring->vma->obj);
diff --git a/drivers/macintosh/windfarm_lm75_sensor.c b/drivers/macintosh/windfarm_lm75_sensor.c
index f48ad2445ed6..f5b1ac8347db 100644
--- a/drivers/macintosh/windfarm_lm75_sensor.c
+++ b/drivers/macintosh/windfarm_lm75_sensor.c
@@ -35,8 +35,8 @@
 #endif
 
 struct wf_lm75_sensor {
-	int			ds1775 : 1;
-	int			inited : 1;
+	unsigned int		ds1775 : 1;
+	unsigned int		inited : 1;
 	struct i2c_client	*i2c;
 	struct wf_sensor	sens;
 };
diff --git a/drivers/macintosh/windfarm_smu_sensors.c b/drivers/macintosh/windfarm_smu_sensors.c
index 172fd267dcf6..0f4017a8189e 100644
--- a/drivers/macintosh/windfarm_smu_sensors.c
+++ b/drivers/macintosh/windfarm_smu_sensors.c
@@ -275,8 +275,8 @@ struct smu_cpu_power_sensor {
 	struct list_head	link;
 	struct wf_sensor	*volts;
 	struct wf_sensor	*amps;
-	int			fake_volts : 1;
-	int			quadratic : 1;
+	unsigned int		fake_volts : 1;
+	unsigned int		quadratic : 1;
 	struct wf_sensor	sens;
 };
 #define to_smu_cpu_power(c) container_of(c, struct smu_cpu_power_sensor, sens)
diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index aa9c0b7ee7a2..31b26b18e525 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2447,7 +2447,7 @@ static int ov5640_init_controls(struct ov5640_dev *sensor)
 	/* Auto/manual gain */
 	ctrls->auto_gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_AUTOGAIN,
 					     0, 1, 1, 1);
-	ctrls->gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_GAIN,
+	ctrls->gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_ANALOGUE_GAIN,
 					0, 1023, 1, 0);
 
 	ctrls->saturation = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SATURATION,
diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index 7f143387b9ff..64d16b195fc0 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -263,6 +263,9 @@ static void fdp_nci_i2c_read_device_properties(struct device *dev,
 					   len, sizeof(**fw_vsc_cfg),
 					   GFP_KERNEL);
 
+		if (!*fw_vsc_cfg)
+			goto alloc_err;
+
 		r = device_property_read_u8_array(dev, FDP_DP_FW_VSC_CFG_NAME,
 						  *fw_vsc_cfg, len);
 
@@ -276,6 +279,7 @@ static void fdp_nci_i2c_read_device_properties(struct device *dev,
 		*fw_vsc_cfg = NULL;
 	}
 
+alloc_err:
 	dev_dbg(dev, "Clock type: %d, clock frequency: %d, VSC: %s",
 		*clock_type, *clock_freq, *fw_vsc_cfg != NULL ? "yes" : "no");
 }
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index b3d6ea92b4f7..2ffc2e15d822 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -178,6 +178,7 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	scsi_forget_host(shost);
 	mutex_unlock(&shost->scan_mutex);
 	scsi_proc_host_rm(shost);
+	scsi_proc_hostdir_rm(shost->hostt);
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (scsi_host_set_state(shost, SHOST_DEL))
@@ -329,6 +330,7 @@ static void scsi_host_dev_release(struct device *dev)
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
 
+	/* In case scsi_remove_host() has not been called. */
 	scsi_proc_hostdir_rm(shost->hostt);
 
 	/* Wait for functions invoked through call_rcu(&shost->rcu, ...) */
diff --git a/drivers/staging/mt7621-spi/spi-mt7621.c b/drivers/staging/mt7621-spi/spi-mt7621.c
index b73823830e3a..75ed48f60c8c 100644
--- a/drivers/staging/mt7621-spi/spi-mt7621.c
+++ b/drivers/staging/mt7621-spi/spi-mt7621.c
@@ -442,9 +442,11 @@ static int mt7621_spi_probe(struct platform_device *pdev)
 		return PTR_ERR(base);
 
 	clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(clk))
-		return dev_err_probe(&pdev->dev, PTR_ERR(clk),
-				     "unable to get SYS clock\n");
+	if (IS_ERR(clk)) {
+		dev_err(&pdev->dev, "unable to get SYS clock, err=%d\n",
+			status);
+		return PTR_ERR(clk);
+	}
 
 	status = clk_prepare_enable(clk);
 	if (status)
diff --git a/fs/ext4/fsmap.c b/fs/ext4/fsmap.c
index 6f3f245f3a80..6b52ace1463c 100644
--- a/fs/ext4/fsmap.c
+++ b/fs/ext4/fsmap.c
@@ -486,6 +486,8 @@ static int ext4_getfsmap_datadev(struct super_block *sb,
 		keys[0].fmr_physical = bofs;
 	if (keys[1].fmr_physical >= eofs)
 		keys[1].fmr_physical = eofs - 1;
+	if (keys[1].fmr_physical < keys[0].fmr_physical)
+		return 0;
 	start_fsb = keys[0].fmr_physical;
 	end_fsb = keys[1].fmr_physical;
 
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index b1c6b9398eef..07bb69cd2023 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -157,7 +157,6 @@ int ext4_find_inline_data_nolock(struct inode *inode)
 					(void *)ext4_raw_inode(&is.iloc));
 		EXT4_I(inode)->i_inline_size = EXT4_MIN_INLINE_DATA_SIZE +
 				le32_to_cpu(is.s.here->e_value_size);
-		ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 	}
 out:
 	brelse(is.iloc.bh);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3c7bbdaa425a..6e7989b04d2b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4865,8 +4865,13 @@ static inline int ext4_iget_extra_inode(struct inode *inode,
 
 	if (EXT4_INODE_HAS_XATTR_SPACE(inode)  &&
 	    *magic == cpu_to_le32(EXT4_XATTR_MAGIC)) {
+		int err;
+
 		ext4_set_inode_state(inode, EXT4_STATE_XATTR);
-		return ext4_find_inline_data_nolock(inode);
+		err = ext4_find_inline_data_nolock(inode);
+		if (!err && ext4_has_inline_data(inode))
+			ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+		return err;
 	} else
 		EXT4_I(inode)->i_inline_off = 0;
 	return 0;
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index fd0353017d89..b930e8d559d4 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -178,6 +178,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 		ei_bl->i_flags = 0;
 		inode_set_iversion(inode_bl, 1);
 		i_size_write(inode_bl, 0);
+		EXT4_I(inode_bl)->i_disksize = inode_bl->i_size;
 		inode_bl->i_mode = S_IFREG;
 		if (ext4_has_feature_extents(sb)) {
 			ext4_set_inode_flag(inode_bl, EXT4_INODE_EXTENTS);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2c68591102bd..db9bba3473b5 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1419,11 +1419,10 @@ static struct buffer_head *__ext4_find_entry(struct inode *dir,
 		int has_inline_data = 1;
 		ret = ext4_find_inline_entry(dir, fname, res_dir,
 					     &has_inline_data);
-		if (has_inline_data) {
-			if (inlined)
-				*inlined = 1;
+		if (inlined)
+			*inlined = has_inline_data;
+		if (has_inline_data)
 			goto cleanup_and_exit;
-		}
 	}
 
 	if ((namelen <= 2) && (name[0] == '.') &&
@@ -3515,7 +3514,8 @@ static void ext4_resetent(handle_t *handle, struct ext4_renament *ent,
 	 * so the old->de may no longer valid and need to find it again
 	 * before reset old inode info.
 	 */
-	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL);
+	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de,
+				 &old.inlined);
 	if (IS_ERR(old.bh))
 		retval = PTR_ERR(old.bh);
 	if (!old.bh)
@@ -3677,7 +3677,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 			return retval;
 	}
 
-	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL);
+	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de,
+				 &old.inlined);
 	if (IS_ERR(old.bh))
 		return PTR_ERR(old.bh);
 	/*
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 23334cfeac55..2a70b7556e41 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2823,6 +2823,9 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 			(void *)header, total_ino);
 	EXT4_I(inode)->i_extra_isize = new_extra_isize;
 
+	if (ext4_has_inline_data(inode))
+		error = ext4_find_inline_data_nolock(inode);
+
 cleanup:
 	if (error && (mnt_count != le16_to_cpu(sbi->s_es->s_mnt_count))) {
 		ext4_warning(inode->i_sb, "Unable to expand inode %lu. Delete some EAs or run e2fsck.",
diff --git a/fs/file.c b/fs/file.c
index d6ca500a1053..928ba7b8df1e 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -627,6 +627,7 @@ int __close_fd(struct files_struct *files, unsigned fd)
 	fdt = files_fdtable(files);
 	if (fd >= fdt->max_fds)
 		goto out_unlock;
+	fd = array_index_nospec(fd, fdt->max_fds);
 	file = fdt->fd[fd];
 	if (!file)
 		goto out_unlock;
diff --git a/fs/udf/directory.c b/fs/udf/directory.c
index d9523013096f..73720320f0ab 100644
--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -34,7 +34,7 @@ struct fileIdentDesc *udf_fileident_read(struct inode *dir, loff_t *nf_pos,
 	fibh->soffset = fibh->eoffset;
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
-		fi = udf_get_fileident(iinfo->i_ext.i_data -
+		fi = udf_get_fileident(iinfo->i_data -
 				       (iinfo->i_efe ?
 					sizeof(struct extendedFileEntry) :
 					sizeof(struct fileEntry)),
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 88b7fb8e9998..8fff7ffc33a8 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -50,7 +50,7 @@ static void __udf_adinicb_readpage(struct page *page)
 	 * So just sample it once and use the same value everywhere.
 	 */
 	kaddr = kmap_atomic(page);
-	memcpy(kaddr, iinfo->i_ext.i_data + iinfo->i_lenEAttr, isize);
+	memcpy(kaddr, iinfo->i_data + iinfo->i_lenEAttr, isize);
 	memset(kaddr + isize, 0, PAGE_SIZE - isize);
 	flush_dcache_page(page);
 	SetPageUptodate(page);
@@ -76,8 +76,7 @@ static int udf_adinicb_writepage(struct page *page,
 	BUG_ON(!PageLocked(page));
 
 	kaddr = kmap_atomic(page);
-	memcpy(iinfo->i_ext.i_data + iinfo->i_lenEAttr, kaddr,
-		i_size_read(inode));
+	memcpy(iinfo->i_data + iinfo->i_lenEAttr, kaddr, i_size_read(inode));
 	SetPageUptodate(page);
 	kunmap_atomic(kaddr);
 	mark_inode_dirty(inode);
@@ -213,7 +212,7 @@ long udf_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return put_user(UDF_I(inode)->i_lenEAttr, (int __user *)arg);
 	case UDF_GETEABLOCK:
 		return copy_to_user((char __user *)arg,
-				    UDF_I(inode)->i_ext.i_data,
+				    UDF_I(inode)->i_data,
 				    UDF_I(inode)->i_lenEAttr) ? -EFAULT : 0;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
index f8e5872f7cc2..cdaa86e077b2 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -67,16 +67,16 @@ struct inode *udf_new_inode(struct inode *dir, umode_t mode)
 		iinfo->i_efe = 1;
 		if (UDF_VERS_USE_EXTENDED_FE > sbi->s_udfrev)
 			sbi->s_udfrev = UDF_VERS_USE_EXTENDED_FE;
-		iinfo->i_ext.i_data = kzalloc(inode->i_sb->s_blocksize -
-					    sizeof(struct extendedFileEntry),
-					    GFP_KERNEL);
+		iinfo->i_data = kzalloc(inode->i_sb->s_blocksize -
+					sizeof(struct extendedFileEntry),
+					GFP_KERNEL);
 	} else {
 		iinfo->i_efe = 0;
-		iinfo->i_ext.i_data = kzalloc(inode->i_sb->s_blocksize -
-					    sizeof(struct fileEntry),
-					    GFP_KERNEL);
+		iinfo->i_data = kzalloc(inode->i_sb->s_blocksize -
+					sizeof(struct fileEntry),
+					GFP_KERNEL);
 	}
-	if (!iinfo->i_ext.i_data) {
+	if (!iinfo->i_data) {
 		iput(inode);
 		return ERR_PTR(-ENOMEM);
 	}
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index af1180104e56..77421e65623a 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -150,8 +150,8 @@ void udf_evict_inode(struct inode *inode)
 	truncate_inode_pages_final(&inode->i_data);
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
-	kfree(iinfo->i_ext.i_data);
-	iinfo->i_ext.i_data = NULL;
+	kfree(iinfo->i_data);
+	iinfo->i_data = NULL;
 	udf_clear_extent_cache(inode);
 	if (want_delete) {
 		udf_free_inode(inode);
@@ -278,14 +278,14 @@ int udf_expand_file_adinicb(struct inode *inode)
 		kaddr = kmap_atomic(page);
 		memset(kaddr + iinfo->i_lenAlloc, 0x00,
 		       PAGE_SIZE - iinfo->i_lenAlloc);
-		memcpy(kaddr, iinfo->i_ext.i_data + iinfo->i_lenEAttr,
+		memcpy(kaddr, iinfo->i_data + iinfo->i_lenEAttr,
 			iinfo->i_lenAlloc);
 		flush_dcache_page(page);
 		SetPageUptodate(page);
 		kunmap_atomic(kaddr);
 	}
 	down_write(&iinfo->i_data_sem);
-	memset(iinfo->i_ext.i_data + iinfo->i_lenEAttr, 0x00,
+	memset(iinfo->i_data + iinfo->i_lenEAttr, 0x00,
 	       iinfo->i_lenAlloc);
 	iinfo->i_lenAlloc = 0;
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
@@ -303,8 +303,7 @@ int udf_expand_file_adinicb(struct inode *inode)
 		lock_page(page);
 		down_write(&iinfo->i_data_sem);
 		kaddr = kmap_atomic(page);
-		memcpy(iinfo->i_ext.i_data + iinfo->i_lenEAttr, kaddr,
-		       inode->i_size);
+		memcpy(iinfo->i_data + iinfo->i_lenEAttr, kaddr, inode->i_size);
 		kunmap_atomic(kaddr);
 		unlock_page(page);
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
@@ -392,8 +391,7 @@ struct buffer_head *udf_expand_dir_adinicb(struct inode *inode,
 	}
 	mark_buffer_dirty_inode(dbh, inode);
 
-	memset(iinfo->i_ext.i_data + iinfo->i_lenEAttr, 0,
-		iinfo->i_lenAlloc);
+	memset(iinfo->i_data + iinfo->i_lenEAttr, 0, iinfo->i_lenAlloc);
 	iinfo->i_lenAlloc = 0;
 	eloc.logicalBlockNum = *block;
 	eloc.partitionReferenceNum =
@@ -1241,7 +1239,7 @@ int udf_setsize(struct inode *inode, loff_t newsize)
 		if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 			down_write(&iinfo->i_data_sem);
 			udf_clear_extent_cache(inode);
-			memset(iinfo->i_ext.i_data + iinfo->i_lenEAttr + newsize,
+			memset(iinfo->i_data + iinfo->i_lenEAttr + newsize,
 			       0x00, bsize - newsize -
 			       udf_file_entry_alloc_offset(inode));
 			iinfo->i_lenAlloc = newsize;
@@ -1377,6 +1375,7 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 		ret = -EIO;
 		goto out;
 	}
+	iinfo->i_hidden = hidden_inode;
 	iinfo->i_unique = 0;
 	iinfo->i_lenEAttr = 0;
 	iinfo->i_lenExtents = 0;
@@ -1390,7 +1389,7 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 					sizeof(struct extendedFileEntry));
 		if (ret)
 			goto out;
-		memcpy(iinfo->i_ext.i_data,
+		memcpy(iinfo->i_data,
 		       bh->b_data + sizeof(struct extendedFileEntry),
 		       bs - sizeof(struct extendedFileEntry));
 	} else if (fe->descTag.tagIdent == cpu_to_le16(TAG_IDENT_FE)) {
@@ -1399,7 +1398,7 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 		ret = udf_alloc_i_data(inode, bs - sizeof(struct fileEntry));
 		if (ret)
 			goto out;
-		memcpy(iinfo->i_ext.i_data,
+		memcpy(iinfo->i_data,
 		       bh->b_data + sizeof(struct fileEntry),
 		       bs - sizeof(struct fileEntry));
 	} else if (fe->descTag.tagIdent == cpu_to_le16(TAG_IDENT_USE)) {
@@ -1412,7 +1411,7 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 					sizeof(struct unallocSpaceEntry));
 		if (ret)
 			goto out;
-		memcpy(iinfo->i_ext.i_data,
+		memcpy(iinfo->i_data,
 		       bh->b_data + sizeof(struct unallocSpaceEntry),
 		       bs - sizeof(struct unallocSpaceEntry));
 		return 0;
@@ -1470,6 +1469,8 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 		iinfo->i_lenEAttr = le32_to_cpu(fe->lengthExtendedAttr);
 		iinfo->i_lenAlloc = le32_to_cpu(fe->lengthAllocDescs);
 		iinfo->i_checkpoint = le32_to_cpu(fe->checkpoint);
+		iinfo->i_streamdir = 0;
+		iinfo->i_lenStreams = 0;
 	} else {
 		inode->i_blocks = le64_to_cpu(efe->logicalBlocksRecorded) <<
 		    (inode->i_sb->s_blocksize_bits - 9);
@@ -1483,6 +1484,16 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 		iinfo->i_lenEAttr = le32_to_cpu(efe->lengthExtendedAttr);
 		iinfo->i_lenAlloc = le32_to_cpu(efe->lengthAllocDescs);
 		iinfo->i_checkpoint = le32_to_cpu(efe->checkpoint);
+
+		/* Named streams */
+		iinfo->i_streamdir = (efe->streamDirectoryICB.extLength != 0);
+		iinfo->i_locStreamdir =
+			lelb_to_cpu(efe->streamDirectoryICB.extLocation);
+		iinfo->i_lenStreams = le64_to_cpu(efe->objectSize);
+		if (iinfo->i_lenStreams >= inode->i_size)
+			iinfo->i_lenStreams -= inode->i_size;
+		else
+			iinfo->i_lenStreams = 0;
 	}
 	inode->i_generation = iinfo->i_unique;
 
@@ -1579,8 +1590,8 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 static int udf_alloc_i_data(struct inode *inode, size_t size)
 {
 	struct udf_inode_info *iinfo = UDF_I(inode);
-	iinfo->i_ext.i_data = kmalloc(size, GFP_KERNEL);
-	if (!iinfo->i_ext.i_data)
+	iinfo->i_data = kmalloc(size, GFP_KERNEL);
+	if (!iinfo->i_data)
 		return -ENOMEM;
 	return 0;
 }
@@ -1654,7 +1665,7 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 
 		use->lengthAllocDescs = cpu_to_le32(iinfo->i_lenAlloc);
 		memcpy(bh->b_data + sizeof(struct unallocSpaceEntry),
-		       iinfo->i_ext.i_data, inode->i_sb->s_blocksize -
+		       iinfo->i_data, inode->i_sb->s_blocksize -
 					sizeof(struct unallocSpaceEntry));
 		use->descTag.tagIdent = cpu_to_le16(TAG_IDENT_USE);
 		crclen = sizeof(struct unallocSpaceEntry);
@@ -1684,8 +1695,12 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 
 	if (S_ISDIR(inode->i_mode) && inode->i_nlink > 0)
 		fe->fileLinkCount = cpu_to_le16(inode->i_nlink - 1);
-	else
-		fe->fileLinkCount = cpu_to_le16(inode->i_nlink);
+	else {
+		if (iinfo->i_hidden)
+			fe->fileLinkCount = cpu_to_le16(0);
+		else
+			fe->fileLinkCount = cpu_to_le16(inode->i_nlink);
+	}
 
 	fe->informationLength = cpu_to_le64(inode->i_size);
 
@@ -1723,7 +1738,7 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 
 	if (iinfo->i_efe == 0) {
 		memcpy(bh->b_data + sizeof(struct fileEntry),
-		       iinfo->i_ext.i_data,
+		       iinfo->i_data,
 		       inode->i_sb->s_blocksize - sizeof(struct fileEntry));
 		fe->logicalBlocksRecorded = cpu_to_le64(lb_recorded);
 
@@ -1742,12 +1757,22 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 		crclen = sizeof(struct fileEntry);
 	} else {
 		memcpy(bh->b_data + sizeof(struct extendedFileEntry),
-		       iinfo->i_ext.i_data,
+		       iinfo->i_data,
 		       inode->i_sb->s_blocksize -
 					sizeof(struct extendedFileEntry));
-		efe->objectSize = cpu_to_le64(inode->i_size);
+		efe->objectSize =
+			cpu_to_le64(inode->i_size + iinfo->i_lenStreams);
 		efe->logicalBlocksRecorded = cpu_to_le64(lb_recorded);
 
+		if (iinfo->i_streamdir) {
+			struct long_ad *icb_lad = &efe->streamDirectoryICB;
+
+			icb_lad->extLocation =
+				cpu_to_lelb(iinfo->i_locStreamdir);
+			icb_lad->extLength =
+				cpu_to_le32(inode->i_sb->s_blocksize);
+		}
+
 		udf_adjust_time(iinfo, inode->i_atime);
 		udf_adjust_time(iinfo, inode->i_mtime);
 		udf_adjust_time(iinfo, inode->i_ctime);
@@ -1846,8 +1871,13 @@ struct inode *__udf_iget(struct super_block *sb, struct kernel_lb_addr *ino,
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
-	if (!(inode->i_state & I_NEW))
+	if (!(inode->i_state & I_NEW)) {
+		if (UDF_I(inode)->i_hidden != hidden_inode) {
+			iput(inode);
+			return ERR_PTR(-EFSCORRUPTED);
+		}
 		return inode;
+	}
 
 	memcpy(&UDF_I(inode)->i_location, ino, sizeof(struct kernel_lb_addr));
 	err = udf_read_inode(inode, hidden_inode);
@@ -2028,7 +2058,7 @@ void udf_write_aext(struct inode *inode, struct extent_position *epos,
 	struct udf_inode_info *iinfo = UDF_I(inode);
 
 	if (!epos->bh)
-		ptr = iinfo->i_ext.i_data + epos->offset -
+		ptr = iinfo->i_data + epos->offset -
 			udf_file_entry_alloc_offset(inode) +
 			iinfo->i_lenEAttr;
 	else
@@ -2120,7 +2150,7 @@ int8_t udf_current_aext(struct inode *inode, struct extent_position *epos,
 	if (!epos->bh) {
 		if (!epos->offset)
 			epos->offset = udf_file_entry_alloc_offset(inode);
-		ptr = iinfo->i_ext.i_data + epos->offset -
+		ptr = iinfo->i_data + epos->offset -
 			udf_file_entry_alloc_offset(inode) +
 			iinfo->i_lenEAttr;
 		alen = udf_file_entry_alloc_offset(inode) +
diff --git a/fs/udf/misc.c b/fs/udf/misc.c
index 853bcff51043..1614d308d0f0 100644
--- a/fs/udf/misc.c
+++ b/fs/udf/misc.c
@@ -52,9 +52,9 @@ struct genericFormat *udf_add_extendedattr(struct inode *inode, uint32_t size,
 	uint16_t crclen;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 
-	ea = iinfo->i_ext.i_data;
+	ea = iinfo->i_data;
 	if (iinfo->i_lenEAttr) {
-		ad = iinfo->i_ext.i_data + iinfo->i_lenEAttr;
+		ad = iinfo->i_data + iinfo->i_lenEAttr;
 	} else {
 		ad = ea;
 		size += sizeof(struct extendedAttrHeaderDesc);
@@ -153,7 +153,7 @@ struct genericFormat *udf_get_extendedattr(struct inode *inode, uint32_t type,
 	uint32_t offset;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 
-	ea = iinfo->i_ext.i_data;
+	ea = iinfo->i_data;
 
 	if (iinfo->i_lenEAttr) {
 		struct extendedAttrHeaderDesc *eahd;
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index ef251622da13..05dd1f45ba90 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -478,8 +478,7 @@ static struct fileIdentDesc *udf_add_entry(struct inode *dir,
 		if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 			block = dinfo->i_location.logicalBlockNum;
 			fi = (struct fileIdentDesc *)
-					(dinfo->i_ext.i_data +
-					 fibh->soffset -
+					(dinfo->i_data + fibh->soffset -
 					 udf_ext0_offset(dir) +
 					 dinfo->i_lenEAttr);
 		} else {
@@ -962,7 +961,7 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
 		mark_buffer_dirty_inode(epos.bh, inode);
 		ea = epos.bh->b_data + udf_ext0_offset(inode);
 	} else
-		ea = iinfo->i_ext.i_data + iinfo->i_lenEAttr;
+		ea = iinfo->i_data + iinfo->i_lenEAttr;
 
 	eoffset = sb->s_blocksize - udf_ext0_offset(inode);
 	pc = (struct pathComponent *)ea;
@@ -1142,7 +1141,7 @@ static int udf_rename(struct inode *old_dir, struct dentry *old_dentry,
 		retval = -EIO;
 		if (old_iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 			dir_fi = udf_get_fileident(
-					old_iinfo->i_ext.i_data -
+					old_iinfo->i_data -
 					  (old_iinfo->i_efe ?
 					   sizeof(struct extendedFileEntry) :
 					   sizeof(struct fileEntry)),
diff --git a/fs/udf/partition.c b/fs/udf/partition.c
index 090baff83990..4cbf40575965 100644
--- a/fs/udf/partition.c
+++ b/fs/udf/partition.c
@@ -65,7 +65,7 @@ uint32_t udf_get_pblock_virt15(struct super_block *sb, uint32_t block,
 	}
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
-		loc = le32_to_cpu(((__le32 *)(iinfo->i_ext.i_data +
+		loc = le32_to_cpu(((__le32 *)(iinfo->i_data +
 			vdata->s_start_offset))[block]);
 		goto translate;
 	}
diff --git a/fs/udf/super.c b/fs/udf/super.c
index b7fb7cd35d89..bce48a07790c 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -146,9 +146,12 @@ static struct inode *udf_alloc_inode(struct super_block *sb)
 
 	ei->i_unique = 0;
 	ei->i_lenExtents = 0;
+	ei->i_lenStreams = 0;
 	ei->i_next_alloc_block = 0;
 	ei->i_next_alloc_goal = 0;
 	ei->i_strat4096 = 0;
+	ei->i_streamdir = 0;
+	ei->i_hidden = 0;
 	init_rwsem(&ei->i_data_sem);
 	ei->cached_extent.lstart = -1;
 	spin_lock_init(&ei->i_extent_cache_lock);
@@ -172,7 +175,7 @@ static void init_once(void *foo)
 {
 	struct udf_inode_info *ei = (struct udf_inode_info *)foo;
 
-	ei->i_ext.i_data = NULL;
+	ei->i_data = NULL;
 	inode_init_once(&ei->vfs_inode);
 }
 
@@ -572,6 +575,11 @@ static int udf_parse_options(char *options, struct udf_options *uopt,
 			if (!remount) {
 				if (uopt->nls_map)
 					unload_nls(uopt->nls_map);
+				/*
+				 * load_nls() failure is handled later in
+				 * udf_fill_super() after all options are
+				 * parsed.
+				 */
 				uopt->nls_map = load_nls(args[0].from);
 				uopt->flags |= (1 << UDF_FLAG_NLS_MAP);
 			}
@@ -1200,7 +1208,7 @@ static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
 			vat20 = (struct virtualAllocationTable20 *)bh->b_data;
 		} else {
 			vat20 = (struct virtualAllocationTable20 *)
-							vati->i_ext.i_data;
+							vati->i_data;
 		}
 
 		map->s_type_specific.s_virtual.s_start_offset =
diff --git a/fs/udf/symlink.c b/fs/udf/symlink.c
index 6023c97c6da2..aef3e4d9014d 100644
--- a/fs/udf/symlink.c
+++ b/fs/udf/symlink.c
@@ -122,7 +122,7 @@ static int udf_symlink_filler(struct file *file, struct page *page)
 
 	down_read(&iinfo->i_data_sem);
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
-		symlink = iinfo->i_ext.i_data + iinfo->i_lenEAttr;
+		symlink = iinfo->i_data + iinfo->i_lenEAttr;
 	} else {
 		bh = sb_bread(inode->i_sb, pos);
 
diff --git a/fs/udf/udf_i.h b/fs/udf/udf_i.h
index 2ef0e212f08a..b77bf713a1b6 100644
--- a/fs/udf/udf_i.h
+++ b/fs/udf/udf_i.h
@@ -42,12 +42,12 @@ struct udf_inode_info {
 	unsigned		i_efe : 1;	/* extendedFileEntry */
 	unsigned		i_use : 1;	/* unallocSpaceEntry */
 	unsigned		i_strat4096 : 1;
-	unsigned		reserved : 26;
-	union {
-		struct short_ad	*i_sad;
-		struct long_ad		*i_lad;
-		__u8		*i_data;
-	} i_ext;
+	unsigned		i_streamdir : 1;
+	unsigned		i_hidden : 1;	/* hidden system inode */
+	unsigned		reserved : 24;
+	__u8			*i_data;
+	struct kernel_lb_addr	i_locStreamdir;
+	__u64			i_lenStreams;
 	struct rw_semaphore	i_data_sem;
 	struct udf_ext_cache cached_extent;
 	/* Spinlock for protecting extent cache */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 1658e9f8d803..78c1cd4dfdc0 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3097,6 +3097,8 @@
 
 #define PCI_VENDOR_ID_3COM_2		0xa727
 
+#define PCI_VENDOR_ID_SOLIDRUN		0xd063
+
 #define PCI_VENDOR_ID_DIGIUM		0xd161
 #define PCI_DEVICE_ID_DIGIUM_HFC4S	0xb410
 
diff --git a/net/caif/caif_usb.c b/net/caif/caif_usb.c
index 76d49a1bc6f6..609c5793f45a 100644
--- a/net/caif/caif_usb.c
+++ b/net/caif/caif_usb.c
@@ -135,6 +135,9 @@ static int cfusbl_device_notify(struct notifier_block *me, unsigned long what,
 	struct usb_device *usbdev;
 	int res;
 
+	if (what == NETDEV_UNREGISTER && dev->reg_state >= NETREG_UNREGISTERED)
+		return 0;
+
 	/* Check whether we have a NCM device, and find its VID/PID. */
 	if (!(dev->dev.parent && dev->dev.parent->driver &&
 	      strcmp(dev->dev.parent->driver->name, "cdc_ncm") == 0))
diff --git a/net/ipv6/ila/ila_xlat.c b/net/ipv6/ila/ila_xlat.c
index 7858fa9ea103..87744eb8d0c4 100644
--- a/net/ipv6/ila/ila_xlat.c
+++ b/net/ipv6/ila/ila_xlat.c
@@ -480,6 +480,7 @@ int ila_xlat_nl_cmd_get_mapping(struct sk_buff *skb, struct genl_info *info)
 
 	rcu_read_lock();
 
+	ret = -ESRCH;
 	ila = ila_lookup_by_params(&xp, ilan);
 	if (ila) {
 		ret = ila_dump_info(ila,
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 2c5443ce449c..f705800b2248 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1464,8 +1464,8 @@ static int nfc_se_io(struct nfc_dev *dev, u32 se_idx,
 	return rc;
 
 error:
-	kfree(cb_context);
 	device_unlock(&dev->dev);
+	kfree(cb_context);
 	return rc;
 }
 
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 8266452c143b..c83eaa718369 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -388,7 +388,7 @@ static int tipc_sk_sock_err(struct socket *sock, long *timeout)
 		rc_ = tipc_sk_sock_err((sock_), timeo_);		       \
 		if (rc_)						       \
 			break;						       \
-		prepare_to_wait(sk_sleep(sk_), &wait_, TASK_INTERRUPTIBLE);    \
+		add_wait_queue(sk_sleep(sk_), &wait_);                         \
 		release_sock(sk_);					       \
 		*(timeo_) = wait_woken(&wait_, TASK_INTERRUPTIBLE, *(timeo_)); \
 		sched_annotate_sleep();				               \
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 64fac0ad32d6..97f59fa3e0ed 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -541,7 +541,9 @@ targets += $(call intermediate_targets, .asn1.o, .asn1.c .asn1.h) \
 
 PHONY += $(subdir-ym)
 $(subdir-ym):
-	$(Q)$(MAKE) $(build)=$@ need-builtin=$(if $(findstring $@,$(subdir-obj-y)),1)
+	$(Q)$(MAKE) $(build)=$@ \
+	need-builtin=$(if $(filter $@/built-in.a, $(subdir-obj-y)),1) \
+	need-modorder=$(if $(need-modorder),$(if $(filter $@/modules.order, $(modorder)),1))
 
 # Add FORCE to the prequisites of a target to force it to be always rebuilt.
 # ---------------------------------------------------------------------------

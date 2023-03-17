Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5406BE278
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 09:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbjCQIEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 04:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjCQIEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 04:04:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1381C5A9;
        Fri, 17 Mar 2023 01:04:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10F3CB824AC;
        Fri, 17 Mar 2023 08:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59290C433EF;
        Fri, 17 Mar 2023 08:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679040244;
        bh=bpancMFI9jqGBu3J3laiY8yCUXsGZsT4Ho96sxY5cUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HhEz68jDu8tV7QQSJjicgdKZO5zfjM79WVVCJqRitnj7R4itdsTTf2XalFXBS4XwK
         yFH0UG/8Ypc78weIhQ/V7XebHfrzrGuQXSCkVmu75XtMgznEbfPAAJwhhcsDLxUO90
         EggrPmWmVsjtPlinoq5E7WEz4I4OXbIoYXVwNObM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.310
Date:   Fri, 17 Mar 2023 09:03:57 +0100
Message-Id: <167904023662216@kroah.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <1679040236109254@kroah.com>
References: <1679040236109254@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 608adcd3f063..edd89ca6f956 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 309
+SUBLEVEL = 310
 EXTRAVERSION =
 NAME = Petit Gorille
 
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
index ee5d0f943ec8..e0c9ede0196a 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -197,6 +197,15 @@ static void init_amd_k6(struct cpuinfo_x86 *c)
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
@@ -941,7 +950,7 @@ static void init_amd(struct cpuinfo_x86 *c)
 		 * serializing.
 		 */
 		ret = rdmsrl_safe(MSR_AMD64_DE_CFG, &val);
-		if (!ret && (val & MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT)) {
+		if (!ret && (val & MSR_AMD64_DE_CFG_LFENCE_SERIALIZE)) {
 			/* A serializing LFENCE stops RDTSC speculation */
 			set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
 		} else {
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 63667a5c2c87..6c7563c1ab5f 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -1314,7 +1314,7 @@ int intel_ring_pin(struct intel_ring *ring,
 	if (unlikely(ret))
 		return ret;
 
-	if (i915_vma_is_map_and_fenceable(vma))
+	if (i915_vma_is_map_and_fenceable(vma) && !HAS_LLC(vma->vm->i915))
 		addr = (void __force *)i915_vma_pin_iomap(vma);
 	else
 		addr = i915_gem_object_pin_map(vma->obj, map);
@@ -1346,7 +1346,7 @@ void intel_ring_unpin(struct intel_ring *ring)
 	/* Discard any unused bytes beyond that submitted to hw. */
 	intel_ring_reset(ring, ring->tail);
 
-	if (i915_vma_is_map_and_fenceable(ring->vma))
+	if (i915_vma_is_map_and_fenceable(ring->vma) && !HAS_LLC(ring->vma->vm->i915))
 		i915_vma_unpin_iomap(ring->vma);
 	else
 		i915_gem_object_unpin_map(ring->vma->obj);
diff --git a/drivers/macintosh/windfarm_lm75_sensor.c b/drivers/macintosh/windfarm_lm75_sensor.c
index 6cdfe714901d..1332fc789056 100644
--- a/drivers/macintosh/windfarm_lm75_sensor.c
+++ b/drivers/macintosh/windfarm_lm75_sensor.c
@@ -34,8 +34,8 @@
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
index eb0331b8a583..b78e35425d14 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2002,7 +2002,7 @@ static int ov5640_init_controls(struct ov5640_dev *sensor)
 	/* Auto/manual gain */
 	ctrls->auto_gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_AUTOGAIN,
 					     0, 1, 1, 1);
-	ctrls->gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_GAIN,
+	ctrls->gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_ANALOGUE_GAIN,
 					0, 1023, 1, 0);
 
 	ctrls->saturation = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SATURATION,
diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index 4020c11a9415..3c543981ea18 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -263,6 +263,9 @@ static void fdp_nci_i2c_read_device_properties(struct device *dev,
 					   len * sizeof(**fw_vsc_cfg),
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
diff --git a/fs/ext4/fsmap.c b/fs/ext4/fsmap.c
index 1a4d42a1b161..f1ad06e688ef 100644
--- a/fs/ext4/fsmap.c
+++ b/fs/ext4/fsmap.c
@@ -499,6 +499,8 @@ static int ext4_getfsmap_datadev(struct super_block *sb,
 		keys[0].fmr_physical = bofs;
 	if (keys[1].fmr_physical >= eofs)
 		keys[1].fmr_physical = eofs - 1;
+	if (keys[1].fmr_physical < keys[0].fmr_physical)
+		return 0;
 	start_fsb = keys[0].fmr_physical;
 	end_fsb = keys[1].fmr_physical;
 
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index d2ee281723cf..1569fce14321 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -163,7 +163,6 @@ int ext4_find_inline_data_nolock(struct inode *inode)
 					(void *)ext4_raw_inode(&is.iloc));
 		EXT4_I(inode)->i_inline_size = EXT4_MIN_INLINE_DATA_SIZE +
 				le32_to_cpu(is.s.here->e_value_size);
-		ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 	}
 out:
 	brelse(is.iloc.bh);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f1eea54eb83c..9d6d3cb51514 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4752,8 +4752,13 @@ static inline int ext4_iget_extra_inode(struct inode *inode,
 
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
index fb49413e7734..105756d6d6e3 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -150,6 +150,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 		ei_bl->i_flags = 0;
 		inode_bl->i_version = 1;
 		i_size_write(inode_bl, 0);
+		EXT4_I(inode_bl)->i_disksize = inode_bl->i_size;
 		inode_bl->i_mode = S_IFREG;
 		if (ext4_has_feature_extents(sb)) {
 			ext4_set_inode_flag(inode_bl, EXT4_INODE_EXTENTS);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 461c080181d6..57c78a7a7425 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1425,11 +1425,10 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 		int has_inline_data = 1;
 		ret = ext4_find_inline_entry(dir, &fname, res_dir,
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
@@ -3520,7 +3519,8 @@ static void ext4_resetent(handle_t *handle, struct ext4_renament *ent,
 	 * so the old->de may no longer valid and need to find it again
 	 * before reset old inode info.
 	 */
-	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL);
+	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de,
+				 &old.inlined);
 	if (IS_ERR(old.bh))
 		retval = PTR_ERR(old.bh);
 	if (!old.bh)
@@ -3688,7 +3688,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 			return retval;
 	}
 
-	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de, NULL);
+	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de,
+				 &old.inlined);
 	if (IS_ERR(old.bh))
 		return PTR_ERR(old.bh);
 	/*
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index d18901690319..e1b40bd2f4cf 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2809,6 +2809,9 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 			(void *)header, total_ino);
 	EXT4_I(inode)->i_extra_isize = new_extra_isize;
 
+	if (ext4_has_inline_data(inode))
+		error = ext4_find_inline_data_nolock(inode);
+
 cleanup:
 	if (error && (mnt_count != le16_to_cpu(sbi->s_es->s_mnt_count))) {
 		ext4_warning(inode->i_sb, "Unable to expand inode %lu. Delete some EAs or run e2fsck.",
diff --git a/fs/file.c b/fs/file.c
index 5e79aa9f5d73..eac95f11003a 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -629,6 +629,7 @@ int __close_fd(struct files_struct *files, unsigned fd)
 	fdt = files_fdtable(files);
 	if (fd >= fdt->max_fds)
 		goto out_unlock;
+	fd = array_index_nospec(fd, fdt->max_fds);
 	file = fdt->fd[fd];
 	if (!file)
 		goto out_unlock;
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index d4eae72202fa..0122286beda5 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3045,6 +3045,8 @@
 
 #define PCI_VENDOR_ID_3COM_2		0xa727
 
+#define PCI_VENDOR_ID_SOLIDRUN		0xd063
+
 #define PCI_VENDOR_ID_DIGIUM		0xd161
 #define PCI_DEVICE_ID_DIGIUM_HFC4S	0xb410
 
diff --git a/net/caif/caif_usb.c b/net/caif/caif_usb.c
index 485dde566c1a..98c0548c6f94 100644
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
index 3123b9de91b5..9dd76af884f1 100644
--- a/net/ipv6/ila/ila_xlat.c
+++ b/net/ipv6/ila/ila_xlat.c
@@ -442,6 +442,7 @@ static int ila_nl_cmd_get_mapping(struct sk_buff *skb, struct genl_info *info)
 
 	rcu_read_lock();
 
+	ret = -ESRCH;
 	ila = ila_lookup_by_params(&xp, ilan);
 	if (ila) {
 		ret = ila_dump_info(ila,
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 9898b6a27fef..64b866ed601b 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1454,8 +1454,8 @@ static int nfc_se_io(struct nfc_dev *dev, u32 se_idx,
 	return rc;
 
 error:
-	kfree(cb_context);
 	device_unlock(&dev->dev);
+	kfree(cb_context);
 	return rc;
 }
 
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 40002d2afb8a..5d9d9d693da0 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -373,7 +373,7 @@ static int tipc_sk_sock_err(struct socket *sock, long *timeout)
 		rc_ = tipc_sk_sock_err((sock_), timeo_);		       \
 		if (rc_)						       \
 			break;						       \
-		prepare_to_wait(sk_sleep(sk_), &wait_, TASK_INTERRUPTIBLE);    \
+		add_wait_queue(sk_sleep(sk_), &wait_);                         \
 		release_sock(sk_);					       \
 		*(timeo_) = wait_woken(&wait_, TASK_INTERRUPTIBLE, *(timeo_)); \
 		sched_annotate_sleep();				               \

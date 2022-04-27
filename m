Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216CF511740
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 14:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbiD0LsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 07:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233004AbiD0LsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 07:48:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996A248301;
        Wed, 27 Apr 2022 04:44:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3997B82661;
        Wed, 27 Apr 2022 11:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18277C385A7;
        Wed, 27 Apr 2022 11:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651059887;
        bh=l0pjAETlp4jt8IhtU+zA7M6qG0tdgkCrmc/cQQGeMSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zNRwGq3RXlpH/Yeduk8CEGtKd5QVwzjOWSziRWFHhEzd8T0UZsv3Zbqt0Pq74nslx
         wMlgdv9eeRot/1AqLy9Gf8nYqbIUoX9UfeWywlnlc6ZKTAL00REz7eYL6sfq/bILE9
         kAdI4uQHVakwpSqwvJXwzEIpNSVQIWVhI7N0blsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.277
Date:   Wed, 27 Apr 2022 13:44:36 +0200
Message-Id: <165105987517041@kroah.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <165105987520949@kroah.com>
References: <165105987520949@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index ce295ec15975..ef5240c915f4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 276
+SUBLEVEL = 277
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index 37ad245cf989..fb458623f386 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -191,6 +191,7 @@ tracesys_exit:
 	st  r0, [sp, PT_r0]     ; sys call return value in pt_regs
 
 	;POST Sys Call Ptrace Hook
+	mov r0, sp		; pt_regs needed
 	bl  @syscall_trace_exit
 	b   ret_from_exception ; NOT ret_from_system_call at is saves r0 which
 	; we'd done before calling post hook above
diff --git a/arch/arm/mach-vexpress/spc.c b/arch/arm/mach-vexpress/spc.c
index 635b0d549487..c16f39614003 100644
--- a/arch/arm/mach-vexpress/spc.c
+++ b/arch/arm/mach-vexpress/spc.c
@@ -584,7 +584,7 @@ static int __init ve_spc_clk_init(void)
 		}
 
 		cluster = topology_physical_package_id(cpu_dev->id);
-		if (init_opp_table[cluster])
+		if (cluster < 0 || init_opp_table[cluster])
 			continue;
 
 		if (ve_init_opp_table(cpu_dev))
diff --git a/arch/powerpc/perf/power9-pmu.c b/arch/powerpc/perf/power9-pmu.c
index efb19b089023..75d3a10e20fe 100644
--- a/arch/powerpc/perf/power9-pmu.c
+++ b/arch/powerpc/perf/power9-pmu.c
@@ -107,11 +107,11 @@ extern struct attribute_group isa207_pmu_format_group;
 
 /* Table of alternatives, sorted by column 0 */
 static const unsigned int power9_event_alternatives[][MAX_ALT] = {
-	{ PM_INST_DISP,			PM_INST_DISP_ALT },
-	{ PM_RUN_CYC_ALT,		PM_RUN_CYC },
-	{ PM_RUN_INST_CMPL_ALT,		PM_RUN_INST_CMPL },
-	{ PM_LD_MISS_L1,		PM_LD_MISS_L1_ALT },
 	{ PM_BR_2PATH,			PM_BR_2PATH_ALT },
+	{ PM_INST_DISP,			PM_INST_DISP_ALT },
+	{ PM_RUN_CYC_ALT,               PM_RUN_CYC },
+	{ PM_LD_MISS_L1,                PM_LD_MISS_L1_ALT },
+	{ PM_RUN_INST_CMPL_ALT,         PM_RUN_INST_CMPL },
 };
 
 static int power9_get_alternatives(u64 event, unsigned int flags, u64 alt[])
diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index 2cbd75dd2fd3..ea142936bf11 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -57,15 +57,13 @@ struct compat_timeval {
 };
 
 struct compat_stat {
-	compat_dev_t	st_dev;
-	u16		__pad1;
+	u32		st_dev;
 	compat_ino_t	st_ino;
 	compat_mode_t	st_mode;
 	compat_nlink_t	st_nlink;
 	__compat_uid_t	st_uid;
 	__compat_gid_t	st_gid;
-	compat_dev_t	st_rdev;
-	u16		__pad2;
+	u32		st_rdev;
 	u32		st_size;
 	u32		st_blksize;
 	u32		st_blocks;
diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index 6490b2759bcb..9ef62d42ba5b 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -391,7 +391,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		return 0;
 	case BLKGETSIZE:
 		size = i_size_read(bdev->bd_inode);
-		if ((size >> 9) > ~0UL)
+		if ((size >> 9) > ~(compat_ulong_t)0)
 			return -EFBIG;
 		return compat_put_ulong(arg, size >> 9);
 
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index ff468a6fd8dd..677f582cf3d6 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -82,6 +82,8 @@ static int marvell_cable_detect(struct ata_port *ap)
 	switch(ap->port_no)
 	{
 	case 0:
+		if (!ap->ioaddr.bmdma_addr)
+			return ATA_CBL_PATA_UNK;
 		if (ioread8(ap->ioaddr.bmdma_addr + 1) & 1)
 			return ATA_CBL_PATA40;
 		return ATA_CBL_PATA80;
diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index 5b182061da22..2af0e151b31b 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1390,7 +1390,7 @@ at_xdmac_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
 {
 	struct at_xdmac_chan	*atchan = to_at_xdmac_chan(chan);
 	struct at_xdmac		*atxdmac = to_at_xdmac(atchan->chan.device);
-	struct at_xdmac_desc	*desc, *_desc;
+	struct at_xdmac_desc	*desc, *_desc, *iter;
 	struct list_head	*descs_list;
 	enum dma_status		ret;
 	int			residue, retry;
@@ -1505,11 +1505,13 @@ at_xdmac_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
 	 * microblock.
 	 */
 	descs_list = &desc->descs_list;
-	list_for_each_entry_safe(desc, _desc, descs_list, desc_node) {
-		dwidth = at_xdmac_get_dwidth(desc->lld.mbr_cfg);
-		residue -= (desc->lld.mbr_ubc & 0xffffff) << dwidth;
-		if ((desc->lld.mbr_nda & 0xfffffffc) == cur_nda)
+	list_for_each_entry_safe(iter, _desc, descs_list, desc_node) {
+		dwidth = at_xdmac_get_dwidth(iter->lld.mbr_cfg);
+		residue -= (iter->lld.mbr_ubc & 0xffffff) << dwidth;
+		if ((iter->lld.mbr_nda & 0xfffffffc) == cur_nda) {
+			desc = iter;
 			break;
+		}
 	}
 	residue += cur_ubc << dwidth;
 
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 99f3f22ed647..02d13a44ba45 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1528,7 +1528,7 @@ static int sdma_event_remap(struct sdma_engine *sdma)
 	u32 reg, val, shift, num_map, i;
 	int ret = 0;
 
-	if (IS_ERR(np) || IS_ERR(gpr_np))
+	if (IS_ERR(np) || !gpr_np)
 		goto out;
 
 	event_remap = of_find_property(np, propname, NULL);
@@ -1576,7 +1576,7 @@ static int sdma_event_remap(struct sdma_engine *sdma)
 	}
 
 out:
-	if (!IS_ERR(gpr_np))
+	if (gpr_np)
 		of_node_put(gpr_np);
 
 	return ret;
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c
index 4b22ac3413a1..1f9e3c5ea47d 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c
@@ -197,7 +197,10 @@ static void mdp5_plane_reset(struct drm_plane *plane)
 		drm_framebuffer_unreference(plane->state->fb);
 
 	kfree(to_mdp5_plane_state(plane->state));
+	plane->state = NULL;
 	mdp5_state = kzalloc(sizeof(*mdp5_state), GFP_KERNEL);
+	if (!mdp5_state)
+		return;
 
 	/* assign default blend parameters */
 	mdp5_state->alpha = 255;
diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index df99354ec12a..232f45f722f0 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -681,9 +681,20 @@ static netdev_tx_t usb_8dev_start_xmit(struct sk_buff *skb,
 	atomic_inc(&priv->active_tx_urbs);
 
 	err = usb_submit_urb(urb, GFP_ATOMIC);
-	if (unlikely(err))
-		goto failed;
-	else if (atomic_read(&priv->active_tx_urbs) >= MAX_TX_URBS)
+	if (unlikely(err)) {
+		can_free_echo_skb(netdev, context->echo_index);
+
+		usb_unanchor_urb(urb);
+		usb_free_coherent(priv->udev, size, buf, urb->transfer_dma);
+
+		atomic_dec(&priv->active_tx_urbs);
+
+		if (err == -ENODEV)
+			netif_device_detach(netdev);
+		else
+			netdev_warn(netdev, "failed tx_urb %d\n", err);
+		stats->tx_dropped++;
+	} else if (atomic_read(&priv->active_tx_urbs) >= MAX_TX_URBS)
 		/* Slow down tx path */
 		netif_stop_queue(netdev);
 
@@ -702,19 +713,6 @@ static netdev_tx_t usb_8dev_start_xmit(struct sk_buff *skb,
 
 	return NETDEV_TX_BUSY;
 
-failed:
-	can_free_echo_skb(netdev, context->echo_index);
-
-	usb_unanchor_urb(urb);
-	usb_free_coherent(priv->udev, size, buf, urb->transfer_dma);
-
-	atomic_dec(&priv->active_tx_urbs);
-
-	if (err == -ENODEV)
-		netif_device_detach(netdev);
-	else
-		netdev_warn(netdev, "failed tx_urb %d\n", err);
-
 nomembuf:
 	usb_free_urb(urb);
 
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 045ab0ec5ca2..456d84cbcc6b 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1265,6 +1265,7 @@ static void macb_tx_restart(struct macb_queue *queue)
 	unsigned int head = queue->tx_head;
 	unsigned int tail = queue->tx_tail;
 	struct macb *bp = queue->bp;
+	unsigned int head_idx, tbqp;
 
 	if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
 		queue_writel(queue, ISR, MACB_BIT(TXUBR));
@@ -1272,6 +1273,13 @@ static void macb_tx_restart(struct macb_queue *queue)
 	if (head == tail)
 		return;
 
+	tbqp = queue_readl(queue, TBQP) / macb_dma_desc_get_size(bp);
+	tbqp = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, tbqp));
+	head_idx = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, head));
+
+	if (tbqp == head_idx)
+		return;
+
 	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
 }
 
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 9d5fe4ea9cee..60f0d2053a0a 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1013,8 +1013,8 @@ static s32 e1000_platform_pm_pch_lpt(struct e1000_hw *hw, bool link)
 {
 	u32 reg = link << (E1000_LTRV_REQ_SHIFT + E1000_LTRV_NOSNOOP_SHIFT) |
 	    link << E1000_LTRV_REQ_SHIFT | E1000_LTRV_SEND;
-	u16 max_ltr_enc_d = 0;	/* maximum LTR decoded by platform */
-	u16 lat_enc_d = 0;	/* latency decoded */
+	u32 max_ltr_enc_d = 0;	/* maximum LTR decoded by platform */
+	u32 lat_enc_d = 0;	/* latency decoded */
 	u16 lat_enc = 0;	/* latency encoded */
 
 	if (link) {
diff --git a/drivers/net/ethernet/micrel/Kconfig b/drivers/net/ethernet/micrel/Kconfig
index aa12bace8673..b7e2f49696b7 100644
--- a/drivers/net/ethernet/micrel/Kconfig
+++ b/drivers/net/ethernet/micrel/Kconfig
@@ -45,7 +45,6 @@ config KS8851
 config KS8851_MLL
 	tristate "Micrel KS8851 MLL"
 	depends on HAS_IOMEM
-	depends on PTP_1588_CLOCK_OPTIONAL
 	select MII
 	---help---
 	  This platform driver is for Micrel KS8851 Address/data bus
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 066a4654e838..31657f15eb07 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -524,11 +524,11 @@ static int vxlan_fdb_append(struct vxlan_fdb *f,
 
 	rd = kmalloc(sizeof(*rd), GFP_ATOMIC);
 	if (rd == NULL)
-		return -ENOBUFS;
+		return -ENOMEM;
 
 	if (dst_cache_init(&rd->dst_cache, GFP_ATOMIC)) {
 		kfree(rd);
-		return -ENOBUFS;
+		return -ENOMEM;
 	}
 
 	rd->remote_ip = *ip;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index d198a8780b96..8fa4ffff7c32 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -552,7 +552,7 @@ enum brcmf_sdio_frmtype {
 	BRCMF_SDIO_FT_SUB,
 };
 
-#define SDIOD_DRVSTR_KEY(chip, pmu)     (((chip) << 16) | (pmu))
+#define SDIOD_DRVSTR_KEY(chip, pmu)     (((unsigned int)(chip) << 16) | (pmu))
 
 /* SDIO Pad drive strength to select value mappings */
 struct sdiod_drive_str {
diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index d3cb26f6df73..c1c34b495519 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -1125,8 +1125,6 @@ static void kbd_led_set(struct led_classdev *led_cdev,
 
 	if (value > samsung->kbd_led.max_brightness)
 		value = samsung->kbd_led.max_brightness;
-	else if (value < 0)
-		value = 0;
 
 	samsung->kbd_led_wk = value;
 	queue_work(samsung->led_workqueue, &samsung->kbd_led_work);
diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index dd96ca61a515..986aabc9b8f9 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -160,6 +160,9 @@ static void *ion_buffer_kmap_get(struct ion_buffer *buffer)
 	void *vaddr;
 
 	if (buffer->kmap_cnt) {
+		if (buffer->kmap_cnt == INT_MAX)
+			return ERR_PTR(-EOVERFLOW);
+
 		buffer->kmap_cnt++;
 		return buffer->vaddr;
 	}
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index dba0d12c3db1..1d3f98572068 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -773,7 +773,7 @@ cifs_loose_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	ssize_t rc;
 	struct inode *inode = file_inode(iocb->ki_filp);
 
-	if (iocb->ki_filp->f_flags & O_DIRECT)
+	if (iocb->ki_flags & IOCB_DIRECT)
 		return cifs_user_readv(iocb, iter);
 
 	rc = cifs_revalidate_mapping(inode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4d3eefff3c84..b2d52d4366a1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4224,7 +4224,8 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 	struct super_block *sb = inode->i_sb;
 	ext4_lblk_t first_block, stop_block;
 	struct address_space *mapping = inode->i_mapping;
-	loff_t first_block_offset, last_block_offset;
+	loff_t first_block_offset, last_block_offset, max_length;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	handle_t *handle;
 	unsigned int credits;
 	int ret = 0;
@@ -4270,6 +4271,14 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 		   offset;
 	}
 
+	/*
+	 * For punch hole the length + offset needs to be within one block
+	 * before last range. Adjust the length if it goes beyond that limit.
+	 */
+	max_length = sbi->s_bitmap_maxbytes - inode->i_sb->s_blocksize;
+	if (offset + length > max_length)
+		length = max_length - offset;
+
 	if (offset & (sb->s_blocksize - 1) ||
 	    (offset + length) & (sb->s_blocksize - 1)) {
 		/*
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 9cc79b7b0df1..3de933354a08 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -105,8 +105,10 @@ static void ext4_finish_bio(struct bio *bio)
 				continue;
 			}
 			clear_buffer_async_write(bh);
-			if (bio->bi_status)
+			if (bio->bi_status) {
+				set_buffer_write_io_error(bh);
 				buffer_io_error(bh);
+			}
 		} while ((bh = bh->b_this_page) != head);
 		bit_spin_unlock(BH_Uptodate_Lock, &head->b_state);
 		local_irq_restore(flags);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index dd424958be60..88cf7093927e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3366,9 +3366,11 @@ static int count_overhead(struct super_block *sb, ext4_group_t grp,
 	ext4_fsblk_t		first_block, last_block, b;
 	ext4_group_t		i, ngroups = ext4_get_groups_count(sb);
 	int			s, j, count = 0;
+	int			has_super = ext4_bg_has_super(sb, grp);
 
 	if (!ext4_has_feature_bigalloc(sb))
-		return (ext4_bg_has_super(sb, grp) + ext4_bg_num_gdb(sb, grp) +
+		return (has_super + ext4_bg_num_gdb(sb, grp) +
+			(has_super ? le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks) : 0) +
 			sbi->s_itb_per_group + 2);
 
 	first_block = le32_to_cpu(sbi->s_es->s_first_data_block) +
@@ -4343,9 +4345,18 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	 * Get the # of file system overhead blocks from the
 	 * superblock if present.
 	 */
-	if (es->s_overhead_clusters)
-		sbi->s_overhead = le32_to_cpu(es->s_overhead_clusters);
-	else {
+	sbi->s_overhead = le32_to_cpu(es->s_overhead_clusters);
+	/* ignore the precalculated value if it is ridiculous */
+	if (sbi->s_overhead > ext4_blocks_count(es))
+		sbi->s_overhead = 0;
+	/*
+	 * If the bigalloc feature is not enabled recalculating the
+	 * overhead doesn't take long, so we might as well just redo
+	 * it to make sure we are using the correct value.
+	 */
+	if (!ext4_has_feature_bigalloc(sb))
+		sbi->s_overhead = 0;
+	if (sbi->s_overhead == 0) {
 		err = ext4_calculate_overhead(sb);
 		if (err)
 			goto failed_mount_wq;
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index f4a26759ca38..5b14d4faebbe 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -907,15 +907,15 @@ static int read_rindex_entry(struct gfs2_inode *ip)
 	rgd->rd_bitbytes = be32_to_cpu(buf.ri_bitbytes);
 	spin_lock_init(&rgd->rd_rsspin);
 
-	error = compute_bitstructs(rgd);
-	if (error)
-		goto fail;
-
 	error = gfs2_glock_get(sdp, rgd->rd_addr,
 			       &gfs2_rgrp_glops, CREATE, &rgd->rd_gl);
 	if (error)
 		goto fail;
 
+	error = compute_bitstructs(rgd);
+	if (error)
+		goto fail_glock;
+
 	rgd->rd_rgl = (struct gfs2_rgrp_lvb *)rgd->rd_gl->gl_lksb.sb_lvbptr;
 	rgd->rd_flags &= ~(GFS2_RDF_UPTODATE | GFS2_RDF_PREFERRED);
 	if (rgd->rd_data > sdp->sd_max_rg_data)
@@ -932,6 +932,7 @@ static int read_rindex_entry(struct gfs2_inode *ip)
 	}
 
 	error = 0; /* someone else read in the rgrp; free it and ignore it */
+fail_glock:
 	gfs2_glock_put(rgd->rd_gl);
 
 fail:
diff --git a/fs/stat.c b/fs/stat.c
index 873785dae022..0fda4b6b8fb2 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -286,9 +286,6 @@ SYSCALL_DEFINE2(fstat, unsigned int, fd, struct __old_kernel_stat __user *, stat
 #  define choose_32_64(a,b) b
 #endif
 
-#define valid_dev(x)  choose_32_64(old_valid_dev(x),true)
-#define encode_dev(x) choose_32_64(old_encode_dev,new_encode_dev)(x)
-
 #ifndef INIT_STRUCT_STAT_PADDING
 #  define INIT_STRUCT_STAT_PADDING(st) memset(&st, 0, sizeof(st))
 #endif
@@ -297,7 +294,9 @@ static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
 {
 	struct stat tmp;
 
-	if (!valid_dev(stat->dev) || !valid_dev(stat->rdev))
+	if (sizeof(tmp.st_dev) < 4 && !old_valid_dev(stat->dev))
+		return -EOVERFLOW;
+	if (sizeof(tmp.st_rdev) < 4 && !old_valid_dev(stat->rdev))
 		return -EOVERFLOW;
 #if BITS_PER_LONG == 32
 	if (stat->size > MAX_NON_LFS)
@@ -305,7 +304,7 @@ static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
 #endif
 
 	INIT_STRUCT_STAT_PADDING(tmp);
-	tmp.st_dev = encode_dev(stat->dev);
+	tmp.st_dev = new_encode_dev(stat->dev);
 	tmp.st_ino = stat->ino;
 	if (sizeof(tmp.st_ino) < sizeof(stat->ino) && tmp.st_ino != stat->ino)
 		return -EOVERFLOW;
@@ -315,7 +314,7 @@ static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
 		return -EOVERFLOW;
 	SET_UID(tmp.st_uid, from_kuid_munged(current_user_ns(), stat->uid));
 	SET_GID(tmp.st_gid, from_kgid_munged(current_user_ns(), stat->gid));
-	tmp.st_rdev = encode_dev(stat->rdev);
+	tmp.st_rdev = new_encode_dev(stat->rdev);
 	tmp.st_size = stat->size;
 	tmp.st_atime = stat->atime.tv_sec;
 	tmp.st_mtime = stat->mtime.tv_sec;
@@ -582,11 +581,13 @@ static int cp_compat_stat(struct kstat *stat, struct compat_stat __user *ubuf)
 {
 	struct compat_stat tmp;
 
-	if (!old_valid_dev(stat->dev) || !old_valid_dev(stat->rdev))
+	if (sizeof(tmp.st_dev) < 4 && !old_valid_dev(stat->dev))
+		return -EOVERFLOW;
+	if (sizeof(tmp.st_rdev) < 4 && !old_valid_dev(stat->rdev))
 		return -EOVERFLOW;
 
 	memset(&tmp, 0, sizeof(tmp));
-	tmp.st_dev = old_encode_dev(stat->dev);
+	tmp.st_dev = new_encode_dev(stat->dev);
 	tmp.st_ino = stat->ino;
 	if (sizeof(tmp.st_ino) < sizeof(stat->ino) && tmp.st_ino != stat->ino)
 		return -EOVERFLOW;
@@ -596,7 +597,7 @@ static int cp_compat_stat(struct kstat *stat, struct compat_stat __user *ubuf)
 		return -EOVERFLOW;
 	SET_UID(tmp.st_uid, from_kuid_munged(current_user_ns(), stat->uid));
 	SET_GID(tmp.st_gid, from_kgid_munged(current_user_ns(), stat->gid));
-	tmp.st_rdev = old_encode_dev(stat->rdev);
+	tmp.st_rdev = new_encode_dev(stat->rdev);
 	if ((u64) stat->size > MAX_NON_LFS)
 		return -EOVERFLOW;
 	tmp.st_size = stat->size;
diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index c643cc7fefb5..091369024932 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -130,7 +130,7 @@ static inline bool is_multicast_ether_addr(const u8 *addr)
 #endif
 }
 
-static inline bool is_multicast_ether_addr_64bits(const u8 addr[6+2])
+static inline bool is_multicast_ether_addr_64bits(const u8 *addr)
 {
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
 #ifdef __BIG_ENDIAN
@@ -344,8 +344,7 @@ static inline bool ether_addr_equal(const u8 *addr1, const u8 *addr2)
  * Please note that alignment of addr1 & addr2 are only guaranteed to be 16 bits.
  */
 
-static inline bool ether_addr_equal_64bits(const u8 addr1[6+2],
-					   const u8 addr2[6+2])
+static inline bool ether_addr_equal_64bits(const u8 *addr1, const u8 *addr2)
 {
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
 	u64 fold = (*(const u64 *)addr1) ^ (*(const u64 *)addr2);
diff --git a/include/net/ax25.h b/include/net/ax25.h
index e667bca42ca4..5db7b4c9256d 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -235,6 +235,7 @@ typedef struct ax25_dev {
 #if defined(CONFIG_AX25_DAMA_SLAVE) || defined(CONFIG_AX25_DAMA_MASTER)
 	ax25_dama_info		dama;
 #endif
+	refcount_t		refcount;
 } ax25_dev;
 
 typedef struct ax25_cb {
@@ -289,6 +290,17 @@ static __inline__ void ax25_cb_put(ax25_cb *ax25)
 	}
 }
 
+static inline void ax25_dev_hold(ax25_dev *ax25_dev)
+{
+	refcount_inc(&ax25_dev->refcount);
+}
+
+static inline void ax25_dev_put(ax25_dev *ax25_dev)
+{
+	if (refcount_dec_and_test(&ax25_dev->refcount)) {
+		kfree(ax25_dev);
+	}
+}
 static inline __be16 ax25_type_trans(struct sk_buff *skb, struct net_device *dev)
 {
 	skb->dev      = dev;
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 573ab110c9ec..e5f4d2711404 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -215,8 +215,9 @@ void inet_put_port(struct sock *sk);
 
 void inet_hashinfo_init(struct inet_hashinfo *h);
 
-bool inet_ehash_insert(struct sock *sk, struct sock *osk);
-bool inet_ehash_nolisten(struct sock *sk, struct sock *osk);
+bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk);
+bool inet_ehash_nolisten(struct sock *sk, struct sock *osk,
+			 bool *found_dup_sk);
 int __inet_hash(struct sock *sk, struct sock *osk);
 int inet_hash(struct sock *sk);
 void inet_unhash(struct sock *sk);
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 13f501337308..40c1a2dd48f0 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -932,6 +932,16 @@ void set_named_trigger_data(struct event_trigger_data *data,
 static void
 traceon_trigger(struct event_trigger_data *data, void *rec)
 {
+	struct trace_event_file *file = data->private_data;
+
+	if (file) {
+		if (tracer_tracing_is_on(file->tr))
+			return;
+
+		tracer_tracing_on(file->tr);
+		return;
+	}
+
 	if (tracing_is_on())
 		return;
 
@@ -941,8 +951,15 @@ traceon_trigger(struct event_trigger_data *data, void *rec)
 static void
 traceon_count_trigger(struct event_trigger_data *data, void *rec)
 {
-	if (tracing_is_on())
-		return;
+	struct trace_event_file *file = data->private_data;
+
+	if (file) {
+		if (tracer_tracing_is_on(file->tr))
+			return;
+	} else {
+		if (tracing_is_on())
+			return;
+	}
 
 	if (!data->count)
 		return;
@@ -950,12 +967,25 @@ traceon_count_trigger(struct event_trigger_data *data, void *rec)
 	if (data->count != -1)
 		(data->count)--;
 
-	tracing_on();
+	if (file)
+		tracer_tracing_on(file->tr);
+	else
+		tracing_on();
 }
 
 static void
 traceoff_trigger(struct event_trigger_data *data, void *rec)
 {
+	struct trace_event_file *file = data->private_data;
+
+	if (file) {
+		if (!tracer_tracing_is_on(file->tr))
+			return;
+
+		tracer_tracing_off(file->tr);
+		return;
+	}
+
 	if (!tracing_is_on())
 		return;
 
@@ -965,8 +995,15 @@ traceoff_trigger(struct event_trigger_data *data, void *rec)
 static void
 traceoff_count_trigger(struct event_trigger_data *data, void *rec)
 {
-	if (!tracing_is_on())
-		return;
+	struct trace_event_file *file = data->private_data;
+
+	if (file) {
+		if (!tracer_tracing_is_on(file->tr))
+			return;
+	} else {
+		if (!tracing_is_on())
+			return;
+	}
 
 	if (!data->count)
 		return;
@@ -974,7 +1011,10 @@ traceoff_count_trigger(struct event_trigger_data *data, void *rec)
 	if (data->count != -1)
 		(data->count)--;
 
-	tracing_off();
+	if (file)
+		tracer_tracing_off(file->tr);
+	else
+		tracing_off();
 }
 
 static int
@@ -1156,7 +1196,14 @@ static __init int register_trigger_snapshot_cmd(void) { return 0; }
 static void
 stacktrace_trigger(struct event_trigger_data *data, void *rec)
 {
-	trace_dump_stack(STACK_SKIP);
+	struct trace_event_file *file = data->private_data;
+	unsigned long flags;
+
+	if (file) {
+		local_save_flags(flags);
+		__trace_stack(file->tr, flags, STACK_SKIP, preempt_count());
+	} else
+		trace_dump_stack(STACK_SKIP);
 }
 
 static void
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e3d205f2a3ff..bfbccc739332 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6737,7 +6737,7 @@ void __init mem_init_print_info(const char *str)
 	 */
 #define adj_init_size(start, end, size, pos, adj) \
 	do { \
-		if (start <= pos && pos < end && size > adj) \
+		if (&start[0] <= &pos[0] && &pos[0] < &end[0] && size > adj) \
 			size -= adj; \
 	} while (0)
 
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 466f9e3883c8..20babe8fdbd1 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -92,17 +92,21 @@ static void ax25_kill_by_device(struct net_device *dev)
 			sk = s->sk;
 			if (!sk) {
 				spin_unlock_bh(&ax25_list_lock);
-				s->ax25_dev = NULL;
 				ax25_disconnect(s, ENETUNREACH);
+				s->ax25_dev = NULL;
 				spin_lock_bh(&ax25_list_lock);
 				goto again;
 			}
 			sock_hold(sk);
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
+			ax25_disconnect(s, ENETUNREACH);
 			s->ax25_dev = NULL;
+			if (sk->sk_socket) {
+				dev_put(ax25_dev->dev);
+				ax25_dev_put(ax25_dev);
+			}
 			release_sock(sk);
-			ax25_disconnect(s, ENETUNREACH);
 			spin_lock_bh(&ax25_list_lock);
 			sock_put(sk);
 			/* The entry could have been deleted from the
@@ -369,21 +373,25 @@ static int ax25_ctl_ioctl(const unsigned int cmd, void __user *arg)
 	if (copy_from_user(&ax25_ctl, arg, sizeof(ax25_ctl)))
 		return -EFAULT;
 
-	if ((ax25_dev = ax25_addr_ax25dev(&ax25_ctl.port_addr)) == NULL)
-		return -ENODEV;
-
 	if (ax25_ctl.digi_count > AX25_MAX_DIGIS)
 		return -EINVAL;
 
 	if (ax25_ctl.arg > ULONG_MAX / HZ && ax25_ctl.cmd != AX25_KILL)
 		return -EINVAL;
 
+	ax25_dev = ax25_addr_ax25dev(&ax25_ctl.port_addr);
+	if (!ax25_dev)
+		return -ENODEV;
+
 	digi.ndigi = ax25_ctl.digi_count;
 	for (k = 0; k < digi.ndigi; k++)
 		digi.calls[k] = ax25_ctl.digi_addr[k];
 
-	if ((ax25 = ax25_find_cb(&ax25_ctl.source_addr, &ax25_ctl.dest_addr, &digi, ax25_dev->dev)) == NULL)
+	ax25 = ax25_find_cb(&ax25_ctl.source_addr, &ax25_ctl.dest_addr, &digi, ax25_dev->dev);
+	if (!ax25) {
+		ax25_dev_put(ax25_dev);
 		return -ENOTCONN;
+	}
 
 	switch (ax25_ctl.cmd) {
 	case AX25_KILL:
@@ -450,6 +458,7 @@ static int ax25_ctl_ioctl(const unsigned int cmd, void __user *arg)
 	  }
 
 out_put:
+	ax25_dev_put(ax25_dev);
 	ax25_cb_put(ax25);
 	return ret;
 
@@ -975,14 +984,16 @@ static int ax25_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
 	ax25_cb *ax25;
+	ax25_dev *ax25_dev;
 
 	if (sk == NULL)
 		return 0;
 
 	sock_hold(sk);
-	sock_orphan(sk);
 	lock_sock(sk);
+	sock_orphan(sk);
 	ax25 = sk_to_ax25(sk);
+	ax25_dev = ax25->ax25_dev;
 
 	if (sk->sk_type == SOCK_SEQPACKET) {
 		switch (ax25->state) {
@@ -1044,6 +1055,15 @@ static int ax25_release(struct socket *sock)
 		sk->sk_state_change(sk);
 		ax25_destroy_socket(ax25);
 	}
+	if (ax25_dev) {
+		del_timer_sync(&ax25->timer);
+		del_timer_sync(&ax25->t1timer);
+		del_timer_sync(&ax25->t2timer);
+		del_timer_sync(&ax25->t3timer);
+		del_timer_sync(&ax25->idletimer);
+		dev_put(ax25_dev->dev);
+		ax25_dev_put(ax25_dev);
+	}
 
 	sock->sk   = NULL;
 	release_sock(sk);
@@ -1120,8 +1140,10 @@ static int ax25_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		}
 	}
 
-	if (ax25_dev != NULL)
+	if (ax25_dev) {
 		ax25_fillin_cb(ax25, ax25_dev);
+		dev_hold(ax25_dev->dev);
+	}
 
 done:
 	ax25_cb_add(ax25);
diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index d92195cd7834..55a611f7239b 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -40,6 +40,7 @@ ax25_dev *ax25_addr_ax25dev(ax25_address *addr)
 	for (ax25_dev = ax25_dev_list; ax25_dev != NULL; ax25_dev = ax25_dev->next)
 		if (ax25cmp(addr, (ax25_address *)ax25_dev->dev->dev_addr) == 0) {
 			res = ax25_dev;
+			ax25_dev_hold(ax25_dev);
 		}
 	spin_unlock_bh(&ax25_dev_lock);
 
@@ -59,6 +60,7 @@ void ax25_dev_device_up(struct net_device *dev)
 		return;
 	}
 
+	refcount_set(&ax25_dev->refcount, 1);
 	dev->ax25_ptr     = ax25_dev;
 	ax25_dev->dev     = dev;
 	dev_hold(dev);
@@ -87,6 +89,7 @@ void ax25_dev_device_up(struct net_device *dev)
 	ax25_dev->next = ax25_dev_list;
 	ax25_dev_list  = ax25_dev;
 	spin_unlock_bh(&ax25_dev_lock);
+	ax25_dev_hold(ax25_dev);
 
 	ax25_register_dev_sysctl(ax25_dev);
 }
@@ -116,9 +119,10 @@ void ax25_dev_device_down(struct net_device *dev)
 	if ((s = ax25_dev_list) == ax25_dev) {
 		ax25_dev_list = s->next;
 		spin_unlock_bh(&ax25_dev_lock);
+		ax25_dev_put(ax25_dev);
 		dev->ax25_ptr = NULL;
 		dev_put(dev);
-		kfree(ax25_dev);
+		ax25_dev_put(ax25_dev);
 		return;
 	}
 
@@ -126,9 +130,10 @@ void ax25_dev_device_down(struct net_device *dev)
 		if (s->next == ax25_dev) {
 			s->next = ax25_dev->next;
 			spin_unlock_bh(&ax25_dev_lock);
+			ax25_dev_put(ax25_dev);
 			dev->ax25_ptr = NULL;
 			dev_put(dev);
-			kfree(ax25_dev);
+			ax25_dev_put(ax25_dev);
 			return;
 		}
 
@@ -136,6 +141,7 @@ void ax25_dev_device_down(struct net_device *dev)
 	}
 	spin_unlock_bh(&ax25_dev_lock);
 	dev->ax25_ptr = NULL;
+	ax25_dev_put(ax25_dev);
 }
 
 int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
@@ -147,20 +153,32 @@ int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
 
 	switch (cmd) {
 	case SIOCAX25ADDFWD:
-		if ((fwd_dev = ax25_addr_ax25dev(&fwd->port_to)) == NULL)
+		fwd_dev = ax25_addr_ax25dev(&fwd->port_to);
+		if (!fwd_dev) {
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
-		if (ax25_dev->forward != NULL)
+		}
+		if (ax25_dev->forward) {
+			ax25_dev_put(fwd_dev);
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
+		}
 		ax25_dev->forward = fwd_dev->dev;
+		ax25_dev_put(fwd_dev);
+		ax25_dev_put(ax25_dev);
 		break;
 
 	case SIOCAX25DELFWD:
-		if (ax25_dev->forward == NULL)
+		if (!ax25_dev->forward) {
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
+		}
 		ax25_dev->forward = NULL;
+		ax25_dev_put(ax25_dev);
 		break;
 
 	default:
+		ax25_dev_put(ax25_dev);
 		return -EINVAL;
 	}
 
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index b8e1a5e6a9d3..7d4c86f11b0f 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -78,11 +78,13 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_dev *ax25_dev;
 	int i;
 
-	if ((ax25_dev = ax25_addr_ax25dev(&route->port_addr)) == NULL)
-		return -EINVAL;
 	if (route->digi_count > AX25_MAX_DIGIS)
 		return -EINVAL;
 
+	ax25_dev = ax25_addr_ax25dev(&route->port_addr);
+	if (!ax25_dev)
+		return -EINVAL;
+
 	write_lock_bh(&ax25_route_lock);
 
 	ax25_rt = ax25_route_list;
@@ -94,6 +96,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 			if (route->digi_count != 0) {
 				if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 					write_unlock_bh(&ax25_route_lock);
+					ax25_dev_put(ax25_dev);
 					return -ENOMEM;
 				}
 				ax25_rt->digipeat->lastrepeat = -1;
@@ -104,6 +107,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 				}
 			}
 			write_unlock_bh(&ax25_route_lock);
+			ax25_dev_put(ax25_dev);
 			return 0;
 		}
 		ax25_rt = ax25_rt->next;
@@ -111,6 +115,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 
 	if ((ax25_rt = kmalloc(sizeof(ax25_route), GFP_ATOMIC)) == NULL) {
 		write_unlock_bh(&ax25_route_lock);
+		ax25_dev_put(ax25_dev);
 		return -ENOMEM;
 	}
 
@@ -123,6 +128,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 		if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 			write_unlock_bh(&ax25_route_lock);
 			kfree(ax25_rt);
+			ax25_dev_put(ax25_dev);
 			return -ENOMEM;
 		}
 		ax25_rt->digipeat->lastrepeat = -1;
@@ -135,6 +141,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_rt->next   = ax25_route_list;
 	ax25_route_list = ax25_rt;
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 
 	return 0;
 }
@@ -176,6 +183,7 @@ static int ax25_rt_del(struct ax25_routes_struct *route)
 		}
 	}
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 
 	return 0;
 }
@@ -218,6 +226,7 @@ static int ax25_rt_opt(struct ax25_route_opt_struct *rt_option)
 
 out:
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 	return err;
 }
 
diff --git a/net/ax25/ax25_subr.c b/net/ax25/ax25_subr.c
index 038b109b2be7..c129865cad9f 100644
--- a/net/ax25/ax25_subr.c
+++ b/net/ax25/ax25_subr.c
@@ -264,12 +264,20 @@ void ax25_disconnect(ax25_cb *ax25, int reason)
 {
 	ax25_clear_queues(ax25);
 
-	if (!ax25->sk || !sock_flag(ax25->sk, SOCK_DESTROY))
-		ax25_stop_heartbeat(ax25);
-	ax25_stop_t1timer(ax25);
-	ax25_stop_t2timer(ax25);
-	ax25_stop_t3timer(ax25);
-	ax25_stop_idletimer(ax25);
+	if (reason == ENETUNREACH) {
+		del_timer_sync(&ax25->timer);
+		del_timer_sync(&ax25->t1timer);
+		del_timer_sync(&ax25->t2timer);
+		del_timer_sync(&ax25->t3timer);
+		del_timer_sync(&ax25->idletimer);
+	} else {
+		if (!ax25->sk || !sock_flag(ax25->sk, SOCK_DESTROY))
+			ax25_stop_heartbeat(ax25);
+		ax25_stop_t1timer(ax25);
+		ax25_stop_t2timer(ax25);
+		ax25_stop_t3timer(ax25);
+		ax25_stop_idletimer(ax25);
+	}
 
 	ax25->state = AX25_STATE_0;
 
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 176bddacc16e..7e93087d1366 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -428,7 +428,7 @@ struct sock *dccp_v4_request_recv_sock(const struct sock *sk,
 
 	if (__inet_inherit_port(sk, newsk) < 0)
 		goto put_and_exit;
-	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash));
+	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash), NULL);
 	if (*own_req)
 		ireq->ireq_opt = NULL;
 	else
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 2cd3508a3786..ae4851fdbe9e 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -538,7 +538,7 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
 		dccp_done(newsk);
 		goto out;
 	}
-	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash));
+	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash), NULL);
 	/* Clone pktoptions received with SYN, if we own the req */
 	if (*own_req && ireq->pktopts) {
 		newnp->pktoptions = skb_clone(ireq->pktopts, GFP_ATOMIC);
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 08ba0f91f2ab..44b1d630c40b 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -784,7 +784,7 @@ static void reqsk_queue_hash_req(struct request_sock *req,
 			    (unsigned long)req);
 	mod_timer(&req->rsk_timer, jiffies + timeout);
 
-	inet_ehash_insert(req_to_sk(req), NULL);
+	inet_ehash_insert(req_to_sk(req), NULL, NULL);
 	/* before letting lookups find us, make sure all req fields
 	 * are committed to memory and refcnt initialized.
 	 */
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 8a54babf5c90..1346e45cf8d1 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -23,6 +23,9 @@
 #include <net/addrconf.h>
 #include <net/inet_connection_sock.h>
 #include <net/inet_hashtables.h>
+#if IS_ENABLED(CONFIG_IPV6)
+#include <net/inet6_hashtables.h>
+#endif
 #include <net/secure_seq.h>
 #include <net/ip.h>
 #include <net/tcp.h>
@@ -395,10 +398,52 @@ static u32 inet_sk_port_offset(const struct sock *sk)
 					  inet->inet_dport);
 }
 
-/* insert a socket into ehash, and eventually remove another one
- * (The another one can be a SYN_RECV or TIMEWAIT
+/* Searches for an exsiting socket in the ehash bucket list.
+ * Returns true if found, false otherwise.
  */
-bool inet_ehash_insert(struct sock *sk, struct sock *osk)
+static bool inet_ehash_lookup_by_sk(struct sock *sk,
+				    struct hlist_nulls_head *list)
+{
+	const __portpair ports = INET_COMBINED_PORTS(sk->sk_dport, sk->sk_num);
+	const int sdif = sk->sk_bound_dev_if;
+	const int dif = sk->sk_bound_dev_if;
+	const struct hlist_nulls_node *node;
+	struct net *net = sock_net(sk);
+	struct sock *esk;
+
+	INET_ADDR_COOKIE(acookie, sk->sk_daddr, sk->sk_rcv_saddr);
+
+	sk_nulls_for_each_rcu(esk, node, list) {
+		if (esk->sk_hash != sk->sk_hash)
+			continue;
+		if (sk->sk_family == AF_INET) {
+			if (unlikely(INET_MATCH(esk, net, acookie,
+						sk->sk_daddr,
+						sk->sk_rcv_saddr,
+						ports, dif, sdif))) {
+				return true;
+			}
+		}
+#if IS_ENABLED(CONFIG_IPV6)
+		else if (sk->sk_family == AF_INET6) {
+			if (unlikely(INET6_MATCH(esk, net,
+						 &sk->sk_v6_daddr,
+						 &sk->sk_v6_rcv_saddr,
+						 ports, dif, sdif))) {
+				return true;
+			}
+		}
+#endif
+	}
+	return false;
+}
+
+/* Insert a socket into ehash, and eventually remove another one
+ * (The another one can be a SYN_RECV or TIMEWAIT)
+ * If an existing socket already exists, socket sk is not inserted,
+ * and sets found_dup_sk parameter to true.
+ */
+bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 {
 	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
 	struct hlist_nulls_head *list;
@@ -417,16 +462,23 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk)
 	if (osk) {
 		WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
 		ret = sk_nulls_del_node_init_rcu(osk);
+	} else if (found_dup_sk) {
+		*found_dup_sk = inet_ehash_lookup_by_sk(sk, list);
+		if (*found_dup_sk)
+			ret = false;
 	}
+
 	if (ret)
 		__sk_nulls_add_node_rcu(sk, list);
+
 	spin_unlock(lock);
+
 	return ret;
 }
 
-bool inet_ehash_nolisten(struct sock *sk, struct sock *osk)
+bool inet_ehash_nolisten(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 {
-	bool ok = inet_ehash_insert(sk, osk);
+	bool ok = inet_ehash_insert(sk, osk, found_dup_sk);
 
 	if (ok) {
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
@@ -469,7 +521,7 @@ int __inet_hash(struct sock *sk, struct sock *osk)
 	int err = 0;
 
 	if (sk->sk_state != TCP_LISTEN) {
-		inet_ehash_nolisten(sk, osk);
+		inet_ehash_nolisten(sk, osk, NULL);
 		return 0;
 	}
 	WARN_ON(!sk_unhashed(sk));
@@ -556,7 +608,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 		tb = inet_csk(sk)->icsk_bind_hash;
 		spin_lock_bh(&head->lock);
 		if (sk_head(&tb->owners) == sk && !sk->sk_bind_node.next) {
-			inet_ehash_nolisten(sk, NULL);
+			inet_ehash_nolisten(sk, NULL, NULL);
 			spin_unlock_bh(&head->lock);
 			return 0;
 		}
@@ -632,7 +684,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	inet_bind_hash(sk, tb, port);
 	if (sk_unhashed(sk)) {
 		inet_sk(sk)->inet_sport = htons(port);
-		inet_ehash_nolisten(sk, (struct sock *)tw);
+		inet_ehash_nolisten(sk, (struct sock *)tw, NULL);
 	}
 	if (tw)
 		inet_twsk_bind_unhash(tw, hinfo);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 744479c8b91f..3d56f2729418 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1344,6 +1344,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 				  bool *own_req)
 {
 	struct inet_request_sock *ireq;
+	bool found_dup_sk = false;
 	struct inet_sock *newinet;
 	struct tcp_sock *newtp;
 	struct sock *newsk;
@@ -1414,12 +1415,22 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 
 	if (__inet_inherit_port(sk, newsk) < 0)
 		goto put_and_exit;
-	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash));
+	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash),
+				       &found_dup_sk);
 	if (likely(*own_req)) {
 		tcp_move_syn(newtp, req);
 		ireq->ireq_opt = NULL;
 	} else {
 		newinet->inet_opt = NULL;
+
+		if (!req_unhash && found_dup_sk) {
+			/* This code path should only be executed in the
+			 * syncookie case only
+			 */
+			bh_unlock_sock(newsk);
+			sock_put(newsk);
+			newsk = NULL;
+		}
 	}
 	return newsk;
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 0f0772c48bf0..21637031fbab 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1064,6 +1064,7 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	struct ipv6_txoptions *opt;
 	struct tcp6_sock *newtcp6sk;
 	struct inet_sock *newinet;
+	bool found_dup_sk = false;
 	struct tcp_sock *newtp;
 	struct sock *newsk;
 #ifdef CONFIG_TCP_MD5SIG
@@ -1232,7 +1233,8 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 		tcp_done(newsk);
 		goto out;
 	}
-	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash));
+	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash),
+				       &found_dup_sk);
 	if (*own_req) {
 		tcp_move_syn(newtp, req);
 
@@ -1247,6 +1249,15 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 				skb_set_owner_r(newnp->pktoptions, newsk);
 			}
 		}
+	} else {
+		if (!req_unhash && found_dup_sk) {
+			/* This code path should only be executed in the
+			 * syncookie case only
+			 */
+			bh_unlock_sock(newsk);
+			sock_put(newsk);
+			newsk = NULL;
+		}
 	}
 
 	return newsk;
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 24e8ac2b724e..979cd7dff40a 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2212,6 +2212,13 @@ static int netlink_dump(struct sock *sk)
 	 * single netdev. The outcome is MSG_TRUNC error.
 	 */
 	skb_reserve(skb, skb_tailroom(skb) - alloc_size);
+
+	/* Make sure malicious BPF programs can not read unitialized memory
+	 * from skb->head -> skb->data
+	 */
+	skb_reset_network_header(skb);
+	skb_reset_mac_header(skb);
+
 	netlink_skb_set_owner_r(skb, sk);
 
 	if (nlk->dump_done_errno > 0)
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index ed3528aec15f..a4a4260615d6 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -1977,7 +1977,7 @@ static struct nlattr *reserve_sfa_size(struct sw_flow_actions **sfa,
 	new_acts_size = max(next_offset + req_size, ksize(*sfa) * 2);
 
 	if (new_acts_size > MAX_ACTIONS_BUFSIZE) {
-		if ((MAX_ACTIONS_BUFSIZE - next_offset) < req_size) {
+		if ((next_offset + req_size) > MAX_ACTIONS_BUFSIZE) {
 			OVS_NLERR(log, "Flow action size exceeds max %u",
 				  MAX_ACTIONS_BUFSIZE);
 			return ERR_PTR(-EMSGSIZE);
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index b0dd17d1992e..61093ce76b61 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2829,8 +2829,9 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 
 		status = TP_STATUS_SEND_REQUEST;
 		err = po->xmit(skb);
-		if (unlikely(err > 0)) {
-			err = net_xmit_errno(err);
+		if (unlikely(err != 0)) {
+			if (err > 0)
+				err = net_xmit_errno(err);
 			if (err && __packet_get_status(po, ph) ==
 				   TP_STATUS_AVAILABLE) {
 				/* skb was destructed already */
@@ -3029,8 +3030,12 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 		skb->no_fcs = 1;
 
 	err = po->xmit(skb);
-	if (err > 0 && (err = net_xmit_errno(err)) != 0)
-		goto out_unlock;
+	if (unlikely(err != 0)) {
+		if (err > 0)
+			err = net_xmit_errno(err);
+		if (err)
+			goto out_unlock;
+	}
 
 	dev_put(dev);
 
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index f72fe0cba30d..dd3053c243c1 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1617,8 +1617,7 @@ static void dapm_seq_run(struct snd_soc_card *card,
 		switch (w->id) {
 		case snd_soc_dapm_pre:
 			if (!w->event)
-				list_for_each_entry_safe_continue(w, n, list,
-								  power_list);
+				continue;
 
 			if (event == SND_SOC_DAPM_STREAM_START)
 				ret = w->event(w,
@@ -1630,8 +1629,7 @@ static void dapm_seq_run(struct snd_soc_card *card,
 
 		case snd_soc_dapm_post:
 			if (!w->event)
-				list_for_each_entry_safe_continue(w, n, list,
-								  power_list);
+				continue;
 
 			if (event == SND_SOC_DAPM_STREAM_START)
 				ret = w->event(w,
diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index 5f5a6b7ef1cf..3c4cf5da5daa 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1210,6 +1210,7 @@ static void snd_usbmidi_output_drain(struct snd_rawmidi_substream *substream)
 		} while (drain_urbs && timeout);
 		finish_wait(&ep->drain_wait, &wait);
 	}
+	port->active = 0;
 	spin_unlock_irq(&ep->buffer_lock);
 }
 
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index 62456a806bb4..4b8f1c46420d 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -22,7 +22,7 @@
  */
 
 /* handling of USB vendor/product ID pairs as 32-bit numbers */
-#define USB_ID(vendor, product) (((vendor) << 16) | (product))
+#define USB_ID(vendor, product) (((unsigned int)(vendor) << 16) | (product))
 #define USB_ID_VENDOR(id) ((id) >> 16)
 #define USB_ID_PRODUCT(id) ((u16)(id))
 

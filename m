Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7EDA55AA8B
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 15:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbiFYNmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 09:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbiFYNmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 09:42:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A2318E05;
        Sat, 25 Jun 2022 06:42:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8569CB802BE;
        Sat, 25 Jun 2022 13:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F6DC3411C;
        Sat, 25 Jun 2022 13:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656164566;
        bh=FyBbFh5vUzU9fiDyrWF4et6b1ucyN49GctpwWAyaiso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0THU1cNrSyaYaALj1AzX1/CcpxT1lOzFS0cS2g1QWtrOX5InIic7JagJemEg5zYt
         ACBw2uuoi2CdJewWqeA6OlHnfUJy/YS/Amu9LEsRSUamyRlnoAvfxDjZkYH/uNvw3O
         RMUNa4KXalP85Wtd8mU61zeYm/KMF6PEQol2YVOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.50
Date:   Sat, 25 Jun 2022 15:42:34 +0200
Message-Id: <1656164554185236@kroah.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <1656164554204142@kroah.com>
References: <1656164554204142@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 3e9782979b7c..03b3a493fcca 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 49
+SUBLEVEL = 50
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
index 5051b3c1a4f1..79164e439036 100644
--- a/arch/arm64/mm/cache.S
+++ b/arch/arm64/mm/cache.S
@@ -231,8 +231,6 @@ SYM_FUNC_END_PI(__dma_flush_area)
  */
 SYM_FUNC_START_PI(__dma_map_area)
 	add	x1, x0, x1
-	cmp	w2, #DMA_FROM_DEVICE
-	b.eq	__dma_inv_area
 	b	__dma_clean_area
 SYM_FUNC_END_PI(__dma_map_area)
 
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 6ad634a27d5b..df0adb7e2fe8 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -748,7 +748,7 @@ void ptep_zap_key(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 	pgste_val(pgste) |= PGSTE_GR_BIT | PGSTE_GC_BIT;
 	ptev = pte_val(*ptep);
 	if (!(ptev & _PAGE_INVALID) && (ptev & _PAGE_WRITE))
-		page_set_storage_key(ptev & PAGE_MASK, PAGE_DEFAULT_KEY, 1);
+		page_set_storage_key(ptev & PAGE_MASK, PAGE_DEFAULT_KEY, 0);
 	pgste_set_unlock(ptep, pgste);
 	preempt_enable();
 }
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index dff6238ca9ad..d2aecf7bf66b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -989,6 +989,32 @@ static int dm_dmub_hw_init(struct amdgpu_device *adev)
 	return 0;
 }
 
+static void dm_dmub_hw_resume(struct amdgpu_device *adev)
+{
+	struct dmub_srv *dmub_srv = adev->dm.dmub_srv;
+	enum dmub_status status;
+	bool init;
+
+	if (!dmub_srv) {
+		/* DMUB isn't supported on the ASIC. */
+		return;
+	}
+
+	status = dmub_srv_is_hw_init(dmub_srv, &init);
+	if (status != DMUB_STATUS_OK)
+		DRM_WARN("DMUB hardware init check failed: %d\n", status);
+
+	if (status == DMUB_STATUS_OK && init) {
+		/* Wait for firmware load to finish. */
+		status = dmub_srv_wait_for_auto_load(dmub_srv, 100000);
+		if (status != DMUB_STATUS_OK)
+			DRM_WARN("Wait for DMUB auto-load failed: %d\n", status);
+	} else {
+		/* Perform the full hardware initialization. */
+		dm_dmub_hw_init(adev);
+	}
+}
+
 #if defined(CONFIG_DRM_AMD_DC_DCN)
 static void mmhub_read_system_context(struct amdgpu_device *adev, struct dc_phy_addr_space_config *pa_config)
 {
@@ -2268,9 +2294,7 @@ static int dm_resume(void *handle)
 		amdgpu_dm_outbox_init(adev);
 
 	/* Before powering on DC we need to re-initialize DMUB. */
-	r = dm_dmub_hw_init(adev);
-	if (r)
-		DRM_ERROR("DMUB interface failed to initialize: status=%d\n", r);
+	dm_dmub_hw_resume(adev);
 
 	/* power on hardware */
 	dc_set_power_state(dm->dc, DC_ACPI_CM_POWER_STATE_D0);
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 030ae89f3a33..18dc64d7f412 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -980,8 +980,10 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 		break;
 
 	case CQE_RX_TRUNCATED:
-		netdev_err(ndev, "Dropped a truncated packet\n");
-		return;
+		++ndev->stats.rx_dropped;
+		rxbuf_oob = &rxq->rx_oobs[rxq->buf_index];
+		netdev_warn_once(ndev, "Dropped a truncated packet\n");
+		goto drop;
 
 	case CQE_RX_COALESCED_4:
 		netdev_err(ndev, "RX coalescing is unsupported\n");
@@ -1043,6 +1045,7 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 
 	mana_rx_skb(old_buf, oob, rxq);
 
+drop:
 	mana_move_wq_tail(rxq->gdma_rq, rxbuf_oob->wqe_inf.wqe_size_in_bu);
 
 	mana_post_pkt_rxq(rxq);
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 3d40306971b8..0e908061b5d7 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1620,13 +1620,6 @@ static void pl011_set_mctrl(struct uart_port *port, unsigned int mctrl)
 	    container_of(port, struct uart_amba_port, port);
 	unsigned int cr;
 
-	if (port->rs485.flags & SER_RS485_ENABLED) {
-		if (port->rs485.flags & SER_RS485_RTS_AFTER_SEND)
-			mctrl &= ~TIOCM_RTS;
-		else
-			mctrl |= TIOCM_RTS;
-	}
-
 	cr = pl011_read(uap, REG_CR);
 
 #define	TIOCMBIT(tiocmbit, uartbit)		\
@@ -1850,14 +1843,8 @@ static int pl011_startup(struct uart_port *port)
 	cr = uap->old_cr & (UART011_CR_RTS | UART011_CR_DTR);
 	cr |= UART01x_CR_UARTEN | UART011_CR_RXE;
 
-	if (port->rs485.flags & SER_RS485_ENABLED) {
-		if (port->rs485.flags & SER_RS485_RTS_AFTER_SEND)
-			cr &= ~UART011_CR_RTS;
-		else
-			cr |= UART011_CR_RTS;
-	} else {
+	if (!(port->rs485.flags & SER_RS485_ENABLED))
 		cr |= UART011_CR_TXE;
-	}
 
 	pl011_write(cr, uap, REG_CR);
 
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index eb15423f935a..4d3ad4c6c60f 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -144,6 +144,11 @@ uart_update_mctrl(struct uart_port *port, unsigned int set, unsigned int clear)
 	unsigned long flags;
 	unsigned int old;
 
+	if (port->rs485.flags & SER_RS485_ENABLED) {
+		set &= ~TIOCM_RTS;
+		clear &= ~TIOCM_RTS;
+	}
+
 	spin_lock_irqsave(&port->lock, flags);
 	old = port->mctrl;
 	port->mctrl = (old & ~clear) | set;
@@ -157,23 +162,10 @@ uart_update_mctrl(struct uart_port *port, unsigned int set, unsigned int clear)
 
 static void uart_port_dtr_rts(struct uart_port *uport, int raise)
 {
-	int rs485_on = uport->rs485_config &&
-		(uport->rs485.flags & SER_RS485_ENABLED);
-	int RTS_after_send = !!(uport->rs485.flags & SER_RS485_RTS_AFTER_SEND);
-
-	if (raise) {
-		if (rs485_on && RTS_after_send) {
-			uart_set_mctrl(uport, TIOCM_DTR);
-			uart_clear_mctrl(uport, TIOCM_RTS);
-		} else {
-			uart_set_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
-		}
-	} else {
-		unsigned int clear = TIOCM_DTR;
-
-		clear |= (!rs485_on || RTS_after_send) ? TIOCM_RTS : 0;
-		uart_clear_mctrl(uport, clear);
-	}
+	if (raise)
+		uart_set_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
+	else
+		uart_clear_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
 }
 
 /*
@@ -1089,11 +1081,6 @@ uart_tiocmset(struct tty_struct *tty, unsigned int set, unsigned int clear)
 		goto out;
 
 	if (!tty_io_error(tty)) {
-		if (uport->rs485.flags & SER_RS485_ENABLED) {
-			set &= ~TIOCM_RTS;
-			clear &= ~TIOCM_RTS;
-		}
-
 		uart_update_mctrl(uport, set, clear);
 		ret = 0;
 	}
@@ -2408,6 +2395,9 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 		 */
 		spin_lock_irqsave(&port->lock, flags);
 		port->mctrl &= TIOCM_DTR;
+		if (port->rs485.flags & SER_RS485_ENABLED &&
+		    !(port->rs485.flags & SER_RS485_RTS_AFTER_SEND))
+			port->mctrl |= TIOCM_RTS;
 		port->ops->set_mctrl(port, port->mctrl);
 		spin_unlock_irqrestore(&port->lock, flags);
 
diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
index d15a54f6c24b..ef253599dcf9 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -774,9 +774,13 @@ struct eth_dev *gether_setup_name(struct usb_gadget *g,
 	dev->qmult = qmult;
 	snprintf(net->name, sizeof(net->name), "%s%%d", netname);
 
-	if (get_ether_addr(dev_addr, net->dev_addr))
+	if (get_ether_addr(dev_addr, net->dev_addr)) {
+		net->addr_assign_type = NET_ADDR_RANDOM;
 		dev_warn(&g->dev,
 			"using random %s ethernet address\n", "self");
+	} else {
+		net->addr_assign_type = NET_ADDR_SET;
+	}
 	if (get_ether_addr(host_addr, dev->host_mac))
 		dev_warn(&g->dev,
 			"using random %s ethernet address\n", "host");
@@ -833,6 +837,9 @@ struct net_device *gether_setup_name_default(const char *netname)
 	INIT_LIST_HEAD(&dev->tx_reqs);
 	INIT_LIST_HEAD(&dev->rx_reqs);
 
+	/* by default we always have a random MAC address */
+	net->addr_assign_type = NET_ADDR_RANDOM;
+
 	skb_queue_head_init(&dev->rx_frames);
 
 	/* network device setup */
@@ -869,7 +876,6 @@ int gether_register_netdev(struct net_device *net)
 	dev = netdev_priv(net);
 	g = dev->gadget;
 
-	net->addr_assign_type = NET_ADDR_RANDOM;
 	eth_hw_addr_set(net, dev->dev_mac);
 
 	status = register_netdev(net);
@@ -910,6 +916,7 @@ int gether_set_dev_addr(struct net_device *net, const char *dev_addr)
 	if (get_ether_addr(dev_addr, new_addr))
 		return -EINVAL;
 	memcpy(dev->dev_mac, new_addr, ETH_ALEN);
+	net->addr_assign_type = NET_ADDR_SET;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(gether_set_dev_addr);
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index efea20a4b0e9..ecf564d150b3 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -72,15 +72,51 @@ static inline void zonefs_i_size_write(struct inode *inode, loff_t isize)
 		zi->i_flags &= ~ZONEFS_ZONE_OPEN;
 }
 
-static int zonefs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
-			      unsigned int flags, struct iomap *iomap,
-			      struct iomap *srcmap)
+static int zonefs_read_iomap_begin(struct inode *inode, loff_t offset,
+				   loff_t length, unsigned int flags,
+				   struct iomap *iomap, struct iomap *srcmap)
 {
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 	struct super_block *sb = inode->i_sb;
 	loff_t isize;
 
-	/* All I/Os should always be within the file maximum size */
+	/*
+	 * All blocks are always mapped below EOF. If reading past EOF,
+	 * act as if there is a hole up to the file maximum size.
+	 */
+	mutex_lock(&zi->i_truncate_mutex);
+	iomap->bdev = inode->i_sb->s_bdev;
+	iomap->offset = ALIGN_DOWN(offset, sb->s_blocksize);
+	isize = i_size_read(inode);
+	if (iomap->offset >= isize) {
+		iomap->type = IOMAP_HOLE;
+		iomap->addr = IOMAP_NULL_ADDR;
+		iomap->length = length;
+	} else {
+		iomap->type = IOMAP_MAPPED;
+		iomap->addr = (zi->i_zsector << SECTOR_SHIFT) + iomap->offset;
+		iomap->length = isize - iomap->offset;
+	}
+	mutex_unlock(&zi->i_truncate_mutex);
+
+	trace_zonefs_iomap_begin(inode, iomap);
+
+	return 0;
+}
+
+static const struct iomap_ops zonefs_read_iomap_ops = {
+	.iomap_begin	= zonefs_read_iomap_begin,
+};
+
+static int zonefs_write_iomap_begin(struct inode *inode, loff_t offset,
+				    loff_t length, unsigned int flags,
+				    struct iomap *iomap, struct iomap *srcmap)
+{
+	struct zonefs_inode_info *zi = ZONEFS_I(inode);
+	struct super_block *sb = inode->i_sb;
+	loff_t isize;
+
+	/* All write I/Os should always be within the file maximum size */
 	if (WARN_ON_ONCE(offset + length > zi->i_max_size))
 		return -EIO;
 
@@ -90,7 +126,7 @@ static int zonefs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	 * operation.
 	 */
 	if (WARN_ON_ONCE(zi->i_ztype == ZONEFS_ZTYPE_SEQ &&
-			 (flags & IOMAP_WRITE) && !(flags & IOMAP_DIRECT)))
+			 !(flags & IOMAP_DIRECT)))
 		return -EIO;
 
 	/*
@@ -99,47 +135,44 @@ static int zonefs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	 * write pointer) and unwriten beyond.
 	 */
 	mutex_lock(&zi->i_truncate_mutex);
+	iomap->bdev = inode->i_sb->s_bdev;
+	iomap->offset = ALIGN_DOWN(offset, sb->s_blocksize);
+	iomap->addr = (zi->i_zsector << SECTOR_SHIFT) + iomap->offset;
 	isize = i_size_read(inode);
-	if (offset >= isize)
+	if (iomap->offset >= isize) {
 		iomap->type = IOMAP_UNWRITTEN;
-	else
+		iomap->length = zi->i_max_size - iomap->offset;
+	} else {
 		iomap->type = IOMAP_MAPPED;
-	if (flags & IOMAP_WRITE)
-		length = zi->i_max_size - offset;
-	else
-		length = min(length, isize - offset);
+		iomap->length = isize - iomap->offset;
+	}
 	mutex_unlock(&zi->i_truncate_mutex);
 
-	iomap->offset = ALIGN_DOWN(offset, sb->s_blocksize);
-	iomap->length = ALIGN(offset + length, sb->s_blocksize) - iomap->offset;
-	iomap->bdev = inode->i_sb->s_bdev;
-	iomap->addr = (zi->i_zsector << SECTOR_SHIFT) + iomap->offset;
-
 	trace_zonefs_iomap_begin(inode, iomap);
 
 	return 0;
 }
 
-static const struct iomap_ops zonefs_iomap_ops = {
-	.iomap_begin	= zonefs_iomap_begin,
+static const struct iomap_ops zonefs_write_iomap_ops = {
+	.iomap_begin	= zonefs_write_iomap_begin,
 };
 
 static int zonefs_readpage(struct file *unused, struct page *page)
 {
-	return iomap_readpage(page, &zonefs_iomap_ops);
+	return iomap_readpage(page, &zonefs_read_iomap_ops);
 }
 
 static void zonefs_readahead(struct readahead_control *rac)
 {
-	iomap_readahead(rac, &zonefs_iomap_ops);
+	iomap_readahead(rac, &zonefs_read_iomap_ops);
 }
 
 /*
  * Map blocks for page writeback. This is used only on conventional zone files,
  * which implies that the page range can only be within the fixed inode size.
  */
-static int zonefs_map_blocks(struct iomap_writepage_ctx *wpc,
-			     struct inode *inode, loff_t offset)
+static int zonefs_write_map_blocks(struct iomap_writepage_ctx *wpc,
+				   struct inode *inode, loff_t offset)
 {
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 
@@ -153,12 +186,12 @@ static int zonefs_map_blocks(struct iomap_writepage_ctx *wpc,
 	    offset < wpc->iomap.offset + wpc->iomap.length)
 		return 0;
 
-	return zonefs_iomap_begin(inode, offset, zi->i_max_size - offset,
-				  IOMAP_WRITE, &wpc->iomap, NULL);
+	return zonefs_write_iomap_begin(inode, offset, zi->i_max_size - offset,
+					IOMAP_WRITE, &wpc->iomap, NULL);
 }
 
 static const struct iomap_writeback_ops zonefs_writeback_ops = {
-	.map_blocks		= zonefs_map_blocks,
+	.map_blocks		= zonefs_write_map_blocks,
 };
 
 static int zonefs_writepage(struct page *page, struct writeback_control *wbc)
@@ -188,7 +221,8 @@ static int zonefs_swap_activate(struct swap_info_struct *sis,
 		return -EINVAL;
 	}
 
-	return iomap_swapfile_activate(sis, swap_file, span, &zonefs_iomap_ops);
+	return iomap_swapfile_activate(sis, swap_file, span,
+				       &zonefs_read_iomap_ops);
 }
 
 static const struct address_space_operations zonefs_file_aops = {
@@ -607,7 +641,7 @@ static vm_fault_t zonefs_filemap_page_mkwrite(struct vm_fault *vmf)
 
 	/* Serialize against truncates */
 	filemap_invalidate_lock_shared(inode->i_mapping);
-	ret = iomap_page_mkwrite(vmf, &zonefs_iomap_ops);
+	ret = iomap_page_mkwrite(vmf, &zonefs_write_iomap_ops);
 	filemap_invalidate_unlock_shared(inode->i_mapping);
 
 	sb_end_pagefault(inode->i_sb);
@@ -862,7 +896,7 @@ static ssize_t zonefs_file_dio_write(struct kiocb *iocb, struct iov_iter *from)
 	if (append)
 		ret = zonefs_file_dio_append(iocb, from);
 	else
-		ret = iomap_dio_rw(iocb, from, &zonefs_iomap_ops,
+		ret = iomap_dio_rw(iocb, from, &zonefs_write_iomap_ops,
 				   &zonefs_write_dio_ops, 0, 0);
 	if (zi->i_ztype == ZONEFS_ZTYPE_SEQ &&
 	    (ret > 0 || ret == -EIOCBQUEUED)) {
@@ -904,7 +938,7 @@ static ssize_t zonefs_file_buffered_write(struct kiocb *iocb,
 	if (ret <= 0)
 		goto inode_unlock;
 
-	ret = iomap_file_buffered_write(iocb, from, &zonefs_iomap_ops);
+	ret = iomap_file_buffered_write(iocb, from, &zonefs_write_iomap_ops);
 	if (ret > 0)
 		iocb->ki_pos += ret;
 	else if (ret == -EIO)
@@ -997,7 +1031,7 @@ static ssize_t zonefs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			goto inode_unlock;
 		}
 		file_accessed(iocb->ki_filp);
-		ret = iomap_dio_rw(iocb, to, &zonefs_iomap_ops,
+		ret = iomap_dio_rw(iocb, to, &zonefs_read_iomap_ops,
 				   &zonefs_read_dio_ops, 0, 0);
 	} else {
 		ret = generic_file_read_iter(iocb, to);
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 40df35088cdb..3cfba41a0829 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5441,6 +5441,8 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				    struct bpf_reg_state *regs,
 				    bool ptr_to_mem_ok)
 {
+	enum bpf_prog_type prog_type = env->prog->type == BPF_PROG_TYPE_EXT ?
+		env->prog->aux->dst_prog->type : env->prog->type;
 	struct bpf_verifier_log *log = &env->log;
 	const char *func_name, *ref_tname;
 	const struct btf_type *t, *ref_t;
@@ -5533,8 +5535,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 					reg_ref_tname);
 				return -EINVAL;
 			}
-		} else if (btf_get_prog_ctx_type(log, btf, t,
-						 env->prog->type, i)) {
+		} else if (btf_get_prog_ctx_type(log, btf, t, prog_type, i)) {
 			/* If function expects ctx type in BTF check that caller
 			 * is passing PTR_TO_CTX.
 			 */
diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index 73b4c76e6b86..52f1426ae06e 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -371,6 +371,18 @@ static void test_func_map_prog_compatibility(void)
 				     "./test_attach_probe.o");
 }
 
+static void test_func_replace_global_func(void)
+{
+	const char *prog_name[] = {
+		"freplace/test_pkt_access",
+	};
+
+	test_fexit_bpf2bpf_common("./freplace_global_func.o",
+				  "./test_pkt_access.o",
+				  ARRAY_SIZE(prog_name),
+				  prog_name, false, NULL);
+}
+
 void test_fexit_bpf2bpf(void)
 {
 	if (test__start_subtest("target_no_callees"))
@@ -391,4 +403,6 @@ void test_fexit_bpf2bpf(void)
 		test_func_replace_multi();
 	if (test__start_subtest("fmod_ret_freplace"))
 		test_fmod_ret_freplace();
+	if (test__start_subtest("func_replace_global_func"))
+		test_func_replace_global_func();
 }
diff --git a/tools/testing/selftests/bpf/progs/freplace_global_func.c b/tools/testing/selftests/bpf/progs/freplace_global_func.c
new file mode 100644
index 000000000000..96cb61a6ce87
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/freplace_global_func.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+__noinline
+int test_ctx_global_func(struct __sk_buff *skb)
+{
+	volatile int retval = 1;
+	return retval;
+}
+
+SEC("freplace/test_pkt_access")
+int new_test_pkt_access(struct __sk_buff *skb)
+{
+	return test_ctx_global_func(skb);
+}
+
+char _license[] SEC("license") = "GPL";

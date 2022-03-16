Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16494DAF78
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 13:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355618AbiCPMQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 08:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbiCPMQM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 08:16:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00C839814;
        Wed, 16 Mar 2022 05:14:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D008A6167E;
        Wed, 16 Mar 2022 12:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20629C340E9;
        Wed, 16 Mar 2022 12:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647432896;
        bh=EF/OHUXC8wS7L2Lh3N+uXe9SId54HwS9w1QV7Vo3hVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SEY68Obbqo1GFTdf37Qf3aBJXETkVILxN1arpB51t6X12hBUjZ7xiC8fk5fEJ+HWi
         oNoLe/7XfXoLh9KU2UwG6QLeQOiczdZOp0IxEfGTwgR7YPx9aO6mFF9oVAf2cf0mxY
         sUtLDXdd68JKhO+bhx4zsYG+bnl2enPNh9T29To0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.9.307
Date:   Wed, 16 Mar 2022 13:14:45 +0100
Message-Id: <164743288445243@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <1647432884267@kroah.com>
References: <1647432884267@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 482b84118857..19363e65ef22 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 4
 PATCHLEVEL = 9
-SUBLEVEL = 306
+SUBLEVEL = 307
 EXTRAVERSION =
 NAME = Roaring Lionus
 
diff --git a/arch/arm/include/asm/spectre.h b/arch/arm/include/asm/spectre.h
index d1fa5607d3aa..85f9e538fb32 100644
--- a/arch/arm/include/asm/spectre.h
+++ b/arch/arm/include/asm/spectre.h
@@ -25,7 +25,13 @@ enum {
 	SPECTRE_V2_METHOD_LOOP8 = BIT(__SPECTRE_V2_METHOD_LOOP8),
 };
 
+#ifdef CONFIG_GENERIC_CPU_VULNERABILITIES
 void spectre_v2_update_state(unsigned int state, unsigned int methods);
+#else
+static inline void spectre_v2_update_state(unsigned int state,
+					   unsigned int methods)
+{}
+#endif
 
 int spectre_bhb_update_vectors(unsigned int method);
 
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 1040efcb98db..77ec669fd5ee 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -1074,9 +1074,9 @@ vector_bhb_loop8_\name:
 
 	@ bhb workaround
 	mov	r0, #8
-1:	b	. + 4
+3:	b	. + 4
 	subs	r0, r0, #1
-	bne	1b
+	bne	3b
 	dsb
 	isb
 	b	2b
diff --git a/drivers/gpio/gpio-ts4900.c b/drivers/gpio/gpio-ts4900.c
index 5bd21725e604..930a6098b758 100644
--- a/drivers/gpio/gpio-ts4900.c
+++ b/drivers/gpio/gpio-ts4900.c
@@ -1,7 +1,7 @@
 /*
  * Digital I/O driver for Technologic Systems I2C FPGA Core
  *
- * Copyright (C) 2015 Technologic Systems
+ * Copyright (C) 2015, 2018 Technologic Systems
  * Copyright (C) 2016 Savoir-Faire Linux
  *
  * This program is free software; you can redistribute it and/or
@@ -52,19 +52,33 @@ static int ts4900_gpio_direction_input(struct gpio_chip *chip,
 {
 	struct ts4900_gpio_priv *priv = gpiochip_get_data(chip);
 
-	/*
-	 * This will clear the output enable bit, the other bits are
-	 * dontcare when this is cleared
+	/* Only clear the OE bit here, requires a RMW. Prevents potential issue
+	 * with OE and data getting to the physical pin at different times.
 	 */
-	return regmap_write(priv->regmap, offset, 0);
+	return regmap_update_bits(priv->regmap, offset, TS4900_GPIO_OE, 0);
 }
 
 static int ts4900_gpio_direction_output(struct gpio_chip *chip,
 					unsigned int offset, int value)
 {
 	struct ts4900_gpio_priv *priv = gpiochip_get_data(chip);
+	unsigned int reg;
 	int ret;
 
+	/* If changing from an input to an output, we need to first set the
+	 * proper data bit to what is requested and then set OE bit. This
+	 * prevents a glitch that can occur on the IO line
+	 */
+	regmap_read(priv->regmap, offset, &reg);
+	if (!(reg & TS4900_GPIO_OE)) {
+		if (value)
+			reg = TS4900_GPIO_OUT;
+		else
+			reg &= ~TS4900_GPIO_OUT;
+
+		regmap_write(priv->regmap, offset, reg);
+	}
+
 	if (value)
 		ret = regmap_write(priv->regmap, offset, TS4900_GPIO_OE |
 							 TS4900_GPIO_OUT);
diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index ad7b9772a4b2..78f34e87212a 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1515,6 +1515,7 @@ static int lpc_eth_drv_resume(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct netdata_local *pldat;
+	int ret;
 
 	if (device_may_wakeup(&pdev->dev))
 		disable_irq_wake(ndev->irq);
@@ -1524,7 +1525,9 @@ static int lpc_eth_drv_resume(struct platform_device *pdev)
 			pldat = netdev_priv(ndev);
 
 			/* Enable interface clock */
-			clk_enable(pldat->clk);
+			ret = clk_enable(pldat->clk);
+			if (ret)
+				return ret;
 
 			/* Reset and initialize */
 			__lpc_eth_reset(pldat);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index 6379bfedc9f0..9a7ba55b4693 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -2899,11 +2899,11 @@ int qed_iov_mark_vf_flr(struct qed_hwfn *p_hwfn, u32 *p_disabled_vfs)
 	return found;
 }
 
-static void qed_iov_get_link(struct qed_hwfn *p_hwfn,
-			     u16 vfid,
-			     struct qed_mcp_link_params *p_params,
-			     struct qed_mcp_link_state *p_link,
-			     struct qed_mcp_link_capabilities *p_caps)
+static int qed_iov_get_link(struct qed_hwfn *p_hwfn,
+			    u16 vfid,
+			    struct qed_mcp_link_params *p_params,
+			    struct qed_mcp_link_state *p_link,
+			    struct qed_mcp_link_capabilities *p_caps)
 {
 	struct qed_vf_info *p_vf = qed_iov_get_vf_info(p_hwfn,
 						       vfid,
@@ -2911,7 +2911,7 @@ static void qed_iov_get_link(struct qed_hwfn *p_hwfn,
 	struct qed_bulletin_content *p_bulletin;
 
 	if (!p_vf)
-		return;
+		return -EINVAL;
 
 	p_bulletin = p_vf->bulletin.p_virt;
 
@@ -2921,6 +2921,7 @@ static void qed_iov_get_link(struct qed_hwfn *p_hwfn,
 		__qed_vf_get_link_state(p_hwfn, p_link, p_bulletin);
 	if (p_caps)
 		__qed_vf_get_link_caps(p_hwfn, p_caps, p_bulletin);
+	return 0;
 }
 
 static void qed_iov_process_mbx_req(struct qed_hwfn *p_hwfn,
@@ -3538,6 +3539,7 @@ static int qed_get_vf_config(struct qed_dev *cdev,
 	struct qed_public_vf_info *vf_info;
 	struct qed_mcp_link_state link;
 	u32 tx_rate;
+	int ret;
 
 	/* Sanitize request */
 	if (IS_VF(cdev))
@@ -3551,7 +3553,9 @@ static int qed_get_vf_config(struct qed_dev *cdev,
 
 	vf_info = qed_iov_get_public_vf_info(hwfn, vf_id, true);
 
-	qed_iov_get_link(hwfn, vf_id, NULL, &link, NULL);
+	ret = qed_iov_get_link(hwfn, vf_id, NULL, &link, NULL);
+	if (ret)
+		return ret;
 
 	/* Fill information about VF */
 	ivi->vf = vf_id;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_vf.c b/drivers/net/ethernet/qlogic/qed/qed_vf.c
index 170243d3276b..d0449d5418f7 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_vf.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_vf.c
@@ -384,6 +384,9 @@ int qed_vf_hw_prepare(struct qed_hwfn *p_hwfn)
 						    p_iov->bulletin.size,
 						    &p_iov->bulletin.phys,
 						    GFP_KERNEL);
+	if (!p_iov->bulletin.p_virt)
+		goto free_pf2vf_reply;
+
 	DP_VERBOSE(p_hwfn, QED_MSG_IOV,
 		   "VF's bulletin Board [%p virt 0x%llx phys 0x%08x bytes]\n",
 		   p_iov->bulletin.p_virt,
@@ -397,6 +400,10 @@ int qed_vf_hw_prepare(struct qed_hwfn *p_hwfn)
 
 	return qed_vf_pf_acquire(p_hwfn);
 
+free_pf2vf_reply:
+	dma_free_coherent(&p_hwfn->cdev->pdev->dev,
+			  sizeof(union pfvf_tlvs),
+			  p_iov->pf2vf_reply, p_iov->pf2vf_reply_phys);
 free_vf2pf_request:
 	dma_free_coherent(&p_hwfn->cdev->pdev->dev,
 			  sizeof(union vfpf_tlvs),
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index df3b3384984c..1f9a6ea356b0 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1175,7 +1175,7 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 	if (rc) {
 		dev_err(dev,
 			"Cannot register network device, aborting\n");
-		goto error;
+		goto put_node;
 	}
 
 	dev_info(dev,
@@ -1183,6 +1183,8 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 		 (unsigned int __force)ndev->mem_start, lp->base_addr, ndev->irq);
 	return 0;
 
+put_node:
+	of_node_put(lp->phy_node);
 error:
 	xemaclite_remove_ndev(ndev);
 	return rc;
diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index e6646c8a7bdb..78788402edd8 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -1040,15 +1040,11 @@ static void connect(struct backend_info *be)
 	xenvif_carrier_on(be->vif);
 
 	unregister_hotplug_status_watch(be);
-	if (xenbus_exists(XBT_NIL, dev->nodename, "hotplug-status")) {
-		err = xenbus_watch_pathfmt(dev, &be->hotplug_status_watch,
-					   NULL, hotplug_status_changed,
-					   "%s/%s", dev->nodename,
-					   "hotplug-status");
-		if (err)
-			goto err;
+	err = xenbus_watch_pathfmt(dev, &be->hotplug_status_watch, NULL,
+				   hotplug_status_changed,
+				   "%s/%s", dev->nodename, "hotplug-status");
+	if (!err)
 		be->have_hotplug_status_watch = 1;
-	}
 
 	netif_tx_wake_all_queues(be->vif->dev);
 
diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
index ed65993aae96..838ec17073fd 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -1617,7 +1617,9 @@ static int port100_probe(struct usb_interface *interface,
 	nfc_digital_free_device(dev->nfc_digital_dev);
 
 error:
+	usb_kill_urb(dev->in_urb);
 	usb_free_urb(dev->in_urb);
+	usb_kill_urb(dev->out_urb);
 	usb_free_urb(dev->out_urb);
 	usb_put_dev(dev->udev);
 
diff --git a/drivers/staging/gdm724x/gdm_lte.c b/drivers/staging/gdm724x/gdm_lte.c
index 454e47424ade..463f920d3782 100644
--- a/drivers/staging/gdm724x/gdm_lte.c
+++ b/drivers/staging/gdm724x/gdm_lte.c
@@ -85,14 +85,15 @@ static void tx_complete(void *arg)
 
 static int gdm_lte_rx(struct sk_buff *skb, struct nic *nic, int nic_type)
 {
-	int ret;
+	int ret, len;
 
+	len = skb->len + ETH_HLEN;
 	ret = netif_rx_ni(skb);
 	if (ret == NET_RX_DROP) {
 		nic->stats.rx_dropped++;
 	} else {
 		nic->stats.rx_packets++;
-		nic->stats.rx_bytes += skb->len + ETH_HLEN;
+		nic->stats.rx_bytes += len;
 	}
 
 	return 0;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b5bff1e760a3..8ded1d894100 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8457,6 +8457,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 out_free_delayed:
 	btrfs_free_delayed_extent_op(extent_op);
 out_free_buf:
+	btrfs_tree_unlock(buf);
 	free_extent_buffer(buf);
 out_free_reserved:
 	btrfs_free_reserved_extent(root, ins.objectid, ins.offset, 0);
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 6dd276227217..5747174e0326 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -7327,8 +7327,8 @@ struct mlx5_ifc_bufferx_reg_bits {
 	u8         reserved_at_0[0x6];
 	u8         lossy[0x1];
 	u8         epsb[0x1];
-	u8         reserved_at_8[0xc];
-	u8         size[0xc];
+	u8         reserved_at_8[0x8];
+	u8         size[0x10];
 
 	u8         xoff_threshold[0x10];
 	u8         xon_threshold[0x10];
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 12bee7043be6..90e0fd5621da 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1077,10 +1077,12 @@ static int __init set_buf_size(char *str)
 	if (!str)
 		return 0;
 	buf_size = memparse(str, &str);
-	/* nr_entries can not be zero */
-	if (buf_size == 0)
-		return 0;
-	trace_buf_size = buf_size;
+	/*
+	 * nr_entries can not be zero and the startup
+	 * tests require some buffer space. Therefore
+	 * ensure we have at least 4096 bytes of buffer.
+	 */
+	trace_buf_size = max(4096UL, buf_size);
 	return 1;
 }
 __setup("trace_buf_size=", set_buf_size);
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index c4ef1be59cb1..839c4237d131 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -90,6 +90,13 @@ static void ax25_kill_by_device(struct net_device *dev)
 	ax25_for_each(s, &ax25_list) {
 		if (s->ax25_dev == ax25_dev) {
 			sk = s->sk;
+			if (!sk) {
+				spin_unlock_bh(&ax25_list_lock);
+				s->ax25_dev = NULL;
+				ax25_disconnect(s, ENETUNREACH);
+				spin_lock_bh(&ax25_list_lock);
+				goto again;
+			}
 			sock_hold(sk);
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 4f384abb4ced..eaf0a483211a 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -155,22 +155,25 @@ static bool batadv_is_on_batman_iface(const struct net_device *net_dev)
 	struct net *net = dev_net(net_dev);
 	struct net_device *parent_dev;
 	const struct net *parent_net;
+	int iflink;
 	bool ret;
 
 	/* check if this is a batman-adv mesh interface */
 	if (batadv_softif_is_valid(net_dev))
 		return true;
 
-	/* no more parents..stop recursion */
-	if (dev_get_iflink(net_dev) == 0 ||
-	    dev_get_iflink(net_dev) == net_dev->ifindex)
+	iflink = dev_get_iflink(net_dev);
+	if (iflink == 0)
 		return false;
 
 	parent_net = batadv_getlink_net(net_dev, net);
 
+	/* iflink to itself, most likely physical device */
+	if (net == parent_net && iflink == net_dev->ifindex)
+		return false;
+
 	/* recurse over the parent device */
-	parent_dev = __dev_get_by_index((struct net *)parent_net,
-					dev_get_iflink(net_dev));
+	parent_dev = __dev_get_by_index((struct net *)parent_net, iflink);
 	/* if we got a NULL parent_dev there is something broken.. */
 	if (!parent_dev) {
 		pr_err("Cannot find parent device\n");
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 3fb5d8ecc849..e42df58b8876 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -198,7 +198,7 @@ static ssize_t speed_show(struct device *dev,
 	if (!rtnl_trylock())
 		return restart_syscall();
 
-	if (netif_running(netdev)) {
+	if (netif_running(netdev) && netif_device_present(netdev)) {
 		struct ethtool_link_ksettings cmd;
 
 		if (!__ethtool_get_link_ksettings(netdev, &cmd))
diff --git a/net/sctp/sctp_diag.c b/net/sctp/sctp_diag.c
index e8f56b7c5afb..a044964fa802 100644
--- a/net/sctp/sctp_diag.c
+++ b/net/sctp/sctp_diag.c
@@ -45,10 +45,6 @@ static void inet_diag_msg_sctpasoc_fill(struct inet_diag_msg *r,
 		r->idiag_timer = SCTP_EVENT_TIMEOUT_T3_RTX;
 		r->idiag_retrans = asoc->rtx_data_chunks;
 		r->idiag_expires = jiffies_to_msecs(t3_rtx->expires - jiffies);
-	} else {
-		r->idiag_timer = 0;
-		r->idiag_retrans = 0;
-		r->idiag_expires = 0;
 	}
 }
 
@@ -128,13 +124,14 @@ static int inet_sctp_diag_fill(struct sock *sk, struct sctp_association *asoc,
 	r = nlmsg_data(nlh);
 	BUG_ON(!sk_fullsock(sk));
 
+	r->idiag_timer = 0;
+	r->idiag_retrans = 0;
+	r->idiag_expires = 0;
 	if (asoc) {
 		inet_diag_msg_sctpasoc_fill(r, sk, asoc);
 	} else {
 		inet_diag_msg_common_fill(r, sk);
 		r->idiag_state = sk->sk_state;
-		r->idiag_timer = 0;
-		r->idiag_retrans = 0;
 	}
 
 	if (inet_diag_msg_attrs_fill(sk, skb, r, ext, user_ns, net_admin))
diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/selftests/memfd/memfd_test.c
index 26546892cd54..faab09215c88 100644
--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -373,6 +373,7 @@ static void mfd_fail_write(int fd)
 			printf("mmap()+mprotect() didn't fail as expected\n");
 			abort();
 		}
+		munmap(p, mfd_def_size);
 	}
 
 	/* verify PUNCH_HOLE fails */

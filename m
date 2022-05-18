Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0DF52B408
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 09:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbiERHmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 03:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbiERHlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 03:41:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543E411904F;
        Wed, 18 May 2022 00:41:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9534561321;
        Wed, 18 May 2022 07:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC7BC385A5;
        Wed, 18 May 2022 07:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652859708;
        bh=mZOaz7v0RxjAg09ksh5qCtvErMv9VuOFGnkqu9Vwqec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NdSFDPuwkQzne0rClbiwrnc73rPa6LhNyjzbaahljvwZPgrj+yxkV6OwLBuK8QZY9
         Yh+7dox37oFbtEaCSVEDLSnAHVAxzelS9gIUfPW8QEmoafTGUsQOCAcDgFOmDRxfF0
         WbT/8V5sfg4IoqEn5wG7NkaA+tsrltK5j3m0BMIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.280
Date:   Wed, 18 May 2022 09:41:33 +0200
Message-Id: <1652859693128149@kroah.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <1652859693111215@kroah.com>
References: <1652859693111215@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index efe93f82073a..4207e0002fbb 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 279
+SUBLEVEL = 280
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
index 3ba9b6ad0281..4042062df409 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
@@ -522,7 +522,7 @@ static int vmw_fb_kms_detach(struct vmw_fb_par *par,
 
 static int vmw_fb_kms_framebuffer(struct fb_info *info)
 {
-	struct drm_mode_fb_cmd2 mode_cmd;
+	struct drm_mode_fb_cmd2 mode_cmd = {0};
 	struct vmw_fb_par *par = info->par;
 	struct fb_var_screeninfo *var = &info->var;
 	struct drm_framebuffer *cur_fb;
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index d65431417b17..e02d7bfc4ae4 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -793,7 +793,7 @@ config SENSORS_LTC4261
 
 config SENSORS_LTQ_CPUTEMP
 	bool "Lantiq cpu temperature sensor driver"
-	depends on LANTIQ
+	depends on SOC_XWAY
 	help
 	  If you say yes here you get support for the temperature
 	  sensor inside your CPU.
diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
index ca54ce5c8e10..4010b61743f5 100644
--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -1590,8 +1590,9 @@ static ssize_t show_temp(struct device *dev, struct device_attribute *devattr,
 		temp *= 125;
 		if (sign)
 			temp -= 128000;
-	} else
-		temp = data->temp[nr] * 1000;
+	} else {
+		temp = ((s8)data->temp[nr]) * 1000;
+	}
 
 	return sprintf(buf, "%d\n", temp);
 }
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 2d92a9fe4606..4f0da3963b01 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -5956,6 +5956,11 @@ static int efx_ef10_mtd_probe(struct efx_nic *efx)
 		n_parts++;
 	}
 
+	if (!n_parts) {
+		kfree(parts);
+		return 0;
+	}
+
 	rc = efx_mtd_add(efx, &parts[0].common, n_parts, sizeof(*parts));
 fail:
 	if (rc)
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ee1eb14ae8fc..885c4352bdef 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2025,11 +2025,13 @@ static void hw_scan_work(struct work_struct *work)
 			if (req->ie_len)
 				skb_put_data(probe, req->ie, req->ie_len);
 
+			rcu_read_lock();
 			if (!ieee80211_tx_prepare_skb(hwsim->hw,
 						      hwsim->hw_scan_vif,
 						      probe,
 						      hwsim->tmp_chan->band,
 						      NULL)) {
+				rcu_read_unlock();
 				kfree_skb(probe);
 				continue;
 			}
@@ -2037,6 +2039,7 @@ static void hw_scan_work(struct work_struct *work)
 			local_bh_disable();
 			mac80211_hwsim_tx_frame(hwsim->hw, probe,
 						hwsim->tmp_chan);
+			rcu_read_unlock();
 			local_bh_enable();
 		}
 	}
diff --git a/drivers/s390/net/ctcm_mpc.c b/drivers/s390/net/ctcm_mpc.c
index e02f295d38a9..07d9668137df 100644
--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -625,8 +625,6 @@ static void mpc_rcvd_sweep_resp(struct mpcg_info *mpcginfo)
 		ctcm_clear_busy_do(dev);
 	}
 
-	kfree(mpcginfo);
-
 	return;
 
 }
@@ -1205,10 +1203,10 @@ static void ctcmpc_unpack_skb(struct channel *ch, struct sk_buff *pskb)
 						CTCM_FUNTAIL, dev->name);
 			priv->stats.rx_dropped++;
 			/* mpcginfo only used for non-data transfers */
-			kfree(mpcginfo);
 			if (do_debug_data)
 				ctcmpc_dump_skb(pskb, -8);
 		}
+		kfree(mpcginfo);
 	}
 done:
 
@@ -1991,7 +1989,6 @@ static void mpc_action_rcvd_xid0(fsm_instance *fsm, int event, void *arg)
 		}
 		break;
 	}
-	kfree(mpcginfo);
 
 	CTCM_PR_DEBUG("ctcmpc:%s() %s xid2:%i xid7:%i xidt_p2:%i \n",
 		__func__, ch->id, grp->outstanding_xid2,
@@ -2052,7 +2049,6 @@ static void mpc_action_rcvd_xid7(fsm_instance *fsm, int event, void *arg)
 		mpc_validate_xid(mpcginfo);
 		break;
 	}
-	kfree(mpcginfo);
 	return;
 }
 
diff --git a/drivers/s390/net/ctcm_sysfs.c b/drivers/s390/net/ctcm_sysfs.c
index ded1930a00b2..e3813a7aa5e6 100644
--- a/drivers/s390/net/ctcm_sysfs.c
+++ b/drivers/s390/net/ctcm_sysfs.c
@@ -39,11 +39,12 @@ static ssize_t ctcm_buffer_write(struct device *dev,
 	struct ctcm_priv *priv = dev_get_drvdata(dev);
 	int rc;
 
-	ndev = priv->channel[CTCM_READ]->netdev;
-	if (!(priv && priv->channel[CTCM_READ] && ndev)) {
+	if (!(priv && priv->channel[CTCM_READ] &&
+	      priv->channel[CTCM_READ]->netdev)) {
 		CTCM_DBF_TEXT(SETUP, CTC_DBF_ERROR, "bfnondev");
 		return -ENODEV;
 	}
+	ndev = priv->channel[CTCM_READ]->netdev;
 
 	rc = kstrtouint(buf, 0, &bs1);
 	if (rc)
diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
index d01b5c2a7760..da4d7284db67 100644
--- a/drivers/s390/net/lcs.c
+++ b/drivers/s390/net/lcs.c
@@ -1757,10 +1757,11 @@ lcs_get_control(struct lcs_card *card, struct lcs_cmd *cmd)
 			lcs_schedule_recovery(card);
 			break;
 		case LCS_CMD_STOPLAN:
-			pr_warn("Stoplan for %s initiated by LGW\n",
-				card->dev->name);
-			if (card->dev)
+			if (card->dev) {
+				pr_warn("Stoplan for %s initiated by LGW\n",
+					card->dev->name);
 				netif_carrier_off(card->dev);
+			}
 			break;
 		default:
 			LCS_DBF_TEXT(5, trace, "noLGWcmd");
diff --git a/drivers/tty/serial/digicolor-usart.c b/drivers/tty/serial/digicolor-usart.c
index 50ec5f1ac77f..794864fac625 100644
--- a/drivers/tty/serial/digicolor-usart.c
+++ b/drivers/tty/serial/digicolor-usart.c
@@ -476,10 +476,10 @@ static int digicolor_uart_probe(struct platform_device *pdev)
 		return PTR_ERR(uart_clk);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	dp->port.mapbase = res->start;
 	dp->port.membase = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(dp->port.membase))
 		return PTR_ERR(dp->port.membase);
+	dp->port.mapbase = res->start;
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index ec2de4e448c4..d80718629a76 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -731,6 +731,7 @@ static int wdm_release(struct inode *inode, struct file *file)
 			kill_urbs(desc);
 			spin_lock_irq(&desc->iuspin);
 			desc->resp_count = 0;
+			clear_bit(WDM_RESPONDING, &desc->flags);
 			spin_unlock_irq(&desc->iuspin);
 			desc->manage_power(desc->intf, 0);
 		} else {
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 56564006f738..a58335adab8a 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2125,10 +2125,14 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = RSVD(3) },
 	{ USB_DEVICE(0x1508, 0x1001),						/* Fibocom NL668 (IOT version) */
 	  .driver_info = RSVD(4) | RSVD(5) | RSVD(6) },
+	{ USB_DEVICE(0x1782, 0x4d10) },						/* Fibocom L610 (AT mode) */
+	{ USB_DEVICE_INTERFACE_CLASS(0x1782, 0x4d11, 0xff) },			/* Fibocom L610 (ECM/RNDIS mode) */
 	{ USB_DEVICE(0x2cb7, 0x0104),						/* Fibocom NL678 series */
 	  .driver_info = RSVD(4) | RSVD(5) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0105, 0xff),			/* Fibocom NL678 series */
 	  .driver_info = RSVD(6) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0106, 0xff) },			/* Fibocom MA510 (ECM mode w/ diag intf.) */
+	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x010a, 0xff) },			/* Fibocom MA510 (ECM mode) */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2cb7, 0x010b, 0xff, 0xff, 0x30) },	/* Fibocom FG150 Diag */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2cb7, 0x010b, 0xff, 0, 0) },		/* Fibocom FG150 AT */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a0, 0xff) },			/* Fibocom NL668-AM/NL652-EU (laptop MBIM) */
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 103b77f56aec..80791adab5c4 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -103,6 +103,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LCM220_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LCM960_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LM920_PRODUCT_ID) },
+	{ USB_DEVICE(HP_VENDOR_ID, HP_LM930_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LM940_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_TD620_PRODUCT_ID) },
 	{ USB_DEVICE(CRESSI_VENDOR_ID, CRESSI_EDY_PRODUCT_ID) },
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index c1b93d101990..ddd75529ab46 100644
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -134,6 +134,7 @@
 #define HP_TD620_PRODUCT_ID	0x0956
 #define HP_LD960_PRODUCT_ID	0x0b39
 #define HP_LD381_PRODUCT_ID	0x0f7f
+#define HP_LM930_PRODUCT_ID	0x0f9b
 #define HP_LCM220_PRODUCT_ID	0x3139
 #define HP_LCM960_PRODUCT_ID	0x3239
 #define HP_LD220_PRODUCT_ID	0x3524
diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 8240c95c1d22..f926a0b0b133 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -170,6 +170,8 @@ static const struct usb_device_id id_table[] = {
 	{DEVICE_SWI(0x1199, 0x9090)},	/* Sierra Wireless EM7565 QDL */
 	{DEVICE_SWI(0x1199, 0x9091)},	/* Sierra Wireless EM7565 */
 	{DEVICE_SWI(0x1199, 0x90d2)},	/* Sierra Wireless EM9191 QDL */
+	{DEVICE_SWI(0x1199, 0xc080)},	/* Sierra Wireless EM7590 QDL */
+	{DEVICE_SWI(0x1199, 0xc081)},	/* Sierra Wireless EM7590 */
 	{DEVICE_SWI(0x413c, 0x81a2)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card */
 	{DEVICE_SWI(0x413c, 0x81a3)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card */
 	{DEVICE_SWI(0x413c, 0x81a4)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card */
diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index de123f436f1a..3a308bf98fc3 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -145,7 +145,7 @@ enum {
 #define NETIF_F_HW_ESP_TX_CSUM	__NETIF_F(HW_ESP_TX_CSUM)
 #define	NETIF_F_RX_UDP_TUNNEL_PORT  __NETIF_F(RX_UDP_TUNNEL_PORT)
 
-/* Finds the next feature with the highest number of the range of start till 0.
+/* Finds the next feature with the highest number of the range of start-1 till 0.
  */
 static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 {
@@ -164,7 +164,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 	for ((bit) = find_next_netdev_feature((mask_addr),		\
 					      NETDEV_FEATURE_COUNT);	\
 	     (bit) >= 0;						\
-	     (bit) = find_next_netdev_feature((mask_addr), (bit) - 1))
+	     (bit) = find_next_netdev_feature((mask_addr), (bit)))
 
 /* Features valid for ethtool to change */
 /* = all defined minus driver/device-class-related */
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index bf858e416b5e..0b82e3857d33 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2403,8 +2403,11 @@ static struct notifier_block cpuset_track_online_nodes_nb = {
  */
 void __init cpuset_init_smp(void)
 {
-	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
-	top_cpuset.mems_allowed = node_states[N_MEMORY];
+	/*
+	 * cpus_allowd/mems_allowed set to v2 values in the initial
+	 * cpuset_bind() call will be reset to v1 values in another
+	 * cpuset_bind() call when v1 cpuset is mounted.
+	 */
 	top_cpuset.old_mems_allowed = top_cpuset.mems_allowed;
 
 	cpumask_copy(top_cpuset.effective_cpus, cpu_active_mask);
diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index 4842436c55f3..a50c87329bc5 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -489,6 +489,17 @@ int batadv_frag_send_packet(struct sk_buff *skb,
 		goto free_skb;
 	}
 
+	/* GRO might have added fragments to the fragment list instead of
+	 * frags[]. But this is not handled by skb_split and must be
+	 * linearized to avoid incorrect length information after all
+	 * batman-adv fragments were created and submitted to the
+	 * hard-interface
+	 */
+	if (skb_has_frag_list(skb) && __skb_linearize(skb)) {
+		ret = -ENOMEM;
+		goto free_skb;
+	}
+
 	/* Create one header to be copied to all fragments */
 	frag_header.packet_type = BATADV_UNICAST_FRAG;
 	frag_header.version = BATADV_COMPAT_VERSION;
diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
index 7232274de334..17683aea8a35 100644
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -22,6 +22,8 @@
 static siphash_key_t net_secret __read_mostly;
 static siphash_key_t ts_secret __read_mostly;
 
+#define EPHEMERAL_PORT_SHUFFLE_PERIOD (10 * HZ)
+
 static __always_inline void net_secret_init(void)
 {
 	net_get_random_once(&net_secret, sizeof(net_secret));
@@ -100,11 +102,13 @@ u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
 	const struct {
 		struct in6_addr saddr;
 		struct in6_addr daddr;
+		unsigned int timeseed;
 		__be16 dport;
 	} __aligned(SIPHASH_ALIGNMENT) combined = {
 		.saddr = *(struct in6_addr *)saddr,
 		.daddr = *(struct in6_addr *)daddr,
-		.dport = dport
+		.timeseed = jiffies / EPHEMERAL_PORT_SHUFFLE_PERIOD,
+		.dport = dport,
 	};
 	net_secret_init();
 	return siphash(&combined, offsetofend(typeof(combined), dport),
@@ -144,8 +148,10 @@ u32 secure_tcp_seq(__be32 saddr, __be32 daddr,
 u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
 {
 	net_secret_init();
-	return siphash_3u32((__force u32)saddr, (__force u32)daddr,
-			    (__force u16)dport, &net_secret);
+	return siphash_4u32((__force u32)saddr, (__force u32)daddr,
+			    (__force u16)dport,
+			    jiffies / EPHEMERAL_PORT_SHUFFLE_PERIOD,
+			    &net_secret);
 }
 EXPORT_SYMBOL_GPL(secure_ipv4_port_ephemeral);
 #endif
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 0dd5ca2004c7..ec725b460ad6 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -309,6 +309,7 @@ static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
 	struct net *net = sock_net(sk);
 	if (sk->sk_family == AF_INET) {
 		struct sockaddr_in *addr = (struct sockaddr_in *) uaddr;
+		u32 tb_id = RT_TABLE_LOCAL;
 		int chk_addr_ret;
 
 		if (addr_len < sizeof(*addr))
@@ -322,7 +323,8 @@ static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
 		pr_debug("ping_check_bind_addr(sk=%p,addr=%pI4,port=%d)\n",
 			 sk, &addr->sin_addr.s_addr, ntohs(addr->sin_port));
 
-		chk_addr_ret = inet_addr_type(net, addr->sin_addr.s_addr);
+		tb_id = l3mdev_fib_table_by_index(net, sk->sk_bound_dev_if) ? : tb_id;
+		chk_addr_ret = inet_addr_type_table(net, addr->sin_addr.s_addr, tb_id);
 
 		if (addr->sin_addr.s_addr == htonl(INADDR_ANY))
 			chk_addr_ret = RTN_LOCAL;
@@ -364,6 +366,14 @@ static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
 				return -ENODEV;
 			}
 		}
+
+		if (!dev && sk->sk_bound_dev_if) {
+			dev = dev_get_by_index_rcu(net, sk->sk_bound_dev_if);
+			if (!dev) {
+				rcu_read_unlock();
+				return -ENODEV;
+			}
+		}
 		has_addr = pingv6_ops.ipv6_chk_addr(net, &addr->sin6_addr, dev,
 						    scoped);
 		rcu_read_unlock();
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 34cf572cc5dc..52c4098e1deb 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1697,6 +1697,7 @@ static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 #endif
 	RT_CACHE_STAT_INC(in_slow_mc);
 
+	skb_dst_drop(skb);
 	skb_dst_set(skb, &rth->dst);
 	return 0;
 }
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 979cd7dff40a..1b2e99ce54e5 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1947,7 +1947,6 @@ static int netlink_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		copied = len;
 	}
 
-	skb_reset_transport_header(data_skb);
 	err = skb_copy_datagram_msg(data_skb, 0, msg, copied);
 
 	if (msg->msg_name) {
diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index cbf58637ee14..0d5146d6d105 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -145,12 +145,12 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg, size_t len,
 				}
 				break;
 			}
+			if (!timeo)
+				return -EAGAIN;
 			if (signal_pending(current)) {
 				read_done = sock_intr_errno(timeo);
 				break;
 			}
-			if (!timeo)
-				return -EAGAIN;
 		}
 
 		if (!atomic_read(&conn->bytes_to_rcv)) {
diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 3fe09828745a..362d1fb2aae9 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -419,6 +419,9 @@ static int max98090_put_enab_tlv(struct snd_kcontrol *kcontrol,
 
 	val = (val >> mc->shift) & mask;
 
+	if (sel < 0 || sel > mc->max)
+		return -EINVAL;
+
 	*select = sel;
 
 	/* Setting a volume is only valid if it is already On */
@@ -433,7 +436,7 @@ static int max98090_put_enab_tlv(struct snd_kcontrol *kcontrol,
 		mask << mc->shift,
 		sel << mc->shift);
 
-	return 0;
+	return *select != val;
 }
 
 static const char *max98090_perf_pwr_text[] =
diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index d6d72595fbd0..0848aec1bd24 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -528,7 +528,15 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 	unsigned int mask = (1 << fls(max)) - 1;
 	unsigned int invert = mc->invert;
 	unsigned int val, val_mask;
-	int err, ret;
+	int err, ret, tmp;
+
+	tmp = ucontrol->value.integer.value[0];
+	if (tmp < 0)
+		return -EINVAL;
+	if (mc->platform_max && tmp > mc->platform_max)
+		return -EINVAL;
+	if (tmp > mc->max - mc->min + 1)
+		return -EINVAL;
 
 	if (invert)
 		val = (max - ucontrol->value.integer.value[0]) & mask;
@@ -543,6 +551,14 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 	ret = err;
 
 	if (snd_soc_volsw_is_stereo(mc)) {
+		tmp = ucontrol->value.integer.value[1];
+		if (tmp < 0)
+			return -EINVAL;
+		if (mc->platform_max && tmp > mc->platform_max)
+			return -EINVAL;
+		if (tmp > mc->max - mc->min + 1)
+			return -EINVAL;
+
 		if (invert)
 			val = (max - ucontrol->value.integer.value[1]) & mask;
 		else

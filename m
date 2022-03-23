Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4594E4E27
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 09:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242564AbiCWI2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 04:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242660AbiCWI2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 04:28:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7EC7520D;
        Wed, 23 Mar 2022 01:26:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 78FBFCE1F00;
        Wed, 23 Mar 2022 08:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582D2C340EE;
        Wed, 23 Mar 2022 08:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648024003;
        bh=+fNBiL6249JvbUqjagWMqFdJftyuKQ5Wj87sCsU2IVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SyR0XykyrK+QUzgdb3xeVrxYdyw28goXBUHURVh3ksEEiKFpzR9F2z0/ZU+U5+8J7
         rwMAPh7uZJdkiL6jJ0nMxMYHhce0/3Pz9hdgjA1akiLH2zspx0X1FzAxuidKwOX5W8
         AB3mys/vpvPqEOQ1GYh/pSRBIXIEunsGJuGsHELU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.9.308
Date:   Wed, 23 Mar 2022 09:26:35 +0100
Message-Id: <1648023995219199@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <164802399518826@kroah.com>
References: <164802399518826@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 19363e65ef22..ecf06e17c3c8 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 4
 PATCHLEVEL = 9
-SUBLEVEL = 307
+SUBLEVEL = 308
 EXTRAVERSION =
 NAME = Roaring Lionus
 
diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 7b727d738b69..4702aa980ef8 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -918,7 +918,7 @@
 		status = "disabled";
 	};
 
-	crypto: cypto-controller@ff8a0000 {
+	crypto: crypto@ff8a0000 {
 		compatible = "rockchip,rk3288-crypto";
 		reg = <0xff8a0000 0x4000>;
 		interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 95ba4271af6a..01aa8d6da4b9 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -369,6 +369,9 @@ asmlinkage void start_secondary(void)
 	cpu = smp_processor_id();
 	cpu_data[cpu].udelay_val = loops_per_jiffy;
 
+	set_cpu_sibling_map(cpu);
+	set_cpu_core_map(cpu);
+
 	cpumask_set_cpu(cpu, &cpu_coherent_mask);
 	notify_cpu_starting(cpu);
 
@@ -380,9 +383,6 @@ asmlinkage void start_secondary(void)
 	/* The CPU is running and counters synchronised, now mark it online */
 	set_cpu_online(cpu, true);
 
-	set_cpu_sibling_map(cpu);
-	set_cpu_core_map(cpu);
-
 	calculate_cpu_foreign_map();
 
 	/*
diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 2b7786cd548f..0ec52fb2b7fc 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -1114,6 +1114,8 @@ DPRINTK("iovcnt = %d\n",skb_shinfo(skb)->nr_frags);
 	}
 	paddr = dma_map_single(&eni_dev->pci_dev->dev,skb->data,skb->len,
 			       DMA_TO_DEVICE);
+	if (dma_mapping_error(&eni_dev->pci_dev->dev, paddr))
+		return enq_next;
 	ENI_PRV_PADDR(skb) = paddr;
 	/* prepare DMA queue entries */
 	j = 0;
diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index 7cb2b863e653..7d74b7e1a837 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -1692,6 +1692,8 @@ static int fs_init(struct fs_dev *dev)
 	dev->hw_base = pci_resource_start(pci_dev, 0);
 
 	dev->base = ioremap(dev->hw_base, 0x1000);
+	if (!dev->base)
+		return 1;
 
 	reset_chip (dev);
   
diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index 5a7e5e073e52..58c0705470be 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -1821,15 +1821,13 @@ aiptek_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	input_set_abs_params(inputdev, ABS_TILT_Y, AIPTEK_TILT_MIN, AIPTEK_TILT_MAX, 0, 0);
 	input_set_abs_params(inputdev, ABS_WHEEL, AIPTEK_WHEEL_MIN, AIPTEK_WHEEL_MAX - 1, 0, 0);
 
-	/* Verify that a device really has an endpoint */
-	if (intf->cur_altsetting->desc.bNumEndpoints < 1) {
+	err = usb_find_common_endpoints(intf->cur_altsetting,
+					NULL, NULL, &endpoint, NULL);
+	if (err) {
 		dev_err(&intf->dev,
-			"interface has %d endpoints, but must have minimum 1\n",
-			intf->cur_altsetting->desc.bNumEndpoints);
-		err = -EINVAL;
+			"interface has no int in endpoints, but must have minimum 1\n");
 		goto fail3;
 	}
-	endpoint = &intf->cur_altsetting->endpoint[0].desc;
 
 	/* Go set up our URB, which is called when the tablet receives
 	 * input.
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 43cdd5544b0c..a127c853a4e9 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1601,15 +1601,15 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 
 	netif_napi_add(ndev, &priv->napi, rcar_canfd_rx_poll,
 		       RCANFD_NAPI_WEIGHT);
+	spin_lock_init(&priv->tx_lock);
+	devm_can_led_init(ndev);
+	gpriv->ch[priv->channel] = priv;
 	err = register_candev(ndev);
 	if (err) {
 		dev_err(&pdev->dev,
 			"register_candev() failed, error %d\n", err);
 		goto fail_candev;
 	}
-	spin_lock_init(&priv->tx_lock);
-	devm_can_led_init(ndev);
-	gpriv->ch[priv->channel] = priv;
 	dev_info(&pdev->dev, "device registered (channel %u)\n", priv->channel);
 	return 0;
 
diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index 241520943ada..221798499e24 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -162,9 +162,9 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
 	/* Serialise with efx_mcdi_ev_cpl() and efx_mcdi_ev_death() */
 	spin_lock_bh(&mcdi->iface_lock);
 	++mcdi->seqno;
+	seqno = mcdi->seqno & SEQ_MASK;
 	spin_unlock_bh(&mcdi->iface_lock);
 
-	seqno = mcdi->seqno & SEQ_MASK;
 	xflags = 0;
 	if (mcdi->mode == MCDI_MODE_EVENTS)
 		xflags |= MCDI_HEADER_XFLAGS_EVREQ;
diff --git a/drivers/usb/gadget/function/rndis.c b/drivers/usb/gadget/function/rndis.c
index 1e5c2cbe9994..30eeaf9bc8ec 100644
--- a/drivers/usb/gadget/function/rndis.c
+++ b/drivers/usb/gadget/function/rndis.c
@@ -645,6 +645,7 @@ static int rndis_set_response(struct rndis_params *params,
 	BufLength = le32_to_cpu(buf->InformationBufferLength);
 	BufOffset = le32_to_cpu(buf->InformationBufferOffset);
 	if ((BufLength > RNDIS_MAX_TOTAL_SIZE) ||
+	    (BufOffset > RNDIS_MAX_TOTAL_SIZE) ||
 	    (BufOffset + 8 >= RNDIS_MAX_TOTAL_SIZE))
 		    return -EINVAL;
 
diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index 34ad964d54d1..5d8c3fd2acc8 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1253,7 +1253,6 @@ static void usb_gadget_remove_driver(struct usb_udc *udc)
 	usb_gadget_udc_stop(udc);
 
 	udc->driver = NULL;
-	udc->dev.driver = NULL;
 	udc->gadget->dev.driver = NULL;
 }
 
@@ -1301,7 +1300,6 @@ static int udc_bind_to_driver(struct usb_udc *udc, struct usb_gadget_driver *dri
 			driver->function);
 
 	udc->driver = driver;
-	udc->dev.driver = &driver->driver;
 	udc->gadget->dev.driver = &driver->driver;
 
 	ret = driver->bind(udc->gadget, driver);
@@ -1321,7 +1319,6 @@ static int udc_bind_to_driver(struct usb_udc *udc, struct usb_gadget_driver *dri
 		dev_err(&udc->dev, "failed to start %s: %d\n",
 			udc->driver->function, ret);
 	udc->driver = NULL;
-	udc->dev.driver = NULL;
 	udc->gadget->dev.driver = NULL;
 	return ret;
 }
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 300cdbdc8494..c41e7f51150f 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -565,8 +565,7 @@ int sysfs_emit(char *buf, const char *fmt, ...)
 	va_list args;
 	int len;
 
-	if (WARN(!buf || offset_in_page(buf),
-		 "invalid sysfs_emit: buf:%p\n", buf))
+	if (WARN(!buf, "invalid sysfs_emit: buf:%p\n", buf))
 		return 0;
 
 	va_start(args, fmt);
diff --git a/lib/Kconfig b/lib/Kconfig
index 260a80e313b9..600759707ffe 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -16,7 +16,6 @@ config BITREVERSE
 config HAVE_ARCH_BITREVERSE
 	bool
 	default n
-	depends on BITREVERSE
 	help
 	  This option enables the use of hardware bit-reversal instructions on
 	  architectures which support such operations.
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index aeda018e4c49..6dfb964e1ad8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1561,11 +1561,13 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 				if (!copied)
 					copied = used;
 				break;
-			} else if (used <= len) {
-				seq += used;
-				copied += used;
-				offset += used;
 			}
+			if (WARN_ON_ONCE(used > len))
+				used = len;
+			seq += used;
+			copied += used;
+			offset += used;
+
 			/* If recv_actor drops the lock (e.g. TCP splice
 			 * receive) the skb pointer might be invalid when
 			 * getting here: tcp_collapse might have deleted it
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 8e62b05efe29..e79d6881a97e 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2244,8 +2244,11 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 					copy_skb = skb_get(skb);
 					skb_head = skb->data;
 				}
-				if (copy_skb)
+				if (copy_skb) {
+					memset(&PACKET_SKB_CB(copy_skb)->sa.ll, 0,
+					       sizeof(PACKET_SKB_CB(copy_skb)->sa.ll));
 					skb_set_owner_r(copy_skb, sk);
+				}
 			}
 			snaplen = po->rx_ring.frame_size - macoff;
 			if ((int)snaplen < 0) {
@@ -3422,6 +3425,8 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	sock_recv_ts_and_drops(msg, sk, skb);
 
 	if (msg->msg_name) {
+		const size_t max_len = min(sizeof(skb->cb),
+					   sizeof(struct sockaddr_storage));
 		int copy_len;
 
 		/* If the address length field is there to be filled
@@ -3444,6 +3449,10 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 				msg->msg_namelen = sizeof(struct sockaddr_ll);
 			}
 		}
+		if (WARN_ON_ONCE(copy_len > max_len)) {
+			copy_len = max_len;
+			msg->msg_namelen = copy_len;
+		}
 		memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa, copy_len);
 	}
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ab8bca39afa3..562e138deba2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14068,7 +14068,8 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 	wdev->chandef = *chandef;
 	wdev->preset_chandef = *chandef;
 
-	if (wdev->iftype == NL80211_IFTYPE_STATION &&
+	if ((wdev->iftype == NL80211_IFTYPE_STATION ||
+	     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT) &&
 	    !WARN_ON(!wdev->current_bss))
 		wdev->current_bss->pub.channel = chandef->chan;
 
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 4d19f2ff6e05..73b4e7c0d336 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1238,9 +1238,6 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig)
 
 	memcpy(&x->mark, &orig->mark, sizeof(x->mark));
 
-	if (xfrm_init_state(x) < 0)
-		goto error;
-
 	x->props.flags = orig->props.flags;
 	x->props.extra_flags = orig->props.extra_flags;
 
@@ -1317,6 +1314,11 @@ struct xfrm_state *xfrm_state_migrate(struct xfrm_state *x,
 	if (!xc)
 		return NULL;
 
+	xc->props.family = m->new_family;
+
+	if (xfrm_init_state(xc) < 0)
+		goto error;
+
 	memcpy(&xc->id.daddr, &m->new_daddr, sizeof(xc->id.daddr));
 	memcpy(&xc->props.saddr, &m->new_saddr, sizeof(xc->props.saddr));
 
diff --git a/tools/testing/selftests/vm/userfaultfd.c b/tools/testing/selftests/vm/userfaultfd.c
index d77ed41b2094..1f89d3dd8295 100644
--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -60,6 +60,7 @@
 #include <signal.h>
 #include <poll.h>
 #include <string.h>
+#include <linux/mman.h>
 #include <sys/mman.h>
 #include <sys/syscall.h>
 #include <sys/ioctl.h>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC33C4E4E2B
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 09:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242681AbiCWI2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 04:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242663AbiCWI2f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 04:28:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4785F7522F;
        Wed, 23 Mar 2022 01:26:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF9CE615DD;
        Wed, 23 Mar 2022 08:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CE1C340E8;
        Wed, 23 Mar 2022 08:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648024015;
        bh=GDQ6vLwtjt07ELv+nDOiu6ddIEAsgQFXXKNW5X1IOMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TkCXBZ7g28q2mjuHhbzo7dWMYviOM2SrTqafytvOkpS0XnqvePeV/woWKAI4LWqOB
         xNCqxYrtjYu+Aoy4mM69FXjChQcYmulYm759Z/N8ge7K/+VM3qq/ipKdJ1mZpFPZw2
         QZzDYnJkQESoAsSre7G30ZD8GHN64hzAOXzNwBPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.273
Date:   Wed, 23 Mar 2022 09:26:40 +0100
Message-Id: <164802400040226@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <1648024000180248@kroah.com>
References: <1648024000180248@kroah.com>
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
index f683ed316664..bc909859dd8b 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 272
+SUBLEVEL = 273
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 9adb58930c08..872e4e690beb 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -943,7 +943,7 @@
 		status = "disabled";
 	};
 
-	crypto: cypto-controller@ff8a0000 {
+	crypto: crypto@ff8a0000 {
 		compatible = "rockchip,rk3288-crypto";
 		reg = <0x0 0xff8a0000 0x0 0x4000>;
 		interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
index 0d5679380b2a..70fe6013d17c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -484,6 +484,12 @@
 };
 
 &sdhci {
+	/*
+	 * Signal integrity isn't great at 200MHz but 100MHz has proven stable
+	 * enough.
+	 */
+	max-frequency = <100000000>;
+
 	bus-width = <8>;
 	mmc-hs400-1_8v;
 	mmc-hs400-enhanced-strobe;
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 88be966d3e61..f057b0c34844 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -372,6 +372,9 @@ asmlinkage void start_secondary(void)
 	cpu = smp_processor_id();
 	cpu_data[cpu].udelay_val = loops_per_jiffy;
 
+	set_cpu_sibling_map(cpu);
+	set_cpu_core_map(cpu);
+
 	cpumask_set_cpu(cpu, &cpu_coherent_mask);
 	notify_cpu_starting(cpu);
 
@@ -383,9 +386,6 @@ asmlinkage void start_secondary(void)
 	/* The CPU is running and counters synchronised, now mark it online */
 	set_cpu_online(cpu, true);
 
-	set_cpu_sibling_map(cpu);
-	set_cpu_core_map(cpu);
-
 	calculate_cpu_foreign_map();
 
 	/*
diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index ffe519663687..e88fad45241f 100644
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
index e7cffd0cc361..3557ff9ecd82 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -1692,6 +1692,8 @@ static int fs_init(struct fs_dev *dev)
 	dev->hw_base = pci_resource_start(pci_dev, 0);
 
 	dev->base = ioremap(dev->hw_base, 0x1000);
+	if (!dev->base)
+		return 1;
 
 	reset_chip (dev);
   
diff --git a/drivers/firmware/efi/apple-properties.c b/drivers/firmware/efi/apple-properties.c
index 9f6bcf173b0e..aa42d228762f 100644
--- a/drivers/firmware/efi/apple-properties.c
+++ b/drivers/firmware/efi/apple-properties.c
@@ -30,7 +30,7 @@ static bool dump_properties __initdata;
 static int __init dump_properties_enable(char *arg)
 {
 	dump_properties = true;
-	return 0;
+	return 1;
 }
 
 __setup("dump_apple_properties", dump_properties_enable);
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index a3dc6cb7326a..24365601fbbf 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -230,7 +230,7 @@ static int __init efivar_ssdt_setup(char *str)
 		memcpy(efivar_ssdt, str, strlen(str));
 	else
 		pr_warn("efivar_ssdt: name too long: %s\n", str);
-	return 0;
+	return 1;
 }
 __setup("efivar_ssdt=", efivar_ssdt_setup);
 
diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index fbe2df91aad3..2159ec69e223 100644
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
index 786d852a70d5..a1634834b640 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1602,15 +1602,15 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 
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
index 3df872f56289..040b52affe19 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -167,9 +167,9 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
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
index 55be224b64a4..b6c707246dad 100644
--- a/drivers/usb/gadget/function/rndis.c
+++ b/drivers/usb/gadget/function/rndis.c
@@ -643,6 +643,7 @@ static int rndis_set_response(struct rndis_params *params,
 	BufLength = le32_to_cpu(buf->InformationBufferLength);
 	BufOffset = le32_to_cpu(buf->InformationBufferOffset);
 	if ((BufLength > RNDIS_MAX_TOTAL_SIZE) ||
+	    (BufOffset > RNDIS_MAX_TOTAL_SIZE) ||
 	    (BufOffset + 8 >= RNDIS_MAX_TOTAL_SIZE))
 		    return -EINVAL;
 
diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index db7c8aec23fc..b60c4527ff67 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1284,7 +1284,6 @@ static void usb_gadget_remove_driver(struct usb_udc *udc)
 	usb_gadget_udc_stop(udc);
 
 	udc->driver = NULL;
-	udc->dev.driver = NULL;
 	udc->gadget->dev.driver = NULL;
 }
 
@@ -1333,7 +1332,6 @@ static int udc_bind_to_driver(struct usb_udc *udc, struct usb_gadget_driver *dri
 			driver->function);
 
 	udc->driver = driver;
-	udc->dev.driver = &driver->driver;
 	udc->gadget->dev.driver = &driver->driver;
 
 	usb_gadget_udc_set_speed(udc, driver->max_speed);
@@ -1355,7 +1353,6 @@ static int udc_bind_to_driver(struct usb_udc *udc, struct usb_gadget_driver *dri
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
diff --git a/include/linux/if_arp.h b/include/linux/if_arp.h
index 4125f60ee53b..a9b09c7c2ce0 100644
--- a/include/linux/if_arp.h
+++ b/include/linux/if_arp.h
@@ -55,6 +55,7 @@ static inline bool dev_is_mac_header_xmit(const struct net_device *dev)
 	case ARPHRD_VOID:
 	case ARPHRD_NONE:
 	case ARPHRD_RAWIP:
+	case ARPHRD_PIMREG:
 		return false;
 	default:
 		return true;
diff --git a/lib/Kconfig b/lib/Kconfig
index 8396c4cfa1ab..1a33e9365951 100644
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
index c9f6f28e54f3..a0fd9ef2d2c6 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1657,11 +1657,13 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
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
index 1381bfcb3cf0..92394595920c 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2285,8 +2285,11 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
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
@@ -3442,6 +3445,8 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	sock_recv_ts_and_drops(msg, sk, skb);
 
 	if (msg->msg_name) {
+		const size_t max_len = min(sizeof(skb->cb),
+					   sizeof(struct sockaddr_storage));
 		int copy_len;
 
 		/* If the address length field is there to be filled
@@ -3464,6 +3469,10 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 				msg->msg_namelen = sizeof(struct sockaddr_ll);
 			}
 		}
+		if (WARN_ON_ONCE(copy_len > max_len)) {
+			copy_len = max_len;
+			msg->msg_namelen = copy_len;
+		}
 		memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa, copy_len);
 	}
 
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index b26067798dbf..03434e7295eb 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -161,6 +161,12 @@ static enum sctp_disposition __sctp_sf_do_9_1_abort(
 					void *arg,
 					struct sctp_cmd_seq *commands);
 
+static enum sctp_disposition
+__sctp_sf_do_9_2_reshutack(struct net *net, const struct sctp_endpoint *ep,
+			   const struct sctp_association *asoc,
+			   const union sctp_subtype type, void *arg,
+			   struct sctp_cmd_seq *commands);
+
 /* Small helper function that checks if the chunk length
  * is of the appropriate length.  The 'required_length' argument
  * is set to be the size of a specific chunk we are testing.
@@ -337,6 +343,14 @@ enum sctp_disposition sctp_sf_do_5_1B_init(struct net *net,
 	if (!chunk->singleton)
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
+	/* Make sure that the INIT chunk has a valid length.
+	 * Normally, this would cause an ABORT with a Protocol Violation
+	 * error, but since we don't have an association, we'll
+	 * just discard the packet.
+	 */
+	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_init_chunk)))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* If the packet is an OOTB packet which is temporarily on the
 	 * control endpoint, respond with an ABORT.
 	 */
@@ -351,14 +365,6 @@ enum sctp_disposition sctp_sf_do_5_1B_init(struct net *net,
 	if (chunk->sctp_hdr->vtag != 0)
 		return sctp_sf_tabort_8_4_8(net, ep, asoc, type, arg, commands);
 
-	/* Make sure that the INIT chunk has a valid length.
-	 * Normally, this would cause an ABORT with a Protocol Violation
-	 * error, but since we don't have an association, we'll
-	 * just discard the packet.
-	 */
-	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_init_chunk)))
-		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
-
 	/* If the INIT is coming toward a closing socket, we'll send back
 	 * and ABORT.  Essentially, this catches the race of INIT being
 	 * backloged to the socket at the same time as the user isses close().
@@ -1460,19 +1466,16 @@ static enum sctp_disposition sctp_sf_do_unexpected_init(
 	if (!chunk->singleton)
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
+	/* Make sure that the INIT chunk has a valid length. */
+	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_init_chunk)))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* 3.1 A packet containing an INIT chunk MUST have a zero Verification
 	 * Tag.
 	 */
 	if (chunk->sctp_hdr->vtag != 0)
 		return sctp_sf_tabort_8_4_8(net, ep, asoc, type, arg, commands);
 
-	/* Make sure that the INIT chunk has a valid length.
-	 * In this case, we generate a protocol violation since we have
-	 * an association established.
-	 */
-	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_init_chunk)))
-		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
-						  commands);
 	/* Grab the INIT header.  */
 	chunk->subh.init_hdr = (struct sctp_inithdr *)chunk->skb->data;
 
@@ -1787,9 +1790,9 @@ static enum sctp_disposition sctp_sf_do_dupcook_a(
 	 * its peer.
 	*/
 	if (sctp_state(asoc, SHUTDOWN_ACK_SENT)) {
-		disposition = sctp_sf_do_9_2_reshutack(net, ep, asoc,
-				SCTP_ST_CHUNK(chunk->chunk_hdr->type),
-				chunk, commands);
+		disposition = __sctp_sf_do_9_2_reshutack(net, ep, asoc,
+							 SCTP_ST_CHUNK(chunk->chunk_hdr->type),
+							 chunk, commands);
 		if (SCTP_DISPOSITION_NOMEM == disposition)
 			goto nomem;
 
@@ -2218,7 +2221,7 @@ enum sctp_disposition sctp_sf_shutdown_pending_abort(
 	 */
 	if (SCTP_ADDR_DEL ==
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	if (!sctp_err_chunk_valid(chunk))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -2264,7 +2267,7 @@ enum sctp_disposition sctp_sf_shutdown_sent_abort(
 	 */
 	if (SCTP_ADDR_DEL ==
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	if (!sctp_err_chunk_valid(chunk))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -2534,7 +2537,7 @@ enum sctp_disposition sctp_sf_do_9_1_abort(
 	 */
 	if (SCTP_ADDR_DEL ==
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	if (!sctp_err_chunk_valid(chunk))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -2847,13 +2850,11 @@ enum sctp_disposition sctp_sf_do_9_2_shut_ctsn(
  * that belong to this association, it should discard the INIT chunk and
  * retransmit the SHUTDOWN ACK chunk.
  */
-enum sctp_disposition sctp_sf_do_9_2_reshutack(
-					struct net *net,
-					const struct sctp_endpoint *ep,
-					const struct sctp_association *asoc,
-					const union sctp_subtype type,
-					void *arg,
-					struct sctp_cmd_seq *commands)
+static enum sctp_disposition
+__sctp_sf_do_9_2_reshutack(struct net *net, const struct sctp_endpoint *ep,
+			   const struct sctp_association *asoc,
+			   const union sctp_subtype type, void *arg,
+			   struct sctp_cmd_seq *commands)
 {
 	struct sctp_chunk *chunk = arg;
 	struct sctp_chunk *reply;
@@ -2887,6 +2888,26 @@ enum sctp_disposition sctp_sf_do_9_2_reshutack(
 	return SCTP_DISPOSITION_NOMEM;
 }
 
+enum sctp_disposition
+sctp_sf_do_9_2_reshutack(struct net *net, const struct sctp_endpoint *ep,
+			 const struct sctp_association *asoc,
+			 const union sctp_subtype type, void *arg,
+			 struct sctp_cmd_seq *commands)
+{
+	struct sctp_chunk *chunk = arg;
+
+	if (!chunk->singleton)
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
+	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_init_chunk)))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
+	if (chunk->sctp_hdr->vtag != 0)
+		return sctp_sf_tabort_8_4_8(net, ep, asoc, type, arg, commands);
+
+	return __sctp_sf_do_9_2_reshutack(net, ep, asoc, type, arg, commands);
+}
+
 /*
  * sctp_sf_do_ecn_cwr
  *
@@ -3681,6 +3702,11 @@ enum sctp_disposition sctp_sf_do_asconf(struct net *net,
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
 
+	/* Make sure that the ASCONF ADDIP chunk has a valid length.  */
+	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_addip_chunk)))
+		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
+						  commands);
+
 	/* ADD-IP: Section 4.1.1
 	 * This chunk MUST be sent in an authenticated way by using
 	 * the mechanism defined in [I-D.ietf-tsvwg-sctp-auth]. If this chunk
@@ -3688,13 +3714,7 @@ enum sctp_disposition sctp_sf_do_asconf(struct net *net,
 	 * described in [I-D.ietf-tsvwg-sctp-auth].
 	 */
 	if (!net->sctp.addip_noauth && !chunk->auth)
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg,
-					     commands);
-
-	/* Make sure that the ASCONF ADDIP chunk has a valid length.  */
-	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_addip_chunk)))
-		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
-						  commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	hdr = (struct sctp_addiphdr *)chunk->skb->data;
 	serial = ntohl(hdr->serial);
@@ -3823,6 +3843,12 @@ enum sctp_disposition sctp_sf_do_asconf_ack(struct net *net,
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
 
+	/* Make sure that the ADDIP chunk has a valid length.  */
+	if (!sctp_chunk_length_valid(asconf_ack,
+				     sizeof(struct sctp_addip_chunk)))
+		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
+						  commands);
+
 	/* ADD-IP, Section 4.1.2:
 	 * This chunk MUST be sent in an authenticated way by using
 	 * the mechanism defined in [I-D.ietf-tsvwg-sctp-auth]. If this chunk
@@ -3830,14 +3856,7 @@ enum sctp_disposition sctp_sf_do_asconf_ack(struct net *net,
 	 * described in [I-D.ietf-tsvwg-sctp-auth].
 	 */
 	if (!net->sctp.addip_noauth && !asconf_ack->auth)
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg,
-					     commands);
-
-	/* Make sure that the ADDIP chunk has a valid length.  */
-	if (!sctp_chunk_length_valid(asconf_ack,
-				     sizeof(struct sctp_addip_chunk)))
-		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
-						  commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	addip_hdr = (struct sctp_addiphdr *)asconf_ack->skb->data;
 	rcvd_serial = ntohl(addip_hdr->serial);
@@ -4414,6 +4433,9 @@ enum sctp_disposition sctp_sf_discard_chunk(struct net *net,
 {
 	struct sctp_chunk *chunk = arg;
 
+	if (asoc && !sctp_vtag_verify(chunk, asoc))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* Make sure that the chunk has a valid length.
 	 * Since we don't know the chunk type, we use a general
 	 * chunkhdr structure to make a comparison.
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bbc3c876a5d8..7085c54e6e50 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14777,7 +14777,8 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 	wdev->chandef = *chandef;
 	wdev->preset_chandef = *chandef;
 
-	if (wdev->iftype == NL80211_IFTYPE_STATION &&
+	if ((wdev->iftype == NL80211_IFTYPE_STATION ||
+	     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT) &&
 	    !WARN_ON(!wdev->current_bss))
 		wdev->current_bss->pub.channel = chandef->chan;
 
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 5164dfe0aa09..2c17fbdd2366 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1421,9 +1421,6 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 
 	memcpy(&x->mark, &orig->mark, sizeof(x->mark));
 
-	if (xfrm_init_state(x) < 0)
-		goto error;
-
 	x->props.flags = orig->props.flags;
 	x->props.extra_flags = orig->props.extra_flags;
 
@@ -1501,6 +1498,11 @@ struct xfrm_state *xfrm_state_migrate(struct xfrm_state *x,
 	if (!xc)
 		return NULL;
 
+	xc->props.family = m->new_family;
+
+	if (xfrm_init_state(xc) < 0)
+		goto error;
+
 	memcpy(&xc->id.daddr, &m->new_daddr, sizeof(xc->id.daddr));
 	memcpy(&xc->props.saddr, &m->new_saddr, sizeof(xc->props.saddr));
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index dea6f15af485..ba881aedbedd 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -224,7 +224,7 @@ void symbols__fixup_end(struct rb_root *symbols)
 		prev = curr;
 		curr = rb_entry(nd, struct symbol, rb_node);
 
-		if (prev->end == prev->start && prev->end != curr->start)
+		if (prev->end == prev->start || prev->end != curr->start)
 			arch__symbols__fixup_end(prev, curr);
 	}
 
diff --git a/tools/testing/selftests/vm/userfaultfd.c b/tools/testing/selftests/vm/userfaultfd.c
index 1963440f6725..b2c7043c0c30 100644
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

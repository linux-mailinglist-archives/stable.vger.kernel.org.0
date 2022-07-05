Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1134566AE2
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbiGEMC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbiGEMCL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:02:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6574183A9;
        Tue,  5 Jul 2022 05:01:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 651D1B817E0;
        Tue,  5 Jul 2022 12:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEF3C341C7;
        Tue,  5 Jul 2022 12:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022516;
        bh=2SjUKnBlYMObbRagry9lnHLHmnLWtnfuV+FAe2s+P9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TLML7HH+RuQ17vjPZ6wZxXCg3+gYS998a/jU+m84rSVRZntRMA6gR3RkF/rmktE9U
         1pBDgpAYJu19/el9Ro5su2CQiTGNtJIOrWB5BttLsXUfgxpYwucT+zYAweQxD9KrND
         nf7PdxICYO2EKe/uex9ScuiYu2BH370n5t1owEYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jose Alonso <joalonsof@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 4.14 07/29] net: usb: ax88179_178a: Fix packet receiving
Date:   Tue,  5 Jul 2022 13:57:55 +0200
Message-Id: <20220705115606.559918641@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115606.333669144@linuxfoundation.org>
References: <20220705115606.333669144@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jose Alonso <joalonsof@gmail.com>

commit f8ebb3ac881b17712e1d5967c97ab1806b16d3d6 upstream.

This patch corrects packet receiving in ax88179_rx_fixup.

- problem observed:
  ifconfig shows allways a lot of 'RX Errors' while packets
  are received normally.

  This occurs because ax88179_rx_fixup does not recognise properly
  the usb urb received.
  The packets are normally processed and at the end, the code exits
  with 'return 0', generating RX Errors.
  (pkt_cnt==-2 and ptk_hdr over field rx_hdr trying to identify
   another packet there)

  This is a usb urb received by "tcpdump -i usbmon2 -X" on a
  little-endian CPU:
  0x0000:  eeee f8e3 3b19 87a0 94de 80e3 daac 0800
           ^         packet 1 start (pkt_len = 0x05ec)
           ^^^^      IP alignment pseudo header
                ^    ethernet packet start
           last byte ethernet packet   v
           padding (8-bytes aligned)     vvvv vvvv
  0x05e0:  c92d d444 1420 8a69 83dd 272f e82b 9811
  0x05f0:  eeee f8e3 3b19 87a0 94de 80e3 daac 0800
  ...      ^ packet 2
  0x0be0:  eeee f8e3 3b19 87a0 94de 80e3 daac 0800
  ...
  0x1130:  9d41 9171 8a38 0ec5 eeee f8e3 3b19 87a0
  ...
  0x1720:  8cfc 15ff 5e4c e85c eeee f8e3 3b19 87a0
  ...
  0x1d10:  ecfa 2a3a 19ab c78c eeee f8e3 3b19 87a0
  ...
  0x2070:  eeee f8e3 3b19 87a0 94de 80e3 daac 0800
  ...      ^ packet 7
  0x2120:  7c88 4ca5 5c57 7dcc 0d34 7577 f778 7e0a
  0x2130:  f032 e093 7489 0740 3008 ec05 0000 0080
                               ====1==== ====2====
           hdr_off             ^
           pkt_len = 0x05ec         ^^^^
           AX_RXHDR_*=0x00830  ^^^^   ^
           pkt_len = 0                        ^^^^
           AX_RXHDR_DROP_ERR=0x80000000  ^^^^   ^
  0x2140:  3008 ec05 0000 0080 3008 5805 0000 0080
  0x2150:  3008 ec05 0000 0080 3008 ec05 0000 0080
  0x2160:  3008 5803 0000 0080 3008 c800 0000 0080
           ===11==== ===12==== ===13==== ===14====
  0x2170:  0000 0000 0e00 3821
                     ^^^^ ^^^^ rx_hdr
                     ^^^^      pkt_cnt=14
                          ^^^^ hdr_off=0x2138
           ^^^^ ^^^^           padding

  The dump shows that pkt_cnt is the number of entrys in the
  per-packet metadata. It is "2 * packet count".
  Each packet have two entrys. The first have a valid
  value (pkt_len and AX_RXHDR_*) and the second have a
  dummy-header 0x80000000 (pkt_len=0 with AX_RXHDR_DROP_ERR).
  Why exists dummy-header for each packet?!?
  My guess is that this was done probably to align the
  entry for each packet to 64-bits and maintain compatibility
  with old firmware.
  There is also a padding (0x00000000) before the rx_hdr to
  align the end of rx_hdr to 64-bit.
  Note that packets have a alignment of 64-bits (8-bytes).

  This patch assumes that the dummy-header and the last
  padding are optional. So it preserves semantics and
  recognises the same valid packets as the current code.

  This patch was made using only the dumpfile information and
  tested with only one device:
  0b95:1790 ASIX Electronics Corp. AX88179 Gigabit Ethernet

Fixes: 57bc3d3ae8c1 ("net: usb: ax88179_178a: Fix out-of-bounds accesses in RX fixup")
Fixes: e2ca90c276e1 ("ax88179_178a: ASIX AX88179_178A USB 3.0/2.0 to gigabit ethernet adapter driver")
Signed-off-by: Jose Alonso <joalonsof@gmail.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/d6970bb04bf67598af4d316eaeb1792040b18cfd.camel@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c |  101 ++++++++++++++++++++++++++++++-----------
 1 file changed, 76 insertions(+), 25 deletions(-)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1377,6 +1377,42 @@ static int ax88179_rx_fixup(struct usbne
 	 * are bundled into this buffer and where we can find an array of
 	 * per-packet metadata (which contains elements encoded into u16).
 	 */
+
+	/* SKB contents for current firmware:
+	 *   <packet 1> <padding>
+	 *   ...
+	 *   <packet N> <padding>
+	 *   <per-packet metadata entry 1> <dummy header>
+	 *   ...
+	 *   <per-packet metadata entry N> <dummy header>
+	 *   <padding2> <rx_hdr>
+	 *
+	 * where:
+	 *   <packet N> contains pkt_len bytes:
+	 *		2 bytes of IP alignment pseudo header
+	 *		packet received
+	 *   <per-packet metadata entry N> contains 4 bytes:
+	 *		pkt_len and fields AX_RXHDR_*
+	 *   <padding>	0-7 bytes to terminate at
+	 *		8 bytes boundary (64-bit).
+	 *   <padding2> 4 bytes to make rx_hdr terminate at
+	 *		8 bytes boundary (64-bit)
+	 *   <dummy-header> contains 4 bytes:
+	 *		pkt_len=0 and AX_RXHDR_DROP_ERR
+	 *   <rx-hdr>	contains 4 bytes:
+	 *		pkt_cnt and hdr_off (offset of
+	 *		  <per-packet metadata entry 1>)
+	 *
+	 * pkt_cnt is number of entrys in the per-packet metadata.
+	 * In current firmware there is 2 entrys per packet.
+	 * The first points to the packet and the
+	 *  second is a dummy header.
+	 * This was done probably to align fields in 64-bit and
+	 *  maintain compatibility with old firmware.
+	 * This code assumes that <dummy header> and <padding2> are
+	 *  optional.
+	 */
+
 	if (skb->len < 4)
 		return 0;
 	skb_trim(skb, skb->len - 4);
@@ -1391,51 +1427,66 @@ static int ax88179_rx_fixup(struct usbne
 	/* Make sure that the bounds of the metadata array are inside the SKB
 	 * (and in front of the counter at the end).
 	 */
-	if (pkt_cnt * 2 + hdr_off > skb->len)
+	if (pkt_cnt * 4 + hdr_off > skb->len)
 		return 0;
 	pkt_hdr = (u32 *)(skb->data + hdr_off);
 
 	/* Packets must not overlap the metadata array */
 	skb_trim(skb, hdr_off);
 
-	for (; ; pkt_cnt--, pkt_hdr++) {
+	for (; pkt_cnt > 0; pkt_cnt--, pkt_hdr++) {
+		u16 pkt_len_plus_padd;
 		u16 pkt_len;
 
 		le32_to_cpus(pkt_hdr);
 		pkt_len = (*pkt_hdr >> 16) & 0x1fff;
+		pkt_len_plus_padd = (pkt_len + 7) & 0xfff8;
 
-		if (pkt_len > skb->len)
+		/* Skip dummy header used for alignment
+		 */
+		if (pkt_len == 0)
+			continue;
+
+		if (pkt_len_plus_padd > skb->len)
 			return 0;
 
 		/* Check CRC or runt packet */
-		if (((*pkt_hdr & (AX_RXHDR_CRC_ERR | AX_RXHDR_DROP_ERR)) == 0) &&
-		    pkt_len >= 2 + ETH_HLEN) {
-			bool last = (pkt_cnt == 0);
-
-			if (last) {
-				ax_skb = skb;
-			} else {
-				ax_skb = skb_clone(skb, GFP_ATOMIC);
-				if (!ax_skb)
-					return 0;
-			}
-			ax_skb->len = pkt_len;
-			/* Skip IP alignment pseudo header */
-			skb_pull(ax_skb, 2);
-			skb_set_tail_pointer(ax_skb, ax_skb->len);
-			ax_skb->truesize = pkt_len + sizeof(struct sk_buff);
-			ax88179_rx_checksum(ax_skb, pkt_hdr);
+		if ((*pkt_hdr & (AX_RXHDR_CRC_ERR | AX_RXHDR_DROP_ERR)) ||
+		    pkt_len < 2 + ETH_HLEN) {
+			dev->net->stats.rx_errors++;
+			skb_pull(skb, pkt_len_plus_padd);
+			continue;
+		}
 
-			if (last)
-				return 1;
+		/* last packet */
+		if (pkt_len_plus_padd == skb->len) {
+			skb_trim(skb, pkt_len);
 
-			usbnet_skb_return(dev, ax_skb);
+			/* Skip IP alignment pseudo header */
+			skb_pull(skb, 2);
+
+			skb->truesize = SKB_TRUESIZE(pkt_len_plus_padd);
+			ax88179_rx_checksum(skb, pkt_hdr);
+			return 1;
 		}
 
-		/* Trim this packet away from the SKB */
-		if (!skb_pull(skb, (pkt_len + 7) & 0xFFF8))
+		ax_skb = skb_clone(skb, GFP_ATOMIC);
+		if (!ax_skb)
 			return 0;
+		skb_trim(ax_skb, pkt_len);
+
+		/* Skip IP alignment pseudo header */
+		skb_pull(ax_skb, 2);
+
+		skb->truesize = pkt_len_plus_padd +
+				SKB_DATA_ALIGN(sizeof(struct sk_buff));
+		ax88179_rx_checksum(ax_skb, pkt_hdr);
+		usbnet_skb_return(dev, ax_skb);
+
+		skb_pull(skb, pkt_len_plus_padd);
 	}
+
+	return 0;
 }
 
 static struct sk_buff *



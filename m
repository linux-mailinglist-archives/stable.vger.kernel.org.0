Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D994B46AB
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243248AbiBNJmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:42:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245341AbiBNJlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:41:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A3F657AA;
        Mon, 14 Feb 2022 01:37:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C137D60FA2;
        Mon, 14 Feb 2022 09:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1207C340E9;
        Mon, 14 Feb 2022 09:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831439;
        bh=eVBA3Z48eoFmYSlqGiWbfuA3dEczhe99XS1mT4zahPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t5GFnBfAAhxAJnlm+yDedg//C0q+hjqVrt5bxmzZ/O8YaJcw3DxSrawMfRlHwqIhV
         Mp2cTY2rURfVDug+8mvIu+SL3No4r3HEcVoJHdpWxXlVQ7tF1i0nVMWOGb+I//hBbX
         zr0S7jJuorULDsCULbhVwSlVszIL8otcY8qCbtKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Jann Horn <jannh@google.com>
Subject: [PATCH 5.4 54/71] net: usb: ax88179_178a: Fix out-of-bounds accesses in RX fixup
Date:   Mon, 14 Feb 2022 10:26:22 +0100
Message-Id: <20220214092453.860444773@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jann Horn <jannh@google.com>

commit 57bc3d3ae8c14df3ceb4e17d26ddf9eeab304581 upstream.

ax88179_rx_fixup() contains several out-of-bounds accesses that can be
triggered by a malicious (or defective) USB device, in particular:

 - The metadata array (hdr_off..hdr_off+2*pkt_cnt) can be out of bounds,
   causing OOB reads and (on big-endian systems) OOB endianness flips.
 - A packet can overlap the metadata array, causing a later OOB
   endianness flip to corrupt data used by a cloned SKB that has already
   been handed off into the network stack.
 - A packet SKB can be constructed whose tail is far beyond its end,
   causing out-of-bounds heap data to be considered part of the SKB's
   data.

I have tested that this can be used by a malicious USB device to send a
bogus ICMPv6 Echo Request and receive an ICMPv6 Echo Reply in response
that contains random kernel heap data.
It's probably also possible to get OOB writes from this on a
little-endian system somehow - maybe by triggering skb_cow() via IP
options processing -, but I haven't tested that.

Fixes: e2ca90c276e1 ("ax88179_178a: ASIX AX88179_178A USB 3.0/2.0 to gigabit ethernet adapter driver")
Cc: stable@kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c |   68 +++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 29 deletions(-)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1361,58 +1361,68 @@ static int ax88179_rx_fixup(struct usbne
 	u16 hdr_off;
 	u32 *pkt_hdr;
 
-	/* This check is no longer done by usbnet */
-	if (skb->len < dev->net->hard_header_len)
+	/* At the end of the SKB, there's a header telling us how many packets
+	 * are bundled into this buffer and where we can find an array of
+	 * per-packet metadata (which contains elements encoded into u16).
+	 */
+	if (skb->len < 4)
 		return 0;
-
 	skb_trim(skb, skb->len - 4);
 	rx_hdr = get_unaligned_le32(skb_tail_pointer(skb));
-
 	pkt_cnt = (u16)rx_hdr;
 	hdr_off = (u16)(rx_hdr >> 16);
+
+	if (pkt_cnt == 0)
+		return 0;
+
+	/* Make sure that the bounds of the metadata array are inside the SKB
+	 * (and in front of the counter at the end).
+	 */
+	if (pkt_cnt * 2 + hdr_off > skb->len)
+		return 0;
 	pkt_hdr = (u32 *)(skb->data + hdr_off);
 
-	while (pkt_cnt--) {
+	/* Packets must not overlap the metadata array */
+	skb_trim(skb, hdr_off);
+
+	for (; ; pkt_cnt--, pkt_hdr++) {
 		u16 pkt_len;
 
 		le32_to_cpus(pkt_hdr);
 		pkt_len = (*pkt_hdr >> 16) & 0x1fff;
 
-		/* Check CRC or runt packet */
-		if ((*pkt_hdr & AX_RXHDR_CRC_ERR) ||
-		    (*pkt_hdr & AX_RXHDR_DROP_ERR)) {
-			skb_pull(skb, (pkt_len + 7) & 0xFFF8);
-			pkt_hdr++;
-			continue;
-		}
-
-		if (pkt_cnt == 0) {
-			skb->len = pkt_len;
-			/* Skip IP alignment pseudo header */
-			skb_pull(skb, 2);
-			skb_set_tail_pointer(skb, skb->len);
-			skb->truesize = pkt_len + sizeof(struct sk_buff);
-			ax88179_rx_checksum(skb, pkt_hdr);
-			return 1;
-		}
+		if (pkt_len > skb->len)
+			return 0;
 
-		ax_skb = skb_clone(skb, GFP_ATOMIC);
-		if (ax_skb) {
+		/* Check CRC or runt packet */
+		if (((*pkt_hdr & (AX_RXHDR_CRC_ERR | AX_RXHDR_DROP_ERR)) == 0) &&
+		    pkt_len >= 2 + ETH_HLEN) {
+			bool last = (pkt_cnt == 0);
+
+			if (last) {
+				ax_skb = skb;
+			} else {
+				ax_skb = skb_clone(skb, GFP_ATOMIC);
+				if (!ax_skb)
+					return 0;
+			}
 			ax_skb->len = pkt_len;
 			/* Skip IP alignment pseudo header */
 			skb_pull(ax_skb, 2);
 			skb_set_tail_pointer(ax_skb, ax_skb->len);
 			ax_skb->truesize = pkt_len + sizeof(struct sk_buff);
 			ax88179_rx_checksum(ax_skb, pkt_hdr);
+
+			if (last)
+				return 1;
+
 			usbnet_skb_return(dev, ax_skb);
-		} else {
-			return 0;
 		}
 
-		skb_pull(skb, (pkt_len + 7) & 0xFFF8);
-		pkt_hdr++;
+		/* Trim this packet away from the SKB */
+		if (!skb_pull(skb, (pkt_len + 7) & 0xFFF8))
+			return 0;
 	}
-	return 1;
 }
 
 static struct sk_buff *



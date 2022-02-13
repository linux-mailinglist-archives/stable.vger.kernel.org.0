Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09BCE4B3B08
	for <lists+stable@lfdr.de>; Sun, 13 Feb 2022 12:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbiBMLRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Feb 2022 06:17:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiBMLRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Feb 2022 06:17:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B792623
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 03:17:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 185FAB80886
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 11:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450B7C004E1;
        Sun, 13 Feb 2022 11:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644751020;
        bh=9vsKoDKqtmdM9O7iHGnragavhGeANSyBmTnIWYYjyR0=;
        h=Subject:To:Cc:From:Date:From;
        b=nC3H2YuS79a7w3OAbuHodGA3DxXU7u2obox1vqgBPWA4HXKmAq7LCXW0A5lHKxi+Q
         9iPc2abOqbvZ+blDP1JBhvgZvRJsRCQsjNS7rKzOxNOVkb6xJp6Jojw6nSDv0ph9zj
         zdqH0Bx0xAXINFauDOqf6iI3nMbcaJduC0ocC3l0=
Subject: FAILED: patch "[PATCH] net: usb: ax88179_178a: Fix out-of-bounds accesses in RX" failed to apply to 4.9-stable tree
To:     jannh@google.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Feb 2022 12:16:58 +0100
Message-ID: <1644751018150165@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 57bc3d3ae8c14df3ceb4e17d26ddf9eeab304581 Mon Sep 17 00:00:00 2001
From: Jann Horn <jannh@google.com>
Date: Wed, 26 Jan 2022 14:14:52 +0100
Subject: [PATCH] net: usb: ax88179_178a: Fix out-of-bounds accesses in RX
 fixup

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

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 1a627ba4b850..a31098981a65 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1468,58 +1468,68 @@ static int ax88179_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
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


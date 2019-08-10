Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 718AB88E65
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbfHJUyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:54:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53776 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726460AbfHJUns (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:48 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-00053G-C7; Sat, 10 Aug 2019 21:43:45 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDI-0003Yn-Qt; Sat, 10 Aug 2019 21:43:44 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "Greg Ungerer" <gerg@linux-m68k.org>,
        "David S. Miller" <davem@davemloft.net>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.685698016@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 017/157] net: mac8390: Use standard memcpy_{from,to}io()
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 4042cd756e193f49469d31a23d5b85c4dca2a3b6 upstream.

The mac8390 driver defines its own variants of memcpy_fromio() and
memcpy_toio(), using similar implementations, but different function
signatures.

Remove the custom definitions of memcpy_fromio() and memcpy_toio(), and
adjust all callers to the standard signatures.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/8390/mac8390.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/net/ethernet/8390/mac8390.c
+++ b/drivers/net/ethernet/8390/mac8390.c
@@ -153,9 +153,6 @@ static void dayna_block_input(struct net
 static void dayna_block_output(struct net_device *dev, int count,
 			       const unsigned char *buf, int start_page);
 
-#define memcpy_fromio(a, b, c)	memcpy((a), (void *)(b), (c))
-#define memcpy_toio(a, b, c)	memcpy((void *)(a), (b), (c))
-
 #define memcmp_withio(a, b, c)	memcmp((a), (void *)(b), (c))
 
 /* Slow Sane (16-bit chunk memory read/write) Cabletron uses this */
@@ -247,7 +244,7 @@ static enum mac8390_access __init mac839
 	unsigned long outdata = 0xA5A0B5B0;
 	unsigned long indata =  0x00000000;
 	/* Try writing 32 bits */
-	memcpy_toio(membase, &outdata, 4);
+	memcpy_toio((void __iomem *)membase, &outdata, 4);
 	/* Now compare them */
 	if (memcmp_withio(&outdata, membase, 4) == 0)
 		return ACCESS_32;
@@ -742,7 +739,7 @@ static void sane_get_8390_hdr(struct net
 			      struct e8390_pkt_hdr *hdr, int ring_page)
 {
 	unsigned long hdr_start = (ring_page - WD_START_PG)<<8;
-	memcpy_fromio(hdr, dev->mem_start + hdr_start, 4);
+	memcpy_fromio(hdr, (void __iomem *)dev->mem_start + hdr_start, 4);
 	/* Fix endianness */
 	hdr->count = swab16(hdr->count);
 }
@@ -756,13 +753,16 @@ static void sane_block_input(struct net_
 	if (xfer_start + count > ei_status.rmem_end) {
 		/* We must wrap the input move. */
 		int semi_count = ei_status.rmem_end - xfer_start;
-		memcpy_fromio(skb->data, dev->mem_start + xfer_base,
+		memcpy_fromio(skb->data,
+			      (void __iomem *)dev->mem_start + xfer_base,
 			      semi_count);
 		count -= semi_count;
-		memcpy_fromio(skb->data + semi_count, ei_status.rmem_start,
-			      count);
+		memcpy_fromio(skb->data + semi_count,
+			      (void __iomem *)ei_status.rmem_start, count);
 	} else {
-		memcpy_fromio(skb->data, dev->mem_start + xfer_base, count);
+		memcpy_fromio(skb->data,
+			      (void __iomem *)dev->mem_start + xfer_base,
+			      count);
 	}
 }
 
@@ -771,7 +771,7 @@ static void sane_block_output(struct net
 {
 	long shmem = (start_page - WD_START_PG)<<8;
 
-	memcpy_toio(dev->mem_start + shmem, buf, count);
+	memcpy_toio((void __iomem *)dev->mem_start + shmem, buf, count);
 }
 
 /* dayna block input/output */


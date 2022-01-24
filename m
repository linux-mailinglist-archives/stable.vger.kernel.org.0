Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1656498D24
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348204AbiAXT2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:28:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351061AbiAXTZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:25:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C894BC02B875;
        Mon, 24 Jan 2022 11:12:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B396B81238;
        Mon, 24 Jan 2022 19:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911D2C340E5;
        Mon, 24 Jan 2022 19:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051533;
        bh=hjVUjZhp7dNU+LdKVJ55RTXNU/c7VHnMaLBwtnk9LdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wt0us8NuvQF3UHPSB1135se477KzxZtqpY0njxcgV9LISTvxSbC9X8Lazeys5v0/o
         Nbgt4taomQM7LsBgg6IO8POPAhSLCHjBoE8J+OCtp/zwTOiXTaboUCM8I9j9F0lIIz
         mCipKWIEz45cly9C8eylT3Us304/hvryfngmvmMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Braun <michael-dev@fami-braun.de>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.14 185/186] gianfar: fix jumbo packets+napi+rx overrun crash
Date:   Mon, 24 Jan 2022 19:44:20 +0100
Message-Id: <20220124183943.057424110@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Braun <michael-dev@fami-braun.de>

commit d8861bab48b6c1fc3cdbcab8ff9d1eaea43afe7f upstream.

When using jumbo packets and overrunning rx queue with napi enabled,
the following sequence is observed in gfar_add_rx_frag:

   | lstatus                              |       | skb                   |
t  | lstatus,  size, flags                | first | len, data_len, *ptr   |
---+--------------------------------------+-------+-----------------------+
13 | 18002348, 9032, INTERRUPT LAST       | 0     | 9600, 8000,  f554c12e |
12 | 10000640, 1600, INTERRUPT            | 0     | 8000, 6400,  f554c12e |
11 | 10000640, 1600, INTERRUPT            | 0     | 6400, 4800,  f554c12e |
10 | 10000640, 1600, INTERRUPT            | 0     | 4800, 3200,  f554c12e |
09 | 10000640, 1600, INTERRUPT            | 0     | 3200, 1600,  f554c12e |
08 | 14000640, 1600, INTERRUPT FIRST      | 0     | 1600, 0,     f554c12e |
07 | 14000640, 1600, INTERRUPT FIRST      | 1     | 0,    0,     f554c12e |
06 | 1c000080, 128,  INTERRUPT LAST FIRST | 1     | 0,    0,     abf3bd6e |
05 | 18002348, 9032, INTERRUPT LAST       | 0     | 8000, 6400,  c5a57780 |
04 | 10000640, 1600, INTERRUPT            | 0     | 6400, 4800,  c5a57780 |
03 | 10000640, 1600, INTERRUPT            | 0     | 4800, 3200,  c5a57780 |
02 | 10000640, 1600, INTERRUPT            | 0     | 3200, 1600,  c5a57780 |
01 | 10000640, 1600, INTERRUPT            | 0     | 1600, 0,     c5a57780 |
00 | 14000640, 1600, INTERRUPT FIRST      | 1     | 0,    0,     c5a57780 |

So at t=7 a new packets is started but not finished, probably due to rx
overrun - but rx overrun is not indicated in the flags. Instead a new
packets starts at t=8. This results in skb->len to exceed size for the LAST
fragment at t=13 and thus a negative fragment size added to the skb.

This then crashes:

kernel BUG at include/linux/skbuff.h:2277!
Oops: Exception in kernel mode, sig: 5 [#1]
...
NIP [c04689f4] skb_pull+0x2c/0x48
LR [c03f62ac] gfar_clean_rx_ring+0x2e4/0x844
Call Trace:
[ec4bfd38] [c06a84c4] _raw_spin_unlock_irqrestore+0x60/0x7c (unreliable)
[ec4bfda8] [c03f6a44] gfar_poll_rx_sq+0x48/0xe4
[ec4bfdc8] [c048d504] __napi_poll+0x54/0x26c
[ec4bfdf8] [c048d908] net_rx_action+0x138/0x2c0
[ec4bfe68] [c06a8f34] __do_softirq+0x3a4/0x4fc
[ec4bfed8] [c0040150] run_ksoftirqd+0x58/0x70
[ec4bfee8] [c0066ecc] smpboot_thread_fn+0x184/0x1cc
[ec4bff08] [c0062718] kthread+0x140/0x144
[ec4bff38] [c0012350] ret_from_kernel_thread+0x14/0x1c

This patch fixes this by checking for computed LAST fragment size, so a
negative sized fragment is never added.
In order to prevent the newer rx frame from getting corrupted, the FIRST
flag is checked to discard the incomplete older frame.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/gianfar.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -2944,6 +2944,10 @@ static bool gfar_add_rx_frag(struct gfar
 		if (lstatus & BD_LFLAG(RXBD_LAST))
 			size -= skb->len;
 
+		WARN(size < 0, "gianfar: rx fragment size underflow");
+		if (size < 0)
+			return false;
+
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
 				rxb->page_offset + RXBUF_ALIGNMENT,
 				size, GFAR_RXB_TRUESIZE);
@@ -3105,6 +3109,17 @@ int gfar_clean_rx_ring(struct gfar_priv_
 		if (lstatus & BD_LFLAG(RXBD_EMPTY))
 			break;
 
+		/* lost RXBD_LAST descriptor due to overrun */
+		if (skb &&
+		    (lstatus & BD_LFLAG(RXBD_FIRST))) {
+			/* discard faulty buffer */
+			dev_kfree_skb(skb);
+			skb = NULL;
+			rx_queue->stats.rx_dropped++;
+
+			/* can continue normally */
+		}
+
 		/* order rx buffer descriptor reads */
 		rmb();
 



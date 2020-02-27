Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58097172030
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731512AbgB0NwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:52:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730589AbgB0NwQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:52:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1079D20578;
        Thu, 27 Feb 2020 13:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811535;
        bh=TG3ss2HCNOEITBE6VAGYSm6IoiC45U3DCTjPzjeLweo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O6uP+mUPelFRlYY3RsS0NSPSS+mToOT9k92osDVrTOZnwFQJ2P2R7Uw6jK1Tv7eOQ
         Y5PBSLIo9h31Dhl4DPZZQp9uBAJKTpfT9TXfbui2BZQ0IH6aXwe5bUZ4Z9ZXpvpmGF
         ORdRU+eDWBdLso8OFDYGHMoHi6Rft4Z1H/cNy74U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eagle Zhou <eagle.zhou@nxp.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: [PATCH 4.9 132/165] tty: serial: imx: setup the correct sg entry for tx dma
Date:   Thu, 27 Feb 2020 14:36:46 +0100
Message-Id: <20200227132250.317824999@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

commit f76707831829530ffdd3888bebc108aecefccaa0 upstream.

There has oops as below happen on i.MX8MP EVK platform that has
6G bytes DDR memory.

when (xmit->tail < xmit->head) && (xmit->head == 0),
it setups one sg entry with sg->length is zero:
	sg_set_buf(sgl + 1, xmit->buf, xmit->head);

if xmit->buf is allocated from >4G address space, and SDMA only
support <4G address space, then dma_map_sg() will call swiotlb_map()
to do bounce buffer copying and mapping.

But swiotlb_map() don't allow sg entry's length is zero, otherwise
report BUG_ON().

So the patch is to correct the tx DMA scatter list.

Oops:
[  287.675715] kernel BUG at kernel/dma/swiotlb.c:497!
[  287.680592] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[  287.686075] Modules linked in:
[  287.689133] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.4.3-00016-g3fdc4e0-dirty #10
[  287.696872] Hardware name: FSL i.MX8MP EVK (DT)
[  287.701402] pstate: 80000085 (Nzcv daIf -PAN -UAO)
[  287.706199] pc : swiotlb_tbl_map_single+0x1fc/0x310
[  287.711076] lr : swiotlb_map+0x60/0x148
[  287.714909] sp : ffff800010003c00
[  287.718221] x29: ffff800010003c00 x28: 0000000000000000
[  287.723533] x27: 0000000000000040 x26: ffff800011ae0000
[  287.728844] x25: ffff800011ae09f8 x24: 0000000000000000
[  287.734155] x23: 00000001b7af9000 x22: 0000000000000000
[  287.739465] x21: ffff000176409c10 x20: 00000000001f7ffe
[  287.744776] x19: ffff000176409c10 x18: 000000000000002e
[  287.750087] x17: 0000000000000000 x16: 0000000000000000
[  287.755397] x15: 0000000000000000 x14: 0000000000000000
[  287.760707] x13: ffff00017f334000 x12: 0000000000000001
[  287.766018] x11: 00000000001fffff x10: 0000000000000000
[  287.771328] x9 : 0000000000000003 x8 : 0000000000000000
[  287.776638] x7 : 0000000000000000 x6 : 0000000000000000
[  287.781949] x5 : 0000000000200000 x4 : 0000000000000000
[  287.787259] x3 : 0000000000000001 x2 : 00000001b7af9000
[  287.792570] x1 : 00000000fbfff000 x0 : 0000000000000000
[  287.797881] Call trace:
[  287.800328]  swiotlb_tbl_map_single+0x1fc/0x310
[  287.804859]  swiotlb_map+0x60/0x148
[  287.808347]  dma_direct_map_page+0xf0/0x130
[  287.812530]  dma_direct_map_sg+0x78/0xe0
[  287.816453]  imx_uart_dma_tx+0x134/0x2f8
[  287.820374]  imx_uart_dma_tx_callback+0xd8/0x168
[  287.824992]  vchan_complete+0x194/0x200
[  287.828828]  tasklet_action_common.isra.0+0x154/0x1a0
[  287.833879]  tasklet_action+0x24/0x30
[  287.837540]  __do_softirq+0x120/0x23c
[  287.841202]  irq_exit+0xb8/0xd8
[  287.844343]  __handle_domain_irq+0x64/0xb8
[  287.848438]  gic_handle_irq+0x5c/0x148
[  287.852185]  el1_irq+0xb8/0x180
[  287.855327]  cpuidle_enter_state+0x84/0x360
[  287.859508]  cpuidle_enter+0x34/0x48
[  287.863083]  call_cpuidle+0x18/0x38
[  287.866571]  do_idle+0x1e0/0x280
[  287.869798]  cpu_startup_entry+0x20/0x40
[  287.873721]  rest_init+0xd4/0xe0
[  287.876949]  arch_call_rest_init+0xc/0x14
[  287.880958]  start_kernel+0x420/0x44c
[  287.884622] Code: 9124c021 9417aff8 a94363f7 17ffffd5 (d4210000)
[  287.890718] ---[ end trace 5bc44c4ab6b009ce ]---
[  287.895334] Kernel panic - not syncing: Fatal exception in interrupt
[  287.901686] SMP: stopping secondary CPUs
[  288.905607] SMP: failed to stop secondary CPUs 0-1
[  288.910395] Kernel Offset: disabled
[  288.913882] CPU features: 0x0002,2000200c
[  288.917888] Memory Limit: none
[  288.920944] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

Reported-by: Eagle Zhou <eagle.zhou@nxp.com>
Tested-by: Eagle Zhou <eagle.zhou@nxp.com>
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Cc: stable <stable@vger.kernel.org>
Fixes: 7942f8577f2a ("serial: imx: TX DMA: clean up sg initialization")
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/1581401761-6378-1-git-send-email-fugang.duan@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/imx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -532,7 +532,7 @@ static void imx_dma_tx(struct imx_port *
 
 	sport->tx_bytes = uart_circ_chars_pending(xmit);
 
-	if (xmit->tail < xmit->head) {
+	if (xmit->tail < xmit->head || xmit->head == 0) {
 		sport->dma_tx_nents = 1;
 		sg_init_one(sgl, xmit->buf + xmit->tail, sport->tx_bytes);
 	} else {



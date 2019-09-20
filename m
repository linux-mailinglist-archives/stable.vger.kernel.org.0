Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2F81B925A
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391305AbfITObw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:31:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36700 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388339AbfITOZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:13 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqQ-000514-55; Fri, 20 Sep 2019 15:25:10 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqF-0007ul-DX; Fri, 20 Sep 2019 15:24:59 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Christophe Leroy" <christophe.leroy@c-s.fr>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.363256774@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 077/132] net: ucc_geth - fix Oops when changing
 number of buffers in the ring
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit ee0df19305d9fabd9479b785918966f6e25b733b upstream.

When changing the number of buffers in the RX ring while the interface
is running, the following Oops is encountered due to the new number
of buffers being taken into account immediately while their allocation
is done when opening the device only.

[   69.882706] Unable to handle kernel paging request for data at address 0xf0000100
[   69.890172] Faulting instruction address: 0xc033e164
[   69.895122] Oops: Kernel access of bad area, sig: 11 [#1]
[   69.900494] BE PREEMPT CMPCPRO
[   69.907120] CPU: 0 PID: 0 Comm: swapper Not tainted 4.14.115-00006-g179ade8ce3-dirty #269
[   69.915956] task: c0684310 task.stack: c06da000
[   69.920470] NIP:  c033e164 LR: c02e44d0 CTR: c02e41fc
[   69.925504] REGS: dfff1e20 TRAP: 0300   Not tainted  (4.14.115-00006-g179ade8ce3-dirty)
[   69.934161] MSR:  00009032 <EE,ME,IR,DR,RI>  CR: 22004428  XER: 20000000
[   69.940869] DAR: f0000100 DSISR: 20000000
[   69.940869] GPR00: c0352d70 dfff1ed0 c0684310 f00000a4 00000040 dfff1f68 00000000 0000001f
[   69.940869] GPR08: df53f410 1cc00040 00000021 c0781640 42004424 100c82b6 f00000a4 df53f5b0
[   69.940869] GPR16: df53f6c0 c05daf84 00000040 00000000 00000040 c0782be4 00000000 00000001
[   69.940869] GPR24: 00000000 df53f400 000001b0 df53f410 df53f000 0000003f df708220 1cc00044
[   69.978348] NIP [c033e164] skb_put+0x0/0x5c
[   69.982528] LR [c02e44d0] ucc_geth_poll+0x2d4/0x3f8
[   69.987384] Call Trace:
[   69.989830] [dfff1ed0] [c02e4554] ucc_geth_poll+0x358/0x3f8 (unreliable)
[   69.996522] [dfff1f20] [c0352d70] net_rx_action+0x248/0x30c
[   70.002099] [dfff1f80] [c04e93e4] __do_softirq+0xfc/0x310
[   70.007492] [dfff1fe0] [c0021124] irq_exit+0xd0/0xd4
[   70.012458] [dfff1ff0] [c000e7e0] call_do_irq+0x24/0x3c
[   70.017683] [c06dbe80] [c0006bac] do_IRQ+0x64/0xc4
[   70.022474] [c06dbea0] [c001097c] ret_from_except+0x0/0x14
[   70.027964] --- interrupt: 501 at rcu_idle_exit+0x84/0x90
[   70.027964]     LR = rcu_idle_exit+0x74/0x90
[   70.037585] [c06dbf60] [20000000] 0x20000000 (unreliable)
[   70.042984] [c06dbf80] [c004bb0c] do_idle+0xb4/0x11c
[   70.047945] [c06dbfa0] [c004bd14] cpu_startup_entry+0x18/0x1c
[   70.053682] [c06dbfb0] [c05fb034] start_kernel+0x370/0x384
[   70.059153] [c06dbff0] [00003438] 0x3438
[   70.063062] Instruction dump:
[   70.066023] 38a00000 38800000 90010014 4bfff015 80010014 7c0803a6 3123ffff 7c691910
[   70.073767] 38210010 4e800020 38600000 4e800020 <80e3005c> 80c30098 3107ffff 7d083910
[   70.081690] ---[ end trace be7ccd9c1e1a9f12 ]---

This patch forbids the modification of the number of buffers in the
ring while the interface is running.

Fixes: ac421852b3a0 ("ucc_geth: add ethtool support")
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
+++ b/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
@@ -253,14 +253,12 @@ uec_set_ringparam(struct net_device *net
 		return -EINVAL;
 	}
 
+	if (netif_running(netdev))
+		return -EBUSY;
+
 	ug_info->bdRingLenRx[queue] = ring->rx_pending;
 	ug_info->bdRingLenTx[queue] = ring->tx_pending;
 
-	if (netif_running(netdev)) {
-		/* FIXME: restart automatically */
-		netdev_info(netdev, "Please re-open the interface\n");
-	}
-
 	return ret;
 }
 


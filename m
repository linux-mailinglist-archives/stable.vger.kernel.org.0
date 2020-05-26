Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD861CAB22
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgEHMkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728673AbgEHMkS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:40:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C806B2496A;
        Fri,  8 May 2020 12:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941618;
        bh=mc+Xc3kLxlwRsjVxvRiHBAJW7seVG8+y6tXuSAWH/KQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RgNe3ga23En5pBekUTHX3oOpSAUagP6MN7yFBsxwAnoEfgnjMCQzfQjsHp8cZJgzk
         R7CMn3oqRD+bJf+i6wEIb25foly9i0pkr5TwznOdBHsByk7Jweh7aFLFZWseevxzT2
         UQRfWgRIvXS970j2hM/Dxz6PqzWqqsMroC0iY32o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rafal Milecki <zajec5@gmail.com>,
        Grey Christoforo <grey@christoforo.net>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Arend Van Spriel <arend@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.4 064/312] brcmfmac: add eth_type_trans back for PCIe full dongle
Date:   Fri,  8 May 2020 14:30:55 +0200
Message-Id: <20200508123129.049710831@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Franky Lin <franky.lin@broadcom.com>

commit 31143e2933d1675c4c1ba6ce125cdd95870edd85 upstream.

A regression was introduced in commit 9c349892ccc9 ("brcmfmac: revise
handling events in receive path") which moves eth_type_trans() call
to brcmf_rx_frame(). Msgbuf layer doesn't use brcmf_rx_frame() but invokes
brcmf_netif_rx() directly. In such case the Ethernet header was not
stripped out resulting in null pointer dereference in the networking
stack.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
IP: [<ffffffff814c3ce6>] enqueue_to_backlog+0x56/0x260
PGD 0
Oops: 0000 [#1] PREEMPT SMP
Modules linked in: fuse ipt_MASQUERADE nf_nat_masquerade_ipv4
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype
[...]
rtsx_pci scsi_mod usbcore usb_common i8042 serio nvme nvme_core
CPU: 7 PID: 1340 Comm: irq/136-brcmf_p Not tainted 4.7.0-rc1-mainline #1
Hardware name: Dell Inc. XPS 15 9550/0N7TVV, BIOS 01.02.00 04/07/2016
task: ffff8804a0c5bd00 ti: ffff88049e124000 task.ti: ffff88049e124000
RIP: 0010:[<ffffffff814c3ce6>] [<ffffffff814c3ce6>]
enqueue_to_backlog+0x56/0x260
RSP: 0018:ffff88049e127ca0 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff8804bddd7c40 RCX: 000000000000002f
RDX: 0000000000000000 RSI: 0000000000000007 RDI: ffff8804bddd7d4c
RBP: ffff88049e127ce8 R08: 0000000000000000 R09: 0000000000000000
R10: ffff8804bddd12c0 R11: 000000000000149e R12: 0000000000017c40
R13: ffff88049e127d08 R14: ffff8804a9bd6d00 R15: ffff8804bddd7d4c
FS: 0000000000000000(0000) GS:ffff8804bddc0000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000048 CR3: 0000000001806000 CR4: 00000000003406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Stack:
ffff8804bdddad00 ffff8804ad089e00 0000000000000000 0000000000000282
0000000000000000 ffff8804a9bd6d00 ffff8804a1b27e00 ffff8804a9bd6d00
ffff88002ee88000 ffff88049e127d28 ffffffff814c3f3b ffffffff81311fc3
Call Trace:
[<ffffffff814c3f3b>] netif_rx_internal+0x4b/0x170
[<ffffffff81311fc3>] ? swiotlb_tbl_unmap_single+0xf3/0x120
[<ffffffff814c5467>] netif_rx_ni+0x27/0xc0
[<ffffffffa08519e9>] brcmf_netif_rx+0x49/0x70 [brcmfmac]
[<ffffffffa08564d4>] brcmf_msgbuf_process_rx+0x2b4/0x570 [brcmfmac]
[<ffffffff81020017>] ? __xen_set_pgd_hyper+0x57/0xd0
[<ffffffff810d60b0>] ? irq_forced_thread_fn+0x70/0x70
[<ffffffffa0857381>] brcmf_proto_msgbuf_rx_trigger+0x31/0xe0 [brcmfmac]
[<ffffffffa0861e8f>] brcmf_pcie_isr_thread+0x7f/0x110 [brcmfmac]
[<ffffffff810d60d0>] irq_thread_fn+0x20/0x50
[<ffffffff810d63ad>] irq_thread+0x12d/0x1c0
[<ffffffff815d07d5>] ? __schedule+0x2f5/0x7a0
[<ffffffff810d61d0>] ? wake_threads_waitq+0x30/0x30
[<ffffffff810d6280>] ? irq_thread_dtor+0xb0/0xb0
[<ffffffff81098ea8>] kthread+0xd8/0xf0
[<ffffffff815d4b7f>] ret_from_fork+0x1f/0x40
[<ffffffff81098dd0>] ? kthread_worker_fn+0x170/0x170
Code: 1c f5 60 9a 8e 81 9c 58 0f 1f 44 00 00 48 89 45 d0 fa 66 0f 1f
44 00 00 4c 8d bb 0c 01 00 00 4c 89 ff e8 5e 08 11 00 49 8b 56 20 <48>
8b 52 48 83 e2 01 74 10 8b 8b 08 01 00 00 8b 15 59 c5 42 00
RIP [<ffffffff814c3ce6>] enqueue_to_backlog+0x56/0x260
RSP <ffff88049e127ca0>
CR2: 0000000000000048

Fixes: 9c349892ccc9 ("brcmfmac: revise handling events in receive path")
Reported-by: Rafal Milecki <zajec5@gmail.com>
Reported-by: Grey Christoforo <grey@christoforo.net>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Signed-off-by: Franky Lin <franky.lin@broadcom.com>
[arend@broadcom.com: rephrased the commit message]
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -1155,6 +1155,8 @@ brcmf_msgbuf_process_rx_complete(struct
 		brcmu_pkt_buf_free_skb(skb);
 		return;
 	}
+
+	skb->protocol = eth_type_trans(skb, ifp->ndev);
 	brcmf_netif_rx(ifp, skb);
 }
 



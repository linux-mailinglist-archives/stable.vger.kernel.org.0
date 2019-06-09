Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB77F3AAD8
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbfFIQo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:44:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729288AbfFIQo2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:44:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAACC2084A;
        Sun,  9 Jun 2019 16:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098667;
        bh=pFooMs8T91VmlGXDtXCAaLdyEVArBpzfjMqNmEqQ0uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MdItmpHnP5aP3LupDXGMmi7R5L/06lbgGoYTFSaDn/y/sc0eVXZgdeKhLW4UalFcX
         uJzXj+13sfvJdUDI43qY0rLFHoj6bqXzCzPrIey4R4OWL0in0g+ooqrV2HIleCBoj2
         GM9zqnqF45rqBYhnrbFom79ad5TFjf0b2thMVMVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matteo Croce <mcroce@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 18/70] cls_matchall: avoid panic when receiving a packet before filter set
Date:   Sun,  9 Jun 2019 18:41:29 +0200
Message-Id: <20190609164128.584613805@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>

[ Upstream commit 25426043ec9e22b90c789407c28e40f32a9d1985 ]

When a matchall classifier is added, there is a small time interval in
which tp->root is NULL. If we receive a packet in this small time slice
a NULL pointer dereference will happen, leading to a kernel panic:

    # tc qdisc replace dev eth0 ingress
    # tc filter add dev eth0 parent ffff: matchall action gact drop
    Unable to handle kernel NULL pointer dereference at virtual address 0000000000000034
    Mem abort info:
      ESR = 0x96000005
      Exception class = DABT (current EL), IL = 32 bits
      SET = 0, FnV = 0
      EA = 0, S1PTW = 0
    Data abort info:
      ISV = 0, ISS = 0x00000005
      CM = 0, WnR = 0
    user pgtable: 4k pages, 39-bit VAs, pgdp = 00000000a623d530
    [0000000000000034] pgd=0000000000000000, pud=0000000000000000
    Internal error: Oops: 96000005 [#1] SMP
    Modules linked in: cls_matchall sch_ingress nls_iso8859_1 nls_cp437 vfat fat m25p80 spi_nor mtd xhci_plat_hcd xhci_hcd phy_generic sfp mdio_i2c usbcore i2c_mv64xxx marvell10g mvpp2 usb_common spi_orion mvmdio i2c_core sbsa_gwdt phylink ip_tables x_tables autofs4
    Process ksoftirqd/0 (pid: 9, stack limit = 0x0000000009de7d62)
    CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.1.0-rc6 #21
    Hardware name: Marvell 8040 MACCHIATOBin Double-shot (DT)
    pstate: 40000005 (nZcv daif -PAN -UAO)
    pc : mall_classify+0x28/0x78 [cls_matchall]
    lr : tcf_classify+0x78/0x138
    sp : ffffff80109db9d0
    x29: ffffff80109db9d0 x28: ffffffc426058800
    x27: 0000000000000000 x26: ffffffc425b0dd00
    x25: 0000000020000000 x24: 0000000000000000
    x23: ffffff80109dbac0 x22: 0000000000000001
    x21: ffffffc428ab5100 x20: ffffffc425b0dd00
    x19: ffffff80109dbac0 x18: 0000000000000000
    x17: 0000000000000000 x16: 0000000000000000
    x15: 0000000000000000 x14: 0000000000000000
    x13: ffffffbf108ad288 x12: dead000000000200
    x11: 00000000f0000000 x10: 0000000000000001
    x9 : ffffffbf1089a220 x8 : 0000000000000001
    x7 : ffffffbebffaa950 x6 : 0000000000000000
    x5 : 000000442d6ba000 x4 : 0000000000000000
    x3 : ffffff8008735ad8 x2 : ffffff80109dbac0
    x1 : ffffffc425b0dd00 x0 : ffffff8010592078
    Call trace:
     mall_classify+0x28/0x78 [cls_matchall]
     tcf_classify+0x78/0x138
     __netif_receive_skb_core+0x29c/0xa20
     __netif_receive_skb_one_core+0x34/0x60
     __netif_receive_skb+0x28/0x78
     netif_receive_skb_internal+0x2c/0xc0
     napi_gro_receive+0x1a0/0x1d8
     mvpp2_poll+0x928/0xb18 [mvpp2]
     net_rx_action+0x108/0x378
     __do_softirq+0x128/0x320
     run_ksoftirqd+0x44/0x60
     smpboot_thread_fn+0x168/0x1b0
     kthread+0x12c/0x130
     ret_from_fork+0x10/0x1c
    Code: aa0203f3 aa1e03e0 d503201f f9400684 (b9403480)
    ---[ end trace fc71e2ef7b8ab5a5 ]---
    Kernel panic - not syncing: Fatal exception in interrupt
    SMP: stopping secondary CPUs
    Kernel Offset: disabled
    CPU features: 0x002,00002000
    Memory Limit: none
    Rebooting in 1 seconds..

Fix this by adding a NULL check in mall_classify().

Fixes: ed76f5edccc9 ("net: sched: protect filter_chain list with filter_chain_lock mutex")
Signed-off-by: Matteo Croce <mcroce@redhat.com>
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_matchall.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -32,6 +32,9 @@ static int mall_classify(struct sk_buff
 {
 	struct cls_mall_head *head = rcu_dereference_bh(tp->root);
 
+	if (unlikely(!head))
+		return -1;
+
 	if (tc_skip_sw(head->flags))
 		return -1;
 



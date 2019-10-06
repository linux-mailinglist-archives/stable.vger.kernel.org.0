Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF33CD70C
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbfJFRve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:51:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727631AbfJFRu5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:50:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1B5021850;
        Sun,  6 Oct 2019 17:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383933;
        bh=SsmMWj3jspdVYymTd9rWSZYZZF4Otthg7BZ/+Oq09qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hDd3+RZcSjwoRrWEqlWMxtLVjN0meuXReyL4v2BaO6T/W/ay0w8mPzgX30NZv/Z9c
         2fIG2cOH9oKTDW974hbIk/Ewwv48ZP2hciX+IYql81gWZBBnkAIRoZuO3kUlTMLX9+
         iU0X0EBh0X9YJ17dhKbhNetSkN5Q7j3FXkGMrNIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 149/166] net: dsa: sja1105: Initialize the meta_lock
Date:   Sun,  6 Oct 2019 19:21:55 +0200
Message-Id: <20191006171225.464320750@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit d6530e5ad45089c018c3cc5b5957a34721249f6f ]

Otherwise, with CONFIG_DEBUG_SPINLOCK=y, this stack trace gets printed
when enabling RX timestamping and receiving a PTP frame:

[  318.537078] INFO: trying to register non-static key.
[  318.542040] the code is fine but needs lockdep annotation.
[  318.547500] turning off the locking correctness validator.
[  318.552972] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.3.0-13257-g0825b0669811-dirty #1962
[  318.561283] Hardware name: Freescale LS1021A
[  318.565566] [<c03144bc>] (unwind_backtrace) from [<c030e164>] (show_stack+0x10/0x14)
[  318.573289] [<c030e164>] (show_stack) from [<c11b9f50>] (dump_stack+0xd4/0x100)
[  318.580579] [<c11b9f50>] (dump_stack) from [<c03b9b40>] (register_lock_class+0x728/0x734)
[  318.588731] [<c03b9b40>] (register_lock_class) from [<c03b60c4>] (__lock_acquire+0x78/0x25cc)
[  318.597227] [<c03b60c4>] (__lock_acquire) from [<c03b8ef8>] (lock_acquire+0xd8/0x234)
[  318.605033] [<c03b8ef8>] (lock_acquire) from [<c11db934>] (_raw_spin_lock+0x44/0x54)
[  318.612755] [<c11db934>] (_raw_spin_lock) from [<c1164370>] (sja1105_rcv+0x1f8/0x4e8)
[  318.620561] [<c1164370>] (sja1105_rcv) from [<c115d7cc>] (dsa_switch_rcv+0x80/0x204)
[  318.628283] [<c115d7cc>] (dsa_switch_rcv) from [<c0f58c80>] (__netif_receive_skb_one_core+0x50/0x6c)
[  318.637386] [<c0f58c80>] (__netif_receive_skb_one_core) from [<c0f58f04>] (netif_receive_skb_internal+0xac/0x264)
[  318.647611] [<c0f58f04>] (netif_receive_skb_internal) from [<c0f59e98>] (napi_gro_receive+0x1d8/0x338)
[  318.656887] [<c0f59e98>] (napi_gro_receive) from [<c0c298a4>] (gfar_clean_rx_ring+0x328/0x724)
[  318.665472] [<c0c298a4>] (gfar_clean_rx_ring) from [<c0c29e60>] (gfar_poll_rx_sq+0x34/0x94)
[  318.673795] [<c0c29e60>] (gfar_poll_rx_sq) from [<c0f5b40c>] (net_rx_action+0x128/0x4f8)
[  318.681860] [<c0f5b40c>] (net_rx_action) from [<c03022f0>] (__do_softirq+0x148/0x5ac)
[  318.689666] [<c03022f0>] (__do_softirq) from [<c0355af4>] (irq_exit+0x160/0x170)
[  318.697040] [<c0355af4>] (irq_exit) from [<c03c6818>] (__handle_domain_irq+0x60/0xb4)
[  318.704847] [<c03c6818>] (__handle_domain_irq) from [<c07e9440>] (gic_handle_irq+0x58/0x9c)
[  318.713172] [<c07e9440>] (gic_handle_irq) from [<c0301a70>] (__irq_svc+0x70/0x98)
[  318.720622] Exception stack(0xc2001f18 to 0xc2001f60)
[  318.725656] 1f00:                                                       00000001 00000006
[  318.733805] 1f20: 00000000 c20165c0 ffffe000 c2010cac c2010cf4 00000001 00000000 c2010c88
[  318.741955] 1f40: c1f7a5a8 00000000 00000000 c2001f68 c03ba140 c030a288 200e0013 ffffffff
[  318.750110] [<c0301a70>] (__irq_svc) from [<c030a288>] (arch_cpu_idle+0x24/0x3c)
[  318.757486] [<c030a288>] (arch_cpu_idle) from [<c038a480>] (do_idle+0x1b8/0x2a4)
[  318.764859] [<c038a480>] (do_idle) from [<c038a94c>] (cpu_startup_entry+0x18/0x1c)
[  318.772407] [<c038a94c>] (cpu_startup_entry) from [<c1e00f10>] (start_kernel+0x4cc/0x4fc)

Fixes: 844d7edc6a34 ("net: dsa: sja1105: Add a global sja1105_tagger_data structure")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2165,6 +2165,7 @@ static int sja1105_probe(struct spi_devi
 	tagger_data = &priv->tagger_data;
 	skb_queue_head_init(&tagger_data->skb_rxtstamp_queue);
 	INIT_WORK(&tagger_data->rxtstamp_work, sja1105_rxtstamp_work);
+	spin_lock_init(&tagger_data->meta_lock);
 
 	/* Connections between dsa_port and sja1105_port */
 	for (i = 0; i < SJA1105_NUM_PORTS; i++) {



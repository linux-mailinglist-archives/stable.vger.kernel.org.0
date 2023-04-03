Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3F26D4ABD
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234114AbjDCOt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbjDCOtj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:49:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C107FD4FB3
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:48:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 505E161652
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670E0C433EF;
        Mon,  3 Apr 2023 14:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533273;
        bh=Hff13wxe4iJb1MsIElHuHpeTMxzP9IJnWZF+4HaBnfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQeNaR5jFn7r+j3BRBWWJI/3gL99TP5LjiMk4nOQyeioJmzAtTYBLkvUbZbiVvxGg
         dza1fdeQxBWNUi0RaZdKLbQ19ZZQ/VlLPiHIePSBTMrYvsBLZiSZQFUM6OT29XoH4R
         Kw026uzs4bnlCSRFgcnpq6cmYxdGF1SklgTXDH3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Faicker Mo <faicker.mo@ucloud.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 091/187] net/net_failover: fix txq exceeding warning
Date:   Mon,  3 Apr 2023 16:08:56 +0200
Message-Id: <20230403140418.960504142@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Faicker Mo <faicker.mo@ucloud.cn>

[ Upstream commit e3cbdcb0fbb61045ef3ce0e072927cc41737f787 ]

The failover txq is inited as 16 queues.
when a packet is transmitted from the failover device firstly,
the failover device will select the queue which is returned from
the primary device if the primary device is UP and running.
If the primary device txq is bigger than the default 16,
it can lead to the following warning:
eth0 selects TX queue 18, but real number of TX queues is 16

The warning backtrace is:
[   32.146376] CPU: 18 PID: 9134 Comm: chronyd Tainted: G            E      6.2.8-1.el7.centos.x86_64 #1
[   32.147175] Hardware name: Red Hat KVM, BIOS 1.10.2-3.el7_4.1 04/01/2014
[   32.147730] Call Trace:
[   32.147971]  <TASK>
[   32.148183]  dump_stack_lvl+0x48/0x70
[   32.148514]  dump_stack+0x10/0x20
[   32.148820]  netdev_core_pick_tx+0xb1/0xe0
[   32.149180]  __dev_queue_xmit+0x529/0xcf0
[   32.149533]  ? __check_object_size.part.0+0x21c/0x2c0
[   32.149967]  ip_finish_output2+0x278/0x560
[   32.150327]  __ip_finish_output+0x1fe/0x2f0
[   32.150690]  ip_finish_output+0x2a/0xd0
[   32.151032]  ip_output+0x7a/0x110
[   32.151337]  ? __pfx_ip_finish_output+0x10/0x10
[   32.151733]  ip_local_out+0x5e/0x70
[   32.152054]  ip_send_skb+0x19/0x50
[   32.152366]  udp_send_skb.isra.0+0x163/0x3a0
[   32.152736]  udp_sendmsg+0xba8/0xec0
[   32.153060]  ? __folio_memcg_unlock+0x25/0x60
[   32.153445]  ? __pfx_ip_generic_getfrag+0x10/0x10
[   32.153854]  ? sock_has_perm+0x85/0xa0
[   32.154190]  inet_sendmsg+0x6d/0x80
[   32.154508]  ? inet_sendmsg+0x6d/0x80
[   32.154838]  sock_sendmsg+0x62/0x70
[   32.155152]  ____sys_sendmsg+0x134/0x290
[   32.155499]  ___sys_sendmsg+0x81/0xc0
[   32.155828]  ? _get_random_bytes.part.0+0x79/0x1a0
[   32.156240]  ? ip4_datagram_release_cb+0x5f/0x1e0
[   32.156649]  ? get_random_u16+0x69/0xf0
[   32.156989]  ? __fget_light+0xcf/0x110
[   32.157326]  __sys_sendmmsg+0xc4/0x210
[   32.157657]  ? __sys_connect+0xb7/0xe0
[   32.157995]  ? __audit_syscall_entry+0xce/0x140
[   32.158388]  ? syscall_trace_enter.isra.0+0x12c/0x1a0
[   32.158820]  __x64_sys_sendmmsg+0x24/0x30
[   32.159171]  do_syscall_64+0x38/0x90
[   32.159493]  entry_SYSCALL_64_after_hwframe+0x72/0xdc

Fix that by reducing txq number as the non-existent primary-dev does.

Fixes: cfc80d9a1163 ("net: Introduce net_failover driver")
Signed-off-by: Faicker Mo <faicker.mo@ucloud.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/net_failover.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 7a28e082436e4..d0c916a53d7ce 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -130,14 +130,10 @@ static u16 net_failover_select_queue(struct net_device *dev,
 			txq = ops->ndo_select_queue(primary_dev, skb, sb_dev);
 		else
 			txq = netdev_pick_tx(primary_dev, skb, NULL);
-
-		qdisc_skb_cb(skb)->slave_dev_queue_mapping = skb->queue_mapping;
-
-		return txq;
+	} else {
+		txq = skb_rx_queue_recorded(skb) ? skb_get_rx_queue(skb) : 0;
 	}
 
-	txq = skb_rx_queue_recorded(skb) ? skb_get_rx_queue(skb) : 0;
-
 	/* Save the original txq to restore before passing to the driver */
 	qdisc_skb_cb(skb)->slave_dev_queue_mapping = skb->queue_mapping;
 
-- 
2.39.2




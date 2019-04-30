Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E506F6E1
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730921AbfD3Luz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730609AbfD3Luy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:50:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BE3620449;
        Tue, 30 Apr 2019 11:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556625053;
        bh=5YCjkaI2QIXlBzK3QcJgY4n7zbzF292tiykPg2mKO6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dar5zj/mSnogihdPiqPGxystD3ZFq6mJb1fEheMW6ZE9CtLavw+42Ct+v5E024Y86
         KCC6gliupvPnJ0OEWod+gPXFTscRUbkisI08UgQ+oa8RCMQyGcoSxqTCfIoOD3c38Q
         JGhjhq/Ww58NQ0xPDRRSDorpmq/53ViTrs7Jhl/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ZhangXiaoxu <zhangxiaoxu5@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 73/89] ipv4: set the tcp_min_rtt_wlen range from 0 to one day
Date:   Tue, 30 Apr 2019 13:39:04 +0200
Message-Id: <20190430113613.171700620@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ZhangXiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit 19fad20d15a6494f47f85d869f00b11343ee5c78 ]

There is a UBSAN report as below:
UBSAN: Undefined behaviour in net/ipv4/tcp_input.c:2877:56
signed integer overflow:
2147483647 * 1000 cannot be represented in type 'int'
CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.1.0-rc4-00058-g582549e #1
Call Trace:
 <IRQ>
 dump_stack+0x8c/0xba
 ubsan_epilogue+0x11/0x60
 handle_overflow+0x12d/0x170
 ? ttwu_do_wakeup+0x21/0x320
 __ubsan_handle_mul_overflow+0x12/0x20
 tcp_ack_update_rtt+0x76c/0x780
 tcp_clean_rtx_queue+0x499/0x14d0
 tcp_ack+0x69e/0x1240
 ? __wake_up_sync_key+0x2c/0x50
 ? update_group_capacity+0x50/0x680
 tcp_rcv_established+0x4e2/0xe10
 tcp_v4_do_rcv+0x22b/0x420
 tcp_v4_rcv+0xfe8/0x1190
 ip_protocol_deliver_rcu+0x36/0x180
 ip_local_deliver+0x15b/0x1a0
 ip_rcv+0xac/0xd0
 __netif_receive_skb_one_core+0x7f/0xb0
 __netif_receive_skb+0x33/0xc0
 netif_receive_skb_internal+0x84/0x1c0
 napi_gro_receive+0x2a0/0x300
 receive_buf+0x3d4/0x2350
 ? detach_buf_split+0x159/0x390
 virtnet_poll+0x198/0x840
 ? reweight_entity+0x243/0x4b0
 net_rx_action+0x25c/0x770
 __do_softirq+0x19b/0x66d
 irq_exit+0x1eb/0x230
 do_IRQ+0x7a/0x150
 common_interrupt+0xf/0xf
 </IRQ>

It can be reproduced by:
  echo 2147483647 > /proc/sys/net/ipv4/tcp_min_rtt_wlen

Fixes: f672258391b42 ("tcp: track min RTT using windowed min-filter")
Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/networking/ip-sysctl.txt |    1 +
 net/ipv4/sysctl_net_ipv4.c             |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -422,6 +422,7 @@ tcp_min_rtt_wlen - INTEGER
 	minimum RTT when it is moved to a longer path (e.g., due to traffic
 	engineering). A longer window makes the filter more resistant to RTT
 	inflations such as transient congestion. The unit is seconds.
+	Possible values: 0 - 86400 (1 day)
 	Default: 300
 
 tcp_moderate_rcvbuf - BOOLEAN
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -49,6 +49,7 @@ static int ip_ping_group_range_min[] = {
 static int ip_ping_group_range_max[] = { GID_T_MAX, GID_T_MAX };
 static int comp_sack_nr_max = 255;
 static u32 u32_max_div_HZ = UINT_MAX / HZ;
+static int one_day_secs = 24 * 3600;
 
 /* obsolete */
 static int sysctl_tcp_low_latency __read_mostly;
@@ -1151,7 +1152,9 @@ static struct ctl_table ipv4_net_table[]
 		.data		= &init_net.ipv4.sysctl_tcp_min_rtt_wlen,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one_day_secs
 	},
 	{
 		.procname	= "tcp_autocorking",



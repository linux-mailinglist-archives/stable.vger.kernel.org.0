Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BACF68DBA
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732817AbfGOOBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:01:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732249AbfGOOBK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:01:10 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14611212F5;
        Mon, 15 Jul 2019 14:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199269;
        bh=YU9Ov+IvcB3FjIh32fC4t4bC4jBwOGJL+Nj4udUiX0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kRuaz6cgg5v6LD9j3K8Xovtsy5Tbe8uSUqRDlRRtVaSrt+ERHiSdlaifiZs+soI2F
         jhVIKgXPZednwF1qYv8siKcFC9S8K/QVrDWtvkBQ35CVDXDvVt4TbHzuRq/OPL16A+
         KN2MOPYbZtDU9Z4q+SL4fQiuWm1qJbj6Y4bgaE+Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 5.2 223/249] rxrpc: Fix oops in tracepoint
Date:   Mon, 15 Jul 2019 09:46:28 -0400
Message-Id: <20190715134655.4076-223-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 99f0eae653b2db64917d0b58099eb51e300b311d ]

If the rxrpc_eproto tracepoint is enabled, an oops will be cause by the
trace line that rxrpc_extract_header() tries to emit when a protocol error
occurs (typically because the packet is short) because the call argument is
NULL.

Fix this by using ?: to assume 0 as the debug_id if call is NULL.

This can then be induced by:

	echo -e '\0\0\0\0\0\0\0\0' | ncat -4u --send-only <addr> 20001

where addr has the following program running on it:

	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <unistd.h>
	#include <sys/socket.h>
	#include <arpa/inet.h>
	#include <linux/rxrpc.h>
	int main(void)
	{
		struct sockaddr_rxrpc srx;
		int fd;
		memset(&srx, 0, sizeof(srx));
		srx.srx_family			= AF_RXRPC;
		srx.srx_service			= 0;
		srx.transport_type		= AF_INET;
		srx.transport_len		= sizeof(srx.transport.sin);
		srx.transport.sin.sin_family	= AF_INET;
		srx.transport.sin.sin_port	= htons(0x4e21);
		fd = socket(AF_RXRPC, SOCK_DGRAM, AF_INET6);
		bind(fd, (struct sockaddr *)&srx, sizeof(srx));
		sleep(20);
		return 0;
	}

It results in the following oops.

	BUG: kernel NULL pointer dereference, address: 0000000000000340
	#PF: supervisor read access in kernel mode
	#PF: error_code(0x0000) - not-present page
	...
	RIP: 0010:trace_event_raw_event_rxrpc_rx_eproto+0x47/0xac
	...
	Call Trace:
	 <IRQ>
	 rxrpc_extract_header+0x86/0x171
	 ? rcu_read_lock_sched_held+0x5d/0x63
	 ? rxrpc_new_skb+0xd4/0x109
	 rxrpc_input_packet+0xef/0x14fc
	 ? rxrpc_input_data+0x986/0x986
	 udp_queue_rcv_one_skb+0xbf/0x3d0
	 udp_unicast_rcv_skb.isra.8+0x64/0x71
	 ip_protocol_deliver_rcu+0xe4/0x1b4
	 ip_local_deliver+0xf0/0x154
	 __netif_receive_skb_one_core+0x50/0x6c
	 netif_receive_skb_internal+0x26b/0x2e9
	 napi_gro_receive+0xf8/0x1da
	 rtl8169_poll+0x303/0x4c4
	 net_rx_action+0x10e/0x333
	 __do_softirq+0x1a5/0x38f
	 irq_exit+0x54/0xc4
	 do_IRQ+0xda/0xf8
	 common_interrupt+0xf/0xf
	 </IRQ>
	 ...
	 ? cpuidle_enter_state+0x23c/0x34d
	 cpuidle_enter+0x2a/0x36
	 do_idle+0x163/0x1ea
	 cpu_startup_entry+0x1d/0x1f
	 start_secondary+0x157/0x172
	 secondary_startup_64+0xa4/0xb0

Fixes: a25e21f0bcd2 ("rxrpc, afs: Use debug_ids rather than pointers in traces")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rxrpc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index d85816878a52..cc1d060cbf13 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -1379,7 +1379,7 @@ TRACE_EVENT(rxrpc_rx_eproto,
 			     ),
 
 	    TP_fast_assign(
-		    __entry->call = call->debug_id;
+		    __entry->call = call ? call->debug_id : 0;
 		    __entry->serial = serial;
 		    __entry->why = why;
 			   ),
-- 
2.20.1


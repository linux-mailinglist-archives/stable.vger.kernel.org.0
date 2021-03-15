Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D150D33B675
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhCON54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230513AbhCON5V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBA1264F12;
        Mon, 15 Mar 2021 13:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816630;
        bh=yYdzIwPB7Xib0g7TLUPduIN9M2ypvKfrm3eiX0R9cbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vU6TgWuMkZ7XwZMstSEuCcAO+l/5MEWghmn6PAVzACvGAMIKlmNl2mP+wuO82arLr
         7Fg1heGQiC/L7f2cXmfTj9BGPtG9NkTTn8T85ZNt2Dk+CfDzKwxDq9Y6FiAtaIY4a3
         6IBX89WPyn2V1cWRXAEo4LCDnqgyxwaZdl4SySMY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Qingyu Li <ieatmuttonchuan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 014/168] tcp: add sanity tests to TCP_QUEUE_SEQ
Date:   Mon, 15 Mar 2021 14:54:06 +0100
Message-Id: <20210315135550.809435421@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Eric Dumazet <edumazet@google.com>

commit 8811f4a9836e31c14ecdf79d9f3cb7c5d463265d upstream.

Qingyu Li reported a syzkaller bug where the repro
changes RCV SEQ _after_ restoring data in the receive queue.

mprotect(0x4aa000, 12288, PROT_READ)    = 0
mmap(0x1ffff000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x1ffff000
mmap(0x20000000, 16777216, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x20000000
mmap(0x21000000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x21000000
socket(AF_INET6, SOCK_STREAM, IPPROTO_IP) = 3
setsockopt(3, SOL_TCP, TCP_REPAIR, [1], 4) = 0
connect(3, {sa_family=AF_INET6, sin6_port=htons(0), sin6_flowinfo=htonl(0), inet_pton(AF_INET6, "::1", &sin6_addr), sin6_scope_id=0}, 28) = 0
setsockopt(3, SOL_TCP, TCP_REPAIR_QUEUE, [1], 4) = 0
sendmsg(3, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="0x0000000000000003\0\0", iov_len=20}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 20
setsockopt(3, SOL_TCP, TCP_REPAIR, [0], 4) = 0
setsockopt(3, SOL_TCP, TCP_QUEUE_SEQ, [128], 4) = 0
recvfrom(3, NULL, 20, 0, NULL, NULL)    = -1 ECONNRESET (Connection reset by peer)

syslog shows:
[  111.205099] TCP recvmsg seq # bug 2: copied 80, seq 0, rcvnxt 80, fl 0
[  111.207894] WARNING: CPU: 1 PID: 356 at net/ipv4/tcp.c:2343 tcp_recvmsg_locked+0x90e/0x29a0

This should not be allowed. TCP_QUEUE_SEQ should only be used
when queues are empty.

This patch fixes this case, and the tx path as well.

Fixes: ee9952831cfd ("tcp: Initial repair mode")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=212005
Reported-by: Qingyu Li <ieatmuttonchuan@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2957,16 +2957,23 @@ static int do_tcp_setsockopt(struct sock
 		break;
 
 	case TCP_QUEUE_SEQ:
-		if (sk->sk_state != TCP_CLOSE)
+		if (sk->sk_state != TCP_CLOSE) {
 			err = -EPERM;
-		else if (tp->repair_queue == TCP_SEND_QUEUE)
-			WRITE_ONCE(tp->write_seq, val);
-		else if (tp->repair_queue == TCP_RECV_QUEUE) {
-			WRITE_ONCE(tp->rcv_nxt, val);
-			WRITE_ONCE(tp->copied_seq, val);
-		}
-		else
+		} else if (tp->repair_queue == TCP_SEND_QUEUE) {
+			if (!tcp_rtx_queue_empty(sk))
+				err = -EPERM;
+			else
+				WRITE_ONCE(tp->write_seq, val);
+		} else if (tp->repair_queue == TCP_RECV_QUEUE) {
+			if (tp->rcv_nxt != tp->copied_seq) {
+				err = -EPERM;
+			} else {
+				WRITE_ONCE(tp->rcv_nxt, val);
+				WRITE_ONCE(tp->copied_seq, val);
+			}
+		} else {
 			err = -EINVAL;
+		}
 		break;
 
 	case TCP_REPAIR_OPTIONS:



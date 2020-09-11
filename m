Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E6E26611D
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 16:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgIKOWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 10:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgIKNMA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:12:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CBDE22470;
        Fri, 11 Sep 2020 13:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829248;
        bh=C5nKer2Jum4n4Im1aEba68v56hO50CYpNw/1Tc/C6lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m2kXUuCfuJvRtUklfbZvq6AptnfdSBEEiU6GUXQ6GsAZyB0HEjNH8W7rhWXgNpmYU
         kPnfQWcLcGe/OFJOX9B4aihkP3Us1i14tRKaca1gmbSbI63DpBy5aOqppDjy4T+0LP
         sjdSyjd0ko/sGPqvm0dkThIVcig+/osBnQ+l59u4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+e36f41d207137b5d12f7@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 6/8] tipc: fix shutdown() of connectionless socket
Date:   Fri, 11 Sep 2020 14:54:53 +0200
Message-Id: <20200911125422.009520336@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911125421.695645838@linuxfoundation.org>
References: <20200911125421.695645838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 2a63866c8b51a3f72cea388dfac259d0e14c4ba6 ]

syzbot is reporting hung task at nbd_ioctl() [1], for there are two
problems regarding TIPC's connectionless socket's shutdown() operation.

----------
#include <fcntl.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <linux/nbd.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
        const int fd = open("/dev/nbd0", 3);
        alarm(5);
        ioctl(fd, NBD_SET_SOCK, socket(PF_TIPC, SOCK_DGRAM, 0));
        ioctl(fd, NBD_DO_IT, 0); /* To be interrupted by SIGALRM. */
        return 0;
}
----------

One problem is that wait_for_completion() from flush_workqueue() from
nbd_start_device_ioctl() from nbd_ioctl() cannot be completed when
nbd_start_device_ioctl() received a signal at wait_event_interruptible(),
for tipc_shutdown() from kernel_sock_shutdown(SHUT_RDWR) from
nbd_mark_nsock_dead() from sock_shutdown() from nbd_start_device_ioctl()
is failing to wake up a WQ thread sleeping at wait_woken() from
tipc_wait_for_rcvmsg() from sock_recvmsg() from sock_xmit() from
nbd_read_stat() from recv_work() scheduled by nbd_start_device() from
nbd_start_device_ioctl(). Fix this problem by always invoking
sk->sk_state_change() (like inet_shutdown() does) when tipc_shutdown() is
called.

The other problem is that tipc_wait_for_rcvmsg() cannot return when
tipc_shutdown() is called, for tipc_shutdown() sets sk->sk_shutdown to
SEND_SHUTDOWN (despite "how" is SHUT_RDWR) while tipc_wait_for_rcvmsg()
needs sk->sk_shutdown set to RCV_SHUTDOWN or SHUTDOWN_MASK. Fix this
problem by setting sk->sk_shutdown to SHUTDOWN_MASK (like inet_shutdown()
does) when the socket is connectionless.

[1] https://syzkaller.appspot.com/bug?id=3fe51d307c1f0a845485cf1798aa059d12bf18b2

Reported-by: syzbot <syzbot+e36f41d207137b5d12f7@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/socket.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2565,18 +2565,21 @@ static int tipc_shutdown(struct socket *
 	lock_sock(sk);
 
 	__tipc_shutdown(sock, TIPC_CONN_SHUTDOWN);
-	sk->sk_shutdown = SEND_SHUTDOWN;
+	if (tipc_sk_type_connectionless(sk))
+		sk->sk_shutdown = SHUTDOWN_MASK;
+	else
+		sk->sk_shutdown = SEND_SHUTDOWN;
 
 	if (sk->sk_state == TIPC_DISCONNECTING) {
 		/* Discard any unreceived messages */
 		__skb_queue_purge(&sk->sk_receive_queue);
 
-		/* Wake up anyone sleeping in poll */
-		sk->sk_state_change(sk);
 		res = 0;
 	} else {
 		res = -ENOTCONN;
 	}
+	/* Wake up anyone sleeping in poll. */
+	sk->sk_state_change(sk);
 
 	release_sock(sk);
 	return res;



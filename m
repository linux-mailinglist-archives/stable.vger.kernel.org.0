Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCC6019B41B
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387421AbgDAQYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:24:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732286AbgDAQYC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:24:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 169DF21744;
        Wed,  1 Apr 2020 16:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758241;
        bh=6kmzOfKlvodBmbyU6T7UJ/bnCnSCfu18QH7zz18a3lI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pROjNTrtHmQKr4pYkSRcmcbvElPteWfl+N9lnN9L7L8K/2I0mIKOWftnZUSIunqQa
         gttcJBBoAlUBA9ZUfkNI7zdD9MYKtbMz4lJAHRdNP53wxYxDH92yWpT6O/WaJ3dXX5
         rwSzPriZ1kl6WMWXDDyXGym8qsOi05vboDvgmHsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 028/116] tcp: repair: fix TCP_QUEUE_SEQ implementation
Date:   Wed,  1 Apr 2020 18:16:44 +0200
Message-Id: <20200401161545.988970668@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161542.669484650@linuxfoundation.org>
References: <20200401161542.669484650@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6cd6cbf593bfa3ae6fc3ed34ac21da4d35045425 ]

When application uses TCP_QUEUE_SEQ socket option to
change tp->rcv_next, we must also update tp->copied_seq.

Otherwise, stuff relying on tcp_inq() being precise can
eventually be confused.

For example, tcp_zerocopy_receive() might crash because
it does not expect tcp_recv_skb() to return NULL.

We could add tests in various places to fix the issue,
or simply make sure tcp_inq() wont return a random value,
and leave fast path as it is.

Note that this fixes ioctl(fd, SIOCINQ, &val) at the same
time.

Fixes: ee9952831cfd ("tcp: Initial repair mode")
Fixes: 05255b823a61 ("tcp: add TCP_ZEROCOPY_RECEIVE support for zerocopy receive")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2870,8 +2870,10 @@ static int do_tcp_setsockopt(struct sock
 			err = -EPERM;
 		else if (tp->repair_queue == TCP_SEND_QUEUE)
 			tp->write_seq = val;
-		else if (tp->repair_queue == TCP_RECV_QUEUE)
+		else if (tp->repair_queue == TCP_RECV_QUEUE) {
 			WRITE_ONCE(tp->rcv_nxt, val);
+			WRITE_ONCE(tp->copied_seq, val);
+		}
 		else
 			err = -EINVAL;
 		break;



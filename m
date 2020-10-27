Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1E529B043
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460349AbgJ0ORh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:17:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900922AbgJ0ORg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:17:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26FC62072D;
        Tue, 27 Oct 2020 14:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808255;
        bh=fbUSzlPx4zQ2pnGfHdEfXwafO/IyIBo1m7vriQL/cEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UhA0t/Q/5nkvAqLgQUfudlyQ98haBeLG1yuf320Ragm7B1YEy9kKQWov70F3Qc1QG
         sxaPc/Vrc1YeL0gA0la0FWE4sM6LGZQgsElkfnsdL/qzsGi6aKfl0yk1xDZRE2xqer
         MT+e3hEwH6AVXNj/t9Pipc5U4wE3h99O2fvzM11c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Apollon Oikonomopoulos <apoikos@dmesg.gr>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 023/264] tcp: fix to update snd_wl1 in bulk receiver fast path
Date:   Tue, 27 Oct 2020 14:51:21 +0100
Message-Id: <20201027135431.739910965@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit 18ded910b589839e38a51623a179837ab4cc3789 ]

In the header prediction fast path for a bulk data receiver, if no
data is newly acknowledged then we do not call tcp_ack() and do not
call tcp_ack_update_window(). This means that a bulk receiver that
receives large amounts of data can have the incoming sequence numbers
wrap, so that the check in tcp_may_update_window fails:
   after(ack_seq, tp->snd_wl1)

If the incoming receive windows are zero in this state, and then the
connection that was a bulk data receiver later wants to send data,
that connection can find itself persistently rejecting the window
updates in incoming ACKs. This means the connection can persistently
fail to discover that the receive window has opened, which in turn
means that the connection is unable to send anything, and the
connection's sending process can get permanently "stuck".

The fix is to update snd_wl1 in the header prediction fast path for a
bulk data receiver, so that it keeps up and does not see wrapping
problems.

This fix is based on a very nice and thorough analysis and diagnosis
by Apollon Oikonomopoulos (see link below).

This is a stable candidate but there is no Fixes tag here since the
bug predates current git history. Just for fun: looks like the bug
dates back to when header prediction was added in Linux v2.1.8 in Nov
1996. In that version tcp_rcv_established() was added, and the code
only updates snd_wl1 in tcp_ack(), and in the new "Bulk data transfer:
receiver" code path it does not call tcp_ack(). This fix seems to
apply cleanly at least as far back as v3.2.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Reported-by: Apollon Oikonomopoulos <apoikos@dmesg.gr>
Tested-by: Apollon Oikonomopoulos <apoikos@dmesg.gr>
Link: https://www.spinics.net/lists/netdev/msg692430.html
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20201022143331.1887495-1-ncardwell.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5631,6 +5631,8 @@ void tcp_rcv_established(struct sock *sk
 				tcp_data_snd_check(sk);
 				if (!inet_csk_ack_scheduled(sk))
 					goto no_ack;
+			} else {
+				tcp_update_wl(tp, TCP_SKB_CB(skb)->seq);
 			}
 
 			__tcp_ack_snd_check(sk, 0);



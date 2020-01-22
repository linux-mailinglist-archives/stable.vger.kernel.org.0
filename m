Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF6621455D0
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730676AbgAVNZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:25:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730443AbgAVNZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:25:27 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E66A2467B;
        Wed, 22 Jan 2020 13:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699525;
        bh=7vA9ZW7WwkHccEel+n+5U8Okkd7rnOSnouieo2fX4dQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2NbWu/QxB+9cKpPAiB9CrGykhIv1CELD0/+b15KUyysEAwVD6os8WMf2vxAAlzrZv
         lwhC7HYPHSvY+DtKx4yVKHIlHGPI+wLYATw2/d8t4L70eWiteHLUqp5zDvEuFTYs3n
         9meWUiReIJRI96l9i3vCVQlmndxe2y07MgU9KNFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jason Baron <jbaron@akamai.com>,
        Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 5.4 172/222] tcp: refine rule to allow EPOLLOUT generation under mem pressure
Date:   Wed, 22 Jan 2020 10:29:18 +0100
Message-Id: <20200122092846.021033976@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 216808c6ba6d00169fd2aa928ec3c0e63bef254f upstream.

At the time commit ce5ec440994b ("tcp: ensure epoll edge trigger
wakeup when write queue is empty") was added to the kernel,
we still had a single write queue, combining rtx and write queues.

Once we moved the rtx queue into a separate rb-tree, testing
if sk_write_queue is empty has been suboptimal.

Indeed, if we have packets in the rtx queue, we probably want
to delay the EPOLLOUT generation at the time incoming packets
will free them, making room, but more importantly avoiding
flooding application with EPOLLOUT events.

Solution is to use tcp_rtx_and_write_queues_empty() helper.

Fixes: 75c119afe14f ("tcp: implement rb-tree based retransmit queue")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Neal Cardwell <ncardwell@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/tcp.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1087,8 +1087,7 @@ do_error:
 		goto out;
 out_err:
 	/* make sure we wake any epoll edge trigger waiter */
-	if (unlikely(skb_queue_len(&sk->sk_write_queue) == 0 &&
-		     err == -EAGAIN)) {
+	if (unlikely(tcp_rtx_and_write_queues_empty(sk) && err == -EAGAIN)) {
 		sk->sk_write_space(sk);
 		tcp_chrono_stop(sk, TCP_CHRONO_SNDBUF_LIMITED);
 	}
@@ -1419,8 +1418,7 @@ out_err:
 	sock_zerocopy_put_abort(uarg, true);
 	err = sk_stream_error(sk, flags, err);
 	/* make sure we wake any epoll edge trigger waiter */
-	if (unlikely(skb_queue_len(&sk->sk_write_queue) == 0 &&
-		     err == -EAGAIN)) {
+	if (unlikely(tcp_rtx_and_write_queues_empty(sk) && err == -EAGAIN)) {
 		sk->sk_write_space(sk);
 		tcp_chrono_stop(sk, TCP_CHRONO_SNDBUF_LIMITED);
 	}



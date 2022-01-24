Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA624997EB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378452AbiAXVR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:17:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34382 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376794AbiAXVN1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:13:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03CA9B812A4;
        Mon, 24 Jan 2022 21:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177ECC340E8;
        Mon, 24 Jan 2022 21:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058800;
        bh=nuteEGewQqTwcTFHFsQbW1oe/ul0Q5xnOiHBmfH1eRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xwDtJxbbpjtj12xW19E5UwZL1z0pMTyPSLWsMQHl5wogFWXd7Y+aBVdQeZCni7ZrP
         AgBpYcR1JVThl8mtiZqAh/i66l7DKcb4M/JYttWmsaa5OX2zdxXcia2iBUVCkj5cJ3
         blIpUXH6mw6ZW7iN1v6i3p2t5216XfqM295VMSiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0373/1039] bpf, sockmap: Fix return codes from tcp_bpf_recvmsg_parser()
Date:   Mon, 24 Jan 2022 19:36:02 +0100
Message-Id: <20220124184137.848364641@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 5b2c5540b8110eea0d67a78fb0ddb9654c58daeb ]

Applications can be confused slightly because we do not always return the
same error code as expected, e.g. what the TCP stack normally returns. For
example on a sock err sk->sk_err instead of returning the sock_error we
return EAGAIN. This usually means the application will 'try again'
instead of aborting immediately. Another example, when a shutdown event
is received we should immediately abort instead of waiting for data when
the user provides a timeout.

These tend to not be fatal, applications usually recover, but introduces
bogus errors to the user or introduces unexpected latency. Before
'c5d2177a72a16' we fell back to the TCP stack when no data was available
so we managed to catch many of the cases here, although with the extra
latency cost of calling tcp_msg_wait_data() first.

To fix lets duplicate the error handling in TCP stack into tcp_bpf so
that we get the same error codes.

These were found in our CI tests that run applications against sockmap
and do longer lived testing, at least compared to test_sockmap that
does short-lived ping/pong tests, and in some of our test clusters
we deploy.

Its non-trivial to do these in a shorter form CI tests that would be
appropriate for BPF selftests, but we are looking into it so we can
ensure this keeps working going forward. As a preview one idea is to
pull in the packetdrill testing which catches some of this.

Fixes: c5d2177a72a16 ("bpf, sockmap: Fix race in ingress receive verdict with redirect to self")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220104205918.286416-1-john.fastabend@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index f70aa0932bd6c..9b9b02052fd36 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -196,12 +196,39 @@ msg_bytes_ready:
 		long timeo;
 		int data;
 
+		if (sock_flag(sk, SOCK_DONE))
+			goto out;
+
+		if (sk->sk_err) {
+			copied = sock_error(sk);
+			goto out;
+		}
+
+		if (sk->sk_shutdown & RCV_SHUTDOWN)
+			goto out;
+
+		if (sk->sk_state == TCP_CLOSE) {
+			copied = -ENOTCONN;
+			goto out;
+		}
+
 		timeo = sock_rcvtimeo(sk, nonblock);
+		if (!timeo) {
+			copied = -EAGAIN;
+			goto out;
+		}
+
+		if (signal_pending(current)) {
+			copied = sock_intr_errno(timeo);
+			goto out;
+		}
+
 		data = tcp_msg_wait_data(sk, psock, timeo);
 		if (data && !sk_psock_queue_empty(psock))
 			goto msg_bytes_ready;
 		copied = -EAGAIN;
 	}
+out:
 	release_sock(sk);
 	sk_psock_put(sk, psock);
 	return copied;
-- 
2.34.1




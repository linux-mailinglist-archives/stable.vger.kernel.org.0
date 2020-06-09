Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1339A1F4398
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733139AbgFIRyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:54:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733131AbgFIRym (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:54:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3662207F9;
        Tue,  9 Jun 2020 17:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725282;
        bh=jM0oMkokSpwwffYJacSP7JNj/zACzPww+HO/X0xDT+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0dsKjld7Hhv/k/FsYIDnP6LyWaRrNizMQ7Xf9AulK+gYc3jY1pzwkT4kK0W/1eIXt
         +wasvdKbE7MnhWM6Mj8rDoML3aXA25OEkbS37JbHwHzSY4ZKRL5IfLHpXVkvcR993G
         gGbqkZzbEnxX0tcQcxr5GyrLQV2iYGJ4iAsu0Pl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 15/41] mptcp: fix unblocking connect()
Date:   Tue,  9 Jun 2020 19:45:17 +0200
Message-Id: <20200609174113.589926014@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174112.129412236@linuxfoundation.org>
References: <20200609174112.129412236@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 41be81a8d3d09acb9033799938306349328861f9 ]

Currently unblocking connect() on MPTCP sockets fails frequently.
If mptcp_stream_connect() is invoked to complete a previously
attempted unblocking connection, it will still try to create
the first subflow via __mptcp_socket_create(). If the 3whs is
completed and the 'can_ack' flag is already set, the latter
will fail with -EINVAL.

This change addresses the issue checking for pending connect and
delegating the completion to the first subflow. Additionally
do msk addresses and sk_state changes only when needed.

Fixes: 2303f994b3e1 ("mptcp: Associate MPTCP context with TCP socket")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -920,6 +920,14 @@ static int mptcp_stream_connect(struct s
 	int err;
 
 	lock_sock(sock->sk);
+	if (sock->state != SS_UNCONNECTED && msk->subflow) {
+		/* pending connection or invalid state, let existing subflow
+		 * cope with that
+		 */
+		ssock = msk->subflow;
+		goto do_connect;
+	}
+
 	ssock = __mptcp_socket_create(msk, TCP_SYN_SENT);
 	if (IS_ERR(ssock)) {
 		err = PTR_ERR(ssock);
@@ -934,9 +942,17 @@ static int mptcp_stream_connect(struct s
 		mptcp_subflow_ctx(ssock->sk)->request_mptcp = 0;
 #endif
 
+do_connect:
 	err = ssock->ops->connect(ssock, uaddr, addr_len, flags);
-	inet_sk_state_store(sock->sk, inet_sk_state_load(ssock->sk));
-	mptcp_copy_inaddrs(sock->sk, ssock->sk);
+	sock->state = ssock->state;
+
+	/* on successful connect, the msk state will be moved to established by
+	 * subflow_finish_connect()
+	 */
+	if (!err || err == EINPROGRESS)
+		mptcp_copy_inaddrs(sock->sk, ssock->sk);
+	else
+		inet_sk_state_store(sock->sk, inet_sk_state_load(ssock->sk));
 
 unlock:
 	release_sock(sock->sk);



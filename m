Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916683AEE3C
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhFUQ1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:27:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232113AbhFUQZU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:25:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE9BF611C1;
        Mon, 21 Jun 2021 16:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292505;
        bh=QyJQeR/1wF27IRXTZXQA8A07iAp10orJQxYuY6Pohas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDGkoPe85/QAskcX2FNY2NxlHKCzvuIQsiQuCXUHgNL49LWApopl8XdBwGSTksqdc
         4a9EPRq8WxCcbRB0qSF+2/cQwtOjt6jfPdSiE0vhTqlRcMjLUKuJqHm7e0bMMD8IN8
         AsgU4dU+s/6UID4Va3Wyfyod60ClSOlWzjt4JIQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Kaustubh Pandey <kapandey@codeaurora.org>
Subject: [PATCH 5.10 025/146] udp: fix race between close() and udp_abort()
Date:   Mon, 21 Jun 2021 18:14:15 +0200
Message-Id: <20210621154912.127290897@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit a8b897c7bcd47f4147d066e22cc01d1026d7640e ]

Kaustubh reported and diagnosed a panic in udp_lib_lookup().
The root cause is udp_abort() racing with close(). Both
racing functions acquire the socket lock, but udp{v6}_destroy_sock()
release it before performing destructive actions.

We can't easily extend the socket lock scope to avoid the race,
instead use the SOCK_DEAD flag to prevent udp_abort from doing
any action when the critical race happens.

Diagnosed-and-tested-by: Kaustubh Pandey <kapandey@codeaurora.org>
Fixes: 5d77dca82839 ("net: diag: support SOCK_DESTROY for UDP sockets")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 10 ++++++++++
 net/ipv6/udp.c |  3 +++
 2 files changed, 13 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 9d28b2778e8f..fbb9a11fe4a3 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2569,6 +2569,9 @@ void udp_destroy_sock(struct sock *sk)
 {
 	struct udp_sock *up = udp_sk(sk);
 	bool slow = lock_sock_fast(sk);
+
+	/* protects from races with udp_abort() */
+	sock_set_flag(sk, SOCK_DEAD);
 	udp_flush_pending_frames(sk);
 	unlock_sock_fast(sk, slow);
 	if (static_branch_unlikely(&udp_encap_needed_key)) {
@@ -2819,10 +2822,17 @@ int udp_abort(struct sock *sk, int err)
 {
 	lock_sock(sk);
 
+	/* udp{v6}_destroy_sock() sets it under the sk lock, avoid racing
+	 * with close()
+	 */
+	if (sock_flag(sk, SOCK_DEAD))
+		goto out;
+
 	sk->sk_err = err;
 	sk->sk_error_report(sk);
 	__udp_disconnect(sk, 0);
 
+out:
 	release_sock(sk);
 
 	return 0;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 29d9691359b9..e2de58d6cdce 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1596,6 +1596,9 @@ void udpv6_destroy_sock(struct sock *sk)
 {
 	struct udp_sock *up = udp_sk(sk);
 	lock_sock(sk);
+
+	/* protects from races with udp_abort() */
+	sock_set_flag(sk, SOCK_DEAD);
 	udp_v6_flush_pending_frames(sk);
 	release_sock(sk);
 
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC4E3B63A7
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbhF1O6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237001AbhF1O4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:56:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66F9961C91;
        Mon, 28 Jun 2021 14:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891224;
        bh=aUeuIH1sfzJkc/v+yS8bwKEvd50D9xe6Sqf8nR1MWGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m7yRS8Nmz/XRSwwjB+UQQPuz73IR4wCdQns/cOeW2ym0YYDc16ZHhpwEiJJJvJWXq
         pgR95K3EHx1OF+ZIm1SnIvjQbX+EFTmce71Pfy/zv5E9NbHTnxa5mRhAth+Af8YSt/
         /dC/dPjHy/BCXO5RFL949Z0rHnnl3VXsF62vAUPe5dDPTQWESPWQ821NMJHuEtzOAG
         iqfqM5svgHzRTwWTG7kI54N9iqTZCIRbmUDM+6bQWZwTZDnR3iqxIIKXMZ2PCGw242
         G64EXYnQp7zVr3pPjS6AhOhVjdd3NtdyeXELZZnzHkjPX8wYs00SB3cqCi0k/FrHKi
         TX5YEAdeHhBFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Kaustubh Pandey <kapandey@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 21/71] udp: fix race between close() and udp_abort()
Date:   Mon, 28 Jun 2021 10:39:13 -0400
Message-Id: <20210628144003.34260-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
index 18a1a4890c5f..79249a44e4a3 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1998,6 +1998,9 @@ void udp_destroy_sock(struct sock *sk)
 {
 	struct udp_sock *up = udp_sk(sk);
 	bool slow = lock_sock_fast(sk);
+
+	/* protects from races with udp_abort() */
+	sock_set_flag(sk, SOCK_DEAD);
 	udp_flush_pending_frames(sk);
 	unlock_sock_fast(sk, slow);
 	if (static_key_false(&udp_encap_needed) && up->encap_type) {
@@ -2228,10 +2231,17 @@ int udp_abort(struct sock *sk, int err)
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
index 1ad84e18c03b..3a876a2fdd82 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1325,6 +1325,9 @@ void udpv6_destroy_sock(struct sock *sk)
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


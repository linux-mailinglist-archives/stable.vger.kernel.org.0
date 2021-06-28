Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5458C3B630B
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbhF1OvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:51:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236453AbhF1OtV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:49:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6583561D20;
        Mon, 28 Jun 2021 14:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891013;
        bh=OptOz2fisIGCvH3Zsww+79CKj7rj2Pu5G7SE5nhXbGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cAL4pC2iDrsP++yTgz12hSRmZxJ+SQVByeQOKHxuarcavCLz5foE391ElwUDRVZ1z
         w5y7kVzk0cbTcmcmmKiji+BIo77l4AYOUDkkRUs6kDSQiNQ3LvjJClrp4Efhd4+JDg
         6bCDHY1AFYDcgfHQR7suqeX8GlFvTVAwofYuAwUDUi+J91M4U7M2J5CPn3z8yyUjQj
         UmUsoVdIVFiYheALSVZssRf8M9vID6SqnjyMupuyPjVBqn0V+vUTpAXSSyUpBJOmNu
         84VmOE2ronfoSZ9ygiuNczCG8IwFVzPR5Y2fAOmK0zgM/8QMwwZok38cDd5ElqJZyM
         n2Su0LLZZDveg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Kaustubh Pandey <kapandey@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 25/88] udp: fix race between close() and udp_abort()
Date:   Mon, 28 Jun 2021 10:35:25 -0400
Message-Id: <20210628143628.33342-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
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
index 8f298f27f6ec..cf5c4d2f68c1 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2337,6 +2337,9 @@ void udp_destroy_sock(struct sock *sk)
 {
 	struct udp_sock *up = udp_sk(sk);
 	bool slow = lock_sock_fast(sk);
+
+	/* protects from races with udp_abort() */
+	sock_set_flag(sk, SOCK_DEAD);
 	udp_flush_pending_frames(sk);
 	unlock_sock_fast(sk, slow);
 	if (static_key_false(&udp_encap_needed) && up->encap_type) {
@@ -2570,10 +2573,17 @@ int udp_abort(struct sock *sk, int err)
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
index 38ad3fac8c37..d9d25b9c07ae 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1434,6 +1434,9 @@ void udpv6_destroy_sock(struct sock *sk)
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


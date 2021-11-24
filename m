Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD89B45C399
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350862AbhKXNk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:40:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:51616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350383AbhKXNiF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:38:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91FE36321D;
        Wed, 24 Nov 2021 12:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758566;
        bh=cirMelDD1jA4y3zy6skNo3A/lbYbKdEROYnGlA3xii4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLyOeho9/qb8NcVwzYqcOEqxyOmwzxdlzPUcJRiCA8/M8UZ2PYR6o+iXCMfn4ukn6
         /h/UJx1bBHSFRx2I4NGjCxQjdf6pRP/Cht0CLeMbajJfl7Kam60o6C/23vuBXwea/4
         +qA9/EakC80RgZLvhTTrqbIo6m8mviOBQBGRA5XI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/154] sock: fix /proc/net/sockstat underflow in sk_clone_lock()
Date:   Wed, 24 Nov 2021 12:57:54 +0100
Message-Id: <20211124115704.850428242@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

[ Upstream commit 938cca9e4109b30ee1d476904538225a825e54eb ]

sk_clone_lock() needs to call sock_inuse_add(1) before entering the
sk_free_unlock_clone() error path, for __sk_free() from sk_free() from
sk_free_unlock_clone() calls sock_inuse_add(-1).

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 648845ab7e200993 ("sock: Move the socket inuse to namespace.")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 3da4cd632ba8e..6d9af4ef93d7a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1896,8 +1896,10 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 	newsk->sk_prot_creator = prot;
 
 	/* SANITY */
-	if (likely(newsk->sk_net_refcnt))
+	if (likely(newsk->sk_net_refcnt)) {
 		get_net(sock_net(newsk));
+		sock_inuse_add(sock_net(newsk), 1);
+	}
 	sk_node_init(&newsk->sk_node);
 	sock_lock_init(newsk);
 	bh_lock_sock(newsk);
@@ -1968,8 +1970,6 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 	newsk->sk_err_soft = 0;
 	newsk->sk_priority = 0;
 	newsk->sk_incoming_cpu = raw_smp_processor_id();
-	if (likely(newsk->sk_net_refcnt))
-		sock_inuse_add(sock_net(newsk), 1);
 
 	/* Before updating sk_refcnt, we must commit prior changes to memory
 	 * (Documentation/RCU/rculist_nulls.rst for details)
-- 
2.33.0




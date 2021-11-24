Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF7945C510
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352109AbhKXNyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:54:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354671AbhKXNwr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:52:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89B156120D;
        Wed, 24 Nov 2021 13:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759085;
        bh=cpcvhHxjUWUBTDOJGZJQwP3WhvKHaQpiUub6+d94qsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jGIl3YdyRQW7OCuCffpz8X3/xOuKMfjYwOGC72cbkxCEqjsPayy6SZquqPE1jjua/
         BU/CDg+PYWaQwQhWt5Sd+mujOIRgChkKFPd0zX+XKbm7aibCGEKqsLb1kh5wHTJMwF
         cVj8a+jInaaXmykit0Bxgez7HA537w0d60nPOrVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/279] sock: fix /proc/net/sockstat underflow in sk_clone_lock()
Date:   Wed, 24 Nov 2021 12:56:47 +0100
Message-Id: <20211124115722.945668669@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
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
index c1601f75ec4b3..1b31e10181629 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2043,8 +2043,10 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
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
@@ -2115,8 +2117,6 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 	newsk->sk_err_soft = 0;
 	newsk->sk_priority = 0;
 	newsk->sk_incoming_cpu = raw_smp_processor_id();
-	if (likely(newsk->sk_net_refcnt))
-		sock_inuse_add(sock_net(newsk), 1);
 
 	/* Before updating sk_refcnt, we must commit prior changes to memory
 	 * (Documentation/RCU/rculist_nulls.rst for details)
-- 
2.33.0




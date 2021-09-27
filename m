Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B891419C0D
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237728AbhI0RZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:25:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237727AbhI0RXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:23:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6E1A613A9;
        Mon, 27 Sep 2021 17:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762900;
        bh=Igm8WezuYTaPVJN2HKZsN9aGg/fdxmXqyqVhZAEXnbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IbM5V6XS27ez+U4zbKJLD4gf7GqSvEcn0DXx96WXxyLrgvFj73dm2WIJqQmMfMwVC
         NvtIkvckdoVgeEHic5i25mp8p2R9csepSZD6AbLYQ/iK9AjWclFe9csa+s8XwimBkl
         8SZlkJO1+ZAdAyGS8mz8dv5huUW6b3CyRwar1Gqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 061/162] napi: fix race inside napi_enable
Date:   Mon, 27 Sep 2021 19:01:47 +0200
Message-Id: <20210927170235.589030577@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

[ Upstream commit 3765996e4f0b8a755cab215a08df744490c76052 ]

The process will cause napi.state to contain NAPI_STATE_SCHED and
not in the poll_list, which will cause napi_disable() to get stuck.

The prefix "NAPI_STATE_" is removed in the figure below, and
NAPI_STATE_HASHED is ignored in napi.state.

                      CPU0       |                   CPU1       | napi.state
===============================================================================
napi_disable()                   |                              | SCHED | NPSVC
napi_enable()                    |                              |
{                                |                              |
    smp_mb__before_atomic();     |                              |
    clear_bit(SCHED, &n->state); |                              | NPSVC
                                 | napi_schedule_prep()         | SCHED | NPSVC
                                 | napi_poll()                  |
                                 |   napi_complete_done()       |
                                 |   {                          |
                                 |      if (n->state & (NPSVC | | (1)
                                 |               _BUSY_POLL)))  |
                                 |           return false;      |
                                 |     ................         |
                                 |   }                          | SCHED | NPSVC
                                 |                              |
    clear_bit(NPSVC, &n->state); |                              | SCHED
}                                |                              |
                                 |                              |
napi_schedule_prep()             |                              | SCHED | MISSED (2)

(1) Here return direct. Because of NAPI_STATE_NPSVC exists.
(2) NAPI_STATE_SCHED exists. So not add napi.poll_list to sd->poll_list

Since NAPI_STATE_SCHED already exists and napi is not in the
sd->poll_list queue, NAPI_STATE_SCHED cannot be cleared and will always
exist.

1. This will cause this queue to no longer receive packets.
2. If you encounter napi_disable under the protection of rtnl_lock, it
   will cause the entire rtnl_lock to be locked, affecting the overall
   system.

This patch uses cmpxchg to implement napi_enable(), which ensures that
there will be no race due to the separation of clear two bits.

Fixes: 2d8bff12699abc ("netpoll: Close race condition between poll_one_napi and napi_disable")
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8f1a47ad6781..693f15a05630 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6988,12 +6988,16 @@ EXPORT_SYMBOL(napi_disable);
  */
 void napi_enable(struct napi_struct *n)
 {
-	BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
-	smp_mb__before_atomic();
-	clear_bit(NAPI_STATE_SCHED, &n->state);
-	clear_bit(NAPI_STATE_NPSVC, &n->state);
-	if (n->dev->threaded && n->thread)
-		set_bit(NAPI_STATE_THREADED, &n->state);
+	unsigned long val, new;
+
+	do {
+		val = READ_ONCE(n->state);
+		BUG_ON(!test_bit(NAPI_STATE_SCHED, &val));
+
+		new = val & ~(NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC);
+		if (n->dev->threaded && n->thread)
+			new |= NAPIF_STATE_THREADED;
+	} while (cmpxchg(&n->state, val, new) != val);
 }
 EXPORT_SYMBOL(napi_enable);
 
-- 
2.33.0




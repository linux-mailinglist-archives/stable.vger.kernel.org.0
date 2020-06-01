Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE32C1EACF6
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731164AbgFASL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:11:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731160AbgFASLw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:11:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B2B2207D0;
        Mon,  1 Jun 2020 18:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035111;
        bh=INyIoLZR38S87I4PhecHV7SKIoJ1l7kF2k1fHiJg7wQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b6A0Cmbcy902Rv5X2zw9sORIdnGbaZmd3Pv629RMcn4nBz/iwNX7pkLhnSNS+PLgr
         2ttObMBbWc7XiLyHsnKtKRq+gRrg4BV7I7QIqiK+LrUL2FVT5AKEbX75adoWOvoyu7
         q6FeVHaT8X2UL3N6j05KjuEACjYzkcGh/xgy6r7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Jiong Wang <jiongwang@huawei.com>,
        Yuqi Jin <jinyuqi@huawei.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>
Subject: [PATCH 5.6 015/177] net: revert "net: get rid of an signed integer overflow in ip_idents_reserve()"
Date:   Mon,  1 Jun 2020 19:52:33 +0200
Message-Id: <20200601174049.938201802@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuqi Jin <jinyuqi@huawei.com>

[ Upstream commit a6211caa634da39d861a47437ffcda8b38ef421b ]

Commit adb03115f459 ("net: get rid of an signed integer overflow in ip_idents_reserve()")
used atomic_cmpxchg to replace "atomic_add_return" inside the function
"ip_idents_reserve". The reason was to avoid UBSAN warning.
However, this change has caused performance degrade and in GCC-8,
fno-strict-overflow is now mapped to -fwrapv -fwrapv-pointer
and signed integer overflow is now undefined by default at all
optimization levels[1]. Moreover, it was a bug in UBSAN vs -fwrapv
/-fno-strict-overflow, so Let's revert it safely.

[1] https://gcc.gnu.org/gcc-8/changes.html

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jiong Wang <jiongwang@huawei.com>
Signed-off-by: Yuqi Jin <jinyuqi@huawei.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -491,18 +491,16 @@ u32 ip_idents_reserve(u32 hash, int segs
 	atomic_t *p_id = ip_idents + hash % IP_IDENTS_SZ;
 	u32 old = READ_ONCE(*p_tstamp);
 	u32 now = (u32)jiffies;
-	u32 new, delta = 0;
+	u32 delta = 0;
 
 	if (old != now && cmpxchg(p_tstamp, old, now) == old)
 		delta = prandom_u32_max(now - old);
 
-	/* Do not use atomic_add_return() as it makes UBSAN unhappy */
-	do {
-		old = (u32)atomic_read(p_id);
-		new = old + delta + segs;
-	} while (atomic_cmpxchg(p_id, old, new) != old);
-
-	return new - segs;
+	/* If UBSAN reports an error there, please make sure your compiler
+	 * supports -fno-strict-overflow before reporting it that was a bug
+	 * in UBSAN, and it has been fixed in GCC-8.
+	 */
+	return atomic_add_return(segs + delta, p_id) - segs;
 }
 EXPORT_SYMBOL(ip_idents_reserve);
 



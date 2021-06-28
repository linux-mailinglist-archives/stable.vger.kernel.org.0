Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BBB3B6271
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbhF1Orm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:47:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234791AbhF1OmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:42:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2D6961CD4;
        Mon, 28 Jun 2021 14:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890818;
        bh=7B9aiw+wYeIaVZab/3hke8iSwixN+0gVlwP/Gwm/9y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QX7zIxapEsg0YxsDoIS+soVYUPPYaTjYU2m4LX9sag9HjKhqqN9d5IIRbdWvqfFqh
         d2djlapBBhA647iPjBZMqktUMrSCT3yZtt0IXreyCkhMdKTyQYOWYq22z26qr7HJ79
         ibHgN8P9Xskc2AOk2wCiBx8pCZdmM4mwiX1JsZ2WALV5cyj+UXEvBdMZFE7czAwekw
         zkz80fp1ldGyIhUnWztPhAGK//RDmK1E6l0+06p1yvp+7GHj52P6LHGqgeJ6nHKJiN
         CDv0Oj6pXVXuXW6c+yIb3EaLdke6JXqri9Z3ZgXIr8l8AwXbgxf+DN4Y11CtgblrjW
         8c8Q7aChQW3wQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        Young Xiao <92siuyang@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 034/109] sch_cake: Fix out of bounds when parsing TCP options and header
Date:   Mon, 28 Jun 2021 10:31:50 -0400
Message-Id: <20210628143305.32978-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit ba91c49dedbde758ba0b72f57ac90b06ddf8e548 ]

The TCP option parser in cake qdisc (cake_get_tcpopt and
cake_tcph_may_drop) could read one byte out of bounds. When the length
is 1, the execution flow gets into the loop, reads one byte of the
opcode, and if the opcode is neither TCPOPT_EOL nor TCPOPT_NOP, it reads
one more byte, which exceeds the length of 1.

This fix is inspired by commit 9609dad263f8 ("ipv4: tcp_input: fix stack
out of bounds when parsing TCP options.").

v2 changes:

Added doff validation in cake_get_tcphdr to avoid parsing garbage as TCP
header. Although it wasn't strictly an out-of-bounds access (memory was
allocated), garbage values could be read where CAKE expected the TCP
header if doff was smaller than 5.

Cc: Young Xiao <92siuyang@gmail.com>
Fixes: 8b7138814f29 ("sch_cake: Add optional ACK filter")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cake.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 32712e7dcbdc..2025f0f559de 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -900,7 +900,7 @@ static struct tcphdr *cake_get_tcphdr(const struct sk_buff *skb,
 	}
 
 	tcph = skb_header_pointer(skb, offset, sizeof(_tcph), &_tcph);
-	if (!tcph)
+	if (!tcph || tcph->doff < 5)
 		return NULL;
 
 	return skb_header_pointer(skb, offset,
@@ -924,6 +924,8 @@ static const void *cake_get_tcpopt(const struct tcphdr *tcph,
 			length--;
 			continue;
 		}
+		if (length < 2)
+			break;
 		opsize = *ptr++;
 		if (opsize < 2 || opsize > length)
 			break;
@@ -1061,6 +1063,8 @@ static bool cake_tcph_may_drop(const struct tcphdr *tcph,
 			length--;
 			continue;
 		}
+		if (length < 2)
+			break;
 		opsize = *ptr++;
 		if (opsize < 2 || opsize > length)
 			break;
-- 
2.30.2


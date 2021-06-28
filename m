Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBA93B60F6
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhF1ObY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:31:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234742AbhF1OaZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 001A461CB4;
        Mon, 28 Jun 2021 14:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890403;
        bh=xMbFFv5Ocj+okRzMU7IVyFe9akyULqkzGAexCMXgzLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jkZOQvqjhfEHI4UNFdLhxHQfTYqvWjnHFsfOvpxNTM4AWeM/NzH1z4i+AKcET8aT/
         glG+9Chhjbqne/J2xm0P5mKg7gJe3c6kdhSrs7LoCIlkVCw4cSqZbtIa9RShwDLubt
         ywJ2KQbRawqMkXn5LLiVB/XJEgQ2DDAMD+ORzn6Kawiay8ePK/aPMFUp9J2V+60ksH
         ayVjZeVXPRKQiB3nd7HRyNF00oeIa3NADb83/PIzI/x8M6vBa2lioswjWkogesh2K6
         DQL7J6foJsApqudj+Pi0TJyYEC5GNyN5KoBh9NWjc9h4Q7PDGdlLVD/OvEXXMyt42q
         0t+C1mBK/OTow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/101] net/packet: annotate data race in packet_sendmsg()
Date:   Mon, 28 Jun 2021 10:25:06 -0400
Message-Id: <20210628142607.32218-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d1b5bee4c8be01585033be9b3a8878789285285f ]

There is a known race in packet_sendmsg(), addressed
in commit 32d3182cd2cd ("net/packet: fix race in tpacket_snd()")

Now we have data_race(), we can use it to avoid a future KCSAN warning,
as syzbot loves stressing af_packet sockets :)

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index ddb68aa836f7..7892d7074847 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3033,10 +3033,13 @@ static int packet_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	struct sock *sk = sock->sk;
 	struct packet_sock *po = pkt_sk(sk);
 
-	if (po->tx_ring.pg_vec)
+	/* Reading tx_ring.pg_vec without holding pg_vec_lock is racy.
+	 * tpacket_snd() will redo the check safely.
+	 */
+	if (data_race(po->tx_ring.pg_vec))
 		return tpacket_snd(po, msg);
-	else
-		return packet_snd(sock, msg, len);
+
+	return packet_snd(sock, msg, len);
 }
 
 /*
-- 
2.30.2


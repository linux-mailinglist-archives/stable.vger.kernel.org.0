Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62F93F6526
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238812AbhHXRKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239272AbhHXRIz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:08:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED30261A2C;
        Tue, 24 Aug 2021 17:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824411;
        bh=RREXKyWD8Clsir3EpnZeLQUSDl1G3hsFij508QdQTi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9lDEHECq4Ew9+7u7aKrXGDEVvyO5LiR9fRoFvxONb64zfcWg5Mwk5RSwG7yvzyQt
         tNWpH97DYI2V7srzJrrjjQoNN3bstPp/h/JNjViuA9qHq/+22vR/rKZtx8Wkzsci8g
         gDlCxesAEQviZF7jWaQWPruiz+3Mxxro4Ckg4Y4vgQKUtl17pqRmiEwyu1AuL5sNs5
         0EPf6GcYdO6nvwa2sphPOaLYPZyfI4ktbvjOSJBf8ztbM/ODTT2RtDsc4QOHyn7AmA
         7HOhiDxubad2Yot+j5sWLNsrsOt2bCKakYEj4MN3cA8BPI1KnkqoJkatw3S+PPQT4/
         rA6UmGoggkw9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Pete Heist <pete@heistp.net>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 62/98] sch_cake: fix srchost/dsthost hashing mode
Date:   Tue, 24 Aug 2021 12:58:32 -0400
Message-Id: <20210824165908.709932-63-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 86b9bbd332d0510679c7fedcee3e3bd278be5756 ]

When adding support for using the skb->hash value as the flow hash in CAKE,
I accidentally introduced a logic error that broke the host-only isolation
modes of CAKE (srchost and dsthost keywords). Specifically, the flow_hash
variable should stay initialised to 0 in cake_hash() in pure host-based
hashing mode. Add a check for this before using the skb->hash value as
flow_hash.

Fixes: b0c19ed6088a ("sch_cake: Take advantage of skb->hash where appropriate")
Reported-by: Pete Heist <pete@heistp.net>
Tested-by: Pete Heist <pete@heistp.net>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cake.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 5c15968b5155..c2c37ffd94f2 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -720,7 +720,7 @@ static u32 cake_hash(struct cake_tin_data *q, const struct sk_buff *skb,
 skip_hash:
 	if (flow_override)
 		flow_hash = flow_override - 1;
-	else if (use_skbhash)
+	else if (use_skbhash && (flow_mode & CAKE_FLOW_FLOWS))
 		flow_hash = skb->hash;
 	if (host_override) {
 		dsthost_hash = host_override - 1;
-- 
2.30.2


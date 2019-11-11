Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C74A2F7F72
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfKKSav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:30:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:47226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727420AbfKKSav (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:30:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ED8421872;
        Mon, 11 Nov 2019 18:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497050;
        bh=wuS+24sMyWuJ69A80X28xPQdpAf3+N8d/kMuzZ7Fpkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F82O+JHMOFWQii64kiEJC9Q+L8sd38ytupj8itz7Xe7xtR8OQDwF9GrpINO1i6Ln9
         0gh4jCN8jxfggKY+oWVKBY1a+ONus/XZv63PoPS6jcq2Kh36NIyemmruYoWwGU4DdY
         10WJ44ONB1+yU1TUu0k0GSVCLJi87fSQ882X01sU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Simon Horman <horms@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 28/43] ipvs: move old_secure_tcp into struct netns_ipvs
Date:   Mon, 11 Nov 2019 19:28:42 +0100
Message-Id: <20191111181319.324342120@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181246.772983347@linuxfoundation.org>
References: <20191111181246.772983347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c24b75e0f9239e78105f81c5f03a751641eb07ef ]

syzbot reported the following issue :

BUG: KCSAN: data-race in update_defense_level / update_defense_level

read to 0xffffffff861a6260 of 4 bytes by task 3006 on cpu 1:
 update_defense_level+0x621/0xb30 net/netfilter/ipvs/ip_vs_ctl.c:177
 defense_work_handler+0x3d/0xd0 net/netfilter/ipvs/ip_vs_ctl.c:225
 process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
 worker_thread+0xa0/0x800 kernel/workqueue.c:2415
 kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

write to 0xffffffff861a6260 of 4 bytes by task 7333 on cpu 0:
 update_defense_level+0xa62/0xb30 net/netfilter/ipvs/ip_vs_ctl.c:205
 defense_work_handler+0x3d/0xd0 net/netfilter/ipvs/ip_vs_ctl.c:225
 process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
 worker_thread+0xa0/0x800 kernel/workqueue.c:2415
 kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 7333 Comm: kworker/0:5 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events defense_work_handler

Indeed, old_secure_tcp is currently a static variable, while it
needs to be a per netns variable.

Fixes: a0840e2e165a ("IPVS: netns, ip_vs_ctl local vars moved to ipvs struct.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_vs.h            |  1 +
 net/netfilter/ipvs/ip_vs_ctl.c | 15 +++++++--------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index a6cc576fd467f..b0156f8a9ab7f 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -880,6 +880,7 @@ struct netns_ipvs {
 	struct delayed_work	defense_work;   /* Work handler */
 	int			drop_rate;
 	int			drop_counter;
+	int			old_secure_tcp;
 	atomic_t		dropentry;
 	/* locks in ctl.c */
 	spinlock_t		dropentry_lock;  /* drop entry handling */
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 56c62b65923f1..b176f76dfaa14 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -97,7 +97,6 @@ static bool __ip_vs_addr_is_local_v6(struct net *net,
 static void update_defense_level(struct netns_ipvs *ipvs)
 {
 	struct sysinfo i;
-	static int old_secure_tcp = 0;
 	int availmem;
 	int nomem;
 	int to_change = -1;
@@ -178,35 +177,35 @@ static void update_defense_level(struct netns_ipvs *ipvs)
 	spin_lock(&ipvs->securetcp_lock);
 	switch (ipvs->sysctl_secure_tcp) {
 	case 0:
-		if (old_secure_tcp >= 2)
+		if (ipvs->old_secure_tcp >= 2)
 			to_change = 0;
 		break;
 	case 1:
 		if (nomem) {
-			if (old_secure_tcp < 2)
+			if (ipvs->old_secure_tcp < 2)
 				to_change = 1;
 			ipvs->sysctl_secure_tcp = 2;
 		} else {
-			if (old_secure_tcp >= 2)
+			if (ipvs->old_secure_tcp >= 2)
 				to_change = 0;
 		}
 		break;
 	case 2:
 		if (nomem) {
-			if (old_secure_tcp < 2)
+			if (ipvs->old_secure_tcp < 2)
 				to_change = 1;
 		} else {
-			if (old_secure_tcp >= 2)
+			if (ipvs->old_secure_tcp >= 2)
 				to_change = 0;
 			ipvs->sysctl_secure_tcp = 1;
 		}
 		break;
 	case 3:
-		if (old_secure_tcp < 2)
+		if (ipvs->old_secure_tcp < 2)
 			to_change = 1;
 		break;
 	}
-	old_secure_tcp = ipvs->sysctl_secure_tcp;
+	ipvs->old_secure_tcp = ipvs->sysctl_secure_tcp;
 	if (to_change >= 0)
 		ip_vs_protocol_timeout_change(ipvs,
 					      ipvs->sysctl_secure_tcp > 1);
-- 
2.20.1




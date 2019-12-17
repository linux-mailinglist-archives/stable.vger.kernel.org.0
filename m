Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 642FB12204E
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfLQAxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:53:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35472 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727148AbfLQAvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15L-0003N8-0n; Tue, 17 Dec 2019 00:51:35 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15J-0005aG-3A; Tue, 17 Dec 2019 00:51:33 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "syzbot" <syzkaller@googlegroups.com>,
        "Eric Dumazet" <edumazet@google.com>,
        "Simon Horman" <horms@verge.net.au>
Date:   Tue, 17 Dec 2019 00:47:04 +0000
Message-ID: <lsq.1576543535.534470975@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 090/136] ipvs: move old_secure_tcp into struct netns_ipvs
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit c24b75e0f9239e78105f81c5f03a751641eb07ef upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/ip_vs.h            |  1 +
 net/netfilter/ipvs/ip_vs_ctl.c | 15 +++++++--------
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -919,6 +919,7 @@ struct netns_ipvs {
 	struct delayed_work	defense_work;   /* Work handler */
 	int			drop_rate;
 	int			drop_counter;
+	int			old_secure_tcp;
 	atomic_t		dropentry;
 	/* locks in ctl.c */
 	spinlock_t		dropentry_lock;  /* drop entry handling */
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -97,7 +97,6 @@ static bool __ip_vs_addr_is_local_v6(str
 static void update_defense_level(struct netns_ipvs *ipvs)
 {
 	struct sysinfo i;
-	static int old_secure_tcp = 0;
 	int availmem;
 	int nomem;
 	int to_change = -1;
@@ -178,35 +177,35 @@ static void update_defense_level(struct
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


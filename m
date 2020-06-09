Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CE81F4411
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733025AbgFISAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731910AbgFIRyp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:54:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A589207C3;
        Tue,  9 Jun 2020 17:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725284;
        bh=55xVFPoFEr5iTuis4xbFShwfW/HkegS1sk4Cc6Lcbs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C9O7BrC2fIvjP/DxqB3qxS097imSmGkn7ts+ygyC00UtA5IzQoCBihyTb/rG6R4uv
         XfFcfzA5AysugOBxLdL7XgG7+XIeazjLqYQdNTUzWu90MvXfgLJw4MAmtTj4+boVx+
         tBpOrJusXT/4CLfJZg9Sdv8d8kwXnrKIQAOrzRY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Vecera <ivecera@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 16/41] net/sched: fix infinite loop in sch_fq_pie
Date:   Tue,  9 Jun 2020 19:45:18 +0200
Message-Id: <20200609174113.683589069@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174112.129412236@linuxfoundation.org>
References: <20200609174112.129412236@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit bb2f930d6dd708469a587dc9ed1efe1ef969c0bf ]

this command hangs forever:

 # tc qdisc add dev eth0 root fq_pie flows 65536

 watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [tc:1028]
 [...]
 CPU: 1 PID: 1028 Comm: tc Not tainted 5.7.0-rc6+ #167
 RIP: 0010:fq_pie_init+0x60e/0x8b7 [sch_fq_pie]
 Code: 4c 89 65 50 48 89 f8 48 c1 e8 03 42 80 3c 30 00 0f 85 2a 02 00 00 48 8d 7d 10 4c 89 65 58 48 89 f8 48 c1 e8 03 42 80 3c 30 00 <0f> 85 a7 01 00 00 48 8d 7d 18 48 c7 45 10 46 c3 23 00 48 89 f8 48
 RSP: 0018:ffff888138d67468 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
 RAX: 1ffff9200018d2b2 RBX: ffff888139c1c400 RCX: ffffffffffffffff
 RDX: 000000000000c5e8 RSI: ffffc900000e5000 RDI: ffffc90000c69590
 RBP: ffffc90000c69580 R08: fffffbfff79a9699 R09: fffffbfff79a9699
 R10: 0000000000000700 R11: fffffbfff79a9698 R12: ffffc90000c695d0
 R13: 0000000000000000 R14: dffffc0000000000 R15: 000000002347c5e8
 FS:  00007f01e1850e40(0000) GS:ffff88814c880000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000000000067c340 CR3: 000000013864c000 CR4: 0000000000340ee0
 Call Trace:
  qdisc_create+0x3fd/0xeb0
  tc_modify_qdisc+0x3be/0x14a0
  rtnetlink_rcv_msg+0x5f3/0x920
  netlink_rcv_skb+0x121/0x350
  netlink_unicast+0x439/0x630
  netlink_sendmsg+0x714/0xbf0
  sock_sendmsg+0xe2/0x110
  ____sys_sendmsg+0x5b4/0x890
  ___sys_sendmsg+0xe9/0x160
  __sys_sendmsg+0xd3/0x170
  do_syscall_64+0x9a/0x370
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

we can't accept 65536 as a valid number for 'nflows', because the loop on
'idx' in fq_pie_init() will never end. The extack message is correct, but
it doesn't say that 0 is not a valid number for 'flows': while at it, fix
this also. Add a tdc selftest to check correct validation of 'flows'.

CC: Ivan Vecera <ivecera@redhat.com>
Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Ivan Vecera <ivecera@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_fq_pie.c                                         |    4 -
 tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_pie.json |   21 ++++++++++
 2 files changed, 23 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_pie.json

--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -298,9 +298,9 @@ static int fq_pie_change(struct Qdisc *s
 			goto flow_error;
 		}
 		q->flows_cnt = nla_get_u32(tb[TCA_FQ_PIE_FLOWS]);
-		if (!q->flows_cnt || q->flows_cnt > 65536) {
+		if (!q->flows_cnt || q->flows_cnt >= 65536) {
 			NL_SET_ERR_MSG_MOD(extack,
-					   "Number of flows must be < 65536");
+					   "Number of flows must range in [1..65535]");
 			goto flow_error;
 		}
 	}
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_pie.json
@@ -0,0 +1,21 @@
+[
+    {
+        "id": "83be",
+        "name": "Create FQ-PIE with invalid number of flows",
+        "category": [
+            "qdisc",
+            "fq_pie"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY root fq_pie flows 65536",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY"
+        ]
+    }
+]



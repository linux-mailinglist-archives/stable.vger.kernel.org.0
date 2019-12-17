Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C03EB12205E
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbfLQAyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:54:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35530 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727183AbfLQAvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15O-0003Pf-JT; Tue, 17 Dec 2019 00:51:38 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15L-0005gF-Nm; Tue, 17 Dec 2019 00:51:35 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Davide Caratti" <dcaratti@redhat.com>
Date:   Tue, 17 Dec 2019 00:47:47 +0000
Message-ID: <lsq.1576543535.672461820@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 133/136] net/sched: act_pedit: fix WARN() in the
 traffic path
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

From: Davide Caratti <dcaratti@redhat.com>

commit f67169fef8dbcc1ac6a6a109ecaad0d3b259002c upstream.

when configuring act_pedit rules, the number of keys is validated only on
addition of a new entry. This is not sufficient to avoid hitting a WARN()
in the traffic path: for example, it is possible to replace a valid entry
with a new one having 0 extended keys, thus causing splats in dmesg like:

 pedit BUG: index 42
 WARNING: CPU: 2 PID: 4054 at net/sched/act_pedit.c:410 tcf_pedit_act+0xc84/0x1200 [act_pedit]
 [...]
 RIP: 0010:tcf_pedit_act+0xc84/0x1200 [act_pedit]
 Code: 89 fa 48 c1 ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e ac 00 00 00 48 8b 44 24 10 48 c7 c7 a0 c4 e4 c0 8b 70 18 e8 1c 30 95 ea <0f> 0b e9 a0 fa ff ff e8 00 03 f5 ea e9 14 f4 ff ff 48 89 58 40 e9
 RSP: 0018:ffff888077c9f320 EFLAGS: 00010286
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffffac2983a2
 RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffff888053927bec
 RBP: dffffc0000000000 R08: ffffed100a726209 R09: ffffed100a726209
 R10: 0000000000000001 R11: ffffed100a726208 R12: ffff88804beea780
 R13: ffff888079a77400 R14: ffff88804beea780 R15: ffff888027ab2000
 FS:  00007fdeec9bd740(0000) GS:ffff888053900000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007ffdb3dfd000 CR3: 000000004adb4006 CR4: 00000000001606e0
 Call Trace:
  tcf_action_exec+0x105/0x3f0
  tcf_classify+0xf2/0x410
  __dev_queue_xmit+0xcbf/0x2ae0
  ip_finish_output2+0x711/0x1fb0
  ip_output+0x1bf/0x4b0
  ip_send_skb+0x37/0xa0
  raw_sendmsg+0x180c/0x2430
  sock_sendmsg+0xdb/0x110
  __sys_sendto+0x257/0x2b0
  __x64_sys_sendto+0xdd/0x1b0
  do_syscall_64+0xa5/0x4e0
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
 RIP: 0033:0x7fdeeb72e993
 Code: 48 8b 0d e0 74 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 0d d6 2c 00 00 75 13 49 89 ca b8 2c 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 4b cc 00 00 48 89 04 24
 RSP: 002b:00007ffdb3de8a18 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
 RAX: ffffffffffffffda RBX: 000055c81972b700 RCX: 00007fdeeb72e993
 RDX: 0000000000000040 RSI: 000055c81972b700 RDI: 0000000000000003
 RBP: 00007ffdb3dea130 R08: 000055c819728510 R09: 0000000000000010
 R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000040
 R13: 000055c81972b6c0 R14: 000055c81972969c R15: 0000000000000080

Fix this moving the check on 'nkeys' earlier in tcf_pedit_init(), so that
attempts to install rules having 0 keys are always rejected with -EINVAL.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16:
 - Drop change in tcf_pedit_keys_ex_parse()
 - netlink doesn't support error messages
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -50,13 +50,13 @@ static int tcf_pedit_init(struct net *ne
 	if (tb[TCA_PEDIT_PARMS] == NULL)
 		return -EINVAL;
 	parm = nla_data(tb[TCA_PEDIT_PARMS]);
+	if (!parm->nkeys)
+		return -EINVAL;
 	ksize = parm->nkeys * sizeof(struct tc_pedit_key);
 	if (nla_len(tb[TCA_PEDIT_PARMS]) < sizeof(*parm) + ksize)
 		return -EINVAL;
 
 	if (!tcf_hash_check(parm->index, a, bind)) {
-		if (!parm->nkeys)
-			return -EINVAL;
 		ret = tcf_hash_create(parm->index, est, a, sizeof(*p), bind);
 		if (ret)
 			return ret;


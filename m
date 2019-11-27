Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB6A810BB25
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732561AbfK0VKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:10:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732959AbfK0VJ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:09:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9083F2176D;
        Wed, 27 Nov 2019 21:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888999;
        bh=JM1fv81yspaktalVpD5IBv1OZL9GUoebHOYYcy3Ld9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pwunB/hcKaTVnmd1wXPN3ud9RN3J47Bw+vdDoXSml1O0UIeeyruK7cyVVRuGovaQ/
         ql+vNwXL/+01GmwhcQqtUnceJOvTHKjFREbqyc2v0LOkyQg4oPSeUMZPppdErPNQko
         CzqcqxXom6Hp7mkbM7oR1KGMkcVGqOfkHWojk/0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 05/95] net/sched: act_pedit: fix WARN() in the traffic path
Date:   Wed, 27 Nov 2019 21:31:22 +0100
Message-Id: <20191127202849.657696450@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit f67169fef8dbcc1ac6a6a109ecaad0d3b259002c ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_pedit.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -43,7 +43,7 @@ static struct tcf_pedit_key_ex *tcf_pedi
 	int err = -EINVAL;
 	int rem;
 
-	if (!nla || !n)
+	if (!nla)
 		return NULL;
 
 	keys_ex = kcalloc(n, sizeof(*k), GFP_KERNEL);
@@ -170,6 +170,10 @@ static int tcf_pedit_init(struct net *ne
 	}
 
 	parm = nla_data(pattr);
+	if (!parm->nkeys) {
+		NL_SET_ERR_MSG_MOD(extack, "Pedit requires keys to be passed");
+		return -EINVAL;
+	}
 	ksize = parm->nkeys * sizeof(struct tc_pedit_key);
 	if (nla_len(pattr) < sizeof(*parm) + ksize) {
 		NL_SET_ERR_MSG_ATTR(extack, pattr, "Length of TCA_PEDIT_PARMS or TCA_PEDIT_PARMS_EX pedit attribute is invalid");
@@ -183,12 +187,6 @@ static int tcf_pedit_init(struct net *ne
 	index = parm->index;
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
-		if (!parm->nkeys) {
-			tcf_idr_cleanup(tn, index);
-			NL_SET_ERR_MSG_MOD(extack, "Pedit requires keys to be passed");
-			ret = -EINVAL;
-			goto out_free;
-		}
 		ret = tcf_idr_create(tn, index, est, a,
 				     &act_pedit_ops, bind, false);
 		if (ret) {



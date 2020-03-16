Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A59C1862EB
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbgCPCeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:34:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729730AbgCPCeE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:34:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66FF0206EB;
        Mon, 16 Mar 2020 02:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326043;
        bh=8utJ4PbiBkJFqLWavO/QYmjVPSaB2McN1fDCS3CNWwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kf33GIacZxdQb+WRd5kZqTQXVmg0KYqxjAr8GHdw2qvVCQQjE1ZzSbKDXRhbbJBbG
         nXZfQkdafcqQBZrJvUc3TUEXNS7pn2vOWvpWG5d2Mtg9ezUhSUtMSI9qPl5faepKmn
         KaUY+w3JJ4CQSGu/8Pblu79JkiI4jYSnO08RHnfc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongli Zhang <dongli.zhang@oracle.com>,
        Julien Grall <jgrall@amazon.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>, xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.5 36/41] xenbus: req->body should be updated before req->state
Date:   Sun, 15 Mar 2020 22:33:14 -0400
Message-Id: <20200316023319.749-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023319.749-1-sashal@kernel.org>
References: <20200316023319.749-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongli Zhang <dongli.zhang@oracle.com>

[ Upstream commit 1b6a51e86cce38cf4d48ce9c242120283ae2f603 ]

The req->body should be updated before req->state is updated and the
order should be guaranteed by a barrier.

Otherwise, read_reply() might return req->body = NULL.

Below is sample callstack when the issue is reproduced on purpose by
reordering the updates of req->body and req->state and adding delay in
code between updates of req->state and req->body.

[   22.356105] general protection fault: 0000 [#1] SMP PTI
[   22.361185] CPU: 2 PID: 52 Comm: xenwatch Not tainted 5.5.0xen+ #6
[   22.366727] Hardware name: Xen HVM domU, BIOS ...
[   22.372245] RIP: 0010:_parse_integer_fixup_radix+0x6/0x60
... ...
[   22.392163] RSP: 0018:ffffb2d64023fdf0 EFLAGS: 00010246
[   22.395933] RAX: 0000000000000000 RBX: 75746e7562755f6d RCX: 0000000000000000
[   22.400871] RDX: 0000000000000000 RSI: ffffb2d64023fdfc RDI: 75746e7562755f6d
[   22.405874] RBP: 0000000000000000 R08: 00000000000001e8 R09: 0000000000cdcdcd
[   22.410945] R10: ffffb2d6402ffe00 R11: ffff9d95395eaeb0 R12: ffff9d9535935000
[   22.417613] R13: ffff9d9526d4a000 R14: ffff9d9526f4f340 R15: ffff9d9537654000
[   22.423726] FS:  0000000000000000(0000) GS:ffff9d953bc80000(0000) knlGS:0000000000000000
[   22.429898] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   22.434342] CR2: 000000c4206a9000 CR3: 00000001ea3fc002 CR4: 00000000001606e0
[   22.439645] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   22.444941] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   22.450342] Call Trace:
[   22.452509]  simple_strtoull+0x27/0x70
[   22.455572]  xenbus_transaction_start+0x31/0x50
[   22.459104]  netback_changed+0x76c/0xcc1 [xen_netfront]
[   22.463279]  ? find_watch+0x40/0x40
[   22.466156]  xenwatch_thread+0xb4/0x150
[   22.469309]  ? wait_woken+0x80/0x80
[   22.472198]  kthread+0x10e/0x130
[   22.474925]  ? kthread_park+0x80/0x80
[   22.477946]  ret_from_fork+0x35/0x40
[   22.480968] Modules linked in: xen_kbdfront xen_fbfront(+) xen_netfront xen_blkfront
[   22.486783] ---[ end trace a9222030a747c3f7 ]---
[   22.490424] RIP: 0010:_parse_integer_fixup_radix+0x6/0x60

The virt_rmb() is added in the 'true' path of test_reply(). The "while"
is changed to "do while" so that test_reply() is used as a read memory
barrier.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Link: https://lore.kernel.org/r/20200303221423.21962-1-dongli.zhang@oracle.com
Reviewed-by: Julien Grall <jgrall@amazon.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xenbus/xenbus_comms.c | 2 ++
 drivers/xen/xenbus/xenbus_xs.c    | 9 ++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_comms.c b/drivers/xen/xenbus/xenbus_comms.c
index d239fc3c5e3de..852ed161fc2a7 100644
--- a/drivers/xen/xenbus/xenbus_comms.c
+++ b/drivers/xen/xenbus/xenbus_comms.c
@@ -313,6 +313,8 @@ static int process_msg(void)
 			req->msg.type = state.msg.type;
 			req->msg.len = state.msg.len;
 			req->body = state.body;
+			/* write body, then update state */
+			virt_wmb();
 			req->state = xb_req_state_got_reply;
 			req->cb(req);
 		} else
diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index ddc18da61834e..3a06eb699f333 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -191,8 +191,11 @@ static bool xenbus_ok(void)
 
 static bool test_reply(struct xb_req_data *req)
 {
-	if (req->state == xb_req_state_got_reply || !xenbus_ok())
+	if (req->state == xb_req_state_got_reply || !xenbus_ok()) {
+		/* read req->state before all other fields */
+		virt_rmb();
 		return true;
+	}
 
 	/* Make sure to reread req->state each time. */
 	barrier();
@@ -202,7 +205,7 @@ static bool test_reply(struct xb_req_data *req)
 
 static void *read_reply(struct xb_req_data *req)
 {
-	while (req->state != xb_req_state_got_reply) {
+	do {
 		wait_event(req->wq, test_reply(req));
 
 		if (!xenbus_ok())
@@ -216,7 +219,7 @@ static void *read_reply(struct xb_req_data *req)
 		if (req->err)
 			return ERR_PTR(req->err);
 
-	}
+	} while (req->state != xb_req_state_got_reply);
 
 	return req->body;
 }
-- 
2.20.1


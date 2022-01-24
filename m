Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57EBC4988F3
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245757AbiAXSwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:52:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48834 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245520AbiAXSut (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:50:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1ADE614BE;
        Mon, 24 Jan 2022 18:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6F9C340E7;
        Mon, 24 Jan 2022 18:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050248;
        bh=tvYs1VSePffa4h5x8YjWrQTm+RhMLjGYNBC6EzBNKdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HYtU/NmsD1M78KnQb4IIgWTAAGi3ZjPRKzXlOuDjJw4lIlSHKaPJXwS000mMsLzOb
         ppyNY1TcM2/CEYkLdSL/fRkXmFRNiiq9NRkyXFtDuAEa63VDMk4OpIR6+qz1N6zozA
         wfOw5Qz0CsW6da0d30crwJvf6LjxcHAIz3qu2xKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 058/114] fs: dlm: filter user dlm messages for kernel locks
Date:   Mon, 24 Jan 2022 19:42:33 +0100
Message-Id: <20220124183928.895238375@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 6c2e3bf68f3e5e5a647aa52be246d5f552d7496d ]

This patch fixes the following crash by receiving a invalid message:

[  160.672220] ==================================================================
[  160.676206] BUG: KASAN: user-memory-access in dlm_user_add_ast+0xc3/0x370
[  160.679659] Read of size 8 at addr 00000000deadbeef by task kworker/u32:13/319
[  160.681447]
[  160.681824] CPU: 10 PID: 319 Comm: kworker/u32:13 Not tainted 5.14.0-rc2+ #399
[  160.683472] Hardware name: Red Hat KVM/RHEL-AV, BIOS 1.14.0-1.module+el8.6.0+12648+6ede71a5 04/01/2014
[  160.685574] Workqueue: dlm_recv process_recv_sockets
[  160.686721] Call Trace:
[  160.687310]  dump_stack_lvl+0x56/0x6f
[  160.688169]  ? dlm_user_add_ast+0xc3/0x370
[  160.689116]  kasan_report.cold.14+0x116/0x11b
[  160.690138]  ? dlm_user_add_ast+0xc3/0x370
[  160.690832]  dlm_user_add_ast+0xc3/0x370
[  160.691502]  _receive_unlock_reply+0x103/0x170
[  160.692241]  _receive_message+0x11df/0x1ec0
[  160.692926]  ? rcu_read_lock_sched_held+0xa1/0xd0
[  160.693700]  ? rcu_read_lock_bh_held+0xb0/0xb0
[  160.694427]  ? lock_acquire+0x175/0x400
[  160.695058]  ? do_purge.isra.51+0x200/0x200
[  160.695744]  ? lock_acquired+0x360/0x5d0
[  160.696400]  ? lock_contended+0x6a0/0x6a0
[  160.697055]  ? lock_release+0x21d/0x5e0
[  160.697686]  ? lock_is_held_type+0xe0/0x110
[  160.698352]  ? lock_is_held_type+0xe0/0x110
[  160.699026]  ? ___might_sleep+0x1cc/0x1e0
[  160.699698]  ? dlm_wait_requestqueue+0x94/0x140
[  160.700451]  ? dlm_process_requestqueue+0x240/0x240
[  160.701249]  ? down_write_killable+0x2b0/0x2b0
[  160.701988]  ? do_raw_spin_unlock+0xa2/0x130
[  160.702690]  dlm_receive_buffer+0x1a5/0x210
[  160.703385]  dlm_process_incoming_buffer+0x726/0x9f0
[  160.704210]  receive_from_sock+0x1c0/0x3b0
[  160.704886]  ? dlm_tcp_shutdown+0x30/0x30
[  160.705561]  ? lock_acquire+0x175/0x400
[  160.706197]  ? rcu_read_lock_sched_held+0xa1/0xd0
[  160.706941]  ? rcu_read_lock_bh_held+0xb0/0xb0
[  160.707681]  process_recv_sockets+0x32/0x40
[  160.708366]  process_one_work+0x55e/0xad0
[  160.709045]  ? pwq_dec_nr_in_flight+0x110/0x110
[  160.709820]  worker_thread+0x65/0x5e0
[  160.710423]  ? process_one_work+0xad0/0xad0
[  160.711087]  kthread+0x1ed/0x220
[  160.711628]  ? set_kthread_struct+0x80/0x80
[  160.712314]  ret_from_fork+0x22/0x30

The issue is that we received a DLM message for a user lock but the
destination lock is a kernel lock. Note that the address which is trying
to derefence is 00000000deadbeef, which is in a kernel lock
lkb->lkb_astparam, this field should never be derefenced by the DLM
kernel stack. In case of a user lock lkb->lkb_astparam is lkb->lkb_ua
(memory is shared by a union field). The struct lkb_ua will be handled
by the DLM kernel stack but on a kernel lock it will contain invalid
data and ends in most likely crashing the kernel.

It can be reproduced with two cluster nodes.

node 2:
dlm_tool join test
echo "862 fooobaar 1 2 1" > /sys/kernel/debug/dlm/test_locks
echo "862 3 1" > /sys/kernel/debug/dlm/test_waiters

node 1:
dlm_tool join test

python:
foo = DLM(h_cmd=3, o_nextcmd=1, h_nodeid=1, h_lockspace=0x77222027, \
          m_type=7, m_flags=0x1, m_remid=0x862, m_result=0xFFFEFFFE)
newFile = open("/sys/kernel/debug/dlm/comms/2/rawmsg", "wb")
newFile.write(bytes(foo))

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lock.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 3a7f401e943c1..ffab7dc881574 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -3975,6 +3975,14 @@ static int validate_message(struct dlm_lkb *lkb, struct dlm_message *ms)
 	int from = ms->m_header.h_nodeid;
 	int error = 0;
 
+	/* currently mixing of user/kernel locks are not supported */
+	if (ms->m_flags & DLM_IFL_USER && ~lkb->lkb_flags & DLM_IFL_USER) {
+		log_error(lkb->lkb_resource->res_ls,
+			  "got user dlm message for a kernel lock");
+		error = -EINVAL;
+		goto out;
+	}
+
 	switch (ms->m_type) {
 	case DLM_MSG_CONVERT:
 	case DLM_MSG_UNLOCK:
@@ -4003,6 +4011,7 @@ static int validate_message(struct dlm_lkb *lkb, struct dlm_message *ms)
 		error = -EINVAL;
 	}
 
+out:
 	if (error)
 		log_error(lkb->lkb_resource->res_ls,
 			  "ignore invalid message %d from %d %x %x %x %d",
-- 
2.34.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF756A6FB3
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfICQe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:34:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731026AbfICQ2E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:28:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 918132343A;
        Tue,  3 Sep 2019 16:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528083;
        bh=vO/ZH76YJ35lxyy92BlgYST4jDQO3MLwsSLQcHAeT2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3G/s4NeWGkkrZ7TWLyRH+KSG4uZeLgkakvYNkrN9oKv/yaTBtWYvVyNqS5U/KFMy
         bTh7Peu9uKlBl9uEAP9Eid/ixRup4GiwLNZ+PrxIH9+zYozQbUMEIDCk4OYPLh6qre
         AURys2JjmX11cqC6WvUOCq/oXwxvmKWWV0K8nlIw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ZhangXiaoxu <zhangxiaoxu5@huawei.com>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 095/167] cifs: Fix lease buffer length error
Date:   Tue,  3 Sep 2019 12:24:07 -0400
Message-Id: <20190903162519.7136-95-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ZhangXiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit b57a55e2200ede754e4dc9cce4ba9402544b9365 ]

There is a KASAN slab-out-of-bounds:
BUG: KASAN: slab-out-of-bounds in _copy_from_iter_full+0x783/0xaa0
Read of size 80 at addr ffff88810c35e180 by task mount.cifs/539

CPU: 1 PID: 539 Comm: mount.cifs Not tainted 4.19 #10
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
            rel-1.12.0-0-ga698c8995f-prebuilt.qemu.org 04/01/2014
Call Trace:
 dump_stack+0xdd/0x12a
 print_address_description+0xa7/0x540
 kasan_report+0x1ff/0x550
 check_memory_region+0x2f1/0x310
 memcpy+0x2f/0x80
 _copy_from_iter_full+0x783/0xaa0
 tcp_sendmsg_locked+0x1840/0x4140
 tcp_sendmsg+0x37/0x60
 inet_sendmsg+0x18c/0x490
 sock_sendmsg+0xae/0x130
 smb_send_kvec+0x29c/0x520
 __smb_send_rqst+0x3ef/0xc60
 smb_send_rqst+0x25a/0x2e0
 compound_send_recv+0x9e8/0x2af0
 cifs_send_recv+0x24/0x30
 SMB2_open+0x35e/0x1620
 open_shroot+0x27b/0x490
 smb2_open_op_close+0x4e1/0x590
 smb2_query_path_info+0x2ac/0x650
 cifs_get_inode_info+0x1058/0x28f0
 cifs_root_iget+0x3bb/0xf80
 cifs_smb3_do_mount+0xe00/0x14c0
 cifs_do_mount+0x15/0x20
 mount_fs+0x5e/0x290
 vfs_kern_mount+0x88/0x460
 do_mount+0x398/0x31e0
 ksys_mount+0xc6/0x150
 __x64_sys_mount+0xea/0x190
 do_syscall_64+0x122/0x590
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

It can be reproduced by the following step:
  1. samba configured with: server max protocol = SMB2_10
  2. mount -o vers=default

When parse the mount version parameter, the 'ops' and 'vals'
was setted to smb30,  if negotiate result is smb21, just
update the 'ops' to smb21, but the 'vals' is still smb30.
When add lease context, the iov_base is allocated with smb21
ops, but the iov_len is initiallited with the smb30. Because
the iov_len is longer than iov_base, when send the message,
copy array out of bounds.

we need to keep the 'ops' and 'vals' consistent.

Fixes: 9764c02fcbad ("SMB3: Add support for multidialect negotiate (SMB2.1 and later)")
Fixes: d5c7076b772a ("smb3: add smb3.1.1 to default dialect list")

Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 2bc47eb6215e2..cbe633f1840a2 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -712,6 +712,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 		} else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID)) {
 			/* ops set to 3.0 by default for default so update */
 			ses->server->ops = &smb21_operations;
+			ses->server->vals = &smb21_values;
 		}
 	} else if (le16_to_cpu(rsp->DialectRevision) !=
 				ses->server->vals->protocol_id) {
-- 
2.20.1


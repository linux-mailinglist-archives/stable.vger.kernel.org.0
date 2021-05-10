Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DAE37845A
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbhEJKvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:51:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233490AbhEJKuI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D44561606;
        Mon, 10 May 2021 10:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643138;
        bh=AAcA8OdPJl+ilu/dPnGtwVxONE61/5EAHLfi0bMQ3Q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jLQ0EAQOFS4XAkfcb6DqeDk44/iWl3c6E490kOAEe1b1iGzciEZqDssxZW6TfUTwG
         v4ysF1V/mC8yZjXWi5M61BetFA+3E/fGdefdNM/eBVQAFO3ZRHLpxQDDDav7jSFfmt
         Zl3QSFyLptTopo0gwsn141Vzlat4HRw6KedHFEvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Huang <jinsdb@126.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 192/299] drm/amdkfd: Fix cat debugfs hang_hws file causes system crash bug
Date:   Mon, 10 May 2021 12:19:49 +0200
Message-Id: <20210510102011.291527484@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Huang <jinsdb@126.com>

[ Upstream commit d73610211eec8aa027850982b1a48980aa1bc96e ]

Here is the system crash log:
[ 1272.884438] BUG: unable to handle kernel NULL pointer dereference at
(null)
[ 1272.884444] IP: [<          (null)>]           (null)
[ 1272.884447] PGD 825b09067 PUD 8267c8067 PMD 0
[ 1272.884452] Oops: 0010 [#1] SMP
[ 1272.884509] CPU: 13 PID: 3485 Comm: cat Kdump: loaded Tainted: G
[ 1272.884515] task: ffff9a38dbd4d140 ti: ffff9a37cd3b8000 task.ti:
ffff9a37cd3b8000
[ 1272.884517] RIP: 0010:[<0000000000000000>]  [<          (null)>]
(null)
[ 1272.884520] RSP: 0018:ffff9a37cd3bbe68  EFLAGS: 00010203
[ 1272.884522] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
0000000000014d5f
[ 1272.884524] RDX: fffffffffffffff4 RSI: 0000000000000001 RDI:
ffff9a38aca4d200
[ 1272.884526] RBP: ffff9a37cd3bbed0 R08: ffff9a38dcd5f1a0 R09:
ffff9a31ffc07300
[ 1272.884527] R10: ffff9a31ffc07300 R11: ffffffffaddd5e9d R12:
ffff9a38b4e0fb00
[ 1272.884529] R13: 0000000000000001 R14: ffff9a37cd3bbf18 R15:
ffff9a38aca4d200
[ 1272.884532] FS:  00007feccaa67740(0000) GS:ffff9a38dcd40000(0000)
knlGS:0000000000000000
[ 1272.884534] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1272.884536] CR2: 0000000000000000 CR3: 00000008267c0000 CR4:
00000000003407e0
[ 1272.884537] Call Trace:
[ 1272.884544]  [<ffffffffade68940>] ? seq_read+0x130/0x440
[ 1272.884548]  [<ffffffffade40f8f>] vfs_read+0x9f/0x170
[ 1272.884552]  [<ffffffffade41e4f>] SyS_read+0x7f/0xf0
[ 1272.884557]  [<ffffffffae374ddb>] system_call_fastpath+0x22/0x27
[ 1272.884558] Code:  Bad RIP value.
[ 1272.884562] RIP  [<          (null)>]           (null)
[ 1272.884564]  RSP <ffff9a37cd3bbe68>
[ 1272.884566] CR2: 0000000000000000

Signed-off-by: Qu Huang <jinsdb@126.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_debugfs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_debugfs.c b/drivers/gpu/drm/amd/amdkfd/kfd_debugfs.c
index 511712c2e382..673d5e34f213 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_debugfs.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_debugfs.c
@@ -33,6 +33,11 @@ static int kfd_debugfs_open(struct inode *inode, struct file *file)
 
 	return single_open(file, show, NULL);
 }
+static int kfd_debugfs_hang_hws_read(struct seq_file *m, void *data)
+{
+	seq_printf(m, "echo gpu_id > hang_hws\n");
+	return 0;
+}
 
 static ssize_t kfd_debugfs_hang_hws_write(struct file *file,
 	const char __user *user_buf, size_t size, loff_t *ppos)
@@ -94,7 +99,7 @@ void kfd_debugfs_init(void)
 	debugfs_create_file("rls", S_IFREG | 0444, debugfs_root,
 			    kfd_debugfs_rls_by_device, &kfd_debugfs_fops);
 	debugfs_create_file("hang_hws", S_IFREG | 0200, debugfs_root,
-			    NULL, &kfd_debugfs_hang_hws_fops);
+			    kfd_debugfs_hang_hws_read, &kfd_debugfs_hang_hws_fops);
 }
 
 void kfd_debugfs_fini(void)
-- 
2.30.2




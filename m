Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CEA353ED7
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238627AbhDEJIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:08:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238543AbhDEJIJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:08:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8B9961394;
        Mon,  5 Apr 2021 09:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613682;
        bh=nzC4oBSY6+RyaZuZqk2xSIuA6elFtTFCH4IjRIfXr5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GnTIaUzAls3Ex4rwT7mMdX7kVZNInrLJtY0AJFAuN2L+8cAnqCvsRAHKVbe8qlTkF
         /dksMD8qi6LDcp0vwnFfZKbmBBlx4wdn+Y7i6l56ec3RO0D9znT+80FB4AmTZihMka
         0VzNlvlj9gIFpQpjHfmd1S2z3FnqgUrIKVBGTkJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/126] net: 9p: advance iov on empty read
Date:   Mon,  5 Apr 2021 10:53:35 +0200
Message-Id: <20210405085032.786316361@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

[ Upstream commit d65614a01d24704b016635abf5cc028a54e45a62 ]

I met below warning when cating a small size(about 80bytes) txt file
on 9pfs(msize=2097152 is passed to 9p mount option), the reason is we
miss iov_iter_advance() if the read count is 0 for zerocopy case, so
we didn't truncate the pipe, then iov_iter_pipe() thinks the pipe is
full. Fix it by removing the exception for 0 to ensure to call
iov_iter_advance() even on empty read for zerocopy case.

[    8.279568] WARNING: CPU: 0 PID: 39 at lib/iov_iter.c:1203 iov_iter_pipe+0x31/0x40
[    8.280028] Modules linked in:
[    8.280561] CPU: 0 PID: 39 Comm: cat Not tainted 5.11.0+ #6
[    8.281260] RIP: 0010:iov_iter_pipe+0x31/0x40
[    8.281974] Code: 2b 42 54 39 42 5c 76 22 c7 07 20 00 00 00 48 89 57 18 8b 42 50 48 c7 47 08 b
[    8.283169] RSP: 0018:ffff888000cbbd80 EFLAGS: 00000246
[    8.283512] RAX: 0000000000000010 RBX: ffff888000117d00 RCX: 0000000000000000
[    8.283876] RDX: ffff88800031d600 RSI: 0000000000000000 RDI: ffff888000cbbd90
[    8.284244] RBP: ffff888000cbbe38 R08: 0000000000000000 R09: ffff8880008d2058
[    8.284605] R10: 0000000000000002 R11: ffff888000375510 R12: 0000000000000050
[    8.284964] R13: ffff888000cbbe80 R14: 0000000000000050 R15: ffff88800031d600
[    8.285439] FS:  00007f24fd8af600(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
[    8.285844] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    8.286150] CR2: 00007f24fd7d7b90 CR3: 0000000000c97000 CR4: 00000000000406b0
[    8.286710] Call Trace:
[    8.288279]  generic_file_splice_read+0x31/0x1a0
[    8.289273]  ? do_splice_to+0x2f/0x90
[    8.289511]  splice_direct_to_actor+0xcc/0x220
[    8.289788]  ? pipe_to_sendpage+0xa0/0xa0
[    8.290052]  do_splice_direct+0x8b/0xd0
[    8.290314]  do_sendfile+0x1ad/0x470
[    8.290576]  do_syscall_64+0x2d/0x40
[    8.290818]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    8.291409] RIP: 0033:0x7f24fd7dca0a
[    8.292511] Code: c3 0f 1f 80 00 00 00 00 4c 89 d2 4c 89 c6 e9 bd fd ff ff 0f 1f 44 00 00 31 8
[    8.293360] RSP: 002b:00007ffc20932818 EFLAGS: 00000206 ORIG_RAX: 0000000000000028
[    8.293800] RAX: ffffffffffffffda RBX: 0000000001000000 RCX: 00007f24fd7dca0a
[    8.294153] RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000001
[    8.294504] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
[    8.294867] R10: 0000000001000000 R11: 0000000000000206 R12: 0000000000000003
[    8.295217] R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000000
[    8.295782] ---[ end trace 63317af81b3ca24b ]---

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/client.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 09f1ec589b80..eb42bbb72f52 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1617,10 +1617,6 @@ p9_client_read_once(struct p9_fid *fid, u64 offset, struct iov_iter *to,
 	}
 
 	p9_debug(P9_DEBUG_9P, "<<< RREAD count %d\n", count);
-	if (!count) {
-		p9_tag_remove(clnt, req);
-		return 0;
-	}
 
 	if (non_zc) {
 		int n = copy_to_iter(dataptr, count, to);
-- 
2.30.1




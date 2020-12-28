Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDDE2E64DC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390785AbgL1Nhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:37:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:37538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389298AbgL1Nho (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:37:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86CB22072C;
        Mon, 28 Dec 2020 13:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162649;
        bh=4t0DZGoAtDWlHD+bQah5pFXRrCGlWDaoHsarHDLTejs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GT4xBe6ty3ulOnzFiloBf5pysiYgE081CGu95bs3sa8Wg9DFSsGOY0rQerQKOtnyx
         Of2qFtsf20/2IuWz/gCNdIoBhkgAUyf1Fg0oZFvgO2wHyqP+C3Ac9vHdcIzmir4Rkx
         iG2efil1M/EFU8qwItzyqadO1DypOpE9ialaGrYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+86dc6632faaca40133ab@syzkaller.appspotmail.com,
        David Howells <dhowells@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/453] afs: Fix memory leak when mounting with multiple source parameters
Date:   Mon, 28 Dec 2020 13:44:21 +0100
Message-Id: <20201228124938.469192413@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 4cb682964706deffb4861f0a91329ab3a705039f ]

There's a memory leak in afs_parse_source() whereby multiple source=
parameters overwrite fc->source in the fs_context struct without freeing
the previously recorded source.

Fix this by only permitting a single source parameter and rejecting with
an error all subsequent ones.

This was caught by syzbot with the kernel memory leak detector, showing
something like the following trace:

  unreferenced object 0xffff888114375440 (size 32):
    comm "repro", pid 5168, jiffies 4294923723 (age 569.948s)
    backtrace:
      slab_post_alloc_hook+0x42/0x79
      __kmalloc_track_caller+0x125/0x16a
      kmemdup_nul+0x24/0x3c
      vfs_parse_fs_string+0x5a/0xa1
      generic_parse_monolithic+0x9d/0xc5
      do_new_mount+0x10d/0x15a
      do_mount+0x5f/0x8e
      __do_sys_mount+0xff/0x127
      do_syscall_64+0x2d/0x3a
      entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 13fcc6837049 ("afs: Add fs_context support")
Reported-by: syzbot+86dc6632faaca40133ab@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/afs/super.c b/fs/afs/super.c
index 7f8a9b3137bff..eb04dcc543289 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -236,6 +236,9 @@ static int afs_parse_source(struct fs_context *fc, struct fs_parameter *param)
 
 	_enter(",%s", name);
 
+	if (fc->source)
+		return invalf(fc, "kAFS: Multiple sources not supported");
+
 	if (!name) {
 		printk(KERN_ERR "kAFS: no volume name specified\n");
 		return -EINVAL;
-- 
2.27.0




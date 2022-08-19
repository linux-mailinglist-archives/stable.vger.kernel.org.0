Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C7459A0EC
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350046AbiHSPvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350491AbiHSPuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:50:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CD42A962;
        Fri, 19 Aug 2022 08:48:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98AD6B82811;
        Fri, 19 Aug 2022 15:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1B9C433C1;
        Fri, 19 Aug 2022 15:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924097;
        bh=DrI3adp2yRRvfdOujNonbvaglt/cevXcbaCIs4dPlcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mwWgcjUAdPn5dXQ1NF4CHUxsAsmHUXY/3u/4HdxLu/agQ4tFDF1/TX5+pJyQEZsLS
         z+LC8uFblHrXGvShbu2cS7a2q4buyQExxPHrjD+MfeEhodH/LKkzHHtvuE0ZcciaD5
         SLWnVqfWs0tUlHQs362hR53YhImBJ7vcu4MmhcX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 024/545] xfs: only set IOMAP_F_SHARED when providing a srcmap to a write
Date:   Fri, 19 Aug 2022 17:36:34 +0200
Message-Id: <20220819153830.270831781@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 72a048c1056a72e37ea2ee34cc73d8c6d6cb4290 upstream.

While prototyping a free space defragmentation tool, I observed an
unexpected IO error while running a sequence of commands that can be
recreated by the following sequence of commands:

$ xfs_io -f -c "pwrite -S 0x58 -b 10m 0 10m" file1
$ cp --reflink=always file1 file2
$ punch-alternating -o 1 file2
$ xfs_io -c "funshare 0 10m" file2
fallocate: Input/output error

I then scraped this (abbreviated) stack trace from dmesg:

WARNING: CPU: 0 PID: 30788 at fs/iomap/buffered-io.c:577 iomap_write_begin+0x376/0x450
CPU: 0 PID: 30788 Comm: xfs_io Not tainted 5.14.0-rc6-xfsx #rc6 5ef57b62a900814b3e4d885c755e9014541c8732
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:iomap_write_begin+0x376/0x450
RSP: 0018:ffffc90000c0fc20 EFLAGS: 00010297
RAX: 0000000000000001 RBX: ffffc90000c0fd10 RCX: 0000000000001000
RDX: ffffc90000c0fc54 RSI: 000000000000000c RDI: 000000000000000c
RBP: ffff888005d5dbd8 R08: 0000000000102000 R09: ffffc90000c0fc50
R10: 0000000000b00000 R11: 0000000000101000 R12: ffffea0000336c40
R13: 0000000000001000 R14: ffffc90000c0fd10 R15: 0000000000101000
FS:  00007f4b8f62fe40(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056361c554108 CR3: 000000000524e004 CR4: 00000000001706f0
Call Trace:
 iomap_unshare_actor+0x95/0x140
 iomap_apply+0xfa/0x300
 iomap_file_unshare+0x44/0x60
 xfs_reflink_unshare+0x50/0x140 [xfs 61947ea9b3a73e79d747dbc1b90205e7987e4195]
 xfs_file_fallocate+0x27c/0x610 [xfs 61947ea9b3a73e79d747dbc1b90205e7987e4195]
 vfs_fallocate+0x133/0x330
 __x64_sys_fallocate+0x3e/0x70
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f4b8f79140a

Looking at the iomap tracepoints, I saw this:

iomap_iter:           dev 8:64 ino 0x100 pos 0 length 0 flags WRITE|0x80 (0x81) ops xfs_buffered_write_iomap_ops caller iomap_file_unshare
iomap_iter_dstmap:    dev 8:64 ino 0x100 bdev 8:64 addr -1 offset 0 length 131072 type DELALLOC flags SHARED
iomap_iter_srcmap:    dev 8:64 ino 0x100 bdev 8:64 addr 147456 offset 0 length 4096 type MAPPED flags
iomap_iter:           dev 8:64 ino 0x100 pos 0 length 4096 flags WRITE|0x80 (0x81) ops xfs_buffered_write_iomap_ops caller iomap_file_unshare
iomap_iter_dstmap:    dev 8:64 ino 0x100 bdev 8:64 addr -1 offset 4096 length 4096 type DELALLOC flags SHARED
console:              WARNING: CPU: 0 PID: 30788 at fs/iomap/buffered-io.c:577 iomap_write_begin+0x376/0x450

The first time funshare calls ->iomap_begin, xfs sees that the first
block is shared and creates a 128k delalloc reservation in the COW fork.
The delalloc reservation is returned as dstmap, and the shared block is
returned as srcmap.  So far so good.

funshare calls ->iomap_begin to try the second block.  This time there's
no srcmap (punch-alternating punched it out!) but we still have the
delalloc reservation in the COW fork.  Therefore, we again return the
reservation as dstmap and the hole as srcmap.  iomap_unshare_iter
incorrectly tries to unshare the hole, which __iomap_write_begin rejects
because shared regions must be fully written and therefore cannot
require zeroing.

Therefore, change the buffered write iomap_begin function not to set
IOMAP_F_SHARED when there isn't a source mapping to read from for the
unsharing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_iomap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1062,11 +1062,11 @@ found_cow:
 		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, 0);
 		if (error)
 			return error;
-	} else {
-		xfs_trim_extent(&cmap, offset_fsb,
-				imap.br_startoff - offset_fsb);
+		return xfs_bmbt_to_iomap(ip, iomap, &cmap, IOMAP_F_SHARED);
 	}
-	return xfs_bmbt_to_iomap(ip, iomap, &cmap, IOMAP_F_SHARED);
+
+	xfs_trim_extent(&cmap, offset_fsb, imap.br_startoff - offset_fsb);
+	return xfs_bmbt_to_iomap(ip, iomap, &cmap, 0);
 
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);



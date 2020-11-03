Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B812A593A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730389AbgKCUln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:41:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:53612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730415AbgKCUlm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:41:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B33A223AB;
        Tue,  3 Nov 2020 20:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436101;
        bh=vlLygtW+Wiu2qXHnsEYalOVJscQWNJjdIMX+R+jw+CE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u3ef16H9xPRVSkY5NJ8v7M7sRprb0eHgZ0AdZ1f8O+u8hkNbrlsFEiNzUTRQWSlz8
         B2/9OFKDR1xGdVrKomn0njln1gtF9R5POlbO9m+5htoB+Z2nll8oRN89pG3PdeT8KB
         R86B/0vkqC0Vj1aQQAsXQ5V2GGsUjBdPMRN3CB9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chandan Babu R <chandanrlinux@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 065/391] xfs: Set xfs_bufs b_ops member when zeroing bitmap/summary files
Date:   Tue,  3 Nov 2020 21:31:56 +0100
Message-Id: <20201103203351.705119261@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chandan Babu R <chandanrlinux@gmail.com>

[ Upstream commit c54e14d155f5fdbac73a8cd4bd2678cb252149dc ]

In xfs_growfs_rt(), we enlarge bitmap and summary files by allocating
new blocks for both files. For each of the new blocks allocated, we
allocate an xfs_buf, zero the payload, log the contents and commit the
transaction. Hence these buffers will eventually find themselves
appended to list at xfs_ail->ail_buf_list.

Later, xfs_growfs_rt() loops across all of the new blocks belonging to
the bitmap inode to set the bitmap values to 1. In doing so, it
allocates a new transaction and invokes the following sequence of
functions,
  - xfs_rtfree_range()
    - xfs_rtmodify_range()
      - xfs_rtbuf_get()
        We pass '&xfs_rtbuf_ops' as the ops pointer to xfs_trans_read_buf().
        - xfs_trans_read_buf()
	  We find the xfs_buf of interest in per-ag hash table, invoke
	  xfs_buf_reverify() which ends up assigning '&xfs_rtbuf_ops' to
	  xfs_buf->b_ops.

On the other hand, if xfs_growfs_rt_alloc() had allocated a few blocks
for the bitmap inode and returned with an error, all the xfs_bufs
corresponding to the new bitmap blocks that have been allocated would
continue to be on xfs_ail->ail_buf_list list without ever having a
non-NULL value assigned to their b_ops members. An AIL flush operation
would then trigger the following warning message to be printed on the
console,

  XFS (loop0): _xfs_buf_ioapply: no buf ops on daddr 0x58 len 8
  00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  CPU: 3 PID: 449 Comm: xfsaild/loop0 Not tainted 5.8.0-rc4-chandan-00038-g4d8c2b9de9ab-dirty #37
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
  Call Trace:
   dump_stack+0x57/0x70
   _xfs_buf_ioapply+0x37c/0x3b0
   ? xfs_rw_bdev+0x1e0/0x1e0
   ? xfs_buf_delwri_submit_buffers+0xd4/0x210
   __xfs_buf_submit+0x6d/0x1f0
   xfs_buf_delwri_submit_buffers+0xd4/0x210
   xfsaild+0x2c8/0x9e0
   ? __switch_to_asm+0x42/0x70
   ? xfs_trans_ail_cursor_first+0x80/0x80
   kthread+0xfe/0x140
   ? kthread_park+0x90/0x90
   ret_from_fork+0x22/0x30

This message indicates that the xfs_buf had its b_ops member set to
NULL.

This commit fixes the issue by assigning "&xfs_rtbuf_ops" to b_ops
member of each of the xfs_bufs logged by xfs_growfs_rt_alloc().

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 912f96a248f25..0753b1dfd0750 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -849,6 +849,7 @@ xfs_growfs_rt_alloc(
 				goto out_trans_cancel;
 
 			xfs_trans_buf_set_type(tp, bp, buf_type);
+			bp->b_ops = &xfs_rtbuf_ops;
 			memset(bp->b_addr, 0, mp->m_sb.sb_blocksize);
 			xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 			/*
-- 
2.27.0




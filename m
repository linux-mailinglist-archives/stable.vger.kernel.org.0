Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA6B3DD7B0
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbhHBNrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:47:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234021AbhHBNrS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:47:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E90A96113D;
        Mon,  2 Aug 2021 13:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912028;
        bh=uGggKJwXB1mT2oXtYwnSUtsMjHkK5yv+CjgCzmOphao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MuxdZ0de4oxzJYoyp26LRTtKWFsBgNdf5nfmWeHmh3HLFIByYQ6EAUAGR33HdF+gA
         SNJZ4fFoHP6RPiSmUIiLY0H4+UcpawB8Ko6GbIi01ywHv1jF6UDAdzrRit67bNz3mG
         yK1zkXd8Rpo5kGANv4F/dChr9LgtU7YhkzXrb6fg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junxiao Bi <junxiao.bi@oracle.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Joel Becker <jlbec@evilplan.org>,
        Jun Piao <piaojun@huawei.com>, Mark Fasheh <mark@fasheh.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 16/32] ocfs2: fix zero out valid data
Date:   Mon,  2 Aug 2021 15:44:36 +0200
Message-Id: <20210802134333.438972029@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134332.931915241@linuxfoundation.org>
References: <20210802134332.931915241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junxiao Bi <junxiao.bi@oracle.com>

commit f267aeb6dea5e468793e5b8eb6a9c72c0020d418 upstream.

If append-dio feature is enabled, direct-io write and fallocate could
run in parallel to extend file size, fallocate used "orig_isize" to
record i_size before taking "ip_alloc_sem", when
ocfs2_zeroout_partial_cluster() zeroout EOF blocks, i_size maybe already
extended by ocfs2_dio_end_io_write(), that will cause valid data zeroed
out.

Link: https://lkml.kernel.org/r/20210722054923.24389-1-junxiao.bi@oracle.com
Fixes: 6bba4471f0cc ("ocfs2: fix data corruption by fallocate")
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1918,7 +1918,6 @@ static int __ocfs2_change_file_space(str
 		goto out_inode_unlock;
 	}
 
-	orig_isize = i_size_read(inode);
 	switch (sr->l_whence) {
 	case 0: /*SEEK_SET*/
 		break;
@@ -1926,7 +1925,7 @@ static int __ocfs2_change_file_space(str
 		sr->l_start += f_pos;
 		break;
 	case 2: /*SEEK_END*/
-		sr->l_start += orig_isize;
+		sr->l_start += i_size_read(inode);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1981,6 +1980,7 @@ static int __ocfs2_change_file_space(str
 		ret = -EINVAL;
 	}
 
+	orig_isize = i_size_read(inode);
 	/* zeroout eof blocks in the cluster. */
 	if (!ret && change_size && orig_isize < size) {
 		ret = ocfs2_zeroout_partial_cluster(inode, orig_isize,



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3A12E9986
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbhADQA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:00:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:38056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728461AbhADQA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:00:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B2D922512;
        Mon,  4 Jan 2021 16:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776015;
        bh=XG1sYVOBq0ov/YU6XesQbxeE0/DNtw3YrRR3+Q8Le90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J82aRpt7F8IP7bnqTGv7mfaou5Wx6DHdomRrkYbA+8cL6Ooxm0q/6uKCruMYwmeCC
         Qb82yPXai3TgO6IhgCcpjY59h3x2yRcSzohZqiyWTfxb0PGtQKY2m02IDchBw5eClG
         PFg/IitJavG59DsVFHSMNloLyeyDhxlCKNw4n6tI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+3fd34060f26e766536ff@syzkaller.appspotmail.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 32/47] bfs: dont use WARNING: string when its just info.
Date:   Mon,  4 Jan 2021 16:57:31 +0100
Message-Id: <20210104155707.286492040@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155705.740576914@linuxfoundation.org>
References: <20210104155705.740576914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit dc889b8d4a8122549feabe99eead04e6b23b6513 upstream.

Make the printk() [bfs "printf" macro] seem less severe by changing
"WARNING:" to "NOTE:".

<asm-generic/bug.h> warns us about using WARNING or BUG in a format string
other than in WARN() or BUG() family macros.  bfs/inode.c is doing just
that in a normal printk() call, so change the "WARNING" string to be
"NOTE".

Link: https://lkml.kernel.org/r/20201203212634.17278-1-rdunlap@infradead.org
Reported-by: syzbot+3fd34060f26e766536ff@syzkaller.appspotmail.com
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Tigran A. Aivazian" <aivazian.tigran@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/bfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -351,7 +351,7 @@ static int bfs_fill_super(struct super_b
 
 	info->si_lasti = (le32_to_cpu(bfs_sb->s_start) - BFS_BSIZE) / sizeof(struct bfs_inode) + BFS_ROOT_INO - 1;
 	if (info->si_lasti == BFS_MAX_LASTI)
-		printf("WARNING: filesystem %s was created with 512 inodes, the real maximum is 511, mounting anyway\n", s->s_id);
+		printf("NOTE: filesystem %s was created with 512 inodes, the real maximum is 511, mounting anyway\n", s->s_id);
 	else if (info->si_lasti > BFS_MAX_LASTI) {
 		printf("Impossible last inode number %lu > %d on %s\n", info->si_lasti, BFS_MAX_LASTI, s->s_id);
 		goto out1;



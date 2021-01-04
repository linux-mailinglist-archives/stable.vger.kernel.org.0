Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1142C2E99BD
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbhADQDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:03:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:40050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbhADQDE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:03:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6C7C22507;
        Mon,  4 Jan 2021 16:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776169;
        bh=bgM8K8mfIxwMypr9yt9d+vSr1q/tvc+VRvHeeSHqAYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=utMVXjaw055rXC1wVi+CHkvDsXdVYwcPSVO1RF6j/3fLn/0sJlORC+hcL+0l314q+
         Ny4tkWUwDDxi9dORSWKHaQZ6gQyvdkP38xnKQpsSZoZeXBXAjoAGyiwMCijZZXp41p
         3ywum51xntoRSiH70zCIzr/1ZG3EX6fyCLQLndVQ=
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
Subject: [PATCH 5.10 35/63] bfs: dont use WARNING: string when its just info.
Date:   Mon,  4 Jan 2021 16:57:28 +0100
Message-Id: <20210104155710.524201550@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
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
@@ -350,7 +350,7 @@ static int bfs_fill_super(struct super_b
 
 	info->si_lasti = (le32_to_cpu(bfs_sb->s_start) - BFS_BSIZE) / sizeof(struct bfs_inode) + BFS_ROOT_INO - 1;
 	if (info->si_lasti == BFS_MAX_LASTI)
-		printf("WARNING: filesystem %s was created with 512 inodes, the real maximum is 511, mounting anyway\n", s->s_id);
+		printf("NOTE: filesystem %s was created with 512 inodes, the real maximum is 511, mounting anyway\n", s->s_id);
 	else if (info->si_lasti > BFS_MAX_LASTI) {
 		printf("Impossible last inode number %lu > %d on %s\n", info->si_lasti, BFS_MAX_LASTI, s->s_id);
 		goto out1;



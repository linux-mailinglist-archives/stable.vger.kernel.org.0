Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D69729C1DC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760901AbgJ0OhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:37:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758649AbgJ0OhD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:37:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33F5A2225E;
        Tue, 27 Oct 2020 14:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809422;
        bh=PahXq6/N5/uraeLROJKcnKZLcuVN559gvYkSccDVgWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jlvOnQ7k2F37+GvlUeOYw1ExLxSpmjj6wgc0icTJ1vK7BQTmq9v3u0jPkHh1TD/yW
         ZJuo+BOPZFNhbDxth/3CY+5YoH2qmVbwD7W3pU+54qAsMAk1+cTvFyP2NiSL7dq6gb
         6ks5xAtDkqvccIA5T4U0LjndoQoEnicK3i1itzNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 191/408] mm/swapfile.c: fix potential memory leak in sys_swapon
Date:   Tue, 27 Oct 2020 14:52:09 +0100
Message-Id: <20201027135503.952005751@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit 822bca52ee7eb279acfba261a423ed7ac47d6f73 ]

If we failed to drain inode, we would forget to free the swap address
space allocated by init_swap_address_space() above.

Fixes: dc617f29dbe5 ("vfs: don't allow writes to swap files")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Link: https://lkml.kernel.org/r/20200930101803.53884-1-linmiaohe@huawei.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/swapfile.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index cf62bdb7b3045..ff83ffe7a9108 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3284,7 +3284,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	error = inode_drain_writes(inode);
 	if (error) {
 		inode->i_flags &= ~S_SWAPFILE;
-		goto bad_swap_unlock_inode;
+		goto free_swap_address_space;
 	}
 
 	mutex_lock(&swapon_mutex);
@@ -3309,6 +3309,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 	error = 0;
 	goto out;
+free_swap_address_space:
+	exit_swap_address_space(p->type);
 bad_swap_unlock_inode:
 	inode_unlock(inode);
 bad_swap:
-- 
2.25.1




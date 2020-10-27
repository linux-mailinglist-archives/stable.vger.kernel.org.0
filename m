Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360B229B4E9
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793570AbgJ0PHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:07:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1790069AbgJ0PDq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:03:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0578E20747;
        Tue, 27 Oct 2020 15:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811025;
        bh=LGwsaEU/vCW1w8rIqeoh0Z85x0b832Nyw5LMC9pOKSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XtWhozHfwnBzwHqpwdw7nyfDViB+0MIBQeggdbE8DervjpkF8YJpNDXqFbFljL8jM
         Bz4ZOVtEXFozmsTujJIEfLRqYUJkB3OpxeFotaZRR/aaEFQR9v3YxydfUFONjLAEII
         Z9/r1Op7Ga2Z20CR/HwL07iD91mG9es2d19/NmzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 316/633] mm/swapfile.c: fix potential memory leak in sys_swapon
Date:   Tue, 27 Oct 2020 14:50:59 +0100
Message-Id: <20201027135537.500219645@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index 26707c5dc9fce..605294e4df684 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3336,7 +3336,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	error = inode_drain_writes(inode);
 	if (error) {
 		inode->i_flags &= ~S_SWAPFILE;
-		goto bad_swap_unlock_inode;
+		goto free_swap_address_space;
 	}
 
 	mutex_lock(&swapon_mutex);
@@ -3361,6 +3361,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 	error = 0;
 	goto out;
+free_swap_address_space:
+	exit_swap_address_space(p->type);
 bad_swap_unlock_inode:
 	inode_unlock(inode);
 bad_swap:
-- 
2.25.1




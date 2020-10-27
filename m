Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D87029BD53
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368842AbgJ0Ply (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800520AbgJ0Pf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:35:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84D1122264;
        Tue, 27 Oct 2020 15:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812957;
        bh=jDNgwTEc4vET+ph5pSJLbxGNYDhaGy2JVa0aFujKAjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xfAU9P1dF1DjRxmPvKaLpps9QdO8WANlqu28SU3K/Q8ZhGVT1Mx4rn8htEwxHhnKL
         GI/i5t4gRpnQBsiHluE2gs1BXg3mXbwGxz2hjAksXGHp3Tijh3w2p6WMFTLUjC48j6
         kAqGrLndhJC4u5RLo+IYYimUNxkpzryrndSVwaSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 389/757] mm/swapfile.c: fix potential memory leak in sys_swapon
Date:   Tue, 27 Oct 2020 14:50:39 +0100
Message-Id: <20201027135508.795662818@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index debc94155f74d..b877c1504e00b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3343,7 +3343,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	error = inode_drain_writes(inode);
 	if (error) {
 		inode->i_flags &= ~S_SWAPFILE;
-		goto bad_swap_unlock_inode;
+		goto free_swap_address_space;
 	}
 
 	mutex_lock(&swapon_mutex);
@@ -3368,6 +3368,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 	error = 0;
 	goto out;
+free_swap_address_space:
+	exit_swap_address_space(p->type);
 bad_swap_unlock_inode:
 	inode_unlock(inode);
 bad_swap:
-- 
2.25.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEDD41910C6
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgCXNbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:31:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728235AbgCXNU7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:20:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0901208DB;
        Tue, 24 Mar 2020 13:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056059;
        bh=GF0nQgHSqr93FGkRxyrNN14Mg7LyWH6kxP3Xm7fVJ30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T2jSNL2DTpdfv+/J6TO0lMKDYN2T4KvCnv/Wga3tXZwolpUKinFn66ss0b7hIX5FP
         ty0XfJAyBK71reFHC10jl5vp+Ch0svwqbqoiXXsZ1DgUEt/RN+ptsDufvgK70dt005
         unh41jqHQ0ZqV8D3quEA9L9H/ltIdvIHwSnmTpqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yangerkun <yangerkun@huawei.com>,
        Jeff Layton <jlayton@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 001/119] locks: fix a potential use-after-free problem when wakeup a waiter
Date:   Tue, 24 Mar 2020 14:09:46 +0100
Message-Id: <20200324130808.172555793@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

[ Upstream commit 6d390e4b5d48ec03bb87e63cf0a2bff5f4e116da ]

'16306a61d3b7 ("fs/locks: always delete_block after waiting.")' add the
logic to check waiter->fl_blocker without blocked_lock_lock. And it will
trigger a UAF when we try to wakeup some waiter：

Thread 1 has create a write flock a on file, and now thread 2 try to
unlock and delete flock a, thread 3 try to add flock b on the same file.

Thread2                         Thread3
                                flock syscall(create flock b)
	                        ...flock_lock_inode_wait
				    flock_lock_inode(will insert
				    our fl_blocked_member list
				    to flock a's fl_blocked_requests)
				   sleep
flock syscall(unlock)
...flock_lock_inode_wait
    locks_delete_lock_ctx
    ...__locks_wake_up_blocks
        __locks_delete_blocks(
	b->fl_blocker = NULL)
	...
                                   break by a signal
				   locks_delete_block
				    b->fl_blocker == NULL &&
				    list_empty(&b->fl_blocked_requests)
	                            success, return directly
				 locks_free_lock b
	wake_up(&b->fl_waiter)
	trigger UAF

Fix it by remove this logic, and this patch may also fix CVE-2019-19769.

Cc: stable@vger.kernel.org
Fixes: 16306a61d3b7 ("fs/locks: always delete_block after waiting.")
Signed-off-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/locks.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 44b6da0328426..426b55d333d5b 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -753,20 +753,6 @@ int locks_delete_block(struct file_lock *waiter)
 {
 	int status = -ENOENT;
 
-	/*
-	 * If fl_blocker is NULL, it won't be set again as this thread
-	 * "owns" the lock and is the only one that might try to claim
-	 * the lock.  So it is safe to test fl_blocker locklessly.
-	 * Also if fl_blocker is NULL, this waiter is not listed on
-	 * fl_blocked_requests for some lock, so no other request can
-	 * be added to the list of fl_blocked_requests for this
-	 * request.  So if fl_blocker is NULL, it is safe to
-	 * locklessly check if fl_blocked_requests is empty.  If both
-	 * of these checks succeed, there is no need to take the lock.
-	 */
-	if (waiter->fl_blocker == NULL &&
-	    list_empty(&waiter->fl_blocked_requests))
-		return status;
 	spin_lock(&blocked_lock_lock);
 	if (waiter->fl_blocker)
 		status = 0;
-- 
2.20.1




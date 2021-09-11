Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B1C4076B0
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235882AbhIKNNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:13:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235829AbhIKNNJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:13:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2EEB6108B;
        Sat, 11 Sep 2021 13:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365916;
        bh=hG+7UnzuY21Kf9pUuVV2XycR5F+kwOT2KtokM/cSP+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCkQB2kKArW0oTJfGgDUus9vJRXeI752LvHmg/OOWcbtI1oc6rlH3WYL6oTM9/zvC
         6zwX+JAqZiBp7hBUp+wh7Z1Xt4qq/3aos8aUKpUb6M2zQBUNXgeN62U3J9MdJkbVx6
         Miq1AC1cKVJHvEIG/q7+KOoeykWnQITbx/UiwSvsZRGb/MBpbAZIvik9ChBbuqBvwh
         wLKkhV2i2Ru/WKK9yAGrHf+p/VylFyscNxZO5L2hP4ItR3LJ9lXnyl3kYYJ6BO+bSX
         15U6sDRBmfDQ5f+x9GHEnbQHNHGdvnNaZXDtpkUYs+9Xyp5QK0LZ0SSin+catvTC89
         ZzhaoAZW4EWrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>, lijiazi <lijiazi@xiaomi.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 05/32] fuse: fix use after free in fuse_read_interrupt()
Date:   Sat, 11 Sep 2021 09:11:22 -0400
Message-Id: <20210911131149.284397-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131149.284397-1-sashal@kernel.org>
References: <20210911131149.284397-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit e1e71c168813564be0f6ea3d6740a059ca42d177 ]

There is a potential race between fuse_read_interrupt() and
fuse_request_end().

TASK1
  in fuse_read_interrupt(): delete req->intr_entry (while holding
  fiq->lock)

TASK2
  in fuse_request_end(): req->intr_entry is empty -> skip fiq->lock
  wake up TASK3

TASK3
  request is freed

TASK1
  in fuse_read_interrupt(): dereference req->in.h.unique ***BAM***

Fix by always grabbing fiq->lock if the request was ever interrupted
(FR_INTERRUPTED set) thereby serializing with concurrent
fuse_read_interrupt() calls.

FR_INTERRUPTED is set before the request is queued on fiq->interrupts.
Dequeing the request is done with list_del_init() but FR_INTERRUPTED is not
cleared in this case.

Reported-by: lijiazi <lijiazi@xiaomi.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 1c8f79b3dd06..dde341a6388a 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -288,10 +288,10 @@ void fuse_request_end(struct fuse_req *req)
 
 	/*
 	 * test_and_set_bit() implies smp_mb() between bit
-	 * changing and below intr_entry check. Pairs with
+	 * changing and below FR_INTERRUPTED check. Pairs with
 	 * smp_mb() from queue_interrupt().
 	 */
-	if (!list_empty(&req->intr_entry)) {
+	if (test_bit(FR_INTERRUPTED, &req->flags)) {
 		spin_lock(&fiq->lock);
 		list_del_init(&req->intr_entry);
 		spin_unlock(&fiq->lock);
-- 
2.30.2


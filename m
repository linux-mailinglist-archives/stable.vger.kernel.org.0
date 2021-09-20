Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD37412598
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354474AbhITSqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:46:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383233AbhITSoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:44:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA8D963353;
        Mon, 20 Sep 2021 17:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159142;
        bh=hG+7UnzuY21Kf9pUuVV2XycR5F+kwOT2KtokM/cSP+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3QilqJP44B77ZUiSDxs5IlNVdXo0f0/ghiJBGe47mvp/5pM1kc3gdBke/c39dKSR
         MY95M9LqhBGIb46KRngaJCtRWkjj3eGCWdhxLmke1d+juA0GltIx5aVsPiJVgj85Jl
         l35lJg7ofWrwecCqxeU7jyvb6B28xfPRU0V+lxXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, lijiazi <lijiazi@xiaomi.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 094/168] fuse: fix use after free in fuse_read_interrupt()
Date:   Mon, 20 Sep 2021 18:43:52 +0200
Message-Id: <20210920163924.721426651@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




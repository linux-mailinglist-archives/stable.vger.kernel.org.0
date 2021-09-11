Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570C1407800
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237669AbhIKNWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:22:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236585AbhIKNSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:18:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9C1761351;
        Sat, 11 Sep 2021 13:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366031;
        bh=t2iXuvRApkXkndxKEFV8qBh7oCRTavfhVfmUtTDE7LU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pa8BFMSU/s8fh+6zOMNVfXuF9jjDwKYjHA0AbMa0oH9LtLpO1kzR5lyEWQhhvm5pS
         bUgeKw8jBAmfNt+opvDTGX/E3eHGp7MTKKRy49AUGIk1Bm+z1/d6dIDawyrQqe8aFs
         elYq2Wiy4VynlkMDYinNBmycAnudrEy2B2SDEklg0+UxiyNhfRmRaXNQPSK7fxiFyg
         vT9fsh2aH+sSIvaTeYIGFHIxVFS7oXyWfz3K1MvkC0L+l8hm3ngiIBDI4MvxdmKyRZ
         D/kcRhS41nQebN6deqo/R/Cfw4D2kZK7cZ1lOzu3OPs1Y8B9UnWLW3CUqBhoUQy2YZ
         P2H9sajrOg5og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>, lijiazi <lijiazi@xiaomi.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 04/14] fuse: fix use after free in fuse_read_interrupt()
Date:   Sat, 11 Sep 2021 09:13:35 -0400
Message-Id: <20210911131345.285564-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131345.285564-1-sashal@kernel.org>
References: <20210911131345.285564-1-sashal@kernel.org>
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
index 16aa55b73ccf..7205a89fbb5f 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -282,10 +282,10 @@ void fuse_request_end(struct fuse_conn *fc, struct fuse_req *req)
 
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


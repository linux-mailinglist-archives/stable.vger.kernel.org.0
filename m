Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0238A40777B
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236480AbhIKNRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:17:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237023AbhIKNPi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:15:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 559B161252;
        Sat, 11 Sep 2021 13:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365998;
        bh=f51RfyND1n5AOWohNmVh519ztoFsZG6geBRYA01Fg6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QOU2vXKcvKFWw+cwg+akJu7bNwoWirKzQWH9cHq4NskYOlSbuKvhuDD2tLqSJfXZu
         zgFQGq2CqXBqZoMY+ik8rvp+m1I1C2UuqvnBNF6PdupAy5dT9pt+2DmQs9qLcRRFb9
         GsCS30QVhsQXG/7BPMjteF1NF7hiM7PlILUwVF8Wkqepzo8Zi4QO0CP5kRTS6fGcj5
         tRpimaD9pIDhyGhMKj7AhoFUXKPEswJSgQN/UoqX1xEKPNUOSHCZMbkoP3x+zEKQAc
         WpIW/ZIBeOY7Jn3lDLRz8ngxdHUBbcQBeWuqX4SHp5BC3AzINqKIn1jHch1SYC9zmk
         3dJ+8iPP4izKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>, lijiazi <lijiazi@xiaomi.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 04/25] fuse: fix use after free in fuse_read_interrupt()
Date:   Sat, 11 Sep 2021 09:12:51 -0400
Message-Id: <20210911131312.285225-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131312.285225-1-sashal@kernel.org>
References: <20210911131312.285225-1-sashal@kernel.org>
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
index 4140d5c3ab5a..f943eea9fe4e 100644
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


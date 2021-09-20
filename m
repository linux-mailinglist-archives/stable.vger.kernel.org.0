Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360DC41248E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353013AbhITSfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:35:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380244AbhITSdA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:33:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 754A261AA9;
        Mon, 20 Sep 2021 17:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158887;
        bh=f51RfyND1n5AOWohNmVh519ztoFsZG6geBRYA01Fg6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mJFq9bOgSl2feHf4WMwkLFgLKsx4h9R3MdNO9N8kakeFBYE240K440Hcz2D8h7Nya
         ID8KdQA6SxRKM62JbaWKTEVNYTSqiTTwOQLpG6ldac8k4AsueFAmCx6joGBpHjGLcx
         6uc2hXT2FAe2gtm+euJcUwdzW19hloRaOjor7oMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, lijiazi <lijiazi@xiaomi.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/122] fuse: fix use after free in fuse_read_interrupt()
Date:   Mon, 20 Sep 2021 18:43:50 +0200
Message-Id: <20210920163917.684052361@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
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



